import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_service_booking_app/core/routes/app_pages.dart';
import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/domain/usecases/delete_service.dart';
import 'package:mini_service_booking_app/domain/usecases/get_service.dart';

class ServiceDetailsController extends GetxController {
  final GetService getService;
  final DeleteService deleteService;

  ServiceDetailsController({
    required this.getService,
    required this.deleteService,
  });

  final isLoading = true.obs;
  final service = Rxn<Service>();
  final String serviceId = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    fetchService();
  }

  Future<void> fetchService() async {
    isLoading.value = true;
    try {
      final result = await getService.call(serviceId);
      service.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load service details');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteServiceAction() async {
    final confirm = await Get.dialog(
      AlertDialog(
        title: Text('confirmDelete'.tr),
        content: Text('deleteServiceConfirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await deleteService.call(serviceId); // Call the use case
        Get.back();
        Get.snackbar('Success', 'Service deleted successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete service');
      }
    }
  }

  void navigateToEditService() {
    Get.toNamed(Routes.editService, arguments: service.value);
  }
}
