import 'package:hive/hive.dart';

class HiveService {
  static const String userBox = "userBox";

  // Save User Name based on UID
  Future<void> saveUserName(String uid, String name) async {
    var box = await Hive.openBox(userBox);
    await box.put(uid, name); // Store username under the user's UID
  }

  // Get User Name for the logged-in user
  Future<String?> getUserName(String uid) async {
    var box = await Hive.openBox(userBox);
    return box.get(uid); // Retrieve the username for the logged-in user
  }

  // Clear User Name of a specific user on Logout
  Future<void> clearUserName(String uid) async {
    var box = await Hive.openBox(userBox);
    await box.delete(uid);
  }

  // Clear all user data (optional if you want to remove everything)
  Future<void> clearAllUsers() async {
    var box = await Hive.openBox(userBox);
    await box.clear();
  }
}
