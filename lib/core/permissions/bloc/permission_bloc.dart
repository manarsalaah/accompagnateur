import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/core/permissions/permission_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionService service;
  PermissionBloc({required this.service}) : super(PermissionInitial()) {
    on<CheckPermission>((event, emit) async{
      emit(Checking());
   final  permission = await service.checkPermission(event.permission);
  permission.fold((l) => {
   emit(PermissionFailed(failure: l as PermissionFailure))
  }, (r) => {
  if(r){
    emit(PermissionGranted(permission: event.permission))
  }
  else {
    emit(PermissionDenied(permission: event.permission))
  }
  });
    });

    on<RequestPermission>((event, emit) async{
      emit(Requesting());
   final  permission = await service.requestPermission(event.permission);
  permission.fold((l) => {
   emit(PermissionFailed(failure: l as PermissionFailure))
  }, (r) {
  if(r){
    print("permission granted -> ${event.permission}");
    emit(PermissionGranted(permission: event.permission));
  }
  else {
    emit(PermissionDenied(permission: event.permission));
  }
  });
    });

  }
}
