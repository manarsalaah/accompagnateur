part of 'audio_recording_bloc.dart';

abstract class AudioRecordingEvent extends Equatable {
  const AudioRecordingEvent();
}
class Record extends AudioRecordingEvent{
  String path;
  Record({required this.path});
  @override
  List<Object?> get props => [];
}
class PauseRecording extends AudioRecordingEvent{
  @override
  List<Object?> get props => [];
}
class FinishRecording extends AudioRecordingEvent{
  @override
  List<Object?> get props => [];
}
class ResumeVoiceRecording extends AudioRecordingEvent{
  @override
  List<Object?> get props => [];
}
class CancelVoiceRecording extends AudioRecordingEvent{
  @override
  List<Object?> get props => [];
}
