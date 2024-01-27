import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static const String imageKey = 'image_key';

  static Future<void> saveImage(String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(imageKey, imagePath);
  }

  static Future<String?> getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(imageKey);
  }
}
