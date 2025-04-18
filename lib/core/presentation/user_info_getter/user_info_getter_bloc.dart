import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service_locator.dart';
import '../../utils/app_strings.dart';

part 'user_info_getter_event.dart';
part 'user_info_getter_state.dart';

class UserInfoGetterBloc extends Bloc<UserInfoGetterEvent, UserInfoGetterState> {
  UserInfoGetterBloc() : super(UserInfoGetterInitial()) {
    Dio dio = locator();
    SharedPreferences preferences = locator();
    on<GetUserInfo>((event, emit)async{
      emit(Processing());
      try {
        String? token = preferences.getString(AppStrings.tokenKey);
        String? sejourCode = preferences.getString(AppStrings.codeSejourKey);

        if (token != null && sejourCode != null) {
          if (!JwtDecoder.isExpired(token)) {


          var response=  await dio.get("http://54.36.104.133:81/api/userinfo",options: Options(headers: {"Authorization": "Bearer $token"}));
          var nom = response.data["nom"];
          var prenom = response.data["prenom"];
          var numero = response.data["numero"];
          var email = response.data["email"];
            emit(Success(nom: nom, num: numero,email: email,prenom: prenom));

          } else {
            await preferences.setBool(AppStrings.isConnectedKey, false);
            emit(UnauthorizedInfo());
          }
        } else {
          await preferences.setBool(AppStrings.isConnectedKey, false);
          emit(UnauthorizedInfo());
        }
      }on DioException catch (e) {
        var msg = e.response?.data.toString() ?? e.message ?? e.toString();
        print(msg);
        emit(Problem(errorMsg: msg));
      }
    });
  }
}
