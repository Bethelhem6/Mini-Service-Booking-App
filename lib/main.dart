import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_service_booking_app/core/routes/app_pages.dart';
import 'package:mini_service_booking_app/core/themes/app_theme.dart';
import 'package:mini_service_booking_app/data/models/service_model.dart';
import 'package:mini_service_booking_app/presentation/bindings/app_bindings.dart';
import 'package:mini_service_booking_app/presentation/controllers/theme_controller.dart';
import 'package:mini_service_booking_app/presentation/translations/app_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize GetX dependencies
  await Get.putAsync(() async => sharedPreferences);
  Get.put(ThemeController());

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapter
  Hive.registerAdapter(ServiceModelAdapter());

  // Open Hive box
  await Hive.openBox<ServiceModel>('services');

  // // Create and configure bindings
  // final appBindings = AppBindings();
  // appBindings.box = box;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final AppBindings appBindings;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => GetMaterialApp(
        title: 'Service Booking App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,

        // themeMode: ThemeMode.system,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        initialBinding: AppBindings(), // Use the pre-configured bindings
        translations: AppTranslations(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
      ),
    );
  }
}
