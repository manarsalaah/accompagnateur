part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}
class DownloadPdf extends SettingsEvent{
String type;
DownloadPdf({required this.type});
}
class EditUserInfo extends SettingsEvent{
  final String nom;
  final String prenom;
  final String num;
  final String email;
  EditUserInfo({required this.prenom,required this.nom, required this.num, required this.email});

}
