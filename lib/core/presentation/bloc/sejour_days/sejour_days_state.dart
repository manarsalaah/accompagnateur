part of 'sejour_days_bloc.dart';

abstract class SejourDaysState extends Equatable {
  const SejourDaysState();
}

class SejourDaysInitial extends SejourDaysState {
  @override
  List<Object> get props => [];
}
class LoadingSejourDays extends SejourDaysState {
  @override
  List<Object> get props => [];
}
class ChangingSejourDays extends SejourDaysState {
  @override
  List<Object> get props => [];
}
class ErrorSejourDays extends SejourDaysState {
  @override
  List<Object> get props => [];
}
class SejourDaysLoaded extends SejourDaysState {
 final List<SejourDay> sejourDays;
 final int selectedDayIndex ;
  const SejourDaysLoaded({required this.sejourDays, required this.selectedDayIndex});
  @override
  List<Object> get props => [sejourDays];
}
class UnAuthorizedSejourDay extends SejourDaysState{
  @override
  List<Object?> get props => [];
}
