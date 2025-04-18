import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/audio_messages/domain/entity/audio_message.dart';
import 'package:dartz/dartz.dart';

abstract class AudioMessageRepository {
  Future<Either<Failure, void>> record( String path);
  Future<Either<Failure, void>> pause();
  Future<Either<Failure, void>> resumeRecording();
  Future<Either<Failure, void>> cancelRecording();
  Future<Either<Failure, void>> startPlayer(AudioMessage audioMessage);
  Future<Either<Failure, void>> pausePlayer();
  Future<Either<Failure, void>> stopPlayer();
  Future<Either<Failure, AudioMessage>> stopRecording();
  Future<Either<Failure, void>> deleteAudioMessage(AudioMessage audioMessage);
  Future<Either<Failure, void>> renameAudioMessage(String path,String newName);
  Future<Either<Failure, List<AudioMessage>>> getAllAudioMessages();
  Future<Either<Failure,void>> uploadAudio(AudioMessage audioMessage ,String date);
}
