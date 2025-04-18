import 'package:accompagnateur/core/utils/app_colors.dart';
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
import '../../../../core/utils/utils.dart';

class AttachmentToolTip extends StatelessWidget {

  final String id;
  const AttachmentToolTip({required this.id,super.key});

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
                   // SvgPicture.asset("assets/images/add_comment.svg", width: 20),
                    Icon(Icons.edit_outlined,size: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        "Ajouter un commentaire",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: AppStrings.fontName,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4,
              ),
              GestureDetector(
                onTap: () async {
                  await controller.hideTooltip();
                },
                child: Row(
                  children: [
                    Icon(Icons.favorite,size: 20,color: AppColors.secondaryColor,),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        "Ajouter à l'album séjour",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: AppStrings.fontName,
                          color: AppColors.secondaryColor
                        )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4,
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
                    Icon(Icons.delete,size: 20,color: Colors.redAccent,),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        "Supprimer",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: AppStrings.fontName,
                          color: Colors.redAccent
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
        child: GestureDetector(
          onTap: ()async{
            await controller.showTooltip();
          },
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.more_vert,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
    );
  }
}
