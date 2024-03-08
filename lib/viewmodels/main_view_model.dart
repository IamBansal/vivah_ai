import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vivah_ai/models/address.dart';
import 'package:vivah_ai/viewmodels/base.dart';
import '../models/blessing.dart';
import '../models/ceremony.dart';
import '../models/guest.dart';
import '../models/photo.dart';
import '../providers/api_calls.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class MainViewModel extends BaseViewModel {
  Future<void> init() async {
    debugPrint('Init in main view model is called');
    debugPrint(
        'Before main call ===> Hashtag: $hashtag and isCouple: $isCouple, bride: $bride, groom: $groom, guest: $guestName, userId: $userId');
    if (!isCouple) await getMainDetails();
    debugPrint(
        'After main call ===> Hashtag: $hashtag and isCouple: $isCouple, bride: $bride, groom: $groom, guest: $guestName, userId: $userId');
    List<String> promptAndId = await ApiCalls.getPromptAndId(hashtag);
    prompt = promptAndId.isNotEmpty ? promptAndId[0] : '';
    promptId = promptAndId.isNotEmpty ? promptAndId[1] : '';

    getCeremonyList().whenComplete(() => getLocationList());
    getPhotoList();
    getThumbnails();
    getBlessingsList();
    getGuestList();
    getStoryPhotoList();
    if (!isCouple) getPersonalInvite();
    notifyListeners();
  }

  String hashtag = '';
  bool isCouple = false;
  String bride = '';
  String groom = '';
  String userId = FirebaseAuth.instance.currentUser != null ? (FirebaseAuth.instance.currentUser?.uid)! : '';
  int selectedIndex = 0;
  String prompt = '';
  String promptId = '';
  String guestName = '';

  void setForCouple(String hash, String brideName, String groomName) {
    hashtag = hash;
    bride = brideName;
    groom = groomName;
    isCouple = true;
    notifyListeners();
  }

  void setForGuest(String hash, String guest) {
    hashtag = hash;
    guestName = guest;
    isCouple = false;
    notifyListeners();
  }

  Future<void> getMainDetails() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('entries')
          .where('hashtag', isEqualTo: hashtag)
          .get();

      final data = snapshot.docs[0].data();

      bride = data['bride'];
      groom = data['groom'];
      notifyListeners();
      debugPrint('Fetched: $data');
    } catch (e) {
      debugPrint('Error: $e in fetching main details');
    }
  }

  void setTabIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  List<Map<String, dynamic>> chatHistory = [
    {
      'message': 'How can I help you?',
      'isUser': false,
    },
  ];
  String apiKey = dotenv.env['API_KEY'] ?? '';

  Future<void> sendMessageToChatGPT(String message) async {
    try {
      chatHistory.insert(0, {'message': message, 'isUser': true});
      notifyListeners();

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': prompt},
            {'role': 'user', 'content': message}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final chatResponse = responseData['choices'][0]['message']['content'];
        chatHistory.insert(0, {'message': chatResponse, 'isUser': false});
        notifyListeners();
      } else {
        debugPrint(response.statusCode.toString());
        chatHistory.insert(
            0, {'message': 'There\'s something I don\'t know.\nContact the concerned one', 'isUser': false});
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
      chatHistory.insert(0, {'message': 'There\'s something I don\'t know.\nContact the concerned one', 'isUser': false});
      notifyListeners();
    }
  }

  Future<void> saveUpdatePrompt(String newPrompt) async {
    List<String> prAndId =
        await ApiCalls.saveUpdatePrompt(newPrompt, prompt, promptId, hashtag);
    prompt = prAndId[0];
    promptId = prAndId[1];
    notifyListeners();
  }

  List<Ceremony> ceremonyList = [];
  Ceremony ceremony = Ceremony(
      title: 'title',
      description: 'description',
      url: 'url',
      location: 'location',
      date: 'date',
      userId: 'userId',
      hashtag: 'hashtag',
      ceremonyId: 'ceremonyId',
      latitude: 0,
      longitude: 0);

  Future<void> getCeremonyList() async {
    ceremonyList = await ApiCalls.getCeremonyList(hashtag);
    notifyListeners();
  }

  Future<void> saveCeremonyToDB(String imagePath, String title, String desc,
      String location, String date) async {
    String url = (await ApiCalls.uploadImageOrAudioToCloudinary(imagePath))!;
    final addressesList =
        await GeocodingPlatform.instance.locationFromAddress(location);
    try {
      final firestore = FirebaseFirestore.instance.collection('ceremonies');
      Ceremony cer = Ceremony(
        title: title,
        description: desc,
        url: url,
        location: location,
        date: date,
        userId: userId,
        hashtag: hashtag,
        ceremonyId: '',
        latitude: addressesList.first.latitude,
        longitude: addressesList.first.longitude,
      );
      DocumentReference newDocumentRef = await firestore.add(cer.toMap());

      cer.ceremonyId = newDocumentRef.id;
      await firestore
          .doc(newDocumentRef.id)
          .update({'ceremonyId': newDocumentRef.id});

      ceremonyList.add(cer);
      listForLocations
          .add(Address(cer.location, LatLng(cer.latitude, cer.longitude)));

      markers.add(Marker(
        markerId: MarkerId(cer.title),
        position: LatLng(cer.latitude, cer.longitude),
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));

      address = '';
      notifyListeners();
      debugPrint('Ceremony added');
    } catch (e) {
      debugPrint('Error adding guest to Firestore: $e');
    }
  }

  Future<void> updateCeremony(String imagePath, String title, String desc,
      String location, String date, Ceremony ceremony) async {
    String url = imagePath.isNotEmpty
        ? (await ApiCalls.uploadImageOrAudioToCloudinary(imagePath))!
        : ceremony.url;
    List<Location> addressList = location != ceremony.location
        ? await GeocodingPlatform.instance.locationFromAddress(location)
        : [];
    try {
      Ceremony cer = ceremony;
      cer.location = location;
      cer.latitude = addressList.isNotEmpty
          ? addressList.first.latitude
          : ceremony.latitude;
      cer.longitude = addressList.isNotEmpty
          ? addressList.first.longitude
          : ceremony.longitude;
      cer.title = title;
      cer.description = desc;
      cer.date = date;
      cer.url = url;

      await FirebaseFirestore.instance
          .collection('ceremonies')
          .doc(ceremony.ceremonyId)
          .update(cer.toMap());

      ceremonyList
          .removeWhere((element) => element.ceremonyId == cer.ceremonyId);
      ceremonyList.add(cer);

      listForLocations.removeWhere(
          (element) => element.location.latitude == ceremony.latitude);
      listForLocations
          .add(Address(cer.location, LatLng(cer.latitude, cer.longitude)));

      markers
          .removeWhere((element) => element.markerId.value == ceremony.title);
      markers.add(Marker(
        markerId: MarkerId(cer.title),
        position: LatLng(cer.latitude, cer.longitude),
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));

      notifyListeners();
      debugPrint('Ceremony updated');
    } catch (e) {
      debugPrint('Error updating ceremony to Firestore: $e');
    }
  }

  Future<void> deleteCeremony(Ceremony ceremony) async {
    await FirebaseFirestore.instance
        .collection('ceremonies')
        .doc(ceremony.ceremonyId)
        .delete();
    ceremonyList.removeWhere((item) => item.ceremonyId == ceremony.ceremonyId);
    listForLocations.removeWhere((element) => element.name == ceremony.title);
    markers.removeWhere((marker) => marker.markerId.value == ceremony.title);
    notifyListeners();
  }

  List<PhotoItem> photoList = [];

  Future<void> getPhotoList() async {
    photoList = await ApiCalls.getPhotosList(hashtag);
    notifyListeners();
  }

  Future<void> savePhotoToDB(String imagePath, String photoCategory) async {
    await ApiCalls.uploadPhoto(imagePath, photoCategory, hashtag,
        isCouple ? '$bride | $groom' : guestName);
    getPhotoList();
    notifyListeners();
  }

  List<BlessingItem> blessingList = [];

  Future<void> getBlessingsList() async {
    blessingList = await ApiCalls.getHighlightsList(hashtag);
    notifyListeners();
  }

  Future<void> deleteBlessing(String id) async {
    await FirebaseFirestore.instance.collection('blessings').doc(id).delete();
    blessingList.removeWhere((blessing) => blessing.blessingId == id);
    notifyListeners();
  }

  List<PhotoItem> storyList = [];

  Future<void> saveStoryToDB(String imagePath) async {
    String url = (await ApiCalls.uploadImageOrAudioToCloudinary(imagePath))!;
    try {
      final firestore = FirebaseFirestore.instance.collection('stories');
      PhotoItem story = PhotoItem.fromMap({
        'hashtag': hashtag,
        'addedBy': userId,
        'image': url,
        'name': '$bride | $groom',
        'category': 'story',
        'photoId': ''
      });
      DocumentReference newDoc = await firestore.add(story.toMap());

      await firestore.doc(newDoc.id).update({'photoId': newDoc.id});

      story.photoId = newDoc.id;
      storyList.add(story);
      notifyListeners();

      debugPrint('Story uploaded');
    } catch (e) {
      debugPrint('Error uploading Story to Firestore: $e');
    }
  }

  Future<void> getStoryPhotoList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('stories')
          .where('hashtag', isEqualTo: hashtag)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          storyList.add(PhotoItem.fromMap(data!));
        }
        notifyListeners();
        debugPrint('Found the stories');
      } else {
        debugPrint('No matching documents found.');
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
    }
  }

  Future<void> saveBlessingToDB(String filePath) async {
    String id = (FirebaseAuth.instance.currentUser?.uid)!;

    List<dynamic> cloudinaryResponse =
        (await ApiCalls.uploadVideoToCloudinary(filePath))!;
    try {
      BlessingItem blessing = BlessingItem.fromMap({
        'hashtag': hashtag,
        'addedBy': id,
        'video': cloudinaryResponse[0],
        'duration': cloudinaryResponse[1],
        'name': isCouple ? '$bride | $groom' : guestName,
        'blessingId': ''
      });
      DocumentReference newDocumentRef = await FirebaseFirestore.instance
          .collection('blessings')
          .add(blessing.toMap());

      await FirebaseFirestore.instance
          .collection('blessings')
          .doc(newDocumentRef.id)
          .update({'blessingId': newDocumentRef.id});

      blessing.blessingId = newDocumentRef.id;
      blessingList.add(blessing);
      notifyListeners();
      debugPrint('Blessing uploaded');
    } catch (e) {
      debugPrint('Error uploading photo to Firestore: $e');
    }
  }

  List<Guest> ladkiVale = [];
  List<Guest> ladkeVale = [];
  Guest guest = Guest(
      category: 'category',
      contact: 'contact',
      hashtag: 'hashtag',
      name: 'name',
      relation: 'relation',
      team: 'team',
      url: 'url',
      userId: 'userId',
      guestId: 'guestId',
      isCreated: false,
      image: '',
      memory: '',
      audio: '',
      room: '');
  String guestCreateInviteButtonText = 'Create and share your invite';

  Future<void> getGuestList() async {
    ladkiVale.clear();
    ladkeVale.clear();
    List<Guest> guestList = await ApiCalls.getGuestList(hashtag);
    for (Guest guest in guestList) {
      guest.team == 'Ladki wale' ? ladkiVale.add(guest) : ladkeVale.add(guest);
    }
    notifyListeners();
  }

  Future<void> addGuestToDB(String url, String name, String contact,
      String relation, String category, String team, String room) async {
    final firestore = FirebaseFirestore.instance.collection('guestList');
    Guest guest = Guest.fromMap({
      'url': url,
      'name': name,
      'contact': contact,
      'relation': relation,
      'category': category,
      'team': team,
      'userId': userId,
      'hashtag': hashtag,
      'room': room.isNotEmpty ? room : 'No room',
      'isCreated': false,
      'guestId': '',
      'image': '',
      'memory': '',
      'audio': ''
    });
    try {
      DocumentReference newDocumentRef = await firestore.add(guest.toMap());
      await firestore
          .doc(newDocumentRef.id)
          .update({'guestId': newDocumentRef.id});

      guest.guestId = newDocumentRef.id;
      guest.team == 'Ladki wale' ? ladkiVale.add(guest) : ladkeVale.add(guest);
      notifyListeners();
      debugPrint('Guest added');
    } catch (e) {
      debugPrint('Error adding guest to Firestore: $e');
    }
  }

  Future<void> deleteGuest(String id) async {
    await FirebaseFirestore.instance.collection('guestList').doc(id).delete();
    ladkeVale.removeWhere((guest) => guest.guestId == id);
    ladkiVale.removeWhere((guest) => guest.guestId == id);
    notifyListeners();
  }

  Future<void> updateGuestAddInviteToDB(
      ScreenshotController screenshotController,
      String audioPath,
      Guest guest,
      String memory,
      int indexInList,
      String cartoonImage) async {
    try {
      guestCreateInviteButtonText = 'Creating your invite....';
      notifyListeners();

      String audioUrl = audioPath.isNotEmpty
          ? (await ApiCalls.uploadImageOrAudioToCloudinary(audioPath))!
          : 'No audio';
      String path = await ApiCalls.getScreenshotPath(screenshotController);
      String? url = await ApiCalls.uploadImageOrAudioToCloudinary(path);

      await FirebaseFirestore.instance
          .collection('guestList')
          .doc(guest.guestId)
          .update({
        'image': url,
        'memory': memory,
        'audio': audioUrl,
        'isCreated': true,
        'url': cartoonImage
      });

      guest.isCreated = true;
      guest.image = url!;
      guest.memory = memory;
      guest.audio = audioUrl;
      guest.url = cartoonImage;

      if (guest.team == 'Ladki wale') {
        ladkiVale.removeAt(indexInList);
        ladkiVale.insert(indexInList, guest);
      } else {
        ladkeVale.removeAt(indexInList);
        ladkeVale.insert(indexInList, guest);
      }
      guestCreateInviteButtonText = 'Create and share your invite';
      notifyListeners();
      debugPrint('Data updated successfully');
    } catch (error) {
      debugPrint('Error adding data: $error');
    }
  }

  Guest personalInvite = Guest(
      category: 'category',
      contact: 'contact',
      hashtag: 'hashtag',
      name: 'name',
      relation: 'relation',
      team: 'team',
      url: 'url',
      userId: 'userId',
      guestId: 'guestId',
      isCreated: false,
      image: 'image',
      memory: 'memory',
      audio: 'audio',
      room: '');

  Future<void> getPersonalInvite() async {
    String contact = (FirebaseAuth.instance.currentUser?.phoneNumber)!;
    debugPrint(contact);

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('guestList')
          .where('hashtag', isEqualTo: hashtag)
          .where('contact', isEqualTo: contact.substring(3))
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        personalInvite = Guest.fromMap(snapshot.docs[0].data());
        notifyListeners();
        debugPrint('Found the invitation');
        return;
      } else {
        debugPrint('No matching documents found.');
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
    }
  }

  String address = '';

  Future<void> getLocation(double lat, double lon) async {
    address = await ApiCalls.getAddressFromLatLng(lat, lon);
    notifyListeners();
  }

  List<Address> listForLocations = [];
  Set<Marker> markers = {};

  void getLocationList() {
    for (Ceremony event in ceremonyList) {
      listForLocations.add(
          Address(event.location, LatLng(event.latitude, event.longitude)));
      markers.add(Marker(
        markerId: MarkerId(event.title),
        position: LatLng(event.latitude, event.longitude),
        draggable: false,
        infoWindow: InfoWindow(
          title: event.title,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
    notifyListeners();
  }

  List<PhotoItem> thumbnailList = [];

  Future<void> getThumbnails() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('thumbnail')
          .where('hashtag', isEqualTo: hashtag)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          thumbnailList.add(PhotoItem.fromMap(data!));
        }
        notifyListeners();
        debugPrint('Found the thumbnails');
      } else {
        debugPrint('No matching documents found for thumbnails');
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
    }
  }

  Future<void> saveUpdateThumbnail(String imagePath, String category) async {
    String id = (FirebaseAuth.instance.currentUser?.uid)!;
    String url = (await ApiCalls.uploadImageOrAudioToCloudinary(imagePath))!;
    try {
      final firestore = FirebaseFirestore.instance.collection('thumbnail');
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .where('hashtag', isEqualTo: hashtag)
          .where('category', isEqualTo: category)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var thumbnail = PhotoItem.fromMap(snapshot.docs[0].data());
        firestore.doc(thumbnail.photoId).update({'image': url});
        thumbnail.image = url;
        thumbnailList
            .removeWhere((element) => element.photoId == thumbnail.photoId);
        thumbnailList.add(thumbnail);
        notifyListeners();
        debugPrint('Thumbnail updated');
      } else {
        PhotoItem thumbnail = PhotoItem.fromMap({
          'hashtag': hashtag,
          'addedBy': id,
          'image': url,
          'name': '$bride | $groom',
          'category': category,
          'photoId': ''
        });
        DocumentReference newDoc = await firestore.add(thumbnail.toMap());

        await firestore.doc(newDoc.id).update({'photoId': newDoc.id});
        thumbnail.photoId = newDoc.id;
        thumbnailList.add(thumbnail);
        notifyListeners();
        debugPrint('Thumbnail uploaded');
      }
    } catch (e) {
      debugPrint('Error uploading photo to Firestore: $e');
    }
  }

  void clearAll() {
    photoList = [];
    ceremonyList = [];
    blessingList = [];
    thumbnailList = [];
    markers = {};
    listForLocations = [];
    storyList = [];
    ladkiVale = [];
    ladkeVale = [];
    isCouple = false;
    hashtag = '';
    bride = '';
    groom = '';
    userId = '';
    prompt = '';
    promptId = '';
    notifyListeners();
  }
}
