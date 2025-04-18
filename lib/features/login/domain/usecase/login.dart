import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/login/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

class Login {
  final LoginRepository repository;
  Login({required this.repository});
  Future<Either<Failure, void>> call(String userName, String password)async{
    return await repository.login(userName, password);
  }
}
