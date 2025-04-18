part of 'audio_player_bloc.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();
}
class StartAudioPlayer extends AudioPlayerEvent{
  final AudioMessage audioMessage;
  final int index;
  const StartAudioPlayer({required this.index,required this.audioMessage});
  @override
  List<Object?> get props => [audioMessage,index];

}
class PauseAudioPlayer extends AudioPlayerEvent{
  final AudioMessage audioMessage;
  final int index;
  const PauseAudioPlayer({required this.audioMessage, required this.index});
  @override
  List<Object?> get props => [audioMessage,index];

}
class StopAudioPlayer extends AudioPlayerEvent{
  final int index;
  const StopAudioPlayer({required this.index});
  @override
  List<Object?> get props => [index];

}


