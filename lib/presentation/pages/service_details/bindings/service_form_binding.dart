import 'package:get/get.dart';
import 'package:mini_service_booking_app/domain/usecases/add_service.dart';
import 'package:mini_service_booking_app/domain/usecases/delete_service.dart';
import 'package:mini_service_booking_app/domain/usecases/get_service.dart';
import 'package:mini_service_booking_app/domain/usecases/update_service.dart';
import 'package:mini_service_booking_app/presentation/pages/service_details/controllers/service_form_controller.dart';

class ServiceFormBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetService(Get.find())); // Your service class
    Get.lazyPut(() => DeleteService(Get.find())); // Your service class
    Get.lazyPut(() => AddService(Get.find())); // Your service class
    Get.lazyPut(() => UpdateService(Get.find())); // Your service class

    Get.lazyPut(
      () => ServiceFormController(
        addService: Get.find(),
        updateService: Get.find(),
      ),
    );
  }
}
