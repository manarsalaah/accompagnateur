part of 'upload_media_bloc.dart';

abstract class UploadMediaEvent extends Equatable {
  const UploadMediaEvent();
}
class UploadMediaFromGalleryEvent extends UploadMediaEvent{
  final String path;
  const UploadMediaFromGalleryEvent({required this.path});
  @override
  List<Object?> get props => [path];
}
class UploadMediaFromCameraEvent extends UploadMediaEvent{
  @override
  List<Object?> get props => [];
}
class PickingMediaFromGalleryEvent extends UploadMediaEvent{
  @override
  List<Object?> get props => [];
}
class PickingMediaFromCameraEvent extends UploadMediaEvent{
  @override
  List<Object?> get props => [];
}
class EmitPickingMediaFromGalleryEvent extends UploadMediaEvent{
  @override
  List<Object?> get props => [];
}
class EmitPickingMediaFromCameraEvent extends UploadMediaEvent{
  @override
  List<Object?> get props => [];
}
class SavingMediaEvent extends UploadMediaEvent{
  final File media;
  final String path;
  final String comment;
  const SavingMediaEvent({required this.media,required this.comment, required this.path});
  @override
  List<Object?> get props => [];
}
