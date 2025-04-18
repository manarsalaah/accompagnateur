import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class DeleteAttachment{
  final CoreRepository repository;
  DeleteAttachment({required this.repository});
  Future<Either<Failure,void>> call(String attachmentId)async{
    return await repository.deleteAttachment(attachmentId);
  }
}