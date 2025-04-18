import 'package:accompagnateur/core/permissions/permission_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class PermissionService implements PermissionRepository {

  @override
  Future<Either<Failure, bool>> checkPermission(Permission permission) async {
    try {
      PermissionStatus permissionStatus = await permission.status;
      if (permissionStatus == PermissionStatus.granted) {
        return const Right(true);
      }
      return const Right(false);
    } catch (e) {
      return Left(PermissionFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPermission(Permission permission) async {
    try {
      PermissionStatus permissionStatus = await permission.request();
      if (permissionStatus == PermissionStatus.granted) {
        return const Right(true);
      }
      return const Right(false);
    } catch (e) {
      return Left(PermissionFailure(message: e.toString()));
    }
  }
}
enum Permissions{
  microphone,
  camera,
  manageExternalStorage,
  photos,
  storage,
}
extension PermissionExtension on Permissions {
  Permission get permission {
    switch (this) {
      case Permissions.storage:
        return Permission.storage;
      case Permissions.photos:
        return Permission.photos;
      case Permissions.microphone:
        return Permission.microphone;
      case Permissions.camera:
        return Permission.camera;
        case Permissions.manageExternalStorage:
        return Permission.manageExternalStorage;

    }
  }
}