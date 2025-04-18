import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class UploadVisualAttachments{
final CoreRepository repository;
UploadVisualAttachments({required this.repository});
Future<Either<Failure,void>> call(String codeSejour, String date,BuildContext context)async{
  return repository.uploadVisualAttachment(codeSejour,date,context);
}
}