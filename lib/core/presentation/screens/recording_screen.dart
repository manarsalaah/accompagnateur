import 'dart:async';

import 'package:accompagnateur/core/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:accompagnateur/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/audio_messages/presentation/bloc/audio_message_manager/audio_manager_cubit.dart';
import '../../../features/audio_messages/presentation/bloc/audio_recording/audio_recording_bloc.dart';
import '../../../service_locator.dart';
import '../../directory_manager/bloc/directory_manager_bloc.dart';
import '../../permissions/bloc/permission_bloc.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/screen_util.dart';
import '../widgets/error_popover.dart';


class RecordingScreen extends StatefulWidget {
  final NavigationBloc navigationBloc;
  const RecordingScreen({required this.navigationBloc,super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  Timer? _timer;
  Duration _duration = Duration.zero;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration += const Duration(seconds: 1);
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _duration = Duration.zero;
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enregistrement Audio"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<DirectoryManagerBloc>(
              create: (_) => locator(),
            ),
            BlocProvider<AudioRecordingBloc>(create: (_) => locator()),
            BlocProvider<PermissionBloc>(
              create: (_) => locator(),
            ),
            BlocProvider<AudioManagerCubit>(
              create: (context) => locator(),
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<AudioManagerCubit,AudioManagerState>(listener: (context,state){
                if(state is AudioMessageShared){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primaryColor,
                      content: Text("Action terminée avec succès",style: TextStyle(color: Colors.white,fontFamily: AppStrings.fontName),),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                else if(state is AudioManagerError){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      content: ErrorPopover(
                        message: AppStrings.recordingError,
                        onClose: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }),
              BlocListener<AudioRecordingBloc, AudioRecordingState>(
                listener: (context, state) {
                  if (state is RecordingError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: ErrorPopover(
                          message: AppStrings.recordingError,
                          onClose: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }else if (state is RecordingFinished) {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext buildContext) {
                        return Dialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Slightly increase the border radius for a smoother look
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(buildContext).size.width * 0.9, // Set width to 90% of the screen width
                            child: Container(
                              padding: EdgeInsets.all(16), // Add padding inside the dialog for a clean layout
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center, // Align vertically at the center
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Message audio bien enregistré. Que voulez-vous faire ?",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: AppColors.primaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.of(buildContext).pop();
                                        },

                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space the buttons
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(buildContext).pop();
                                            Navigator.of(buildContext).pop();
                                            widget.navigationBloc.add(NavigationItemSelected(0));
                                          },
                                          child: Text(
                                            "Retour vers l'accueil",
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),

                                      // Button 2
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () async{
                                            Navigator.of(buildContext).pop();
                                            await BlocProvider.of<AudioManagerCubit>(context).uploadAudioMessage(state.audioMessage,formatDate(state.audioMessage.recordedDate));
                                          },
                                          child: Text(
                                            "Publier le message",
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8), // Add space between the buttons
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(buildContext).pop();
                                            Navigator.of(buildContext).pop();
                                            widget.navigationBloc.add(NavigationItemSelected(1));
                                          },
                                          child: Text(
                                            "Consulter mes audios",
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );

                  }
                },
              ),
              BlocListener<DirectoryManagerBloc,DirectoryManagerState>(listener: (context,state){
                if(state is DirectoryCreated){
                  context.read<AudioRecordingBloc>().add(Record(path: state.path));
                }
              }),
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15,bottom: 15),
                  child: Center(
                    child: Text(
                      _formatDuration(_duration),
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: AppStrings.fontName,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                BlocBuilder<AudioRecordingBloc, AudioRecordingState>(
                  builder: (context, state) {
                    if (state is AudioRecordingInitial ||
                        state is RecordingFinished ||
                        state is RecordingError ||
                        state is RecordingCanceled) {
                      _resetTimer();
                      return Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15,bottom: 15),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    context.read<DirectoryManagerBloc>().add(const CreateOrGetDirectory(path: AppStrings.audioDirectoryPath));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor: AppColors.primaryColor,
                                    fixedSize: Size(
                                      ScreenUtil.screenHeight / 6,
                                      ScreenUtil.screenHeight / 6,
                                    ),
                                    shape: const CircleBorder(),
                                    side: BorderSide(color: Colors.white, width: 8),
                                  ),
                                  child: Icon(
                                    Icons.mic,
                                    color: Colors.white,
                                    size: ScreenUtil.screenHeight / 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is Recording) {
                      _startTimer();
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<AudioRecordingBloc>().add(FinishRecording());
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Colors.white,
                              fixedSize: Size(
                                ScreenUtil.screenHeight / 8,
                                ScreenUtil.screenHeight / 8,
                              ),
                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              Icons.stop,
                              color: AppColors.primaryColor,
                              size: ScreenUtil.screenHeight / 15,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  context.read<AudioRecordingBloc>().add(PauseRecording());
                                  _pauseTimer();
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Colors.white,
                                  fixedSize: Size(
                                    ScreenUtil.screenHeight / 8,
                                    ScreenUtil.screenHeight / 8,
                                  ),
                                  shape: const CircleBorder(),
                                ),
                                child: Icon(
                                  Icons.pause,
                                  color: AppColors.primaryColor,
                                  size: ScreenUtil.screenHeight / 15,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  context.read<AudioRecordingBloc>().add(CancelVoiceRecording());
                                  _resetTimer();
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Colors.white,
                                  fixedSize: Size(
                                    ScreenUtil.screenHeight / 8,
                                    ScreenUtil.screenHeight / 8,
                                  ),
                                  shape: const CircleBorder(),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: AppColors.primaryColor,
                                  size: ScreenUtil.screenHeight / 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      var directoryState = BlocProvider.of<DirectoryManagerBloc>(context).state;
                      if (directoryState is DirectoryCreated) {
                        return Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.read<AudioRecordingBloc>().add(FinishRecording());
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor: Colors.white,
                                fixedSize: Size(
                                  ScreenUtil.screenHeight / 8,
                                  ScreenUtil.screenHeight / 8,
                                ),
                                shape: const CircleBorder(),
                              ),
                              child: Icon(
                                Icons.stop,
                                color: AppColors.primaryColor,
                                size: ScreenUtil.screenHeight / 15,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    context.read<AudioRecordingBloc>().add(ResumeVoiceRecording());
                                    _startTimer();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor: Colors.white,
                                    fixedSize: Size(
                                      ScreenUtil.screenHeight / 8,
                                      ScreenUtil.screenHeight / 8,
                                    ),
                                    shape: const CircleBorder(),
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: AppColors.primaryColor,
                                    size: ScreenUtil.screenHeight / 15,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    context.read<AudioRecordingBloc>().add(CancelVoiceRecording());
                                    _resetTimer();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor: Colors.white,
                                    fixedSize: Size(
                                      ScreenUtil.screenHeight / 8,
                                      ScreenUtil.screenHeight / 8,
                                    ),
                                    shape: const CircleBorder(),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColors.primaryColor,
                                    size: ScreenUtil.screenHeight / 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
