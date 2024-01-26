// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:vivah_ai/models/guest.dart';
import 'package:vivah_ai/providers/shared_pref.dart';
import '../models/blessing.dart';
import '../models/ceremony.dart';
import '../models/photo.dart';

class ApiCalls {
  static Future<String?> uploadImageOrAudioToCloudinary(String path) async {
    String cloudName = dotenv.env['CLOUD_NAME'] ?? '';
    String uploadPreset = dotenv.env['UPLOAD_PRESET'] ?? '';
    Uri url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload');

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return json.decode(responseData)['secure_url'];
      } else {
        debugPrint(
            'Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  static Future<List<dynamic>?> uploadVideoToCloudinary(String path) async {
    String cloudName = dotenv.env['CLOUD_NAME'] ?? '';
    String uploadPreset = dotenv.env['UPLOAD_PRESET'] ?? '';
    Uri url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/video/upload');

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return [
          json.decode(responseData)['secure_url'],
          json.decode(responseData)['duration']
        ];
      } else {
        debugPrint(
            'Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  static Future<String?> selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    if (selectedDate != null) {
      return '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    } else {
      return null;
    }
  }

  static Future<String?> makePhotoLabAPICall(String imageUrl) async {
    String apiUrl = 'https://photolab-me.p.rapidapi.com/photolab/v2/';
    String photoApiKey = dotenv.env['PHOTO_API_KEY'] ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Rapidapi-Key': photoApiKey,
      'X-Rapidapi-Host': 'photolab-me.p.rapidapi.com',
    };

    String comboId = '33975893';
    String encodedParams = 'image_url=$imageUrl&combo_id=$comboId';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: encodedParams,
      );

      if (response.statusCode == 200) {
        debugPrint('API call successful with Response: ${response.body}');
        return json.decode(response.body)['image_url'];
      } else {
        debugPrint('API call failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error making API call: $e');
      return null;
    }
  }

  static Future<void> shareDownloadInvite(
      ScreenshotController screenshotController,
      bool download,
      BuildContext context,
      [String? clipText]) async {
    try {
      final uint8List = await screenshotController.capture();
      final tempDir = await getTemporaryDirectory();
      final imagePath = '${tempDir.path}/image.png';

      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(uint8List!);

      if (download) {
        await ImageGallerySaver.saveImage(uint8List,
            quality: 80, name: 'personalised_invite');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invitation saved to gallery')),
        );
      } else {
        await Share.shareFiles(
          [imagePath],
          text: clipText ?? '',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  static Future<void> createShareVideo(ScreenshotController screenshotController, String audioPath) async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

    final uint8List = await screenshotController.capture();
    final tempDir = await getTemporaryDirectory();
    final imagePath = '${tempDir.path}/image.png';

    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(uint8List!);

    Directory? directory = await getExternalStorageDirectory();
    if (Directory("${directory!.path.toString()}/Stikkr").existsSync()) {
      Directory("${directory.path.toString()}/Stikkr")
          .createSync(recursive: true);
    }
    String path = directory.path;
    String outputVideo = "$path/output_video.mp4";

    // Ensure the output directory exists
    await Directory(outputVideo).parent.create(recursive: true);

    List<String> arguments = [
      '-loop', '1',
      '-i', imagePath,
      '-i', audioPath,
      '-c:v', 'mpeg4',
      '-c:a', 'aac',
      '-strict', 'experimental',
      '-b:a', '192k',
      '-shortest',
      outputVideo,
    ];

    int returnCode = await _flutterFFmpeg.executeWithArguments(arguments);
    debugPrint("Video creation process exited with code $returnCode");

    if (await File(outputVideo).exists()) {
      await Share.shareFiles(
        [outputVideo],
        text: 'Sharing it as a video' ?? '',
      );
    } else {
      debugPrint("Error: Video file does not exist.");
    }
  }

  static Future<String> getScreenshotPath(ScreenshotController screenshotController) async {
    try {
      final uint8List = await screenshotController.capture();
      final tempDir = await getTemporaryDirectory();
      final imagePath = '${tempDir.path}/image.png';

      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(uint8List!);
      return imagePath;
    } catch (e) {
      debugPrint('Error: $e');
    }
    return '';
  }

  static Future<void> shareDownloadVoiceInvite(bool download,
      [String? audioUrl]) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final audioPath = '${tempDir.path}/audio.mp3';

      if (!download) {
        await Share.shareFiles([audioPath]);
      } else {
        var response = await http.get(Uri.parse(audioUrl!));

        if (response.statusCode == 200) {
          File file = File(audioPath);
          await file.writeAsBytes(response.bodyBytes);
          debugPrint('Audio file downloaded at: $audioPath');
        } else {
          debugPrint(
              'Failed to download audio. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  static Future<String?> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    return pickedFile?.path;
  }

  static Future<bool> isCouple() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('couple')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    return snapshot.size != 0;
  }

  static Future<dynamic> transcribeAudio(String filePath) async {
    String apiKey = dotenv.env['API_KEY'] ?? '';
    final url = Uri.parse('https://api.openai.com/v1/audio/transcriptions');
    final request = MultipartRequest('POST', url)
      ..headers.addAll({
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'multipart/form-data',
      })
      ..files.add(await http.MultipartFile.fromPath('file', filePath))
      ..fields['model'] = 'whisper-1';

    try {
      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['text'];
      } else {
        debugPrint('Error: ${response.statusCode}, ${response.body}');
        return;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return;
    }
  }

  static Future<List<PhotoItem>> getPhotosList(String hashtag) async {
    List<PhotoItem> photo = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('photos')
          .where('hashtag', isEqualTo: hashtag)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          photo.add(PhotoItem.fromMap(data!));
        }
        debugPrint('Found the images');
        return photo;
      } else {
        debugPrint('No matching documents found for photos.');
        return [];
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
      return [];
    }
  }

  static Future<void> uploadPhoto(String imagePath, String category, String hashtag, String name) async {
    String id = (FirebaseAuth.instance.currentUser?.uid)!;

    String url = (await ApiCalls.uploadImageOrAudioToCloudinary(imagePath))!;
    try {
      final firestore = FirebaseFirestore.instance.collection('photos');
      DocumentReference newDoc = await firestore.add({
        'hashtag': hashtag,
        'addedBy': id,
        'image': url,
        'name': name,
        'category': category
      });

      await firestore.doc(newDoc.id).update({'photoId': newDoc.id});

      debugPrint('Photo uploaded');
    } catch (e) {
      debugPrint('Error uploading photo to Firestore: $e');
    }
  }

  static Future<List<Ceremony>> getCeremonyList(String hashtag) async {
    List<Ceremony> ceremonies = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('ceremonies')
          .where('hashtag', isEqualTo: hashtag)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          ceremonies.add(Ceremony.fromMap(data!));
        }
        debugPrint('Found the ceremony');
        return ceremonies;
      } else {
        debugPrint('No matching documents found for ceremonies.');
        return [];
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
      return [];
    }
  }

  static Future<List<String>> getPromptAndId(String hashtag) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('prompts')
          .where('hashtag', isEqualTo: hashtag)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          debugPrint('Found the prompt');
          return [data!['prompt'], data['promptId']];
        }
      } else {
        debugPrint('No matching documents found for prompt.');
      }
    } catch (error) {
      debugPrint('Error querying prompt: $error');
    }
    return [];
  }

  static Future<List<String>> saveUpdatePrompt(String prompt, String oldPrompt, String promptId, String hashtag) async {
    final firestore = FirebaseFirestore.instance.collection('prompts');
    try {
      if (oldPrompt.isNotEmpty) {
        debugPrint('prompt already available');

        await firestore
            .doc(promptId)
            .update({'prompt': oldPrompt + prompt});

        debugPrint('Prompt updated');
        return [oldPrompt + prompt, promptId];
      } else {
        debugPrint('new prompt');
        String id = (FirebaseAuth.instance.currentUser?.uid)!;

        DocumentReference newDoc = await firestore.add({
          'hashtag': hashtag,
          'addedBy': id,
          'prompt': prompt,
        });

        await firestore.doc(newDoc.id).update({'promptId': newDoc.id});

        debugPrint('Prompt uploaded');
        return [prompt, newDoc.id];
      }
    } catch (e) {
      debugPrint('Error uploading prompt to Firestore: $e');
    }
    return [oldPrompt, promptId];
  }

  static Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  static Future<String> getCurrentPosition(BuildContext context) async {

    try {
      final hasPermission = await _handleLocationPermission(context);
      if (!hasPermission) return '';
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String address = await getAddressFromLatLng(position.latitude, position.longitude);
      debugPrint('Address is $address');
      return address;
    } catch(e) {
      debugPrint(e.toString());
      return 'Error: $e';
    }
  }

  static Future<String> getAddressFromLatLng(double lat, double lon) async {
    try {
      List<Placemark> placeMarks = await GeocodingPlatform.instance
          .placemarkFromCoordinates(lat, lon,
          localeIdentifier: 'en');
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks[0];
        return '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}';
      } else {
        return 'Unable to fetch address';
      }
    } catch (e) {
      debugPrint(e.toString());
      return 'Error: $e';
    }
  }

  static Future<List<BlessingItem>> getHighlightsList(String hashtag) async {
    List<BlessingItem> list = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('blessings')
          .where('hashtag', isEqualTo: hashtag)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          list.add(BlessingItem.fromMap(data!));
        }
        debugPrint('Found the highlights');
        return list;
      } else {
        debugPrint('No matching documents found for highlights.');
        return [];
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
      return [];
    }
  }

  static Future<List<Guest>> getGuestList(String hashtag) async {
    List<Guest> guest = [];
    try {
      await FirebaseFirestore.instance
          .collection('guestList')
          .where('hashtag', isEqualTo: hashtag)
          .get();

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('guestList')
          .where('hashtag', isEqualTo: hashtag)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          guest.add(Guest.fromMap(data!));
        }
        debugPrint('Found the guest');
      } else {
        debugPrint('No matching documents found for guests.');
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
    }
    return guest;
  }

}
