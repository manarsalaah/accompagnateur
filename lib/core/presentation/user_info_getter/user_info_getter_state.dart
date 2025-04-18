part of 'user_info_getter_bloc.dart';

@immutable
abstract class UserInfoGetterState {}

class UserInfoGetterInitial extends UserInfoGetterState {}
class Success extends UserInfoGetterState {
  final String nom;
  final String prenom;
  final String num;
  final String email;
  Success({required this.num, required this.prenom,required this.nom, required this.email});
}
class Problem extends UserInfoGetterState {
  final String errorMsg;
  Problem({required this.errorMsg});
}
class UnauthorizedInfo extends UserInfoGetterState {}
class Processing extends UserInfoGetterState {}
