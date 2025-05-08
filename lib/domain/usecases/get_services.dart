import 'package:mini_service_booking_app/domain/entities/service.dart';
import 'package:mini_service_booking_app/domain/respositories/service_repository.dart';
import 'package:mini_service_booking_app/domain/usecases/base_usecase.dart';

class GetServices implements BaseUseCase<List<Service>, NoParams> {
  final ServiceRepository repository;

  GetServices(this.repository);

  @override
  Future<List<Service>> call(NoParams params) async {
    return await repository.getServices();
  }
}
