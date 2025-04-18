import 'dart:io';

import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:accompagnateur/core/utils/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../bloc/upload_media/upload_media_bloc.dart';

class VideoWidget extends StatefulWidget {
  final File file;
  final String path;
  final UploadMediaBloc uploadMediaBloc;
  const VideoWidget({required this.uploadMediaBloc,required this.path,required this.file,super.key});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController videoPlayerController;
  late bool isPlaying;
  late TextEditingController controller;
  @override
  void initState() {
      super.initState();
      controller = TextEditingController();
      videoPlayerController = VideoPlayerController.file(widget.file);
      videoPlayerController.setLooping(true);
      videoPlayerController.initialize();
      isPlaying= true;
      videoPlayerController.play();

  }
  togglePlayer()async{
    if(isPlaying){
     setState(() {
       isPlaying = false;
     });
     await videoPlayerController.pause();
    }
    else{
      setState(() {
        isPlaying = true;
      });
      await videoPlayerController.play();
    }
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    videoPlayerController.dispose();
  }
  String _videoDuration(Duration duration){
    String twoDigits (int n)=>n.toString().padLeft(2,'0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds);
    return[
      if(duration.inHours >0) hours,
      minutes,
      seconds
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SizedBox(
          height: ScreenUtil.screenHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: ()async{
                  await togglePlayer();
                },
                child: SizedBox(
                  width: ScreenUtil.screenWidth,
                    height: ScreenUtil.screenHeight * 0.75,
                    child: VideoPlayer(videoPlayerController)
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 4),
                child: Row(
                  children: [
                    ValueListenableBuilder(valueListenable: videoPlayerController, builder: (context,VideoPlayerValue value,child){
                      return Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(_videoDuration(value.position),style: TextStyle(
                            color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500
                          ),
                          ),
                        ),
                      );
                    }),
                    Expanded(
                      flex : 5,
                      child: VideoProgressIndicator(videoPlayerController, allowScrubbing: true,
                        colors: const VideoProgressColors(playedColor: AppColors.primaryColor),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(_videoDuration(videoPlayerController.value.duration),style: TextStyle(
                        color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500
                        ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              IconButton(onPressed: ()async{
                await togglePlayer();
              },
                  icon: isPlaying ? const Icon(Icons.pause,color: AppColors.primaryColor,): const Icon(Icons.play_arrow,color: AppColors.primaryColor)
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          flex: 4,
                          child: TextField(
                            cursorColor: AppColors.primaryColor,
                            style: const TextStyle(
                                fontFamily: AppStrings.fontName,
                                fontWeight: FontWeight.w400
                            ),
                            decoration: InputDecoration(
                              hintText: "veuillez saisir votre commentaire",
                              hintStyle: const TextStyle(
                                  fontFamily: AppStrings.fontName,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryColor
                              ),
                              focusedBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 1.0
                                ),
                              ) ,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 1.0
                                ),
                              ),
                            ),
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child: ElevatedButton(

                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(const Size(50, 50)),
                                elevation: MaterialStateProperty.all(2),
                                shape: MaterialStateProperty.all<CircleBorder>(
                                  const CircleBorder(),
                                ),
                                backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                              ),
                              onPressed: () {
                                widget.uploadMediaBloc.add(SavingMediaEvent(media: widget.file, comment: controller.text, path: widget.path));
                                Navigator.of(context).pop();
                              }, child: const Icon(Icons.send,color: Colors.white,)))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
