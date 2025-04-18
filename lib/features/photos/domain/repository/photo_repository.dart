import 'dart:io';

import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entity/photo.dart';

abstract class MediaRepository{
  Future<Either<Failure,void>> uploadMediaFromGallery(String path);
  Future<Either<Failure,File>> captureAPhoto();
  Future<Either<Failure,void>> captureAVideo(String path);
  Future<Either<Failure,void>> saveMedia(String path,File media,String comment);
  Future<Either<Failure,File>> pickMediaFromGallery();
  Either<Failure,List<Media>> getMedias();

}