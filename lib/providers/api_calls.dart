import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class ApiCalls {

  static String cloudName = dotenv.env['CLOUD_NAME'] ?? '';
  static String uploadPreset = dotenv.env['UPLOAD_PRESET'] ?? '';
  static Future<String?> uploadImageToCloudinary(String imagePath) async {
    Uri url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var parsedResponse = json.decode(responseData);
        return parsedResponse['secure_url'];
      } else {
        debugPrint('Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  static DateTime selectedDate = DateTime.now();
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

  static String photoApiKey = dotenv.env['PHOTO_API_KEY'] ?? '';
  static Future<String?> makePhotoLabAPICall(String imageUrl) async {
    String apiUrl = 'https://photolab-me.p.rapidapi.com/photolab/v2/';
    String rapidApiKey = photoApiKey;

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Rapidapi-Key': rapidApiKey,
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
        debugPrint('API call successful');
        debugPrint('Response: ${response.body}');
        var parsedResponse = json.decode(response.body);
        // setState(() {
        //   imageUrlEmbed = parsedResponse['image_url'];
        // });
        return parsedResponse['image_url'];
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

}