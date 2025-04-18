import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/audio_messages/domain/repository/audio_message_repository.dart';
import 'package:dartz/dartz.dart';

import '../entity/audio_message.dart';

class DeleteAudioMessage {
  final AudioMessageRepository repository;
  DeleteAudioMessage({required this.repository});
  Future<Either<Failure, void>> call(AudioMessage audioMessage) async {
    return await repository.deleteAudioMessage(audioMessage);
  }
}
