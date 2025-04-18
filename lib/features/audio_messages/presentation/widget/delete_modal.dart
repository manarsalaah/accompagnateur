import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:accompagnateur/core/utils/app_strings.dart';
import 'package:accompagnateur/features/audio_messages/presentation/bloc/audio_message_manager/audio_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/audio_message.dart';

Future showDeleteDialog(BuildContext context,AudioMessage audioMessage){
  return showDialog(
    context: context, // Provide the context of your widget
    builder: (_) {
      return AlertDialog(
        title: const Text("Supprimer Le fichier",style: TextStyle(color: AppColors.primaryColor),),
        content: const Text("êtes vous sûr de vouloir supprimer le fichier"),
        actions: [
          TextButton(onPressed: ()async{

            await BlocProvider.of<AudioManagerCubit>(context).deleteAudioMessageFile(audioMessage);
            if(context.mounted) {
              Navigator.of(context).pop();
            }
          }, child: Text("Confirmer",style: TextStyle(
              color:  AppColors.primaryColor,
              fontFamily: AppStrings.fontName
          ),
          )
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Annuler",style: TextStyle(
          color:  AppColors.secondaryColor,
          fontFamily: AppStrings.fontName
          ),
          )
          ),
        ],
      );
    },
  );
}