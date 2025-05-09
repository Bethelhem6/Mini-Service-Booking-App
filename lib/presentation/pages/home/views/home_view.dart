import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_service_booking_app/core/constants/app_colors.dart';
import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/presentation/controllers/language_controller.dart';
import 'package:mini_service_booking_app/presentation/pages/home/controllers/home_controller.dart';
import 'package:mini_service_booking_app/presentation/pages/home/views/home_shimmer.dart';
import 'package:mini_service_booking_app/presentation/pages/notification/view/notification_page.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = AppColors.primaryColor;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'serviceBooking'.tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // leading: Builder(
        //   builder:
        //       (context) => IconButton(
        //         icon: const Icon(Icons.menu),
        //         onPressed: () => Scaffold.of(context).openDrawer(),
        //       ),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Get.to(() => NotificationsScreen());
              // Optional: Mark notifications as read when opened
              // controller.markAllAsRead();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent) {
            if (controller.hasNextPage) {
              controller.nextPage();
            }
          }
          return false;
        },
        child: Obx(() {
          if (controller.isLoading.value && controller.currentPage.value == 1) {
            return HomeShimmerLoading();
          }

          return CustomScrollView(
            slivers: [
              // Search and Filter Section
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            hintText: 'Search services...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                          ),
                          onChanged: controller.searchServicess,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                          onPressed: controller.showFilterDialog,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Promotions Carousel
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 180,
                    child: PageView.builder(
                      controller: controller.promotionPageController.value,
                      itemCount: controller.promotions.length,

                      itemBuilder: (context, index) {
                        final promo = controller.promotions[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,

                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                Image.network(
                                  promo['imageUrl']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Container(color: Colors.grey[200]),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.center,
                                      colors: [
                                        Colors.black.withOpacity(0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  bottom: 16,
                                  child: Text(
                                    promo['title']!,
                                    style: textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Dot Indicators
              SliverToBoxAdapter(
                child: Obx(
                  () => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          controller.promotions.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  controller
                                              .promotionPageController
                                              .value
                                              .hasClients &&
                                          (controller
                                                      .promotionPageController
                                                      .value
                                                      .page
                                                      ?.round() ??
                                                  0) ==
                                              index
                                      ? primaryColor
                                      : Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Categories Section
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'categories'.tr,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                    child: Obx(
                      () => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          final isSelected =
                              controller.selectedCategory.value ==
                                  category['id'] ||
                              (controller.selectedCategory.value.isEmpty &&
                                  category['id'] == 'all');
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: InkWell(
                              onTap:
                                  () => controller.filterByCategory(
                                    (category['id'] == 'all'
                                            ? null
                                            : category['id'])
                                        as String?,
                                  ),
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? primaryColor.withOpacity(0.1)
                                              : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          isSelected
                                              ? Border.all(
                                                color: primaryColor,
                                                width: 2,
                                              )
                                              : null,
                                    ),
                                    child: Icon(
                                      category['icon'] as IconData?,
                                      size: 30,
                                      color:
                                          isSelected
                                              ? primaryColor
                                              : Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category['name'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          isSelected
                                              ? primaryColor
                                              : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Services Header
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'availableServices'.tr,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.viewAllServices,
                        child: Text(
                          'seeAll'.tr,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Services Grid View
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: Obx(
                  () => SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: .7,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= controller.paginatedServices.length) {
                          return controller.hasNextPage
                              ? const Center(child: CircularProgressIndicator())
                              : const SizedBox();
                        }
                        final service = controller.paginatedServices[index];
                        return ServiceCard(
                          service: service,
                          controller: controller,
                        );
                      },
                      childCount:
                          controller.paginatedServices.length +
                          (controller.hasNextPage ? 1 : 0),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToAddService,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildDrawer(context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      'BM',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bethelhem Misgina',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'bettymisg6@gmail.com',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Drawer items
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('home'.tr),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('profile'.tr),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.bookmark,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('bookmarks'.tr),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('history'.tr),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('settings'.tr),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('logout'.tr),
                    onTap: controller.logout,
                  ),

                  _buildLanguageTile(context),
                  const Spacer(),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Logout'),
              onTap: controller.logout,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLanguageTile(BuildContext context) {
  final LanguageController languageController = Get.find();

  return ExpansionTile(
    leading: const Icon(Icons.language),
    title: Text('language'.tr),
    children: [
       RadioListTile(
        title: Text('english'.tr),
        value: 'en',
        groupValue: languageController.language,
        onChanged: (value) {
          languageController.changeLanguage(value.toString());
          Get.forceAppUpdate(); // Force UI to update
          Navigator.pop(context);
        },
      ),
    
      RadioListTile(
        title: Text('amharic'.tr),
        value: 'am',
        groupValue: languageController.language,
        onChanged: (value) {
          languageController.changeLanguage(value.toString());
          Get.forceAppUpdate();
          Navigator.pop(context);
        },
      ),
    ],
  );
}

class ServiceCard extends StatelessWidget {
  final Service service;
  final HomeController controller;

  const ServiceCard({
    super.key,
    required this.service,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.navigateToServiceDetails(service.id!),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        service.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 40),
                            ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,

                    child: Obx(
                      () => GestureDetector(
                        onTap: () => controller.toggleFavorite(service.id!),
                        child: Icon(
                          controller.favoriteServices.contains(service.id)
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          color:
                              controller.favoriteServices.contains(service.id)
                                  ? Colors.deepPurple
                                  : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Service Name and Favorite Button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      service.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[600], size: 16),
                      Text(
                        ' ${service.rating.toStringAsFixed(1)} ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Rating
              const SizedBox(height: 4),

              // Category
              // Text(
              //   service.category,
              //   style: TextStyle(color: Colors.grey[600], fontSize: 12),
              // ),
              // const Spacer(),

              // Price
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'price'.trParams({'price': service.price.toStringAsFixed(2)}),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
