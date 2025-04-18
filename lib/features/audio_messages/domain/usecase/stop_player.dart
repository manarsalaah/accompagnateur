import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/audio_messages/domain/repository/audio_message_repository.dart';
import 'package:dartz/dartz.dart';

class StopPlayer{
  final AudioMessageRepository repository;
  StopPlayer({required this.repository});
  Future<Either<Failure,void>> call() async{
    return await repository.stopPlayer();
}
}