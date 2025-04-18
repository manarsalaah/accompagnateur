import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/audio_message.dart';
import '../repository/audio_message_repository.dart';

class GetAllAudioMessages {
  final AudioMessageRepository repository;
  GetAllAudioMessages({required this.repository});
  Future<Either<Failure, List<AudioMessage>>> call() {
    final resut = repository.getAllAudioMessages();
    return resut;
  }
}
