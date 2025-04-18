part of 'audio_recording_bloc.dart';



abstract class AudioRecordingState extends Equatable {
  const AudioRecordingState();
}

class AudioRecordingInitial extends AudioRecordingState {
  @override
  List<Object> get props => [];
}
class Recording extends AudioRecordingState {
  @override
  List<Object> get props => [];
}
class RecordingPaused extends AudioRecordingState {
  @override
  List<Object> get props => [];
}
class RecordingCanceled extends AudioRecordingState {
  @override
  List<Object> get props => [];
}
class RecordingFinished extends AudioRecordingState {
  final AudioMessage audioMessage;
  RecordingFinished({required this.audioMessage});
  @override
  List<Object> get props => [];
}
class RecordingError extends AudioRecordingState {
  @override
  List<Object> get props => [];
}
