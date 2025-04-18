part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}
class NavigationItemSelected extends NavigationEvent {
  final int index;

 NavigationItemSelected(this.index);

}