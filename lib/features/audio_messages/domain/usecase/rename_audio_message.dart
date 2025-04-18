import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/audio_messages/domain/repository/audio_message_repository.dart';
import 'package:dartz/dartz.dart';

class RenameAudioMessage {
  final AudioMessageRepository repository;
  RenameAudioMessage({required this.repository});
  Future<Either<Failure, void>> call(String path, String newName) async {
    return await repository.renameAudioMessage(path,newName);
  }
}
