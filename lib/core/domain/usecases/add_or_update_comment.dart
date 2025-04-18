import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

class AddOrUpdateComment{
  final CoreRepository repository;
  AddOrUpdateComment({required this.repository});
  Future<Either<Failure, void>> call(String comment, String attId) async{
    return await repository.addOrUpdateComment(comment, attId);
  }
}