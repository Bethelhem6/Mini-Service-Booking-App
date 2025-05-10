// lib/data/repositories/service_repository_impl.dart

import 'package:mini_service_booking_app/core/network/network_info.dart';
import 'package:mini_service_booking_app/data/datasources/service_local_data_source.dart';
import 'package:mini_service_booking_app/data/datasources/service_remote_data_source.dart';
import 'package:mini_service_booking_app/data/models/service_model.dart';
import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/domain/respositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;
  final ServiceLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ServiceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Service>> getServices() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteServices = await remoteDataSource.getServices();
        await localDataSource.cacheServices(remoteServices);
        return remoteServices;
      } catch (e) {
        final localServices = await localDataSource.getCachedServices();
        if (localServices.isNotEmpty) {
          return localServices;
        }
        rethrow;
      }
    } else {
      final localServices = await localDataSource.getCachedServices();
      if (localServices.isNotEmpty) {
        return localServices;
      }
      throw Exception('No internet connection and no cached data available');
    }
  }

  @override
  Future<Service> getService(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteService = await remoteDataSource.getService(id);
        // Optionally cache the single service
        return remoteService;
      } catch (e) {
        // Fallback to local if available
        final localServices = await localDataSource.getCachedServices();
        final localService = localServices.firstWhere(
          (service) => service.id == id,
          orElse: () => throw Exception('Service not found'),
        );
        return localService;
      }
    } else {
      final localServices = await localDataSource.getCachedServices();
      final localService = localServices.firstWhere(
        (service) => service.id == id,
        orElse:
            () =>
                throw Exception(
                  'No internet connection and service not cached',
                ),
      );
      return localService;
    }
  }

  @override
  Future<void> addService(Service service) async {
    if (await networkInfo.isConnected) {
      try {
        final serviceModel = ServiceModel(
          id: service.id,
          name: service.name,
          category: service.category,
          price: service.price,
          imageUrl: service.imageUrl,
          availability: service.availability,
          duration: service.duration,
          rating: service.rating,
        );
        await remoteDataSource.addService(serviceModel);
        // Invalidate cache or update local storage
        await localDataSource.clearCache();
      } catch (e) {
        throw Exception('Failed to add service: ${e.toString()}');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<void> updateService(Service service) async {
    if (await networkInfo.isConnected) {
      try {
        final serviceModel = ServiceModel(
          id: service.id,
          name: service.name,
          category: service.category,
          price: service.price,
          imageUrl: service.imageUrl,
          availability: service.availability,
          duration: service.duration,
          rating: service.rating,
        );
        await remoteDataSource.updateService(serviceModel);
        // Invalidate cache or update local storage
        await localDataSource.clearCache();
      } catch (e) {
        throw Exception('Failed to update service: ${e.toString()}');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<void> deleteService(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteService(id);
        // Invalidate cache or update local storage
        await localDataSource.clearCache();
      } catch (e) {
        throw Exception('Failed to delete service: ${e.toString()}');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<List<Service>> searchServices(String query) async {
    final services = await getServices();
    return services
        .where(
          (service) =>
              service.name.toLowerCase().contains(query.toLowerCase()) ||
              service.category.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<List<Service>> filterServices({
    String? category,
    double minPrice = 0,
    double maxPrice = 1000,
    double minRating = 0,
  }) async {
    final services = await getServices();
    return services.where((service) {
      final categoryMatch = category == null || service.category == category;
      final priceMatch = service.price >= minPrice && service.price <= maxPrice;
      final ratingMatch = service.rating >= minRating;
      return categoryMatch && priceMatch && ratingMatch;
    }).toList();
  }
}
