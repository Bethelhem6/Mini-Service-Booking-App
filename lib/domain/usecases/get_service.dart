// lib/domain/usecases/get_service.dart

import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/domain/respositories/service_repository.dart';
import 'package:mini_service_booking_app/domain/usecases/base_usecase.dart';

class GetService implements BaseUseCase<Service, String> {
  final ServiceRepository repository;

  GetService(this.repository);

  @override
  Future<Service> call(String serviceId) async {
    return await repository.getService(serviceId);
  }
}
