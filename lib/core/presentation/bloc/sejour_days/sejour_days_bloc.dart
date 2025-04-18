import 'dart:async';

import 'package:accompagnateur/core/error/failure.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/sejour_day.dart';
import '../../../domain/usecases/get_sejour_days.dart';

part 'sejour_days_event.dart';
part 'sejour_days_state.dart';

class SejourDaysBloc extends Bloc<SejourDaysEvent, SejourDaysState> {
  final GetSejourDays usecase;
  SejourDaysBloc({required this.usecase}) : super(SejourDaysInitial()) {
    print("I am SejourDaysBloc");
    on<LoadSejourDays>((event, emit) async{
      print("------we are in SejourBlocDays------");
      emit(LoadingSejourDays());
     var result =  await usecase.call();
     result.fold((l) {
       if(l is UnAuthorizedFailure){
         emit(UnAuthorizedSejourDay());
       }else{
         emit(ErrorSejourDays());
       }

     } , (r) {
       print("sucess sejour days bloc");
       int selectedIndex = -1;
       var today = DateTime.now();
       if(today.isBefore(r.first.date)){
         print(r.first.date);
         print("today before sejour");
         selectedIndex = 0;
       }else if(today.isAfter(r.last.date)){
         print(r.last.date);
         print("today after sejour");
         selectedIndex = r.length -1;
       }
       else {
         print("today in sejour");
         int i = 0;
         bool indexFound = false;
         while(i < r.length && !indexFound){
           if(today.month==r[i].date.month && today.year==r[i].date.year && today.day==r[i].date.day){
             selectedIndex = i ;
             indexFound = true;
           }
           i++;
         }
       }
       print("just before emit");
       emit(SejourDaysLoaded(sejourDays: r, selectedDayIndex: selectedIndex));
     });
    });
    on<ChangeSejourDay>((event,emit){
      emit(ChangingSejourDays());
      print("changing the sejour days");
      print("the new date ${event.sejourDays[event.newSelectedDayIndex].date}");
      emit(SejourDaysLoaded(sejourDays: event.sejourDays, selectedDayIndex: event.newSelectedDayIndex));
    });
  }
}
