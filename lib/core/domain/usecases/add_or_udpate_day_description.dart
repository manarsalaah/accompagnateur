import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

class AddOrUpdateDayDescription{
  final CoreRepository repository;
  AddOrUpdateDayDescription({required this.repository});
  Future<Either<Failure,void>> call(String codeSejour, String date, String description)async{
    return repository.addOrUpdateDayDescription(codeSejour, date,description);
  }
}