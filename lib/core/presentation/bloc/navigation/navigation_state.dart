part of 'navigation_bloc.dart';

@immutable
abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class NavigationSuccess extends NavigationState {
  final int index;
  NavigationSuccess(this.index);
}