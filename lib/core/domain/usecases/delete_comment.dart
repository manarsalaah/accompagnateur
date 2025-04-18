import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

class DeleteComment{
  final CoreRepository repository;
  DeleteComment({required this.repository});
  Future<Either<Failure, void>> call(String attachmentId) async{
    return await repository.deleteComment(attachmentId);
  }
}