part of 'directory_manager_bloc.dart';

abstract class DirectoryManagerState extends Equatable {
  const DirectoryManagerState();
}

class DirectoryManagerInitial extends DirectoryManagerState {
  @override
  List<Object> get props => [];
}
class DirectoryCreated extends DirectoryManagerState {
  final String path;
  const DirectoryCreated({required this.path});
  @override
  List<Object> get props => [];
}
class CreatingDirectory extends DirectoryManagerState {
  @override
  List<Object> get props => [];

}
class DirectoryFailure extends DirectoryManagerState {
  final DirectoryManagerFailure failure ;
  const DirectoryFailure({required this.failure});
  @override
  List<Object> get props => [];

}
