import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../domain/entity/audio_message.dart';
import '../../../domain/usecase/get_all_audio_messages.dart';

part 'audio_message_getter_event.dart';
part 'audio_message_getter_state.dart';

class AudioMessageGetterBloc extends Bloc<AudioMessageGetterEvent, AudioMessageGetterState> {
  final GetAllAudioMessages usecase;
  AudioMessageGetterBloc({required this.usecase}) : super(AudioMessageGetterInitial()) {
    on<GetAudioMessagesEvent>((event, emit) async{
      emit(Loading());
      final audioMessages = await usecase.call();
      print(audioMessages);
      audioMessages.fold((l) => emit(ErrorProvidingAudioMessages()), (r) {
        int sharedMessagesNumber =0;
        for(var element in r){
          if(element.isShared){
            sharedMessagesNumber ++;
          }
        }
        emit(AudioMessagesProvided(audioMessages: r, NumberOfSharedMessages: sharedMessagesNumber));
      } );
    });
  }
}
