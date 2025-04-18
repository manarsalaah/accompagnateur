import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:accompagnateur/core/utils/app_strings.dart';
import 'package:accompagnateur/core/utils/utils.dart';
import 'package:accompagnateur/features/audio_messages/domain/entity/audio_message.dart';
import 'package:accompagnateur/features/audio_messages/presentation/bloc/audio_player/audio_player_bloc.dart';
import 'package:accompagnateur/features/audio_messages/presentation/widget/rename_modal.dart';
import 'package:accompagnateur/features/audio_messages/presentation/widget/start_button.dart';
import 'package:accompagnateur/features/audio_messages/presentation/widget/pause_button.dart';
import 'package:accompagnateur/features/audio_messages/presentation/widget/stop_button.dart';
import 'package:accompagnateur/features/audio_messages/presentation/widget/audio_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/audio_message_manager/audio_manager_cubit.dart';
import 'delete_modal.dart';

class AudioMessageListItem extends StatelessWidget {
  final AudioMessage audioMessage;
  final int index;

  const AudioMessageListItem({required this.index, required this.audioMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: ListTile(
              title: Text(
                "${audioMessage.name}.${audioMessage.extension}",
                style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: AppStrings.fontName,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                audioMessage.isShared ? "partagé" : "prêt à être partagé",
                style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: AppStrings.fontName,
                    fontWeight: FontWeight.w300),
              ),
              leading: const Icon(
                Icons.music_note,
                color: AppColors.primaryColor,
                size: 30,
              ),
              trailing: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                builder: (context, state) {
                  if (state is Playing) {
                    if (state.index == index) {
                      return StopButton(index: index);
                    }
                    return StartButton(audioMessage: audioMessage, index: index);
                  } else if (state is PlayerPaused) {
                    return Container();
                  } else {
                    return StartButton(audioMessage: audioMessage, index: index);
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async{
                    if(!audioMessage.isShared) {
                      await BlocProvider.of<AudioManagerCubit>(context).uploadAudioMessage(audioMessage,formatDate(audioMessage.recordedDate));
                      //await context.read<AudioManagerCubit>().uploadAudio(audioMessage,"2024-01-10");
                    }
                  },
                  child: Row(
                    children:  [
                      Icon(Icons.share, color: (audioMessage.isShared)?Colors.grey:AppColors.primaryColor,),
                      SizedBox(width: 4),
                      Text(
                        "Publier",
                        style: TextStyle(
                          color: (audioMessage.isShared)?Colors.grey:AppColors.primaryColor,
                          fontFamily: AppStrings.fontName,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8), // Spacing between the two actions
               /* GestureDetector(
                  onTap: () async{
                    // Add your rename functionality here
      if(!audioMessage.isShared) {
        await showRenameDialog(context, audioMessage.path);
      }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: (audioMessage.isShared)?Colors.grey:AppColors.primaryColor,),
                      SizedBox(width: 4),
                      Text(
                        "Renommer",
                        style: TextStyle(
                          color: (audioMessage.isShared)?Colors.grey:AppColors.primaryColor,
                          fontFamily: AppStrings.fontName,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),*/
                //SizedBox(width: 8),
                GestureDetector(
                  onTap: () async{
                    // Add your rename functionality here
                    await showDeleteDialog(context,audioMessage);

                  },
                  child: Row(
                    children: const [
                      Icon(Icons.cancel_outlined, color: AppColors.primaryColor),
                      SizedBox(width: 4),
                      Text(
                        "Supprimer",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: AppStrings.fontName,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
