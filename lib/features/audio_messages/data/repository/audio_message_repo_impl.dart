import 'package:accompagnateur/core/error/exception.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/audio_messages/domain/entity/audio_message.dart';
import 'package:accompagnateur/features/audio_messages/domain/repository/audio_message_repository.dart';
import 'package:dartz/dartz.dart';

import '../data_source/local/audio_message_local_data_source.dart';
import '../data_source/remote/audio_message_remote_datasource.dart';

class AudioMessageRepositoryImpl implements AudioMessageRepository{
final AudioMessageLocalDataSource localDataSource;
final AudioMessageRemoteDataSource remoteDataSource;
AudioMessageRepositoryImpl({required this.localDataSource, required this.remoteDataSource});
  @override
  Future<Either<Failure, void>> deleteAudioMessage(AudioMessage audioMessage) async{
    try{
      print("in audio repo impl");
      if(!audioMessage.isShared) {
        print("going to localDataSource");
        return Right(await localDataSource.deleteAudioMessage(audioMessage.path));
      }else{
        print("going to remoteDataSource");
        return Right(await remoteDataSource.deleteAudioMessage(audioMessage));
      }
    }catch(e){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> pause() async{
    try{
      await localDataSource.pause();
      return const Right(null);
    } on RecordException catch (e){
      return Left(RecordFailure(message: e.message));
    }
    catch(e){
      return Left(RecordFailure(message: "une erreur est survenue"));
    }
  }

  @override
  Future<Either<Failure, void>> renameAudioMessage(String path,String newName) async{
    try{
      await localDataSource.renameAudioMessage(path, newName);
      return const Right(null);
    }catch(e){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> record(String path) async{
    try {
      await localDataSource.record(path);
      return const Right(null);
    } on RecordException catch(e) {
      return Left(RecordFailure(message:e.message ));
    }
    catch(e){
      return Left(RecordFailure(message: "une erreur est survenue"));
    }
  }

  @override
  Future<Either<Failure, AudioMessage>> stopRecording() async{
  try{
    final path = await localDataSource.stopRecording();
   final audioMessage = await localDataSource.saveAudioMessage(path, 0, false);
    return Right(audioMessage.toAudioMessage());
  }on RecordException catch(e) {
    return Left(RecordFailure(message:e.message ));
  }
  catch(e){
    return Left(RecordFailure(message: "une erreur est survenue"));

  }
  }

  @override
  Future<Either<Failure, List<AudioMessage>>> getAllAudioMessages() async{
    try{
      final localAudioMessages = localDataSource.getAllAudioMessagesFromLocal();
      final  remoteAudioMessages = await remoteDataSource.getListOfAudioMessages();
      final List<AudioMessage>audios  = [];
      for (var element in localAudioMessages) {
        audios.add(element.toAudioMessage());
      }for (var element in remoteAudioMessages) {
        audios.add(element.toAudioMessage());
      }
     return Right(audios) ;

    }catch(e){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> pausePlayer() async{
    try{
      await localDataSource.pausePlayer();
      return const Right(null);
    }catch (e){
      return Left(PlayerFailure(message: e.toString()));
    }

  }

  @override
  Future<Either<Failure, void>> startPlayer(AudioMessage audioMessage) async{
    try{
      await localDataSource.startPlayer(audioMessage);
      return const Right(null);
    }catch (e){
      return Left(PlayerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopPlayer() async{
    try{
      await localDataSource.stopPlayer();
      return const Right(null);
    }catch (e){
      return Left(PlayerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelRecording() async{
    try{
      await localDataSource.cancelRecording();
      return const Right(null);
    }catch(e){
      return Left(RecordFailure(message:e.toString() ));
    }
  }

  @override
  Future<Either<Failure, void>> resumeRecording() async{
    try{
      await localDataSource.resumeRecording();
      return const Right(null);
    }catch(e){
      return Left(RecordFailure(message:e.toString() ));
    }
  }

  @override
  Future<Either<Failure, void>> uploadAudio(AudioMessage audioMessage, String date) async{
    try{
      await remoteDataSource.publishAudioMessage(audioMessage, date);
      await localDataSource.deleteAudioMessage(audioMessage.path);
      print("sending the right response");
      return const Right(null);
    }
    on ServerException catch (e){
      return Left(ServerFailure(message: e.message));
    }
    on UnAuthorizedException {
      return Left(UnAuthorizedFailure());
    }
    catch (ex){
      return Left(CacheFailure());
    }
  }


}