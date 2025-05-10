import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mini_service_booking_app/core/routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final rememberMe = false.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    // Load saved credentials if "remember me" was checked
    if (storage.read('rememberMe') == true) {
      usernameController.text = storage.read('username') ?? '';
      passwordController.text = storage.read('password') ?? '';
      rememberMe.value = true;
    }
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter username';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> login() async {
    // if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // try {
    // In a real app, this would be an actual API call
    // if (usernameController.text == 'admin' &&
    //     passwordController.text == '123456') {
    //   // Save credentials if "remember me" is checked
    //   if (rememberMe.value) {
    //     await storage.write('rememberMe', true);
    //     await storage.write('username', usernameController.text);
    //     await storage.write('password', passwordController.text);
    //   } else {
    //     await storage.remove('rememberMe');
    //     await storage.remove('username');
    //     await storage.remove('password');
    //   }

    Get.offAllNamed(Routes.home);
    Get.snackbar(
      'Success',
      'Login successful',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    // } else {
    //   throw Exception('Invalid credentials');
    // }
    // } catch (e) {
    //   Get.snackbar(
    //     'Error',
    //     'Invalid username or password',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    // } finally {
    //   isLoading.value = false;
    // }
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }
}
