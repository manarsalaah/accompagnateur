import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/add_or_udpate_day_description.dart';
import '../../../domain/usecases/delete_day_description.dart';
import '../../../domain/usecases/get_day_description.dart';

part 'day_description_event.dart';
part 'day_description_state.dart';

class DayDescriptionBloc
    extends Bloc<DayDescriptionEvent, DayDescriptionState> {
  GetDayDescription getDayDescription;
  DeleteDayDescription deleteDayDescription;
  AddOrUpdateDayDescription addOrUpdateDayDescription;

  DayDescriptionBloc(
      {required this.getDayDescription,
      required this.addOrUpdateDayDescription,
      required this.deleteDayDescription})
      : super(DayDescriptionInitial()) {
    on<GetDayDescriptionEvent>((event, emit) async {
      emit(DayDescriptionLoading());
      var descriptionApiResponse =
          await getDayDescription.call(event.codeSejour, event.date);
      descriptionApiResponse.fold((l) => emit(DayDescriptionError()),
          (r) => emit(DayDescriptionSuccess(description: r)));
    });
    on<DeleteDayDescriptionEvent>((event, emit) async {
      emit(DayDescriptionLoading());
      var descriptionApiResponse =
          await deleteDayDescription.call(event.codeSejour, event.date);
      descriptionApiResponse.fold((l) => emit(DayDescriptionError()),
          (r) => emit(DayDescriptionSuccess(description: null)));
    });
    on<AddOrUpdateDayDescriptionEvent>((event, emit) async {
      emit(DayDescriptionLoading());
      var descriptionApiResponse =
          await addOrUpdateDayDescription.call(event.codeSejour, event.date,event.description);
      descriptionApiResponse.fold((l) => emit(DayDescriptionError()),
          (r) => emit(DayDescriptionSuccess(description: event.description)));
    });
  }
}
