// lib/domain/usecases/search_services.dart

import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/domain/respositories/service_repository.dart';
import 'package:mini_service_booking_app/domain/usecases/base_usecase.dart';

class SearchServices implements BaseUseCase<List<Service>, String> {
  final ServiceRepository repository;

  SearchServices(this.repository);

  @override
  Future<List<Service>> call(String query) async {
    return await repository.searchServices(query);
  }
}
