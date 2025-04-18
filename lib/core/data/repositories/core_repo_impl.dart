import 'package:accompagnateur/core/data/datasources/remote/remote_core_data_source.dart';
import 'package:accompagnateur/core/data/entity/sejourAttachment.dart';
import 'package:accompagnateur/core/domain/entities/sejour_day.dart';
import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:accompagnateur/core/error/exception.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../datasources/local/local_core_data_source.dart';

class CoreRepositoryImpl extends CoreRepository{
  final LocalCoreDataSource localDataSource;
  final RemoteCoreDataSource remoteDataSource;
  CoreRepositoryImpl({required this.localDataSource, required this.remoteDataSource});
  @override
  Future<Either<Failure, List<SejourDay>>> getSejourDays() async{
    try{
      var sejourDays = localDataSource.getSejourDays();
      if(sejourDays.isEmpty){
        var remoteSejourDays = await remoteDataSource.getSejourDaysFromRemote();
        sejourDays =  localDataSource.saveSejourDays(remoteSejourDays);
      }
      List<SejourDay> days = [];
      for(var e in sejourDays){
        days.add(e.toSejourDay());
      }
      return Right(days);
    } on UnAuthorizedException {
      return Left(UnAuthorizedFailure());
    }
    on ServerException catch(e){
      return Left(ServerFailure(message: e.message));
    }
    catch(error,stacktrace){
      if(kDebugMode){
        print(error);
        print(stacktrace);
      }
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<SejourAttachment>>> getSejourAttachements(String codeSejour, String date)async {
    try{
     return Right(await remoteDataSource.getSejourAttachments(codeSejour, date)) ;
    } on ServerException catch (e){
      print("we're going to send ServerFailure");
      return Left(ServerFailure(message: e.message));
    } on UnAuthorizedException catch(e){
      print("we're going to send UnAuthorizedFailure");
      return Left(UnAuthorizedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> uploadVisualAttachment(String sejourCode,String date,BuildContext context) async{
    try{
      await remoteDataSource.uploadVisualAttachment(sejourCode, date,context);
      return Right(null);
    } on UnAuthorizedException{
      return Left(UnAuthorizedFailure());
    }on ServerException catch(e){
      return Left(ServerFailure(message: e.message));
    }on NoInternetConnectionException catch(e) {
      await localDataSource.saveMediasToPublishLater(e.medias, e.date);
      return Left(NoInternetFailure());
    }
    on NoMediaPickedException{
      return Left(NoMediaPickedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> uploadAttachmentFromCamera(String codeSejour,String date) async{
    try{
      await remoteDataSource.uploadAttachmentFromCamera(codeSejour, date);
      return Right(null);
    } on UnAuthorizedException{
      return Left(UnAuthorizedFailure());
    }
   on ServerException catch (e){
      return Left(ServerFailure(message: e.message));
    }
    on NoMediaPickedException{
          return Left(NoMediaPickedFailure());
          }
  }

  @override
  Future<Either<Failure, void>> deleteAttachment(String attachmentId) async{
    try{
      return Right(await remoteDataSource.deleteAttachment(attachmentId));
    } on UnAuthorizedException {
      return Left(UnAuthorizedFailure());
    } on ServerException catch(e){
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addOrUpdateComment(String comment, String attId) async{
    try{
      return Right(await remoteDataSource.addOrUpdateComment(comment, attId));
    }on UnAuthorizedException{
      return Left(UnAuthorizedFailure());
    }on ServerException catch(e){
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<void> uploadPendingMedias() async {
    print("uploading pending media");
    final medias = localDataSource.getPendingMedias();
    print(medias.length);
      for (var media in medias) {
        try {
          await remoteDataSource.uploadMedia(media);
          localDataSource.deleteMedia(media);
        } catch (e) {
          print(e);
        }
      }
    // Stop the service if there are no more pending medias
    if (localDataSource.getPendingMedias().isEmpty) {

      localDataSource.stopService();
      throw NoMediaPickedException();
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String attachmentId) async{
    try{
      return Right(await remoteDataSource.deleteComment(attachmentId));
    }on UnAuthorizedException{
      return Left(UnAuthorizedFailure());
    }on ServerException catch(e){
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getDayDescription(String codeSejour, String date) async{
    try{
      return Right(await remoteDataSource.getDayDescription(codeSejour, date));
    }on UnAuthorizedException{
    return Left(UnAuthorizedFailure());
    }on ServerException catch(e){
    return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addOrUpdateDayDescription(String codeSejour, String date, String description) async{
    try{
      return Right(await remoteDataSource.addOrUpdateDayDescription(codeSejour, date, description));
    }on UnAuthorizedException{
      return Left(UnAuthorizedFailure());
    }on ServerException catch(e){
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDayDescription(String codeSejour, String date) async{
    try{
      return Right(await remoteDataSource.deleteDayDescription(codeSejour, date));
    }on UnAuthorizedException{
    return Left(UnAuthorizedFailure());
    }on ServerException catch(e){
    return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> uploadAudioAttachment(String codeSejour, String date) {
    // TODO: implement uploadAudioAttachment
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> sendSms(String codeSejour, String type) async{
    try{
      return Right(await remoteDataSource.sendSMS(codeSejour, type));
    }on UnAuthorizedException{
    return Left(UnAuthorizedFailure());
    }on ServerException catch(e){
    return Left(ServerFailure(message: e.message));
    }
  }

}