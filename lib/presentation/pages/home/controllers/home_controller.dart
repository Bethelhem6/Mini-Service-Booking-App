import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_service_booking_app/core/constants/app_colors.dart';
import 'package:mini_service_booking_app/core/routes/app_pages.dart';
import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/domain/usecases/base_usecase.dart';
import 'package:mini_service_booking_app/domain/usecases/filter_service.dart';
import 'package:mini_service_booking_app/domain/usecases/get_services.dart';
import 'package:mini_service_booking_app/domain/usecases/search_service.dart';
import 'package:mini_service_booking_app/presentation/pages/service_details/bindings/service_details_binding.dart';
import 'package:mini_service_booking_app/presentation/pages/service_details/views/service_details_view.dart';

class HomeController extends GetxController {
  final GetServices getServices;
  final SearchServices searchServices;
  final FilterServices filterServices;

  HomeController({
    required this.getServices,
    required this.searchServices,
    required this.filterServices,
  });

  // State variables
  final isLoading = false.obs;
  final isSearching = false.obs;
  final services = <Service>[].obs;
  final filteredServices = <Service>[].obs;
  final searchController = TextEditingController();
  final currentPage = 1.obs;
  final itemsPerPage = 10.obs;
  final selectedCategory = RxString('');
  final minPrice = RxDouble(0);
  final maxPrice = RxDouble(1000);
  final minRating = RxDouble(0);
  final favoriteServices = <String>[].obs;
  // Add to HomeController class
  final promotionPageController = PageController(viewportFraction: 1).obs;

  // Categories for the carousel
  final categories =
      [
        {'id': 'all', 'name': 'All', 'icon': Icons.list},
        {'id': 'cleaning', 'name': 'Cleaning', 'icon': Icons.cleaning_services},
        {'id': 'repair', 'name': 'Repair', 'icon': Icons.build},
        {'id': 'beauty', 'name': 'Beauty', 'icon': Icons.face},
        {'id': 'moving', 'name': 'Moving', 'icon': Icons.local_shipping},
        {
          'id': 'electrical',
          'name': 'Electrical',
          'icon': Icons.electrical_services,
        },
        {'id': 'plumbing', 'name': 'Plumbing', 'icon': Icons.plumbing},
        {'id': 'catering', 'name': 'Catering', 'icon': Icons.restaurant},
        {'id': 'other', 'name': 'Other', 'icon': Icons.category},
      ].obs;

  // Add this getter for dropdown
  List<String> get categoryNames =>
      ['All', ...categories.map((c) => c['name'] as String)].toList();
  final currentPromoIndex = 0.obs;
  final isSwiping = false.obs;
  // Promotions for the carousel
  final promotions =
      [
        {
          'id': '1',
          'title': '20% Off First Booking',
          'subtitle': 'Limited time offer for new customers',
          'imageUrl':
              'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        },
        {
          'id': '2',
          'title': 'Free Consultation',
          'subtitle': 'Get expert advice before booking',
          'imageUrl':
              'https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        },
        {
          'id': '3',
          'title': 'Weekend Special',
          'subtitle': 'Exclusive discounts every weekend',
          'imageUrl':
              'https://images.unsplash.com/photo-1521791136064-7986c2920216?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        },
        {
          'id': '4',
          'title': 'Bundle & Save',
          'subtitle': 'Combine services for extra savings',
          'imageUrl':
              'https://images.unsplash.com/photo-1486401899868-0e435ed85128?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        },
      ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  @override
  void onClose() {
    promotionPageController.value.dispose();
    searchController.dispose();
    super.onClose();
  }

  void searchServicess(String query) async {
    if (query.isEmpty) {
      filteredServices.assignAll(services);
    } else {
      isLoading.value = true;
      try {
        final result = await searchServices.call(query);
        filteredServices.assignAll(result);
        currentPage.value = 1; // Reset to first page when searching
      } catch (e) {
        Get.snackbar('Error', 'Failed to search services');
      } finally {
        isLoading.value = false;
      }
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      filteredServices.assignAll(services);
    }
  }

  void filterByCategory(String? categoryId) {
    selectedCategory.value = categoryId ?? '';

    if (selectedCategory.value.isEmpty || selectedCategory.value == 'all') {
      // Show all services if "All" or empty is selected
      filteredServices.assignAll(services);
    } else {
      // Filter existing services by category
      filteredServices.assignAll(
        services
            .where(
              (service) =>
                  service.category.toLowerCase() ==
                  selectedCategory.value.toLowerCase(),
            )
            .toList(),
      );
    }

    currentPage.value = 1; // Reset to first page when filtering
  }

  // Remove the applyFilters method or modify it to work with existing data
  void applyFilters() {
    isLoading.value = true;

    try {
      List<Service> result = services;

      // Apply category filter
      if (selectedCategory.value.isNotEmpty) {
        result =
            result
                .where(
                  (service) =>
                      service.category.toLowerCase() ==
                      selectedCategory.value.toLowerCase(),
                )
                .toList();
      }

      // Apply price filter
      result =
          result
              .where(
                (service) =>
                    service.price >= minPrice.value &&
                    service.price <= maxPrice.value,
              )
              .toList();

      // Apply rating filter
      result =
          result.where((service) => service.rating >= minRating.value).toList();

      filteredServices.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to filter services');
    } finally {
      isLoading.value = false;
    }
  }

  // void filterByCategory(String? categoryId) {
  //   selectedCategory.value = categoryId ?? '';
  //   applyFilters();
  // }

  Future<void> fetchServices() async {
    if (currentPage.value == 1) {
      isLoading.value = true;
    }
    try {
      final result = await getServices.call(NoParams());
      if (currentPage.value == 1) {
        services.assignAll(result);
        filteredServices.assignAll(result);
      } else {
        services.addAll(result);
        filteredServices.addAll(result);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load services');
    } finally {
      isLoading.value = false;
    }
  }

  // void applyFilters() async {
  //   if (currentPage.value == 1) {
  //     isLoading.value = true;
  //   }
  //   try {
  //     final result = await filterServices.call(
  //       FilterServicesParams(
  //         category:
  //             selectedCategory.value.isEmpty ? null : selectedCategory.value,
  //         minPrice: minPrice.value,
  //         maxPrice: maxPrice.value,
  //         minRating: minRating.value,
  //       ),
  //     );
  //     if (currentPage.value == 1) {
  //       filteredServices.assignAll(result);
  //     } else {
  //       filteredServices.addAll(result);
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to filter services');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void toggleFavorite(String serviceId) {
    if (favoriteServices.contains(serviceId)) {
      favoriteServices.remove(serviceId);
    } else {
      favoriteServices.add(serviceId);
    }
  }

  void navigateToServiceDetails(String id) {
    Get.to(
      () => ServiceDetailsView(),
      binding: ServiceDetailsBinding(),
      arguments: id, // or whatever you're passing
    );
    // Get.toNamed(Routes.serviceDetails, arguments: id);
  }

  void navigateToAddService() {
    Get.toNamed(Routes.addService);
  }

  void viewAllServices() {
    selectedCategory.value = '';
    minPrice.value = 0;
    maxPrice.value = 1000;
    minRating.value = 0;
    applyFilters();
  }

  void logout() {
    Get.offAllNamed(Routes.login);
  }

  void showFilterDialog() {
    final theme = Theme.of(Get.context!);
    final primaryColor = AppColors.primaryColor;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Filter Services',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category Dropdown
                _FilterSection(
                  title: 'Category',
                  child: DropdownButtonFormField<String>(
                    value:
                        selectedCategory.value.isEmpty
                            ? null
                            : selectedCategory.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: '',
                        child: Text(
                          'All Categories',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      ...categories.map(
                        (category) => DropdownMenuItem(
                          value: category['id'] as String,
                          child: Text(
                            category['name'] as String,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) => selectedCategory.value = value ?? '',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),

                // Price Range
                _FilterSection(
                  title: 'Price Range (ETB)',
                  child: Column(
                    children: [
                      RangeSlider(
                        values: RangeValues(minPrice.value, maxPrice.value),
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        activeColor: primaryColor,
                        inactiveColor: Colors.grey[300],
                        labels: RangeLabels(
                          minPrice.value.toStringAsFixed(2),
                          maxPrice.value.toStringAsFixed(2),
                        ),
                        onChanged: (values) {
                          minPrice.value = values.start;
                          maxPrice.value = values.end;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ETB ${minPrice.value.toStringAsFixed(2)}'),
                          Text('ETB ${maxPrice.value.toStringAsFixed(2)}'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Minimum Rating
                _FilterSection(
                  title: 'Minimum Rating',
                  child: Column(
                    children: [
                      Slider(
                        value: minRating.value,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        activeColor: primaryColor,
                        inactiveColor: Colors.grey[300],
                        label: minRating.value.toStringAsFixed(1),
                        onChanged: (value) => minRating.value = value,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('0'),
                          Text('5'),
                          Text(
                            'Selected: ${minRating.value.toStringAsFixed(1)}',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              selectedCategory.value = '';
              minPrice.value = 0;
              maxPrice.value = 1000;
              minRating.value = 0;
              filteredServices.assignAll(services); // Reset to all services
              Get.back();
            },
            child: Text('Reset', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              applyFilters(); // This now works with existing data
              Get.back();
            },
            child: Text('Apply Filters', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // List<String> _getUniqueCategories() {
  //   return services.map((s) => s.category).toSet().toList();
  // }

  // Pagination logic
  List<Service> get paginatedServices {
    final start = (currentPage.value - 1) * itemsPerPage.value;
    final end = start + itemsPerPage.value;
    return filteredServices.sublist(
      start.clamp(0, filteredServices.length),
      end.clamp(0, filteredServices.length),
    );
  }

  bool get hasNextPage =>
      currentPage.value * itemsPerPage.value < filteredServices.length;

  void nextPage() {
    if (hasNextPage) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }
}

// Reusable filter section widget
class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
