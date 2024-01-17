// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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

  static Future<void> shareDownloadVoiceInvite(bool download, [String? audioUrl]) async {
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
          debugPrint('Failed to download audio. Status code: ${response.statusCode}');
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
}
