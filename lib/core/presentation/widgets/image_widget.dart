import 'dart:io';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/upload_visual_attachment/upload_visual_attachment_bloc.dart';
import '../../utils/app_strings.dart';
import '../../utils/screen_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/full_screen_image_page.dart';

class ImageWidget extends StatelessWidget {
  final String id;
  final String path;
  final DateTime uploadDate;
  final int likesNumber;
  final String? comment;
  final String? filePath;
  final List<File> images;
  final int index;

  const ImageWidget({
    required this.id,
    required this.likesNumber,
    required this.comment,
    required this.path,
    required this.uploadDate,
    required this.filePath,
    required this.images,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    File mediaFile = File(filePath!);

    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: ScreenUtil.screenWidth * 0.6,
      child: SizedBox(
        height: ScreenUtil.screenHeight / 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (comment != null)
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: (){print("clicked !!");},
                  behavior: HitTestBehavior.translucent,
                  onLongPress: () async {
                    print("comment long press");
                    var dialogResult = await showCommentOptionsDialog(context);
                    if (dialogResult == 1) {
                      var updatedComment = await showUpdateCommentDialog(context, comment!);
                      if (updatedComment != null) {
                        if (context.mounted) {
                          context.read<UploadVisualAttachmentBloc>().add(
                            AddOrUpdateCommentEvent(comment: updatedComment, attachmentId: id),
                          );
                        }
                      }
                    } else if (dialogResult == 2) {
                      if (context.mounted) {
                        if (await showDeleteCommentDialog(context)) {
                          context.read<UploadVisualAttachmentBloc>().add(
                            DeleteCommentEvent(attachmentId: id),
                          );
                        }
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
                    child: Text(
                      comment!,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppStrings.fontName,
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
                      builder: (context) => FullScreenImagePage(
                        images: images,
                        initialIndex: index,
                      ),
                    ),
                  );*/
                },
                child: Hero(
                  tag: path,
                  child: Container(
                    height: 200,
                    width: ScreenUtil.screenWidth * 0.8,
                    child: Image.file(mediaFile),
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
                          onTap: () async {
                            String? comment = await showCommentDialog(context);
                            if (comment != null) {
                              if (context.mounted) {
                                context.read<UploadVisualAttachmentBloc>().add(
                                  AddOrUpdateCommentEvent(comment: comment, attachmentId: id),
                                );
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
                            onTap: () async {
                              var confirmation = await showMyDepublierDialog(context);
                              if (confirmation) {
                                if (context.mounted) {
                                  context.read<UploadVisualAttachmentBloc>().add(
                                    DeleteVisualUploadEvent(attachmentId: id),
                                  );
                                }
                              }
                            },
                            child: SizedBox(
                              height: 30,
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
                          child: Row(
                            children: [
                              Text(
                                "$likesNumber ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: AppStrings.fontName,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "J'aime",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: AppStrings.fontName,
                                ),
                              ),
                            ],
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
    );
  }
}
