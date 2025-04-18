part of 'get_medias_bloc.dart';

abstract class GetMediasEvent extends Equatable {
  const GetMediasEvent();
}
class GetListOfMedia extends GetMediasEvent {

  @override
  List<Object?> get props => [];

}
