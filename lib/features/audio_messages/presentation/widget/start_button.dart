import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../domain/entity/audio_message.dart';
import '../bloc/audio_player/audio_player_bloc.dart';

class StartButton extends StatelessWidget {
  const StartButton({
    super.key,
    required this.audioMessage,
    required this.index,
  });

  final AudioMessage audioMessage;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        BlocProvider.of<AudioPlayerBloc>(context).add(
            StartAudioPlayer(index: index, audioMessage: audioMessage));
      },
      icon: const Icon(
        Icons.play_arrow,
        color: AppColors.primaryColor,
        size: 30,
      ),
    );
  }
}