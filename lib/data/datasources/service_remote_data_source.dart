import 'package:dio/dio.dart';
import 'package:mini_service_booking_app/core/constants/api_constants.dart';
import 'package:mini_service_booking_app/data/models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<ServiceModel> getService(String id);
  Future<ServiceModel> addService(ServiceModel service);
  Future<ServiceModel> updateService(ServiceModel service);
  Future<void> deleteService(String id);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final Dio dio;

  ServiceRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ServiceModel>> getServices() async {
    final response = await dio.get(ApiConstants.servicesEndpoint);
    return (response.data as List)
        .map((e) => ServiceModel.fromJson(e))
        .toList();
  }

  @override
  Future<ServiceModel> getService(String id) async {
    final response = await dio.get('${ApiConstants.servicesEndpoint}/$id');
    return ServiceModel.fromJson(response.data);
  }

  @override
  Future<ServiceModel> addService(ServiceModel service) async {
    final response = await dio.post(
      ApiConstants.servicesEndpoint,
      data: service.toJson(),
    );
    return ServiceModel.fromJson(response.data);
  }

  @override
  Future<ServiceModel> updateService(ServiceModel service) async {
    final response = await dio.put(
      '${ApiConstants.servicesEndpoint}/${service.id}',
      data: service.toJson(),
    );
    return ServiceModel.fromJson(response.data);
  }

  @override
  Future<void> deleteService(String id) async {
    await dio.delete('${ApiConstants.servicesEndpoint}/$id');
  }
}
