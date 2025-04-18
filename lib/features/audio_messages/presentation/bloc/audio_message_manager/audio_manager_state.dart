part of 'audio_manager_cubit.dart';

abstract class AudioManagerState extends Equatable {
  const AudioManagerState();
}

class AudioManagerInitial extends AudioManagerState {
  @override
  List<Object> get props => [];
}
class AudioMessageRenamed extends AudioManagerState {
  @override
  List<Object> get props => [];
}
class AudioMessageDeleted extends AudioManagerState {
  @override
  List<Object> get props => [];
}
class AudioMessageShared extends AudioManagerState {
  @override
  List<Object> get props => [];
}
class AudioManagerError extends AudioManagerState {
  @override
  List<Object> get props => [];
}
class Processing extends AudioManagerState {
  @override
  List<Object> get props => [];
}
