import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class ApiCalls {

  static Future<String?> uploadImageToCloudinary(String imagePath) async {
    String cloudName = dotenv.env['CLOUD_NAME'] ?? '';
    String uploadPreset = dotenv.env['UPLOAD_PRESET'] ?? '';
    Uri url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return json.decode(responseData)['secure_url'];
      } else {
        debugPrint('Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  static Future<List<dynamic>?> uploadVideoToCloudinary(String videoPath) async {
    String cloudName = dotenv.env['CLOUD_NAME'] ?? '';
    String uploadPreset = dotenv.env['UPLOAD_PRESET'] ?? '';
    Uri url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/video/upload');

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', videoPath));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return [json.decode(responseData)['secure_url'], json.decode(responseData)['duration']];
      } else {
        debugPrint('Failed to upload image. Status code: ${response.statusCode}');
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
      firstDate: DateTime.now(),
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
    String encodedParams =
        'image_url=$imageUrl&combo_id=$comboId';

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

  static Future<void> shareInvite(ScreenshotController screenshotController) async {
    try {
      final uint8List = await screenshotController.capture();
      final tempDir = await getTemporaryDirectory();
      final imagePath = '${tempDir.path}/image.png';

      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(uint8List!);

      await Share.shareFiles(
        [imagePath],
        text:
        'Inviting you!!\nDownload the app to know more about what\'s for you',
      );
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  static Future<String?> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    return pickedFile?.path;
  }

  // Future<void> _takeScreenShot(bool download) async {
  //   try {
  //     final uint8List = await _screenshotController.capture();
  //     final tempDir = await getTemporaryDirectory();
  //     final imagePath = '${tempDir.path}/image.png';
  //
  //     File imageFile = File(imagePath);
  //     await imageFile.writeAsBytes(uint8List!);
  //
  //     if(download) {
  //       // Save to gallery
  //       await GallerySaver.saveImage(imagePath, albumName: 'MoodCard');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Mood Card saved to gallery')),
  //       );
  //     } else {
  //       // Share image
  //       await Share.shareFiles([imagePath]);
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

}