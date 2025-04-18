part of 'day_description_bloc.dart';

@immutable
abstract class DayDescriptionState {}

class DayDescriptionInitial extends DayDescriptionState {}
class DayDescriptionSuccess extends DayDescriptionState {
  final String ? description;
  DayDescriptionSuccess({required this.description});
}
class DayDescriptionError extends DayDescriptionState {}
class DayDescriptionLoading extends DayDescriptionState {}
