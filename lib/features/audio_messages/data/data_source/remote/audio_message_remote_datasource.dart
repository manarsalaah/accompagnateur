import 'dart:io';

import 'package:accompagnateur/features/audio_messages/data/entity/audio_message_entity.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/utils.dart';
import '../../../domain/entity/audio_message.dart';

abstract class AudioMessageRemoteDataSource{
  Future<void> publishAudioMessage(AudioMessage entity,String date);
  Future<void> deleteAudioMessage(AudioMessage entity);
  Future<List<AudioMessageEntity>> getListOfAudioMessages();
}
class AudioMessageRemoteDataSourceImpl extends AudioMessageRemoteDataSource{
  final Dio dio;
  final SharedPreferences preferences;
  AudioMessageRemoteDataSourceImpl({required this.dio,required this.preferences});
  @override
  Future<void> publishAudioMessage(AudioMessage entity,String date) async{
    try{
      String? token = preferences.getString(AppStrings.tokenKey);
      String? sejourCode = preferences.getString(AppStrings.codeSejourKey);
      if(token!= null && sejourCode!= null) {
        if (!JwtDecoder.isExpired(token)) {
            var mediaType =  getMediaType(entity.path);
            print("the selected image path ${entity.path}");
            final FormData formData = FormData.fromMap({
              "file": await MultipartFile.fromFile(entity.path, filename: entity.path.split(context.separator).last),
              "date":date,
              "type":mediaType
            });
            await dio.post(AppStrings.baseUrl+AppStrings.attachment+sejourCode,data: formData,options: Options(headers: {"Authorization": "Bearer $token"}));

        }else{
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }else{
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    }on DioException catch (e){
      var msg = e.response?.data.toString()?? e.message??e.toString();
      print(msg);
      throw ServerException(message: msg);
    }
  }

  @override
  Future<List<AudioMessageEntity>> getListOfAudioMessages() async{
    try {
      await clearTemporaryFiles("audios");
      String? token = preferences.getString(AppStrings.tokenKey);
      String? sejourCode = preferences.getString(AppStrings.codeSejourKey);
      if(token!= null && sejourCode!= null){
        if(!JwtDecoder.isExpired(token)){
          var response = await dio.get('${AppStrings.baseUrl}${AppStrings.attachment}$sejourCode?type=audio',options: Options(headers: {"Authorization": "Bearer $token"}));
          if (response.statusCode == 200) {
            var data = response.data as List<dynamic>;
            List<AudioMessageEntity> attachments = data.map((item) => AudioMessageEntity.fromJson(item)).toList();
            for (var elem in attachments) {
              var mediaResponse = await dio.get(elem.path,
                  options: Options(headers: {"Authorization": "Bearer $token"}, responseType: ResponseType.bytes));
              if (mediaResponse.statusCode == 200) {
                elem.audioData = mediaResponse.data;
                File mediaFile = await saveMediaToFile(elem.audioData!, "${elem.name}${elem.extension}","audios");
                elem.path = mediaFile.path;
              }
            }
            return attachments;
          } else if (response.statusCode == 404) {
            return [];
          } else {
            throw ServerException(message: "Unexpected status code: ${response.statusCode}");
          }
        }else{
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }else{
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    } on DioException catch (ex) {
      if (ex.response != null && ex.response?.statusCode == 404) {
        return [];
      }
      var msg = ex.response?.data?? ex.message??ex.toString();
      throw ServerException(message: msg);
    }
  }

  @override
  Future<void> deleteAudioMessage(AudioMessage entity) async{
    try{
      print("in remote datasource");
      print(entity.attachmentId);
      String? token = preferences.getString(AppStrings.tokenKey);
      if(token!= null) {
        print("token non null");
        if (!JwtDecoder.isExpired(token)) {
          print("token didn't expire");
          print("this is the url -> ${AppStrings.baseUrl}${AppStrings.deleteAtt}${entity.attachmentId!}");
        var result =  await dio.post(AppStrings.baseUrl+AppStrings.deleteAtt+entity.attachmentId!,options: Options(headers: {"Authorization": "Bearer $token"}));
        print("this is the result -> ${result.data}");
        }else{
          print("token expired");
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }
      else{
        print("token null");
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    }on DioException catch(e){
      var msg = e.response?.data.toString()?? e.message??e.toString();
      print(msg);
      throw ServerException(message: msg);
    }
  }

  }

