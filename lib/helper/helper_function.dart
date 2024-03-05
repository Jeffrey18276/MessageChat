import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HelperFunctions {
  // keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  // saving the data to Flutter Secure Storage
  static Future<void> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: userLoggedInKey, value: isUserLoggedIn.toString());
  }

  static Future<void> saveUserName(String userName) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: userNameKey, value: userName);
  }

  static Future<void> saveUserEmail(String userEmail) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: userEmailKey, value: userEmail);
  }

  // getting the data from Flutter Secure Storage
  static Future<bool?> getUserLoggedInStatus() async {
    final storage = FlutterSecureStorage();
    String? value = await storage.read(key: userLoggedInKey);
    return value != null ? value.toLowerCase() == 'true' : null;
  }

  static Future<String?> getUserEmailSF() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: userEmailKey);
  }

  static Future<String?> getUserNameSF() async {
    final storage = FlutterSecureStorage();
    return storage.read(key: userNameKey);
  }
}
