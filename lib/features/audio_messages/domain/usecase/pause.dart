import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/audio_messages/domain/repository/audio_message_repository.dart';
import 'package:dartz/dartz.dart';

class Pause {
  final AudioMessageRepository repository;
  Pause({required this.repository});
  Future<Either<Failure, void>> call() async {
    return await repository.pause();
  }
}
