import 'package:mini_service_booking_app/data/models/get_services_param.dart';
import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/domain/respositories/service_repository.dart';
import 'package:mini_service_booking_app/domain/usecases/base_usecase.dart';

class GetServices implements BaseUseCase<List<Service>, GetServicesParams> {
  final ServiceRepository repository;

  GetServices(this.repository);

  @override
  Future<List<Service>> call(GetServicesParams params) async {
    return await repository.getServices(page: params.offset, limit: params.limit);
  }
}
