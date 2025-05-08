// lib/domain/usecases/update_service.dart

import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/domain/respositories/service_repository.dart';
import 'package:mini_service_booking_app/domain/usecases/base_usecase.dart';

class UpdateService implements BaseUseCase<void, Service> {
  final ServiceRepository repository;

  UpdateService(this.repository);

  @override
  Future<void> call(Service service) async {
    return await repository.updateService(service);
  }
}
