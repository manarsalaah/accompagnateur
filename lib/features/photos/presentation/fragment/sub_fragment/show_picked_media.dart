import 'dart:io';

import 'package:accompagnateur/core/utils/screen_util.dart';
import 'package:accompagnateur/features/photos/presentation/fragment/sub_fragment/video_widget.dart';
import 'package:accompagnateur/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../bloc/upload_media/upload_media_bloc.dart';

class ShowPickedMedia extends StatefulWidget {
  final File media;
  final bool isImage;
  final String path;
  final UploadMediaBloc uploadMediaBloc;

  const ShowPickedMedia(
      {required this.path ,required this.uploadMediaBloc,required this.media, required this.isImage, super.key});

  @override
  State<ShowPickedMedia> createState() => _ShowPickedMediaState();
}

class _ShowPickedMediaState extends State<ShowPickedMedia> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print("this is the path ${widget.media.path}");
    if (widget.isImage) {
      return Scaffold(
        body: SafeArea(
          child: BlocProvider.value(
            value: locator<UploadMediaBloc>(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                height: ScreenUtil.screenHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: ScreenUtil.screenWidth ,
                      height: ScreenUtil.screenHeight * 0.8,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(widget.media,fit: BoxFit.contain,)
                      ),
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
                                    onPressed: (){
                                    widget.uploadMediaBloc.add(SavingMediaEvent(media: widget.media, comment: controller.text, path: widget.path));
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
          ),
        ),
      );
    }else{
      return Scaffold(
        body: BlocProvider.value(
          value: locator<UploadMediaBloc>(),
          child: VideoWidget(file: widget.media,path: widget.path,uploadMediaBloc: widget.uploadMediaBloc,),
        ),
      );
    }

  }
}
