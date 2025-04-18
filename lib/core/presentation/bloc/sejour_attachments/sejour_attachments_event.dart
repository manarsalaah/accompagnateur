part of 'sejour_attachments_bloc.dart';

abstract class SejourAttachmentsEvent extends Equatable {
  const SejourAttachmentsEvent();
}
class LoadSejourAttachmentEvent extends SejourAttachmentsEvent{
  final String codeSejour;
  final String date;
  LoadSejourAttachmentEvent({required this.codeSejour, required this.date});
  @override
  List<Object?> get props => [codeSejour,date];
}