import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class UploadAudioAttachments{
  final CoreRepository repository;
  UploadAudioAttachments({required this.repository});
  Future<Either<Failure,void>> call(String codeSejour, String date)async{
    return repository.uploadAudioAttachment(codeSejour,date);
  }
}