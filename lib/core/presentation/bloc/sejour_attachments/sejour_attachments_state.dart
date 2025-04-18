part of 'sejour_attachments_bloc.dart';

abstract class SejourAttachmentsState extends Equatable {
  const SejourAttachmentsState();
}

class SejourAttachmentsInitial extends SejourAttachmentsState {
  @override
  List<Object> get props => [];
}
class LoadingSejourAttachments extends SejourAttachmentsState {
  @override
  List<Object> get props => [];
}
class SejourAttachmentsLoaded extends SejourAttachmentsState {
  final List<SejourAttachment> sejourAttachmentsList;
  SejourAttachmentsLoaded({required this.sejourAttachmentsList});
  @override
  List<Object> get props => [sejourAttachmentsList];
}
class SejourAttachmentsError extends SejourAttachmentsState {
final String message;
  SejourAttachmentsError({required this.message});
  @override
  List<Object> get props => [message];
}
class UnAuthorizedSejourAttachment extends SejourAttachmentsState{
  @override
  List<Object?> get props => [];
}

