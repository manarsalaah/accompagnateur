import 'dart:async';

import 'package:accompagnateur/core/error/failure.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/usecase/login.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login usecase;
  LoginBloc({required this.usecase}) : super(LoginInitial()) {
    on<Login5sur5>((event, emit) async{
      var result = await usecase.call(event.userName  , event.password);
      result.fold((l) {
        if (l is ServerFailure ){
          emit(LoginError(message: l.message));
        }
        if (l is UnAuthorizedFailure ){
          emit(LoginError(message: "Veuillez vérifier votre code séjour et mot de passe"));
        }
      }, (r) => emit(LoginSuccess()));
    });
  }
}
