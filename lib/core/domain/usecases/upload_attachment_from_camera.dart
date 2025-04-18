import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class UploadAttachmentFromCamera{
  final CoreRepository repository;
  UploadAttachmentFromCamera({required this.repository});
  Future<Either<Failure,void>> call(String codeSejour, String date)async{
    return repository.uploadAttachmentFromCamera(codeSejour, date);
  }
}