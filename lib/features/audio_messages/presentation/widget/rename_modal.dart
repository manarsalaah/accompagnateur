import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:accompagnateur/core/utils/app_strings.dart';
import 'package:accompagnateur/features/audio_messages/presentation/bloc/audio_message_manager/audio_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future showRenameDialog(BuildContext context,String path){
  final TextEditingController textController = TextEditingController();
  return showDialog(
    context: context, // Provide the context of your widget
    builder: (_) {
      return AlertDialog(
        title: const Text("Renommer Le fichier",style: TextStyle(color: AppColors.primaryColor),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("veuillze saisir le noveau nom de fichier"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: ()async{
              var newName = textController.value.text;
            await BlocProvider.of<AudioManagerCubit>(context).renameAudioMessageFile(path,newName);
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