import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/domain/usecases/add_service.dart';
import 'package:mini_service_booking_app/domain/usecases/update_service.dart';

class ServiceFormController extends GetxController {
  final AddService addService;
  final UpdateService updateService;

  ServiceFormController({
    required this.addService,
    required this.updateService,
  });

  // Form key
  final formKey = GlobalKey<FormState>();
  final isSubmitted = false.obs;

  // Controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final imageUrlController = TextEditingController();
  final durationController = TextEditingController();
  final descriptionController = TextEditingController();

  // Observables
  final selectedCategory = ''.obs;
  final availability = true.obs;
  final rating = 4.5.obs;
  final isLoading = false.obs;
  final reviewCount = 0.obs;

  // Categories list
  final List<String> categories = [
    'Cleaning',
    'Repair',
    'Beauty',
    'Moving',
    'Electrical',
    'Plumbing',
    'Catering',
    'Other',
  ];

  // Getters
  bool get isEditMode => Get.arguments != null;
  Service? get existingService => Get.arguments;

  @override
  void onInit() {
    super.onInit();
    if (isEditMode) {
      _populateForm();
    }
  }

  void _populateForm() {
    final service = existingService!;
    nameController.text = service.name;
    selectedCategory.value = service.category;
    priceController.text = service.price.toStringAsFixed(2);
    imageUrlController.text = service.imageUrl;
    durationController.text = service.duration.toString();
    availability.value = service.availability;
    rating.value = service.rating;
    // reviewCount.value = service.reviewCount;
    // if (service.description != null) {
    //   descriptionController.text = service.description!;
    // }
  }

  Future<void> submitForm() async {
    isSubmitted.value = true;
    if (!formKey.currentState!.validate()) return;
    if (selectedCategory.isEmpty) {
      Get.snackbar('Error', 'Please select a category');
      return;
    }

    isLoading.value = true;
    try {
      final service = Service(
        id: existingService?.id,
        name: nameController.text.trim(),
        category: selectedCategory.value,
        price: double.parse(priceController.text),
        imageUrl: imageUrlController.text.trim(),
        availability: availability.value,
        duration: int.parse(durationController.text),
        rating: rating.value,
        // reviewCount: reviewCount.value,
        // description:
        //     descriptionController.text.trim().isNotEmpty
        //         ? descriptionController.text.trim()
        //         : null,
      );

      if (isEditMode) {
        await updateService.call(service);
        Get.back(result: true);
        Get.snackbar('Success', 'Service updated successfully');
      } else {
        await addService.call(service);
        Get.back(result: true);
        Get.snackbar('Success', 'Service added successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save service: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    durationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
