import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/audio_messages/domain/entity/audio_message.dart';
import 'package:accompagnateur/features/audio_messages/domain/repository/audio_message_repository.dart';
import 'package:dartz/dartz.dart';

class StopRecording {
  final AudioMessageRepository repository;
  StopRecording({required this.repository});
  Future<Either<Failure, AudioMessage>> call() async {
    return await repository.stopRecording();
  }
}
