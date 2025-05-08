// controllers/language_controller.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();
  final _key = 'language';

  // Get the current language from storage or default to device locale
  String get language =>
      _box.read(_key) ?? Get.deviceLocale?.languageCode ?? 'en';

  @override
  void onInit() {
    _loadSavedLanguage();
    super.onInit();
  }

  void _loadSavedLanguage() {
    final savedLanguage = _box.read(_key);
    if (savedLanguage != null) {
      changeLanguage(savedLanguage, save: false);
    }
  }

  void changeLanguage(String languageCode, {bool save = true}) async {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final locale = _getLocale(languageCode);
    await Get.updateLocale(locale);
    if (save) {
      _box.write(_key, languageCode);
    }

    Get.back();
    Get.forceAppUpdate();
  }

  Locale _getLocale(String languageCode) {
    switch (languageCode) {
      case 'es':
        return const Locale('es', 'ES');
      case 'am':
        return const Locale('am', 'ET');
      default:
        return const Locale('en', 'US');
    }
  }

  Locale getLocale() {
    final savedLanguage = _box.read(_key);
    if (savedLanguage != null) {
      return _getLocale(savedLanguage);
    }
    return Get.deviceLocale ?? const Locale('en', 'US');
  }
}
