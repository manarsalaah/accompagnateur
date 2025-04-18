import 'package:accompagnateur/core/directory_manager/directory_manager_service.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'directory_manager_event.dart';
part 'directory_manager_state.dart';

class DirectoryManagerBloc extends Bloc<DirectoryManagerEvent, DirectoryManagerState> {
  final DirectoryManagerService service  ;
  DirectoryManagerBloc({required this.service}) : super(DirectoryManagerInitial()) {


    on<CreateOrGetDirectory>((event, emit) async{
      print("!!!!!!!!DirectoryManager!!!!!!!!");
      emit(CreatingDirectory());
      final result = await service.getOrCreateDirectory(event.path);
      result.fold((l) => emit(DirectoryFailure(failure: l as DirectoryManagerFailure)), (r) => emit(DirectoryCreated(path: r)));
    });
  }
}
