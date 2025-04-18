import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/audio_messages/domain/entity/audio_message.dart';
import 'package:accompagnateur/features/audio_messages/domain/repository/audio_message_repository.dart';
import 'package:dartz/dartz.dart';

class UploadAudio {
  final AudioMessageRepository repository;
  UploadAudio({required this.repository});
  Future<Either<Failure, void>> call(AudioMessage audioMessage,String date)async{
     var result = await repository.uploadAudio(audioMessage, date);
     print(result);
     return result;
  }
}