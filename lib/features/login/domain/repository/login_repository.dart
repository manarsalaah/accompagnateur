import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepository{
  Future<Either<Failure, void>> login(String userName, String password);
}