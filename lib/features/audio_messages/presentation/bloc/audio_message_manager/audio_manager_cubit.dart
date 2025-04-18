import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entity/audio_message.dart';
import '../../../domain/usecase/delete_audio_message.dart';
import '../../../domain/usecase/rename_audio_message.dart';
import '../../../domain/usecase/upload_audio.dart';

part 'audio_manager_state.dart';

class AudioManagerCubit extends Cubit<AudioManagerState> {
  final DeleteAudioMessage deleteAudioMessage;
  final RenameAudioMessage renameAudioMessage;
  final UploadAudio uploadAudio;
  AudioManagerCubit({required this.renameAudioMessage, required this.deleteAudioMessage, required this.uploadAudio}) : super(AudioManagerInitial());
Future<void> renameAudioMessageFile(String path, String newName)async{
  emit(Processing());
  var result = await renameAudioMessage.call(path, newName);
  result.fold((l) => emit(AudioManagerError()), (r) => emit(AudioMessageRenamed()));
}
Future<void> deleteAudioMessageFile(AudioMessage audioMessage)async{
  emit(Processing());
  print("we are deleting audio message");
  var result = await deleteAudioMessage.call(audioMessage);
  result.fold((l) => emit(AudioManagerError()), (r) => emit(AudioMessageDeleted()));
}
Future<void> uploadAudioMessage(AudioMessage audioMessage, String date)async{
  emit(Processing());
  var result = await uploadAudio.call(audioMessage,date);
  print("we got the result from the bloc");
  print(result);
  result.fold((l) {
    print("we are on the error side");
    emit(AudioManagerError());
  } , (r){
    print("audio upload success");
    emit(AudioMessageShared());
  });

}

}

