import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class DirectoryManagerRepository {
  Future<Either<Failure,String>> getOrCreateDirectory(String path);
}
