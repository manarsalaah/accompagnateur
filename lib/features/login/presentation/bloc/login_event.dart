part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}
class Login5sur5 extends LoginEvent{
  final String userName;
  final String password;
  Login5sur5({required this.userName, required this.password});
}
