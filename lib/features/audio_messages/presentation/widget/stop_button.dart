import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../bloc/audio_player/audio_player_bloc.dart';

class StopButton extends StatelessWidget {
  const StopButton({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        BlocProvider.of<AudioPlayerBloc>(context).add(
            StopAudioPlayer(index: index)
        );
      },
      icon: const Icon(
        Icons.stop,
        color: AppColors.primaryColor,
        size: 30,
      ),
    );
  }
}
