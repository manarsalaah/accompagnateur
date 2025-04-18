import 'package:accompagnateur/core/utils/app_strings.dart';
import 'package:accompagnateur/features/audio_messages/presentation/bloc/audio_message_manager/audio_manager_cubit.dart';
import 'package:accompagnateur/features/audio_messages/presentation/widget/audio_message_item.dart';
import 'package:accompagnateur/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/presentation/bloc/navigation/navigation_bloc.dart';
import '../../../../core/presentation/screens/recording_screen.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/screen_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/audio_message_getter/audio_message_getter_bloc.dart';
import '../bloc/audio_player/audio_player_bloc.dart';

class AudioMessageFragment extends StatelessWidget {
  const AudioMessageFragment({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
  providers: [
    BlocProvider(
  create: (context) => locator<AudioMessageGetterBloc>()..add(GetAudioMessagesEvent()),
),
    BlocProvider<AudioPlayerBloc>(
      create: (context) => locator(),
    ),
    BlocProvider<AudioManagerCubit>(
      create: (context) => locator(),
    ),
  ],
  child: MultiBlocListener(
  listeners: [
    BlocListener<AudioManagerCubit, AudioManagerState>(
  listener: (context, state) {
    if(state is AudioMessageDeleted || state is AudioMessageShared){
      context.read<AudioMessageGetterBloc>().add(GetAudioMessagesEvent());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primaryColor,
          content: Text("Action terminée avec succès",style: TextStyle(color: Colors.white,fontFamily: AppStrings.fontName),),
          duration: Duration(seconds: 2),
        ),
      );
    }
  },
),

  ],
  child: Container(
    color: Colors.white,
    child: Column(
        children: [
           Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mes messages audios",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                    fontFamily: AppStrings.fontName,
                      //fontWeight: FontWeight.w500,
                      fontSize: 20,
                  ),
                    textAlign: TextAlign.start,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.all(10), // Replace with AppColors.primaryColor
                    ),
                    onPressed: () {
                      final navigationBloc = BlocProvider.of<NavigationBloc>(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecordingScreen(navigationBloc:navigationBloc ,)),
                      );
                    },
                    child: Icon(
                      Icons.add_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15,bottom: 15),
              child: BlocBuilder<AudioMessageGetterBloc, AudioMessageGetterState>(
    builder: (context, state) {
      if(state is AudioMessagesProvided){
        return Text("${state.NumberOfSharedMessages} partagés",
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontFamily: AppStrings.fontName,
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
          textAlign: TextAlign.start,
        );
      }
      return const Text(" ",
                style: TextStyle(
                  color: AppColors.primaryColor,
                fontFamily: AppStrings.fontName,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
              ),
                textAlign: TextAlign.start,
              );
    },
    ),
            ),
          ),
          Expanded(
            child: BlocBuilder<AudioMessageGetterBloc, AudioMessageGetterState>(
              builder: (context, state) {
                if (state is AudioMessagesProvided) {
                  if (state.audioMessages.isEmpty) {
                    return Column(
                      children: [
                        SvgPicture.asset(
                          "assets/images/no_data.svg",
                          width: ScreenUtil.screenWidth / 5,
                          height: ScreenUtil.screenHeight / 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "vous n'avez pas de messages audios enregistrés",
                            style: TextStyle(
                              fontFamily: AppStrings.fontName,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return RefreshIndicator(
                      color: AppColors.primaryColor,
                      onRefresh: () async {
                        context.read<AudioMessageGetterBloc>().add(GetAudioMessagesEvent());
                      },
                      child: ListView.builder(
                        itemCount: state.audioMessages.length,
                        itemBuilder: (context, index) {
                          return AudioMessageListItem(
                            audioMessage: state.audioMessages[index],
                            index: index,
                          );
                        },
                      ),
                    );
                  }
                }
                return Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
              },
            ),
          )
        ],
      ),
  ),
),
);
  }
}
