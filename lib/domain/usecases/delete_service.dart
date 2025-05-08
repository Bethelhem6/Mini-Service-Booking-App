// lib/domain/usecases/delete_service.dart

import 'package:mini_service_booking_app/domain/respositories/service_repository.dart';
import 'package:mini_service_booking_app/domain/usecases/base_usecase.dart';

class DeleteService implements BaseUseCase<void, String> {
  final ServiceRepository repository;

  DeleteService(this.repository);

  @override
  Future<void> call(String serviceId) async {
    return await repository.deleteService(serviceId);
  }
}
