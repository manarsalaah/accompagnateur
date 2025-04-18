import 'package:accompagnateur/core/utils/app_strings.dart';
import 'package:accompagnateur/core/utils/screen_util.dart';
import 'package:accompagnateur/features/audio_messages/presentation/bloc/audio_message_manager/audio_manager_cubit.dart';
import 'package:accompagnateur/features/audio_messages/presentation/widget/delete_modal.dart';
import 'package:accompagnateur/features/audio_messages/presentation/widget/rename_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../core/presentation/bloc/upload_visual_attachment/upload_visual_attachment_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/utils.dart';

class AudioToolTip extends StatelessWidget {

final String id;
  const AudioToolTip({required this.id,super.key});

  @override
  Widget build(BuildContext context) {
    SuperTooltipController controller = SuperTooltipController();
    return SuperTooltip(
      popupDirection: TooltipDirection.up,
      controller: controller,
      content: Container(
        width: ScreenUtil.screenWidth/2,
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                await controller.hideTooltip();
                if(context.mounted) {
                  String? comment = await showCommentDialog(context);
                  if (comment != null && context.mounted) {
                    context.read<UploadVisualAttachmentBloc>().add(
                      AddOrUpdateCommentEvent(comment: comment, attachmentId: id),
                    );
                  }
                }

              },
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
            Divider(
              color: Colors.black45,
            ),
            GestureDetector(
              onTap: () async {
      await controller.hideTooltip();
      if(context.mounted) {
        var confirmation = await showMyDepublierDialog(context);
        if (confirmation && context.mounted) {
          context.read<UploadVisualAttachmentBloc>().add(
            DeleteVisualUploadEvent(attachmentId: id),
          );
        }
      }
              },
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
           /* const Divider(
              color: Colors.black45,
            ),
            GestureDetector(

              onTap: ()async{
               await controller.hideTooltip();
               if(context.mounted) {
                // await showDeleteDialog(context,path);
               }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.delete),
                  ),
                  Text("Supprimer",style: TextStyle(
                      fontFamily: AppStrings.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
      child: IconButton(
    onPressed: () async {
    await controller.showTooltip();
    },
    icon: const Icon(
    Icons.more_vert,
    size: 30,
    ),
      )
    );
  }
}
