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

  static const String guestNameKey = 'guest_name_key';

  static Future<void> saveGuestName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(guestNameKey, name);
  }

  static Future<String?> getGuestName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(guestNameKey);
  }

  static const String nameKey = 'name_key';

  static Future<void> saveNameAndId(
      String bride, String groom, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(nameKey, [bride, groom, id]);
  }

  static Future<List<String>?> getNameAndId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(nameKey);
  }

  static const String imageKey = 'image_key';

  static Future<void> saveImage(String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(imageKey, imagePath);
  }

  static Future<String?> getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(imageKey);
  }

  static const String promptKey = 'prompt_key';

  static Future<void> savePrompt(String prompt) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? oldPrompt = await getPrompt();
    List<String>? list = (await getNameAndId())!;

    await prefs.setString(promptKey,
        "You are Vivah AI, the personal wedding assistant for ${list[0]} and ${list[1]} special day. Your role is to provide guests with detailed information about the venue, menu, transportation, event schedule, and any other wedding-related inquiries. You should offer creative and charming responses while ensuring accuracy and clarity. Use the information provided to answer all questions. Be helpful and engaging in your interactions, making every guest feel welcomed and informed. Information is: $prompt along-with $oldPrompt");
  }

  static Future<String?> getPrompt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(promptKey);
  }
}
