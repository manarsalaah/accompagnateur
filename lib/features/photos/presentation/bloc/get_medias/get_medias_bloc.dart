
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entity/photo.dart';
import '../../../domain/usecase/get_medias.dart';

part 'get_medias_event.dart';
part 'get_medias_state.dart';

class GetMediasBloc extends Bloc<GetMediasEvent, GetMediasState> {
  final GetMedias useCase;
  GetMediasBloc({required this.useCase}) : super(GetMediasInitial()) {
    on<GetListOfMedia>((event, emit) {
      print("get medias event has been triggered");
      emit(LoadingMedias());
     var result =  useCase.call();
      result.fold((l) => emit(ErrorLoadingMedias()), (r) {
        print("get media bloc success");
        Map<String, List<Media>> groupedMedia = <String, List<Media>>{};
        for(var media in r){
          String day = media.date.day.toString();
          if(day.length <2){
            day ="0$day";
          }
          String month = media.date.month.toString();
          if(month.length <2){
            month ="0$month";
          }
          final String dateString = '${media.date.year}-$month-$day';
          if (!groupedMedia.containsKey(dateString)) {
            groupedMedia[dateString] = [];
          }
          groupedMedia[dateString]?.add(media);
        }
        emit(MediasLoaded(medias: groupedMedia));
      });
    });
  }
}
