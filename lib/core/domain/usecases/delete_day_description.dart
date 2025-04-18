import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

class DeleteDayDescription{
  final CoreRepository repository;
  DeleteDayDescription({required this.repository});
  Future<Either<Failure,void>> call(String codeSejour, String date)async{
    return repository.deleteDayDescription(codeSejour, date);
  }
}