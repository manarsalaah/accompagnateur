import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/audio_messages/domain/repository/audio_message_repository.dart';
import 'package:dartz/dartz.dart';

class StartRecording {
  final AudioMessageRepository repository;
  StartRecording({required this.repository});
  Future<Either<Failure, void>> call(String path) async {
    return await repository.record(path);
  }
}
