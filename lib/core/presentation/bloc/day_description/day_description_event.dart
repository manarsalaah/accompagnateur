part of 'day_description_bloc.dart';

@immutable
abstract class DayDescriptionEvent {}
class GetDayDescriptionEvent extends DayDescriptionEvent {
  final String date;
  final String codeSejour;
  GetDayDescriptionEvent({required this.codeSejour,required this.date});
}

class DeleteDayDescriptionEvent extends DayDescriptionEvent {
  final String date;
  final String codeSejour;
  DeleteDayDescriptionEvent({required this.codeSejour,required this.date});
}

class AddOrUpdateDayDescriptionEvent extends DayDescriptionEvent {
  final String date;
  final String codeSejour;
  final String description;
  AddOrUpdateDayDescriptionEvent({required this.codeSejour,required this.date,required this.description});
}

