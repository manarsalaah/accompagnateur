part of 'sejour_days_bloc.dart';

abstract class SejourDaysEvent extends Equatable {
  const SejourDaysEvent();
}
class LoadSejourDays extends SejourDaysEvent {
  @override
  List<Object?> get props => [];
}
class ChangeSejourDay extends SejourDaysEvent {
  final List<SejourDay> sejourDays;
  final int newSelectedDayIndex ;
  ChangeSejourDay({required this.sejourDays, required this.newSelectedDayIndex});
  @override
  List<Object?> get props => [newSelectedDayIndex,sejourDays];
}