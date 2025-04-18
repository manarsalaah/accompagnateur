part of 'upload_visual_attachment_bloc.dart';

@immutable
abstract class UploadVisualAttachmentState {}

class UploadVisualAttachmentInitial extends UploadVisualAttachmentState {}
class UploadingVisualAttachment extends UploadVisualAttachmentState{}
class UploadingVisualAttachmentError extends UploadVisualAttachmentState{
  String message;
  UploadingVisualAttachmentError({required this.message});
}
class UploadingVisualAttachmentSucces extends UploadVisualAttachmentState{}
class UnAuthorizedUpload extends UploadVisualAttachmentState{
  String message;
  UnAuthorizedUpload({required this.message});
}
class DeletingVisualUpload extends UploadVisualAttachmentState{}
class NoInternetUploadError extends UploadVisualAttachmentState{}
class VisualUploadDeleted extends UploadVisualAttachmentState{}
class CommentingAttachment extends UploadVisualAttachmentState{}
class CommentAttachmentSuccess extends UploadVisualAttachmentState{}
class SendingSms extends UploadVisualAttachmentState{}
class SmsSentSuccess extends UploadVisualAttachmentState{}
