part of 'audio_player_bloc.dart';

abstract class AudioPlayerState extends Equatable {
  const AudioPlayerState();
}

class AudioPlayerInitial extends AudioPlayerState {
  @override
  List<Object> get props => [];
}
class Playing extends AudioPlayerState {
  final AudioMessage audioMessage;
  final int index;
  const Playing({required this.audioMessage, required this.index});
  @override
  List<Object> get props => [audioMessage,index];
}
class PlayerPaused extends AudioPlayerState {
  final AudioMessage audioMessage;
  final int index;
  const PlayerPaused({required this.index,required this.audioMessage});
  @override
  List<Object> get props => [audioMessage,index];
}
class PlayerStopped extends AudioPlayerState {
  final int index;
  const PlayerStopped({required this.index});
  @override
  List<Object> get props => [index];
}
class PlayerError extends AudioPlayerState{
  final int index;
 const PlayerError({required this.index});
  @override
  List<Object?> get props => [index];

}
