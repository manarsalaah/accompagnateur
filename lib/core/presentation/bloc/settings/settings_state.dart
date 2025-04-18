part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}
class Loading extends SettingsState {}
class DocumentDownloaded extends SettingsState {
  final Uint8List? pdfData;
  DocumentDownloaded({required this.pdfData});
}
class SettingsError extends SettingsState {
  final String errorMsg;
  SettingsError({required this.errorMsg});
}
class EditSuccess extends SettingsState {}
class UnAuthorized extends SettingsState {}
class UserInfoSuccess extends SettingsState{
  final String nom;
  final String prenom;
  final String email;
  UserInfoSuccess({required this.email, required this.nom, required this.prenom});
}
