import 'package:get/get.dart';
import 'package:mini_service_booking_app/presentation/pages/home/views/home_view.dart';
import 'package:mini_service_booking_app/presentation/pages/home/views/splash_screen.dart';
import 'package:mini_service_booking_app/presentation/pages/login/bindings/login_binding.dart';
import 'package:mini_service_booking_app/presentation/pages/login/views/login_view.dart';
import 'package:mini_service_booking_app/presentation/pages/service_details/bindings/service_details_binding.dart';
import 'package:mini_service_booking_app/presentation/pages/service_details/bindings/service_form_binding.dart';
import 'package:mini_service_booking_app/presentation/pages/service_details/views/service_details_view.dart';
import 'package:mini_service_booking_app/presentation/pages/service_details/views/service_form_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: LoginBinding(), // Add this line
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(), // Add this line
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.serviceDetails,
      page: () => const ServiceDetailsView(),
      binding: ServiceDetailsBinding(),
    ),
    GetPage(
      name: Routes.addService,
      page: () => const ServiceFormView(),
      binding: ServiceFormBinding(),
    ),
    GetPage(
      name: Routes.editService,
      page: () => const ServiceFormView(),
      binding: ServiceFormBinding(),
    ),
  ];
}
