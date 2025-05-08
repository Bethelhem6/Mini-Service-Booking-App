// lib/presentation/pages/login/bindings/login_binding.dart
import 'package:get/get.dart';
import 'package:mini_service_booking_app/presentation/pages/login/controllers/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
