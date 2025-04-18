import 'package:accompagnateur/core/directory_manager/bloc/directory_manager_bloc.dart';
import 'package:accompagnateur/core/permissions/bloc/permission_bloc.dart';
import 'package:accompagnateur/features/photos/presentation/bloc/get_medias/get_medias_bloc.dart';
import 'package:accompagnateur/features/photos/presentation/bloc/upload_media/upload_media_bloc.dart';
import 'package:accompagnateur/features/photos/presentation/fragment/sub_fragment/list_media_fragment.dart';
import 'package:accompagnateur/features/photos/presentation/fragment/sub_fragment/show_picked_media.dart';
import 'package:accompagnateur/features/photos/presentation/fragment/sub_fragment/upload_media_fragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/permissions/permission_service.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../service_locator.dart';

class PhotoFragment extends StatelessWidget {
  const PhotoFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<UploadMediaBloc>(),
        ),
        BlocProvider(
          create: (context) => locator<GetMediasBloc>()..add(GetListOfMedia()),
        ),
        BlocProvider(
          create: (context) => locator<PermissionBloc>(),
        ),
        BlocProvider(
          create: (context) => locator<DirectoryManagerBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UploadMediaBloc,UploadMediaState>(listener: (context,state){
           if(context.read<DirectoryManagerBloc>().state is  DirectoryCreated){
             DirectoryCreated directoryState = context.read<DirectoryManagerBloc>().state as DirectoryCreated;
             if (state is MediaPicked){
               Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => ShowPickedMedia(uploadMediaBloc: locator(),media: state.media, isImage: state.isImage,path: directoryState.path,)));
             }
           }
           if(state is MediaSaved){
             context.read<GetMediasBloc>().add(GetListOfMedia());
           }

          }),
          BlocListener<PermissionBloc,PermissionState>(listener: (context,state){
            print(state);
    if(state is PermissionGranted){
      print(state.permission);
      if(state.permission == Permissions.manageExternalStorage.permission){
        context.read<DirectoryManagerBloc>().add(const CreateOrGetDirectory(path: AppStrings.imagesDirectoryPath));
      }
    }else if(state is PermissionDenied){
      //print("the denied permission is ${state.permission}" );
      context.read<PermissionBloc>().add(RequestPermission(permission: state.permission));
    }
          }),
          BlocListener<DirectoryManagerBloc,DirectoryManagerState>(listener: (context,state){
            if(state is DirectoryCreated){
              if(BlocProvider.of<UploadMediaBloc>(context).state is PickingMediaFromGallery) {
                context.read<UploadMediaBloc>().add(PickingMediaFromGalleryEvent());
              }else if(BlocProvider.of<UploadMediaBloc>(context).state is PickingMediaFromCamera){
                context.read<UploadMediaBloc>().add(PickingMediaFromCameraEvent());
              }
            }else if (state is DirectoryFailure){
              const snackBar = SnackBar(
                content: Text(AppStrings.directoryError),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }),
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const UploadMediaFragment(),
                BlocBuilder< GetMediasBloc, GetMediasState>(
              builder: (context, state) {
                if (state is MediasLoaded){
                  if(state.medias.isNotEmpty) {
            return ListMediaFragment(medias: state.medias,);
                  }else{
            return Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/images/no_data.svg",
                    width: ScreenUtil.screenWidth/5,
                    height: ScreenUtil.screenHeight/5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("vous n'avez pas de photos / vidéos enregistrés",style: TextStyle(
                      fontFamily: AppStrings.fontName,
                      fontWeight: FontWeight.w300,

                    ),
                    ),
                  ),
                ],
              ),
            );
                  }
                }
              return Container();
              },
            )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
