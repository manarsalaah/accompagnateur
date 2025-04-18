import 'package:permission_handler/permission_handler.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';
abstract class PermissionRepository {
  Future<Either<Failure,bool>> checkPermission(Permission permission);
  Future<Either<Failure,bool>> requestPermission(Permission permission);
}