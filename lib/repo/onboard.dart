import 'package:hive/hive.dart';

class OnboardingRepository {
  Future<bool> isOnboardingCompleted() async {
    var box = await Hive.openBox('settings');
    return box.get('onboardingCompleted', defaultValue: false);
  }

  Future<void> setOnboardingCompleted() async {
    var box = await Hive.openBox('settings');
    await box.put('onboardingCompleted', true);
  }
}
