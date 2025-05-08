// lib/data/datasources/service_local_data_source.dart

import 'package:hive/hive.dart';
import 'package:mini_service_booking_app/data/models/service_model.dart';

abstract class ServiceLocalDataSource {
  Future<List<ServiceModel>> getCachedServices();
  Future<void> cacheServices(List<ServiceModel> services);
  Future<void> clearCache();
}

class ServiceLocalDataSourceImpl implements ServiceLocalDataSource {
  final Box<ServiceModel> box;

  ServiceLocalDataSourceImpl({required this.box});

  @override
  Future<List<ServiceModel>> getCachedServices() async {
    return box.values.toList();
  }

  @override
  Future<void> cacheServices(List<ServiceModel> services) async {
    await box.clear();
    await box.addAll(services);
  }

  @override
  Future<void> clearCache() async {
    await box.clear();
  }
}
