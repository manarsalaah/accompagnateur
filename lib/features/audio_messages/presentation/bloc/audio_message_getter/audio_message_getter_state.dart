part of 'audio_message_getter_bloc.dart';

abstract class AudioMessageGetterState{
  const AudioMessageGetterState();
}

class AudioMessageGetterInitial extends AudioMessageGetterState {
  @override
  List<Object> get props => [];
}
class AudioMessagesProvided extends AudioMessageGetterState {
  final List<AudioMessage> audioMessages;
  final int NumberOfSharedMessages;
  const AudioMessagesProvided({required this.audioMessages,required this.NumberOfSharedMessages});
  @override
  List<Object> get props => [audioMessages];
}
class ErrorProvidingAudioMessages extends AudioMessageGetterState {
  @override
  List<Object> get props => [];
}
class Loading extends AudioMessageGetterState {
  @override
  List<Object> get props => [];
}
