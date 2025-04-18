part of 'get_medias_bloc.dart';

abstract class GetMediasState extends Equatable {
  const GetMediasState();
}

class GetMediasInitial extends GetMediasState {
  @override
  List<Object> get props => [];
}
class LoadingMedias extends GetMediasState {
  @override
  List<Object> get props => [];
}
class MediasLoaded extends GetMediasState {
  Map<String, List<Media>> medias;
  MediasLoaded({required this.medias});
  @override
  List<Object> get props => [medias];
}
class ErrorLoadingMedias extends GetMediasState {
  @override
  List<Object> get props => [];
}

