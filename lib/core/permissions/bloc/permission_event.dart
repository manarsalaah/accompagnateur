part of 'permission_bloc.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();
}
class RequestPermission extends PermissionEvent {
  Permission permission;
  RequestPermission({required this.permission});
  @override
  List<Object?> get props => [];
}

class CheckPermission extends PermissionEvent {
  Permission permission;
  CheckPermission({required this.permission});
  @override
  List<Object?> get props => [];
}
