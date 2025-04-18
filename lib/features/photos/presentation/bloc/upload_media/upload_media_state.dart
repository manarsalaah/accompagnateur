part of 'upload_media_bloc.dart';

abstract class UploadMediaState extends Equatable {
  const UploadMediaState();
}

class UploadMediaInitial extends UploadMediaState {
  @override
  List<Object> get props => [];
}
class Uploading extends UploadMediaState {
  @override
  List<Object> get props => [];
}
class PickingMediaFromGallery extends UploadMediaState {
  @override
  List<Object> get props => [];
}
class PickingMediaFromCamera extends UploadMediaState {
  @override
  List<Object> get props => [];
}
class SavingMedia extends UploadMediaState {
  @override
  List<Object> get props => [];
}
class MediaSaved extends UploadMediaState {
  @override
  List<Object> get props => [];
}
class MediaPicked extends UploadMediaState {
  final File media;
  final bool isImage;
  const MediaPicked({required this.media, required this.isImage});
  @override
  List<Object> get props => [media,isImage];
}
class Uploaded extends UploadMediaState {
  @override
  List<Object> get props => [];
}
class UploadingError extends UploadMediaState {
  @override
  List<Object> get props => [];
}class PickingError extends UploadMediaState {
  @override
  List<Object> get props => [];
}class SavingError extends UploadMediaState {
  @override
  List<Object> get props => [];
}
