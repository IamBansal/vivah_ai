import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vivah_ai/viewmodels/base.dart';

import '../models/blessing.dart';
import '../models/ceremony.dart';
import '../models/guest.dart';
import '../models/photo.dart';
import '../providers/api_calls.dart';
import '../providers/shared_pref.dart';

class MainViewModel extends BaseViewModel {

  Future<void> init() async {
    debugPrint('Init in main view model is called');
    isCouple = await ApiCalls.isCouple();
    hashtag = (await LocalData.getName())!;
    List<String> listName = (await LocalData.getNameAndId())!;
    bride = listName[0];
    groom = listName[1];
    userId = listName[2];

    getCeremonyList();
    getPhotoList();
    getBlessingsList();
    getGuestList();
    notifyListeners();
  }

  String hashtag = '';
  bool isCouple = false;
  String bride = '';
  String groom = '';
  String userId = '';
  int selectedIndex = 0;

  List<Ceremony> ceremonyList = [];
  Ceremony ceremony = Ceremony(title: 'title', description: 'description', url: 'url', location: 'location', date: 'date', userId: 'userId', hashtag: 'hashtag', ceremonyId: 'ceremonyId');

  Future<void> getCeremonyList() async {
    ceremonyList = await ApiCalls.getCeremonyList();
    notifyListeners();
  }

  Future<void> saveCeremonyToDB(String imagePath, String title, String desc, String location, String date) async {
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
    await FirebaseFirestore.instance.collection('ceremonies').doc(ceremonyId).delete();
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

  List<Guest> ladkiVale = [];
  List<Guest> ladkeVale = [];
  Guest guest = Guest(category: 'category', contact: 'contact', hashtag: 'hashtag', name: 'name', relation: 'relation', team: 'team', url: 'url', userId: 'userId', guestId: 'guestId', isCreated: false, image: '', memory: '', audio: '');
  String guestCreateInviteButtonText = 'Create and share your invite';

  Future<void> getGuestList() async {
    ladkiVale.clear();
    ladkeVale.clear();
    List<Guest> guestList = await ApiCalls.getGuestList(hashtag);
    for(Guest guest in guestList){
      guest.team == 'Ladki wale' ? ladkiVale.add(guest) : ladkeVale.add(guest);
    }
    notifyListeners();
  }

  Future<void> addGuestToDB(String url, String name, String contact, String relation, String category, String team, String room) async {
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
      await firestore.doc(newDocumentRef.id).update({'guestId': newDocumentRef.id});

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

  Future<void> updateGuestAddInviteToDB(ScreenshotController screenshotController, String audioPath, Guest guest, String memory, int indexInList) async {
    try {
      guestCreateInviteButtonText = 'Creating your invite....';
      notifyListeners();

      String audioUrl = audioPath.isNotEmpty ? (await ApiCalls.uploadImageOrAudioToCloudinary(audioPath))! : 'No audio';
      String path = await ApiCalls.getScreenshotPath(screenshotController);
      String? url = await ApiCalls.uploadImageOrAudioToCloudinary(path);

      await FirebaseFirestore.instance.collection('guestList').doc(guest.guestId).update({
        'image': url,
        'memory': memory,
        'audio': audioUrl,
        'isCreated': true
      });

      guest.isCreated = true;
      guest.image = url!;
      guest.memory = memory;
      guest.audio = audioUrl;

      if(guest.team == 'Ladki wale') {
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

  // String thumbnailUrl = '';

  // Future<void> saveThumbnailToDB(String imagePath, String category) async {
  //   await ApiCalls.uploadThumbnail(imagePath, category);
  //   //TODO - make it better
  //   getPhotoList();
  //   notifyListeners();
  // }

  // Future<void> getThumbnail(String title) async{
  //   thumbnailUrl = await ApiCalls.getThumbnail(title);
  // }

}