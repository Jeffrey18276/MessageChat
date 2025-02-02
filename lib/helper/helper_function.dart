import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HelperFunctions {
  // keys
  static const String userLoggedInKey = "LOGGEDINKEY";
  static const String userNameKey = "USERNAMEKEY";
  static const String userEmailKey = "USEREMAILKEY";

  // Create a single instance of FlutterSecureStorage
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Saving the data to Flutter Secure Storage
  static Future<void> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    try {
      await _storage.write(key: userLoggedInKey, value: isUserLoggedIn.toString());
    } catch (e) {
      print("Error saving user logged in status: $e");
    }
  }

  static Future<void> saveUserName(String userName) async {
    try {
      await _storage.write(key: userNameKey, value: userName);
    } catch (e) {
      print("Error saving username: $e");
    }
  }

  static Future<void> saveUserEmail(String userEmail) async {
    try {
      await _storage.write(key: userEmailKey, value: userEmail);
    } catch (e) {
      print("Error saving user email: $e");
    }
  }

  // Getting the data from Flutter Secure Storage
  static Future<bool> getUserLoggedInStatus() async {
    try {
      String? value = await _storage.read(key: userLoggedInKey);
      return value != null ? value.toLowerCase() == 'true' : false;
    } catch (e) {
      print("Error fetching user logged in status: $e");
      return false;
    }
  }

  static Future<String?> getUserEmailSF() async {
    try {
      return await _storage.read(key: userEmailKey);
    } catch (e) {
      print("Error fetching user email: $e");
      return null;
    }
  }

  static Future<String?> getUserNameSF() async {
    try {
      return await _storage.read(key: userNameKey);
    } catch (e) {
      print("Error fetching username: $e");
      return null;
    }
  }
}
