import 'package:accompagnateur/core/data/entity/sejourAttachment.dart';
import 'package:accompagnateur/core/domain/usecases/get_sejour_attachements.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sejour_attachments_event.dart';
part 'sejour_attachments_state.dart';

class SejourAttachmentsBloc extends Bloc<SejourAttachmentsEvent, SejourAttachmentsState> {
  final GetSejourAttachements usecase;

  SejourAttachmentsBloc({required this.usecase}) : super(SejourAttachmentsInitial()) {
    on<LoadSejourAttachmentEvent>((event, emit) async {
      emit(LoadingSejourAttachments());
      print("loading sejour days");
      var result = await usecase.call(event.codeSejour, event.date);
      await result.fold((l) async {
        if (l is ServerFailure) {
          emit(SejourAttachmentsError(message: l.message));
        } else if (l is UnAuthorizedFailure) {
          emit(UnAuthorizedSejourAttachment());
        }
      }, (r) async {
        r.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
       var sortedList =  sortAttachments(r);
          emit(SejourAttachmentsLoaded(
            sejourAttachmentsList: sortedList,
          ));
      });
    });

  }
  List<SejourAttachment> sortAttachments(List<SejourAttachment> attachments) {
    List<SejourAttachment> withComment = [];
    List<SejourAttachment> withoutComment = [];

    // Separate items based on whether they have a comment
    for (var attachment in attachments) {
      if (attachment.comment != null && attachment.comment!.isNotEmpty) {
        withComment.add(attachment);
      } else {
        withoutComment.add(attachment);
      }
    }

    List<SejourAttachment> sortedList = [];
    int i = 0, j = 0;

    // Alternate between items from both lists
    while (i < withoutComment.length || j < withComment.length) {
      if (i < withoutComment.length) sortedList.add(withoutComment[i++]);
      if (j < withComment.length) sortedList.add(withComment[j++]);
    }

    return sortedList;
  }

}
