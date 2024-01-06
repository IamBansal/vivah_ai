import 'package:shared_preferences/shared_preferences.dart';

class LocalData {

  static const String hashtagKey = 'hashtag_key';

  static Future<void> saveName(String hashtag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(hashtagKey, hashtag);
  }

  static Future<String?> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(hashtagKey);
  }

  static const String nameKey = 'name_key';

  static Future<void> saveNameAndId(String bride, String groom, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(nameKey, [bride, groom, id]);
  }

  static Future<List<String>?> getNameAndId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(nameKey);
  }
}