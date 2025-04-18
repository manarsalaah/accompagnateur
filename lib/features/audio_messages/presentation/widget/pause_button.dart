import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../domain/entity/audio_message.dart';
import '../bloc/audio_player/audio_player_bloc.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({
    super.key,
    required this.index,
    required this.audioMessage
  });

  final int index;
  final AudioMessage audioMessage;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        BlocProvider.of<AudioPlayerBloc>(context).add(
          PauseAudioPlayer( index: index, audioMessage: audioMessage)
        );
      },
      icon: const Icon(
        Icons.pause,
        color: AppColors.primaryColor,
        size: 30,
      ),
    );
  }
}
