import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

class SendSMS {
  final CoreRepository repository;
  SendSMS({required this.repository});
  Future<Either<Failure,void>> call(String codeSejour, String type)async{
    return await repository.sendSms(codeSejour, type);
  }

}