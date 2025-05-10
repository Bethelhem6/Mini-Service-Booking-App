// lib/presentation/bindings/app_bindings.dart
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mini_service_booking_app/core/network/dio_client.dart';
import 'package:mini_service_booking_app/core/network/network_info.dart';
import 'package:mini_service_booking_app/data/datasources/service_local_data_source.dart';
import 'package:mini_service_booking_app/data/datasources/service_remote_data_source.dart';
import 'package:mini_service_booking_app/domain/respositories/service_repository.dart';
import 'package:mini_service_booking_app/data/repositories/service_repository_impl.dart';
import 'package:mini_service_booking_app/domain/usecases/add_service.dart';
import 'package:mini_service_booking_app/domain/usecases/delete_service.dart'
    show DeleteService;
import 'package:mini_service_booking_app/domain/usecases/filter_service.dart';
import 'package:mini_service_booking_app/domain/usecases/get_service.dart';
import 'package:mini_service_booking_app/domain/usecases/get_services.dart';
import 'package:mini_service_booking_app/domain/usecases/search_service.dart';
import 'package:mini_service_booking_app/domain/usecases/update_service.dart';
import 'package:mini_service_booking_app/presentation/controllers/language_controller.dart';

import 'package:mini_service_booking_app/presentation/pages/home/controllers/home_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Initialize core dependencies
    Get.lazyPut(() => DioClient());
    Get.lazyPut(() => Connectivity());
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));

    // 2. Initialize data sources
    Get.lazyPut<ServiceRemoteDataSource>(
      () => ServiceRemoteDataSourceImpl(dio: Get.find<DioClient>().dio),
    );
    Get.lazyPut<ServiceLocalDataSource>(
      () => ServiceLocalDataSourceImpl(box: Hive.box('services')),
    );

    // 3. Initialize repository
    Get.lazyPut<ServiceRepository>(
      () => ServiceRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
    );

    // 4. Initialize use cases
    Get.lazyPut(() => GetServices(Get.find<ServiceRepository>()));
    Get.lazyPut(() => SearchServices(Get.find<ServiceRepository>()));
    Get.lazyPut(() => FilterServices(Get.find<ServiceRepository>()));
    Get.lazyPut(() => AddService(Get.find<ServiceRepository>()));
    Get.lazyPut(() => UpdateService(Get.find<ServiceRepository>()));
    Get.lazyPut(() => GetService(Get.find<ServiceRepository>()));
    Get.lazyPut(() => DeleteService(Get.find<ServiceRepository>()));

    // 5. Initialize controllers
    Get.lazyPut(() => LanguageController());
    Get.lazyPut(
      () => HomeController(
        getServices: Get.find<GetServices>(),
        searchServices: Get.find<SearchServices>(),
        filterServices: Get.find<FilterServices>(),
      ),
    );
  }
}
