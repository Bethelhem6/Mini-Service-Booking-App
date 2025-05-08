// controllers/language_controller.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();
  final _key = 'language';

  // Get the current language from storage or default to device locale
  String get language =>
      _box.read(_key) ?? Get.deviceLocale?.languageCode ?? 'en';

  // Change language and save to storage
  void changeLanguage(String languageCode) {
    final locale = _getLocale(languageCode);
    Get.updateLocale(locale);
    _box.write(_key, languageCode);
  }

  Locale _getLocale(String languageCode) {
    switch (languageCode) {
      case 'es':
        return const Locale('es', 'ES');
      default:
        return const Locale('en', 'US');
    }
  }
}
