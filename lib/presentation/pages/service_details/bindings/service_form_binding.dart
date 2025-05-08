import 'package:get/get.dart';
import 'package:mini_service_booking_app/presentation/pages/service_details/controllers/service_form_controller.dart';

class ServiceFormBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ServiceFormController(
        addService: Get.find(),
        updateService: Get.find(),
      ),
    );
  }
}
