import 'package:mini_service_booking_app/domain/entities/service.dart';

abstract class ServiceRepository {
  Future<List<Service>> getServices({int page = 1, int limit = 10});
  Future<Service> getService(String id);
  Future<void> addService(Service service);
  Future<void> updateService(Service service);
  Future<void> deleteService(String id);
  Future<List<Service>> searchServices(String query);
  Future<List<Service>> filterServices({
    String? category,
    double minPrice,
    double maxPrice,
    double minRating,
  });
}
