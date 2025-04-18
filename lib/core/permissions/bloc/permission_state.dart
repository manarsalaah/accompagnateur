part of 'permission_bloc.dart';

abstract class PermissionState extends Equatable {
  const PermissionState();
}

class PermissionInitial extends PermissionState {
  @override
  List<Object> get props => [];
}

class PermissionGranted extends PermissionState {
  Permission permission;
  PermissionGranted({required this.permission});
  @override
  List<Object?> get props => [];
}

class PermissionDenied extends PermissionState {
  Permission permission;
  PermissionDenied({required this.permission});
  @override
  List<Object?> get props => [];
}
class PermissionFailed extends PermissionState {
  final PermissionFailure failure;
 const PermissionFailed({required this.failure});
  @override
  List<Object?> get props => [];
}
class Requesting extends PermissionState {
  @override
  List<Object?> get props => [];
}
class Checking extends PermissionState {
  @override
  List<Object?> get props => [];
}
