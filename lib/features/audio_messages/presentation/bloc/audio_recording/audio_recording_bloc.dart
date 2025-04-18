import 'package:accompagnateur/features/audio_messages/domain/usecase/pause.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/record.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utils/utils.dart';
import '../../../domain/entity/audio_message.dart';
import '../../../domain/usecase/cancel_recording.dart';
import '../../../domain/usecase/resume_recording.dart';
import '../../../domain/usecase/stop_recording.dart';

part 'audio_recording_event.dart';
part 'audio_recording_state.dart';

class AudioRecordingBloc extends Bloc<AudioRecordingEvent, AudioRecordingState> {
  final StartRecording record;
  final Pause pause;
  final StopRecording stopRecording;
  final ResumeRecording resumeRecording;
  final CancelRecording cancelRecording;
  AudioRecordingBloc({required this.record, required this.stopRecording, required this.pause, required this.cancelRecording, required this.resumeRecording}) : super(AudioRecordingInitial()) {

    on<Record>((event, emit) async{
      print("!!!!!!!!we are recording!!!!!!!!");
      print("this is the path ${event.path}");
      emit (Recording());
      final now = inverseDate(DateTime.now());
      final String subPath = '$now.mp3';
     final result =  await record.call(event.path+subPath);
     result.fold((l) => emit(RecordingError()), (r) => null);
    });
    on<PauseRecording>((event, emit) async{
     final result =  await pause.call();
     result.fold((l) => emit(RecordingError()), (r) => emit(RecordingPaused()));
    });
    on<FinishRecording>((event, emit) async{
      emit (Recording());
     final result = await stopRecording.call();
     result.fold((l) => emit(RecordingError()), (r) => emit(RecordingFinished(audioMessage: r)));
    });
    on<CancelVoiceRecording>((event,emit)async{
      final result = await cancelRecording.call();
      result.fold((l) => emit(RecordingError()), (r) => emit(RecordingCanceled()));
    });
    on<ResumeVoiceRecording>((event,emit)async{
      emit (Recording());
      final result = await resumeRecording.call();
      result.fold((l) => emit(RecordingError()), (r) => null);
    });
  }
}
