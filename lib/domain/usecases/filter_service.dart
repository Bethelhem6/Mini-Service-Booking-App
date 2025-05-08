// lib/domain/usecases/filter_services.dart

import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/domain/respositories/service_repository.dart';
import 'package:mini_service_booking_app/domain/usecases/base_usecase.dart';

class FilterServicesParams {
  final String? category;
  final double minPrice;
  final double maxPrice;
  final double minRating;

  FilterServicesParams({
    this.category,
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.minRating = 0,
  });
}

class FilterServices
    implements BaseUseCase<List<Service>, FilterServicesParams> {
  final ServiceRepository repository;

  FilterServices(this.repository);

  @override
  Future<List<Service>> call(FilterServicesParams params) async {
    return await repository.filterServices(
      category: params.category,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      minRating: params.minRating,
    );
  }
}
