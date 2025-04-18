import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

class GetDayDescription{
  final CoreRepository repository;
  GetDayDescription({required this.repository});
  Future<Either<Failure,String?>> call(String codeSejour, String date)async{
    return repository.getDayDescription(codeSejour, date);
  }
}