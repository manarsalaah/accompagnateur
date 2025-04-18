import 'package:accompagnateur/core/data/entity/sejourAttachment.dart';
import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

class GetSejourAttachements{
  final CoreRepository repository;
  GetSejourAttachements({required this.repository});
  Future<Either<Failure,List<SejourAttachment>>> call(String codeSejour,String date)async{
    return await repository.getSejourAttachements(codeSejour, date);
  }
}