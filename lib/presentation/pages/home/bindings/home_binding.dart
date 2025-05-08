// lib/presentation/pages/home/bindings/home_binding.dart
import 'package:get/get.dart';
import 'package:mini_service_booking_app/presentation/pages/home/controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        getServices: Get.find(),
        searchServices: Get.find(),
        filterServices: Get.find(),
      ),
    );
    
  }
}
