import 'dart:async';
import 'dart:io';

import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/photos/domain/usecase/upload_media_from_gallery.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/utils/utils.dart';
import '../../../domain/usecase/capture_photo.dart';
import '../../../domain/usecase/pick_media_from_gallery.dart';
import '../../../domain/usecase/save_media.dart';

part 'upload_media_event.dart';
part 'upload_media_state.dart';

class UploadMediaBloc extends Bloc<UploadMediaEvent, UploadMediaState> {
  final UploadMediaFromGallery fromGallery ;
  final SaveMedia saveMedia;
  final PickMediaFromGallery pickMediaFromGallery;
  final CapturePhoto capturePhoto;
  UploadMediaBloc({required this.fromGallery,required this.saveMedia, required this.pickMediaFromGallery, required this.capturePhoto}) : super(UploadMediaInitial()) {
    on<UploadMediaFromGalleryEvent>((event, emit) async{
      emit(Uploading());
      final res = await fromGallery.call(event.path);
      res.fold((l) => emit(UploadingError()), (r) => Uploaded());
    });
    on<EmitPickingMediaFromGalleryEvent>((event, emit) {
      emit(PickingMediaFromGallery());
    });
    on<EmitPickingMediaFromCameraEvent>((event, emit) {
      emit(PickingMediaFromCamera());
    });
    on<SavingMediaEvent>((event, emit) async{
      emit(SavingMedia());
    var result = await saveMedia.call(event.path, event.media, event.comment);
    result.fold((l){
      print("bloc failure");
      emit(SavingError());
    }  , (r) {
      print("bloc success");
      emit(MediaSaved());
    });
    });
    on<PickingMediaFromGalleryEvent>((event, emit) async{
      emit(PickingMediaFromGallery());
var result = await pickMediaFromGallery.call();
    result.fold((l) {
      if(l is MediaPickingFailure){

        emit(PickingError());
      }
    }, (r){

      String extension = r.path.split(".").last;
      bool isPhoto = isImage(extension);
      emit(MediaPicked(media: r,isImage: isPhoto));

    });
    });
    on<PickingMediaFromCameraEvent>((event, emit) async{
      emit(PickingMediaFromCamera());
var result = await capturePhoto.call();
    result.fold((l) {
      if(l is MediaPickingFailure){
        emit(PickingError());
      }
    }, (r){

      String extension = r.path.split(".").last;
      bool isPhoto = isImage(extension);
      emit(MediaPicked(media: r,isImage: isPhoto));
    });
    });
  }
}
