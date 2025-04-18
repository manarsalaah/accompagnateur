
import 'dart:io';
import 'dart:math';
import 'package:accompagnateur/core/data/entity/sejourAttachment.dart';
import 'package:accompagnateur/core/data/entity/sejour_edntity.dart';
import 'package:accompagnateur/core/error/exception.dart';
import 'package:accompagnateur/core/utils/app_strings.dart';
import 'package:accompagnateur/features/photos/data/entity/photo_entity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


import '../../../directory_manager/directory_manager_service.dart';
import '../../../utils/utils.dart';
abstract class RemoteCoreDataSource{
  Future<List<SejourDayEntity>> getSejourDaysFromRemote();
  Future <List<SejourAttachment>> getSejourAttachments(String sejourCode, String date);
  Future <void> uploadVisualAttachment(String sejourCode, String date, BuildContext context);
  Future <void> uploadAttachmentFromCamera(String sejourCode, String date);
Future <void> deleteAttachment(String attachmentId);
  Future<void> addOrUpdateComment(String comment, String attId);
  Future<void> deleteComment(String attachmentId);
  Future<void> uploadMedia(MediaEntity media);
  Future<String?> getDayDescription(String codeSejour,String date);
  Future<void> deleteDayDescription(String codeSejour,String date);
  Future<void> sendSMS(String codeSejour,String type);
  Future<void> addOrUpdateDayDescription(String codeSejour,String date,String description);
}
class RemoteCoreDataSourceImpl extends RemoteCoreDataSource{
  final ImagePicker picker;
final Dio dio;
final SharedPreferences preferences;
final DirectoryManagerService directoryManagerService;
RemoteCoreDataSourceImpl({required this.dio, required this.preferences,required this.picker, required this.directoryManagerService});
  @override
  Future<List<SejourDayEntity>> getSejourDaysFromRemote() async{
    try{
      String? token = preferences.getString(AppStrings.tokenKey);
      //print("this is the token from the getSejourDaysFromRemote -> $token");
      if(token != null){
        if(!JwtDecoder.isExpired(token)){
          String? sejourCode =  preferences.getString(AppStrings.codeSejourKey);
         // print('this is url${AppStrings.baseUrl}${AppStrings.getSejourDetails}$sejourCode');
          var result = await dio.get('${AppStrings.baseUrl}${AppStrings.getSejourDetails}$sejourCode',options: Options(headers: {"Authorization": "Bearer $token"}));
          print(result);
          var data = result.data as dynamic;
          String themeSejour = (data["theme"] != null)?data["theme"]:"";
         await preferences.setString(AppStrings.themeSejourKey, themeSejour);
          DateTime date_deb = DateTime.parse(data["dateDebut"]);
          DateTime date_fin = DateTime.parse(data["dateFin"]);
          String date_deb_str = inverseDate(date_deb);
          String date_fin_str = inverseDate(date_fin);
         await preferences.setString(AppStrings.dateDebStringKey, date_deb_str);
          await preferences.setString(AppStrings.dateFinStringKey, date_fin_str);
          await preferences.setInt(AppStrings.nbEnfantKey, data["nbEnfant"]);
          await preferences.setInt(AppStrings.yearStringKey, date_deb.year);
          //String dateString = "de ${inverseDateShort(date_deb)} à ${inverseDateShort(date_fin)}";
          await preferences.setString(AppStrings.dateStringKey, toNewDateString(date_deb,date_fin));
          String? logoUrl = data["logoUrl"];
          if(logoUrl != null) {
            await preferences.setString(AppStrings.logoUrlKey, logoUrl);
          }
          List<DateTime> days  = getAllDaysBetween(date_deb,date_fin);
          List<SejourDayEntity> sejourDays = [];
          for (var i = 0; i < days.length; i++) {
            if(i==0){
              sejourDays.add(SejourDayEntity(description: "", isFirstDay: true, isLastDay: false, date: days[i]))  ;
            }else if (i == days.length-1){
              sejourDays.add(SejourDayEntity(description: "", isFirstDay: false, isLastDay: true, date: days[i]));
            }else{
              sejourDays.add(SejourDayEntity(description: "", isFirstDay: false, isLastDay: false, date: days[i]));
            }
          }
          return sejourDays;
        }
      }
      throw UnAuthorizedException(message: "Veuillez vous reconnecter");

    }on DioException catch(e){
      var msg = e.response?.data.toString()?? e.message??e.toString();
      print(msg);
      throw ServerException(message: msg);

    }
    catch(e, stacktrace){
      if(kDebugMode){
        print(e);
        print(stacktrace);
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<SejourAttachment>> getSejourAttachments(String sejourCode, String date) async {
    try {
      await clearTemporaryFiles("downloads");
      String? token = preferences.getString(AppStrings.tokenKey);
      if (token != null) {
        if (!JwtDecoder.isExpired(token)) {
          var response = await dio.get('${AppStrings.baseUrl}${AppStrings.attachment}$sejourCode?type=image,video&dateCreate=$date',
              options: Options(headers: {"Authorization": "Bearer $token"}));
          if (response.statusCode == 200) {
            var data = response.data as List<dynamic>;
            List<SejourAttachment> attachments = data.map((item) => SejourAttachment.fromJson(item)).toList();
            /*for (var elem in attachments) {
              print("this is the request of image -> ${elem.path}");
              var mediaResponse = await dio.get(elem.path,
                  options: Options(headers: {"Authorization": "Bearer $token"}, responseType: ResponseType.bytes));
              if (mediaResponse.statusCode == 200) {
                print("ok response");
                print(mediaResponse.data);
                String fileName = elem.path.split('/').last;
                File mediaFile = await saveMediaToFile(Uint8List.fromList(mediaResponse.data), fileName,"downloads");
                elem.filePath = mediaFile.path;
              } else {
                print("Failed to load media: ${mediaResponse.statusCode}");
                elem.filePath = null;
              }
            }*/
            return attachments;
          } else if (response.statusCode == 404) {
            return [];
          } else {
            throw ServerException(message: "Unexpected status code: ${response.statusCode}");
          }
        } else {
          print("we are in unAuthorized 1");
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      } else {
        print("we are in unAuthorized 2");
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    } on DioException catch (ex) {
      if (ex.response != null && ex.response?.statusCode == 404) {
        return [];
      }
      var msg = ex.response?.data ?? ex.message ?? ex.toString();
      print(msg);
      throw ServerException(message: msg);
    }
  }
  @override
  Future<void> uploadVisualAttachment(String sejourCode, String date, BuildContext context) async {
    try {
      String? token = preferences.getString(AppStrings.tokenKey);
      if (token != null) {
        if (!JwtDecoder.isExpired(token)) {
          var pickedMedias = await picker.pickMultipleMedia();
          if (pickedMedias.isNotEmpty) {
            final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi)) {

              for (var media in pickedMedias) {
                var mediaType = getMediaType(media.path);

                final imageBytes = await File(media.path).readAsBytes();
                img.Image? image = img.decodeImage(imageBytes);
                final strippedImageBytes = img.encodeJpg(image!, quality: 100);

                String extension = media.path.split(".").last;
                dio.interceptors.add(InterceptorsWrapper(
                  onRequest: (options, handler) {
                    print('--- Request ---');
                    print('URI: ${options.uri}');
                    print('Headers: ${options.headers}');
                    print('Method: ${options.method}');
                    print('Request Body: ${options.data}');
                    return handler.next(options); // continue
                  },
                  onResponse: (response, handler) {
                    print('--- Response ---');
                    print('Status Code: ${response.statusCode}');
                    print('Data: ${response.data}');
                    return handler.next(response); // continue
                  },
                  onError: (DioException e, handler) {
                    print('--- Error ---');
                    print('Error Message: ${e.message}');
                    print('Response Data: ${e.response?.data}');
                    return handler.next(e); // continue
                  },
                ));
                final FormData formData = FormData.fromMap({
                  "file": MultipartFile.fromBytes(
                    strippedImageBytes,
                    filename: media.name,
                    contentType: MediaType('image', extension),
                  ),
                  "date": date,
                  "type": mediaType
                });

                await dio.post(
                  AppStrings.baseUrl + AppStrings.attachment + sejourCode,
                  data: formData,
                  options: Options(headers: {"Authorization": "Bearer $token"}),
                );
              }
            } else {
              throw NoInternetConnectionException(medias: [], date: date);
            }
          } else {
            throw NoMediaPickedException();
          }
        } else {
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      } else {
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    } on DioException catch (e) {
      var msg = e.response?.data.toString() ?? e.message ?? e.toString();
      print('--- DioException ---');
      print('Message: $msg');
      throw ServerException(message: msg);
    }
  }

  @override
  Future<void> uploadAttachmentFromCamera(String sejourCode, String date) async{
    try{
      String? token = preferences.getString(AppStrings.tokenKey);
      if(token!= null ) {
        if (!JwtDecoder.isExpired(token)) {
         // bool permissionGranted = await AndroidPermissionHandler.requestReadMediaVisualUserSelectedPermission();

          var pickedMedia = await picker.pickImage(source: ImageSource.camera);
          if(pickedMedia != null){
            var mediaType =  getMediaType(pickedMedia.path);
            print("the selected image path ${pickedMedia.path}");
            final FormData formData = FormData.fromMap({
              "file": await MultipartFile.fromFile(pickedMedia.path, filename: pickedMedia.path.split(context.separator).last),
              "date":date,
              "type":mediaType
            });
            await dio.post(AppStrings.baseUrl+AppStrings.attachment+sejourCode,data: formData,options: Options(headers: {"Authorization": "Bearer $token"}));
          }else{
            throw NoMediaPickedException();
          }
        }else{
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }else{
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    }on DioException catch (e){
      var msg = e.response?.data.toString()?? e.message??e.toString();
      throw ServerException(message: msg);
    }
  }

  @override
  Future<void> uploadMedia(MediaEntity media)async{
    try{
      String? token = preferences.getString(AppStrings.tokenKey);
      String? sejourCode = preferences.getString(AppStrings.codeSejourKey);
      if(token!= null && sejourCode!=null) {
        if (!JwtDecoder.isExpired(token)) {
            final FormData formData = FormData.fromMap({
              "file": await MultipartFile.fromFile(media.path, filename: media.name),
              "date":formatDate(media.date),
            });
             await dio.post(AppStrings.baseUrl+AppStrings.attachment+sejourCode,data: formData,options: Options(headers: {"Authorization": "Bearer $token"}));

        }else{
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }else{
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    }catch(e){
      if(e is DioException){
        var msg = e.response?.data.toString()?? e.message??e.toString();
        print("Dio Exception inside uploadMedia -> $msg");
      }
      print(e);
    }
}
  @override
  Future<void> deleteAttachment(String attachmentId) async{
    try{
      String? token = preferences.getString(AppStrings.tokenKey);
      if(token!= null) {
        if (!JwtDecoder.isExpired(token)) {
          await dio.post(AppStrings.baseUrl+AppStrings.deleteAtt+attachmentId,options: Options(headers: {"Authorization": "Bearer $token"}));
        }else{
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }
      else{
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    }on DioException catch(e){
      var msg = e.response?.data.toString()?? e.message??e.toString();
      print(msg);
      throw ServerException(message: msg);
    }

  }

  @override
  Future<void> addOrUpdateComment(String comment, String attId) async{
    try{
      print("we are in the comment");
      String? token = preferences.getString(AppStrings.tokenKey);
      if(token!= null) {
        if (!JwtDecoder.isExpired(token)) {
            var data = {
              "comment" : comment
            };
            print("the comment url -> ${AppStrings.baseUrl}${AppStrings.comment}$attId");
            await dio.post("${AppStrings.baseUrl}${AppStrings.comment}$attId",options: Options(headers: {"Authorization": "Bearer $token"}), data:data);
        }else{
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }else{
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    }on DioException catch (e,stack){
      print(e);
      print(stack);
      var msg = e.response?.data.toString()?? e.message??e.toString();
      print(msg);
      throw ServerException(message: msg);
    }
  }

  @override
  Future<void> deleteComment(String attachmentId) async{
   try{
     String? token = preferences.getString(AppStrings.tokenKey);
     if(token!= null) {
       if (!JwtDecoder.isExpired(token)) {
           await dio.delete(AppStrings.baseUrl+AppStrings.comment+attachmentId,options: Options(headers: {"Authorization": "Bearer $token"}));
       }else{
         throw UnAuthorizedException(message: "Veuillez vous reconnecter");
       }
     }else{
       throw UnAuthorizedException(message: "Veuillez vous reconnecter");
     }
   }on DioException catch(e){
     print(e);
     var msg = e.response?.data.toString()?? e.message??e.toString();
     print(msg);
     throw ServerException(message: msg);
   }
  }

  @override
  Future<String?> getDayDescription(String codeSejour, String date) async{
    try{
      String? token = preferences.getString(AppStrings.tokenKey);
      if(token!= null) {
        if (!JwtDecoder.isExpired(token)) {
         var response =  await dio.get("${AppStrings.baseUrl}${AppStrings.description}$codeSejour?date=$date",options: Options(headers: {"Authorization": "Bearer $token"}));
         if (response.statusCode == 404) {
           return null;
         }
         return   response.data["description"].toString();
        }else{
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }else{
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    }on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      var msg = e.response?.data.toString() ?? e.message ?? e.toString();
      print(msg);
      throw ServerException(message: msg);
    }
  }

  @override
  Future<void> addOrUpdateDayDescription(String codeSejour, String date, String description) async{
    try{
      String? token = preferences.getString(AppStrings.tokenKey);
      if(token!= null) {
        if (!JwtDecoder.isExpired(token)) {
          var data = {
            "description" : description,
            "date": date
          };
          await dio.post("${AppStrings.baseUrl}${AppStrings.description}$codeSejour",data: data,options: Options(headers: {"Authorization": "Bearer $token"}));
        }else{
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }else{
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    }on DioException catch (e) {
      var msg = e.response?.data.toString() ?? e.message ?? e.toString();
      if (kDebugMode) {
        print(msg);
      }
      throw ServerException(message: msg);
    }
  }

  @override
  Future<void> deleteDayDescription(String codeSejour, String date) async{
    try{
      String? token = preferences.getString(AppStrings.tokenKey);
      if(token!= null) {
        if (!JwtDecoder.isExpired(token)) {
         await dio.delete("${AppStrings.baseUrl}${AppStrings.description}$codeSejour?date=$date",options: Options(headers: {"Authorization": "Bearer $token"}));
        }else{
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }else{
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    }on DioException catch (e) {
      var msg = e.response?.data.toString() ?? e.message ?? e.toString();
      if (kDebugMode) {
        print(msg);
      }
      throw ServerException(message: msg);
    }
  }

  String _formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    var size = bytes / pow(1024, i);
    return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  @override
  Future<void> sendSMS(String codeSejour, String type) async{
    try{
      String? token = preferences.getString(AppStrings.tokenKey);
      if(token!= null) {
        if (!JwtDecoder.isExpired(token)) {
          await dio.post("${AppStrings.smsEndpoint}$codeSejour?message=$type",options: Options(headers: {"Authorization": "Bearer $token"}));
        }else{
          throw UnAuthorizedException(message: "Veuillez vous reconnecter");
        }
      }else{
        throw UnAuthorizedException(message: "Veuillez vous reconnecter");
      }
    }on DioException catch (e) {
      var msg = e.response?.data.toString() ?? e.message ?? e.toString();
      if (kDebugMode) {
        print(msg);
      }
      throw ServerException(message: msg);
    }
  }
}