import 'package:hive/hive.dart';

class LocalStorageService {
  static const String _boxName = 'userBox';
  static const String _postSignupKey = 'hasCompletedPostSignup';

  static Future<void> initHive() async {
    await Hive.openBox(_boxName);
  }

  static bool hasCompletedPostSignup() {
    final box = Hive.box(_boxName);
    return box.get(_postSignupKey, defaultValue: false);
  }

  static Future<void> setPostSignupCompleted() async {
    final box = Hive.box(_boxName);
    await box.put(_postSignupKey, true);
  }
}
