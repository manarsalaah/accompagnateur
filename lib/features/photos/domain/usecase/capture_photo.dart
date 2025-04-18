import 'dart:io';

import 'package:accompagnateur/features/photos/domain/repository/photo_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class CapturePhoto{
  final MediaRepository repository;
  CapturePhoto({required this.repository});
  Future<Either<Failure,File>> call()async{
    return await repository.captureAPhoto();
  }
}