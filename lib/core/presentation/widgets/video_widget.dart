import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../utils/utils.dart';
import '../bloc/upload_visual_attachment/upload_visual_attachment_bloc.dart';
import '../screens/full_screen_video_page.dart';
import '../../utils/app_strings.dart';
import '../../utils/screen_util.dart';

class VideoWidget extends StatefulWidget {
  final String id;
  final String path;
  final DateTime uploadDate;
  final String? comment;
  int likesNumber;
  final String? filePath;

  VideoWidget({
    this.filePath,
    required this.id,
    required this.likesNumber,
    required this.comment,
    required this.path,
    required this.uploadDate,
    super.key,
  });

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  late File videoFile;

  @override
  void initState() {
    super.initState();
    videoFile = File(widget.filePath!);
    _controller = VideoPlayerController.file(videoFile);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.5 && !_isPlaying) {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    } else if (info.visibleFraction <= 0.5 && _isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.id),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: ScreenUtil.screenWidth * 0.6,
        child: SizedBox(
          height: ScreenUtil.screenHeight / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onLongPress: ()async{
                    if(widget.comment != null){
                      var dialogResult = await showCommentOptionsDialog(context);
                      print(dialogResult);
                      if(dialogResult == 1){
                        // modifier
                        var updatedComment =  await showUpdateCommentDialog(context,widget.comment!);
                        if(updatedComment != null){
                          if(context.mounted) {
                            context.read<UploadVisualAttachmentBloc>().add(AddOrUpdateCommentEvent(comment: updatedComment, attachmentId: widget.id));
                           // context.read<UploadVisualAttachmentBloc>().add(UpdateCommentEvent(comment: updatedComment,attachmentId: widget.id));
                          }
                        }
                      } else if(dialogResult == 2){
                        // supprimer
                        if(context.mounted){
                          if(await showDeleteCommentDialog(context)){
                            context.read<UploadVisualAttachmentBloc>().add(DeleteCommentEvent(attachmentId: widget.id));

                          }
                        }
                      }
                    }
                  },
                  child: Visibility(
                    visible: (widget.comment != null)? true : false,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text((widget.comment != null)? widget.comment! : "",style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppStrings.fontName,
                      ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: GestureDetector(
                  onTap: () {
                   /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenVideoPage(videoPath: widget.path, videoFile: videoFile,),
                      ),
                    );*/
                  },
                  child: Hero(
                    tag: widget.path,
                    child: Container(
                      height: 200,
                      width: ScreenUtil.screenWidth * 0.8,
                      child: FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return VideoPlayer(_controller);
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: ()async{
                              String? comment = await showCommentDialog(context);
                              if(comment!= null){
                                if(context.mounted) {
                                  context.read<UploadVisualAttachmentBloc>().add(AddOrUpdateCommentEvent(comment: comment, attachmentId: widget.id));
                                }
                              }
                            },
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/images/add_comment.svg", width: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Text(
                                      "commenter",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: AppStrings.fontName,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () async{
                                var confirmation =  await showMyDepublierDialog(context);
                                if(confirmation) {
                                  if(context.mounted) {
                                    context.read<UploadVisualAttachmentBloc>().add(DeleteVisualUploadEvent(attachmentId: widget.id));
                                  }
                                }
                              },
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/images/delete_att.svg", width: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Text(
                                        "dépublier",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: AppStrings.fontName,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("assets/images/likes.svg", width: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              "${widget.likesNumber} J'aime",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: AppStrings.fontName,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
