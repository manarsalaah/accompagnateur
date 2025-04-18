import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:accompagnateur/core/utils/app_strings.dart';
import 'package:accompagnateur/core/utils/screen_util.dart';
import 'package:accompagnateur/features/photos/presentation/bloc/upload_media/upload_media_bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/permissions/bloc/permission_bloc.dart';
import '../../../../../core/permissions/permission_service.dart';

class UploadMediaFragment extends StatelessWidget {
  const UploadMediaFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child:
          //ImageIcon(AssetImage("assets/images/image-gallery.png"),color: AppColors.primaryColor,size: ScreenUtil.screenHeight/6,),
          SvgPicture.asset(
            "assets/images/image_upload.svg",
            width: ScreenUtil.screenWidth/1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: const Text("Vous pouvez partager une photo ou un vidéo en choissisant sa source",
            textAlign: TextAlign.center,
            style: TextStyle(
            fontFamily: AppStrings.fontName,
            fontWeight: FontWeight.w300,

          ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                  onPressed: (){
                  context.read<UploadMediaBloc>().add(EmitPickingMediaFromGalleryEvent());
                    context.read<PermissionBloc>().add(CheckPermission(permission: Permissions.manageExternalStorage.permission));
                  }, child:const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.image,color: Colors.white,),
                  SizedBox(width: 3,),
                  Text("Galerie",style: TextStyle(
                    fontFamily: AppStrings.fontName,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  ),
                  )

                ],
              )
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                  onPressed: (){
                    context.read<UploadMediaBloc>().add(EmitPickingMediaFromCameraEvent());
                    context.read<PermissionBloc>().add(CheckPermission(permission: Permissions.manageExternalStorage.permission));
                  }, child:const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.camera_alt,color: Colors.white,),
                  SizedBox(width: 3,),
                  Text("Caméra",style: TextStyle(
                    fontFamily: AppStrings.fontName,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  ),)

                ],
              )
              ),
            ],
          ),
        )

      ],
    );
  }
}
