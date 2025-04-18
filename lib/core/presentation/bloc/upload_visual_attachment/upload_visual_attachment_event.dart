part of 'upload_visual_attachment_bloc.dart';

@immutable
abstract class UploadVisualAttachmentEvent {}
class UploadVisualAttachmentsEvent extends UploadVisualAttachmentEvent{
  final BuildContext context;
  final String date;
  final String codeSejour;
  UploadVisualAttachmentsEvent({required this.date,required this.codeSejour, required this.context});
}
class UploadAttachmentFromCameraEvent extends UploadVisualAttachmentEvent{
  final String codeSejour;
  final String date;
  UploadAttachmentFromCameraEvent({required this.date,required this.codeSejour});
}
class DeleteVisualUploadEvent extends UploadVisualAttachmentEvent{
  final String attachmentId;
  DeleteVisualUploadEvent({required this.attachmentId});
}
class AddOrUpdateCommentEvent extends UploadVisualAttachmentEvent{
  final String attachmentId;
  final String comment;
  AddOrUpdateCommentEvent({required this.comment, required this.attachmentId});
}

class DeleteCommentEvent extends UploadVisualAttachmentEvent{
  final String attachmentId;
  DeleteCommentEvent({required this.attachmentId});
}
class SendSMSEvent extends UploadVisualAttachmentEvent{
  final String codeSejour;
  final String type;
  SendSMSEvent({required this.codeSejour,required this.type});
}

