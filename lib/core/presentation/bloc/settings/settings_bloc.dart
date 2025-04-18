import 'dart:async';
import 'dart:io';
import 'package:accompagnateur/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import '../../../utils/app_strings.dart';
import 'package:device_info_plus/device_info_plus.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    Dio dio = locator();
    SharedPreferences preferences = locator();

    on<EditUserInfo>((event, emit) async {
      try {
        String? token = preferences.getString(AppStrings.tokenKey);
        String? sejourCode = preferences.getString(AppStrings.codeSejourKey);

        if (token != null && sejourCode != null) {
          if (!JwtDecoder.isExpired(token)) {
            Map<String, String> data = {
              "nom": event.nom,
              "prenom": event.prenom,
              "numero": event.num,
              "email": event.email
            };

            await dio.post(
              "http://54.36.104.133:81/api/userinfo",
              options: Options(headers: {"Authorization": "Bearer $token"}),
              data: data,
            );
            emit(EditSuccess());
          } else {
            await preferences.setBool(AppStrings.isConnectedKey, false);
            emit(UnAuthorized());
          }
        } else {
          await preferences.setBool(AppStrings.isConnectedKey, false);
          emit(UnAuthorized());
        }
      } on DioException catch (e) {
        var msg = e.response?.data.toString() ?? e.message ?? e.toString();
        print(msg);
        emit(SettingsError(errorMsg: msg));
      }
    });

    on<DownloadPdf>((event, emit) async {
      try {
        String? token = preferences.getString(AppStrings.tokenKey);
        String? sejourCode = preferences.getString(AppStrings.codeSejourKey);

        if (token != null && sejourCode != null) {
          if (!JwtDecoder.isExpired(token)) {
            // Request storage permissions
            final plugin = DeviceInfoPlugin();
            final android = await plugin.androidInfo;

            final storageStatus = android.version.sdkInt < 33
                ? await Permission.storage.request()
                : PermissionStatus.granted;

            if (storageStatus == PermissionStatus.denied) {
              print("denied");
            }
            if (storageStatus == PermissionStatus.permanentlyDenied) {
              openAppSettings();
            }
            if (storageStatus.isGranted) {
              String url =
                  "http://54.36.104.133:81/api/accomp/pdf/$sejourCode?type=${event.type}";

              // Get the general Downloads directory
              Directory downloadsDirectory = Directory('/storage/emulated/0/Download');
              String filePath = downloadsDirectory.path;

              // Enqueue the download task
              final taskId = await FlutterDownloader.enqueue(
                url: url,
                headers: {"Authorization": "Bearer $token"},
                savedDir: filePath,
                fileName: 'document_${event.type}.pdf',
                showNotification: true,
                openFileFromNotification: true,
              );

              // Fetch the PDF data as bytes (optional)
              final response = await dio.get(url,
                  options: Options(
                    headers: {"Authorization": "Bearer $token"},
                    responseType: ResponseType.bytes,
                  ));

              emit(DocumentDownloaded(pdfData: response.data));
            } else {
              emit(SettingsError(errorMsg: "Permission denied"));
            }
          } else {
            await preferences.setBool(AppStrings.isConnectedKey, false);
            emit(UnAuthorized());
          }
        } else {
          await preferences.setBool(AppStrings.isConnectedKey, false);
          emit(UnAuthorized());
        }
      } on DioException catch (e) {
        var msg = e.response?.data.toString() ?? e.message ?? e.toString();
        print(msg);
        emit(SettingsError(errorMsg: msg));
      } catch (e) {
        print(e);
        emit(SettingsError(errorMsg: e.toString()));
      }
    });
  }
}
