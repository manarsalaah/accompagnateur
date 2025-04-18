import 'dart:async';

import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:accompagnateur/core/error/exception.dart';
import 'package:accompagnateur/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:workmanager/workmanager.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/route_config.dart';
import 'core/utils/screen_util.dart';
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator().then((_) {
    Workmanager().executeTask((task, inputData) async {
      try {
        final CoreRepository coreRepository = locator<CoreRepository>();
        await coreRepository.uploadPendingMedias();
        return Future.value(true);
      } catch (e) {
        print(e.toString());
        return Future.value(false);
      }
    });
  }).catchError((error) {
    print('Error during setupLocator: $error');
  });
}
Future<void> schedulePeriodicChecks() async{
  print("schedule periodicChecks");
  try{
    Timer.periodic(Duration(minutes: 2), (timer) async {
      await locator<CoreRepository>().uploadPendingMedias();
    });
  }catch (e){
    if (e is NoMediaPickedException){
      return;
    }
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await schedulePeriodicChecks();
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      routes: getRoutes(),
    );
  }
}
