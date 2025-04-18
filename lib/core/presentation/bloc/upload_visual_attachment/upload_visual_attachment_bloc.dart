import 'package:accompagnateur/core/error/failure.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/add_or_update_comment.dart';
import '../../../domain/usecases/delete_attachment.dart';
import '../../../domain/usecases/delete_comment.dart';
import '../../../domain/usecases/send_sms.dart';
import '../../../domain/usecases/upload_attachment_from_camera.dart';
import '../../../domain/usecases/upload_visual_attachment.dart';

part 'upload_visual_attachment_event.dart';
part 'upload_visual_attachment_state.dart';

class UploadVisualAttachmentBloc extends Bloc<UploadVisualAttachmentEvent, UploadVisualAttachmentState> {
  UploadVisualAttachments usecase;
  UploadAttachmentFromCamera uploadFromCamera;
  DeleteAttachment deleteAttachment;
  AddOrUpdateComment addorUpdateComment;
  DeleteComment deleteComment;
  SendSMS sendSMS;

  UploadVisualAttachmentBloc({required this.sendSMS,required this.deleteComment,required this.addorUpdateComment, required this.deleteAttachment,required this.usecase, required this.uploadFromCamera}) : super(UploadVisualAttachmentInitial()) {
    on<UploadVisualAttachmentsEvent>((event, emit) async{
      emit(UploadingVisualAttachment());
var result = await usecase.call(event.codeSejour,event.date,event.context);
result.fold((l) {
  if(l is UnAuthorizedFailure){
    emit(UnAuthorizedUpload(message: "veuillez vous reconnecter"));
  }else if (l is ServerFailure){
    emit(UploadingVisualAttachmentError(message:l.message));
  }
  else if(l is NoMediaPickedFailure){

  }
  else if(l is NoInternetFailure){
    emit(NoInternetUploadError());
  }

} , (r) => emit(UploadingVisualAttachmentSucces()));
    });
    on<UploadAttachmentFromCameraEvent>((event, emit) async{
      emit(UploadingVisualAttachment());
var result = await uploadFromCamera.call(event.codeSejour,event.date);
result.fold((l) {
  if(l is UnAuthorizedFailure){
    emit(UnAuthorizedUpload(message: "veuillez vous reconnecter"));
  } else if(l is ServerFailure){
    emit(UploadingVisualAttachmentError(message:l.message));
  }

}, (r) => emit(UploadingVisualAttachmentSucces()));
    });
    on<DeleteVisualUploadEvent>((event, emit) async{
    emit(DeletingVisualUpload());
    var result = await deleteAttachment.call(event.attachmentId);
    result.fold((l) {
      if(l is UnAuthorizedFailure){
        emit(UnAuthorizedUpload(message: "veuillez vous reconnecter"));
      }else if (l is ServerFailure){
        emit(UploadingVisualAttachmentError(message:l.message));
      }
    }, (r) => emit(VisualUploadDeleted()));
    });
    on<AddOrUpdateCommentEvent>((event,emit)async{
      emit(CommentingAttachment());
      var result = await addorUpdateComment.call(event.comment, event.attachmentId);
      result.fold((l) {
        if(l is UnAuthorizedFailure){
          emit(UnAuthorizedUpload(message: "veuillez vous reconnecter"));
        }else if (l is ServerFailure){
          emit(UploadingVisualAttachmentError(message:l.message));
        }
      }, (r) => emit(CommentAttachmentSuccess()));
    });

on<SendSMSEvent>((event,emit)async{
  emit(SendingSms());
  var result = await sendSMS.call(event.codeSejour, event.type);
  result.fold((l) {
    if(l is UnAuthorizedFailure){
      emit(UnAuthorizedUpload(message: "veuillez vous reconnecter"));
    }else if (l is ServerFailure){
      emit(UploadingVisualAttachmentError(message:l.message));
    }
  }, (r) => emit(SmsSentSuccess()));
});

    on<DeleteCommentEvent>((event,emit)async{
      emit(CommentingAttachment());
      var result = await deleteComment.call(event.attachmentId);
      result.fold((l) {
        if(l is UnAuthorizedFailure){
          emit(UnAuthorizedUpload(message: "veuillez vous reconnecter"));
        }else if (l is ServerFailure){
          emit(UploadingVisualAttachmentError(message:l.message));
        }
      }, (r) => emit(CommentAttachmentSuccess()));
    });
  }
}
