import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';
import '../entities/sejour_day.dart';

class GetSejourDays {
  final CoreRepository repository;
  GetSejourDays({required this.repository});
  Future<Either<Failure,List<SejourDay>>> call()async{
    print("we are in the usecase");
    return await repository.getSejourDays();
  }
}