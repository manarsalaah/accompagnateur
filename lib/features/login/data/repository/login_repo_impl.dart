import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/login/data/datasource/login_datasource.dart';
import 'package:accompagnateur/features/login/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';

class LoginRepositoryImpl extends LoginRepository{
  final LoginDataSource dataSource;
  LoginRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, void>> login(String userName, String password) async{
    try{
      await dataSource.login(userName, password);
      return Right(null);
    }
    on UnAuthorizedException {
      return Left(UnAuthorizedFailure());
    }
    on ServerException catch(e){
      return Left(ServerFailure(message: e.message));
    }

  }

}