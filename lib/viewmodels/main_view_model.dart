import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vivah_ai/viewmodels/base.dart';
import '../models/blessing.dart';
import '../models/ceremony.dart';
import '../models/guest.dart';
import '../models/photo.dart';
import '../providers/api_calls.dart';
import '../providers/shared_pref.dart';
import 'package:http/http.dart' as http;

class MainViewModel extends BaseViewModel {
  Future<void> init() async {
    debugPrint('Init in main view model is called');
    isCouple = (await LocalData.getIsCouple())!;
    hashtag = (await LocalData.getName())!;
    List<String> listName = (await LocalData.getNameAndId())!;
    bride = listName[0];
    groom = listName[1];
    userId = listName[2];
    List<String> promptAndId = await ApiCalls.getPromptAndId();
    prompt = promptAndId[0];
    promptId = promptAndId[1];

    getCeremonyList();
    getPhotoList();
    getBlessingsList();
    getGuestList();
    notifyListeners();
    if (!isCouple) getPersonalInvite();
  }

  String hashtag = '';
  bool isCouple = false;
  String bride = '';
  String groom = '';
  String userId = '';
  int selectedIndex = 0;
  String prompt = '';
  String promptId = '';

  void setTabIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> setPrompt() async {
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
      throw Exception(
          'Uh oh! Network Error\nYou are just a bit away, try again and beat the issue.');
    }
  }

  Future<void> saveUpdatePrompt(String newPrompt) async {
    List<String> prAndId =
        await ApiCalls.saveUpdatePrompt(newPrompt, prompt, promptId);
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
      ceremonyId: 'ceremonyId');

  Future<void> getCeremonyList() async {
    ceremonyList = await ApiCalls.getCeremonyList();
    notifyListeners();
  }

  Future<void> saveCeremonyToDB(String imagePath, String title, String desc,
      String location, String date) async {
    String url = (await ApiCalls.uploadImageOrAudioToCloudinary(imagePath))!;
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
          ceremonyId: '');
      DocumentReference newDocumentRef = await firestore.add(cer.toMap());

      cer.ceremonyId = newDocumentRef.id;
      await firestore
          .doc(newDocumentRef.id)
          .update({'ceremonyId': newDocumentRef.id});

      ceremonyList.add(cer);
      notifyListeners();
      debugPrint('Ceremony added');
    } catch (e) {
      debugPrint('Error adding guest to Firestore: $e');
    }
  }

  Future<void> deleteCeremony(String ceremonyId) async {
    await FirebaseFirestore.instance
        .collection('ceremonies')
        .doc(ceremonyId)
        .delete();
    ceremonyList.removeWhere((ceremony) => ceremony.ceremonyId == ceremonyId);
    notifyListeners();
  }

  List<PhotoItem> photoList = [];

  Future<void> getPhotoList() async {
    photoList = await ApiCalls.getPhotosList();
    notifyListeners();
  }

  Future<void> savePhotoToDB(String imagePath, String photoCategory) async {
    await ApiCalls.uploadPhoto(imagePath, photoCategory);
    //TODO - make it better
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

  Future<void> saveBlessingToDB(String filePath) async {
    String id = (FirebaseAuth.instance.currentUser?.uid)!;
    String name =
        isCouple ? await LocalData.getGuestName() ?? 'No name' : bride + groom;

    List<dynamic> cloudinaryResponse =
        (await ApiCalls.uploadVideoToCloudinary(filePath))!;
    try {
      BlessingItem blessing = BlessingItem.fromMap({
        'hashtag': hashtag,
        'addedBy': id,
        'video': cloudinaryResponse[0],
        'duration': cloudinaryResponse[1],
        'name': name,
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
      int indexInList) async {
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
        'isCreated': true
      });

      guest.isCreated = true;
      guest.image = url!;
      guest.memory = memory;
      guest.audio = audioUrl;

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
        // for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
        //   Map<String, dynamic>? data = entry.data();
        //   personalInvite = Guest.fromMap(data!);
        //   notifyListeners();
        // }
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

// String thumbnailUrl = '';

// Future<void> saveThumbnailToDB(String imagePath, String category) async {
//   await ApiCalls.uploadThumbnail(imagePath, category);
//   getPhotoList();
//   notifyListeners();
// }

// Future<void> getThumbnail(String title) async{
//   thumbnailUrl = await ApiCalls.getThumbnail(title);
// }
}
