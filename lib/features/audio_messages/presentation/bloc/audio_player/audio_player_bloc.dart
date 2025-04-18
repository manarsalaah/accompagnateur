
import 'package:accompagnateur/features/audio_messages/domain/entity/audio_message.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecase/pause_player.dart';
import '../../../domain/usecase/start_player.dart';
import '../../../domain/usecase/stop_player.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayer audioPlayer ;
  final StartPlayer startPlayer;
  final PausePlayer pausePlayer;
  final StopPlayer stopPlayer;
  AudioPlayerBloc({required this.startPlayer, required this.stopPlayer, required this.pausePlayer,required this.audioPlayer}) : super(AudioPlayerInitial()) {
    playerComplete(int index) {
      audioPlayer.onPlayerComplete.listen((event) {
        emit(PlayerStopped(index: index));
      });
    }
    on<StartAudioPlayer>((event, emit) async {
      emit(Playing(audioMessage: event.audioMessage, index: event.index));
      final result = await startPlayer.call(event.audioMessage);
      result.fold((l) => emit(PlayerError(index: event.index)), (r) => playerComplete(event.index));
    });
    on<PauseAudioPlayer>((event, emit) async {
      final result = await pausePlayer.call();
      result.fold((l) => emit(PlayerError(index: event.index)), (r) =>
          emit(PlayerPaused(audioMessage: event.audioMessage, index: event.index)));
    });
    on<StopAudioPlayer>((event, emit) async {
      final result = await stopPlayer.call();
      result.fold((l) => emit(PlayerError(index: event.index)), (r) =>
          emit(PlayerStopped(index: event.index)));
    });

  }
}
