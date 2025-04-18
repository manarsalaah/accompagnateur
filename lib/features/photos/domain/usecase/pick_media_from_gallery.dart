import 'dart:io';

import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/photos/domain/repository/photo_repository.dart';
import 'package:dartz/dartz.dart';

class PickMediaFromGallery{
  final MediaRepository repository;
  PickMediaFromGallery({required this.repository});
  Future<Either<Failure,File>> call()async{
    return await repository.pickMediaFromGallery();
  }
}