import 'dart:io';

import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/photos/domain/repository/photo_repository.dart';
import 'package:dartz/dartz.dart';

class SaveMedia{
  final MediaRepository repository;
  SaveMedia({required this.repository});
  Future<Either<Failure, void>> call(String path, File media, String comment)async{
    return await repository.saveMedia(path, media, comment);
  }
}