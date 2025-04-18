import 'dart:io';

import 'package:accompagnateur/core/error/exception.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/photos/data/data_source/local/media_local_data_source.dart';
import 'package:accompagnateur/features/photos/domain/entity/photo.dart';
import 'package:cross_file/src/types/interface.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../domain/repository/photo_repository.dart';

class MediaRepositoryImpl extends MediaRepository{
  final MediaLocalDataSource localDataSource;
  MediaRepositoryImpl({required this.localDataSource});
  @override
  Future<Either<Failure, File>> captureAPhoto() async{
    try{
      var media = await localDataSource.capturePhoto();
      return Right(media);
    }on NoMediaPickedException{
      return Left(NoMediaPickedFailure());
    }
    catch (e,stacktrace){
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }
      return Left(MediaPickingFailure());
    }
  }

  @override
  Future<Either<Failure, void>> captureAVideo(String path) async{
    // TODO: implement captureAVideo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> uploadMediaFromGallery(String path) async{
    try{
      await localDataSource.pickAndSaveMediaFromGallery(path);
      return const Right(null);
    } catch(e,stacktrace){
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }

      return Left(MediaPickingFailure());
    }
  }

  @override
  Future<Either<Failure, File>> pickMediaFromGallery() async{
    try{
            var media = await localDataSource.pickMediaFromGallery();
            return Right(media);
    }on NoMediaPickedException{
      return Left(NoMediaPickedFailure());
    }
    catch (e,stacktrace){
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }
    return Left(MediaPickingFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveMedia(String path, File media,String comment) async{
   try{
     return Right(await localDataSource.saveMedia(media, path, comment));
   }catch(e,stacktrace){

       print(e);
       print(stacktrace);

     return Left(SavingMediaFailure());
   }
  }

  @override
  Either<Failure, List<Media>> getMedias() {
    try{
      var medias = localDataSource.getMedias();
      List<Media> listOfMedias = [];
      for(var elem in medias){
        listOfMedias.add(elem.toMedia());
      }
      return Right(listOfMedias);
    }catch(e,stacktrace){
if (kDebugMode) {
  print(e);
  print(stacktrace);
}
    return Left(CacheFailure());
    }
  }

}