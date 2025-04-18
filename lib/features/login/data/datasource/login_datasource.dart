import 'dart:convert';
import 'package:accompagnateur/core/error/exception.dart';
import 'package:accompagnateur/objectbox.dart';
import 'package:accompagnateur/objectbox_singleton.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/app_strings.dart';

class LoginDataSource {
  final Dio dio;
  final SharedPreferences preferences;

  LoginDataSource({required this.dio, required this.preferences});

  Future<void> login(String userName, String password) async {
    try {
      final data = {
        "username": userName,
        "password": password
      };
      print(AppStrings.baseUrl + AppStrings.login);
      print(jsonEncode(data));
      var loginResult = await dio.post(AppStrings.baseUrl + AppStrings.login, data: jsonEncode(data));
      String token = loginResult.data["token"];
      if(preferences.containsKey(AppStrings.codeSejourKey)){
        var oldCode = preferences.getString(AppStrings.codeSejourKey);
        if(oldCode != userName){
          // here goes the clearing of the objectbox data base
          ObjectBoxSingleton().clearDatabase();
        }
      }
      await preferences.setString(AppStrings.tokenKey, token);
      await preferences.setString(AppStrings.codeSejourKey, userName);
      await preferences.setBool(AppStrings.isConnectedKey,true);
    } on DioException catch (e, stacktrace) {
      print(stacktrace);
      if (e.response?.statusCode == 401) {
        throw UnAuthorizedException(message: "Unauthorized access");
      }
      var msg = e.response?.data.toString() ?? e.message ?? e.toString();
      print(e.response?.statusCode);
      print(msg);
      throw ServerException(message: msg);
    }
  }
}
