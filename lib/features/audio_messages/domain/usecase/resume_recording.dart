import 'package:accompagnateur/features/audio_messages/domain/repository/audio_message_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class ResumeRecording{
  final AudioMessageRepository repository;
  ResumeRecording({required this.repository});
  Future<Either<Failure, void>> call()async{
   return await repository.resumeRecording();
  }
}