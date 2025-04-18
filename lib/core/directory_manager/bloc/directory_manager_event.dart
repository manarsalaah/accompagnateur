part of 'directory_manager_bloc.dart';

abstract class DirectoryManagerEvent extends Equatable {
  const DirectoryManagerEvent();
}
class CreateOrGetDirectory extends DirectoryManagerEvent{
  final String path;
  const CreateOrGetDirectory({required this.path});
  @override
  List<Object?> get props => [];
}
