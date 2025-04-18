import 'dart:async';
import 'package:accompagnateur/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/screen_util.dart';
import '../widgets/wave_clipper.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});
  SharedPreferences preferences = locator();
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      var isConnected= preferences.getBool(AppStrings.isConnectedKey);
      if(isConnected == null || isConnected == false) {
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.loginScreen,(Route<dynamic> route) => false);
      }else{
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.quickAccessScreen,(Route<dynamic> route) => false);
       // Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.mainScreen,(Route<dynamic> route) => false);
      }
    });
    return  Scaffold(
      //backgroundColor: AppColors.secondaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil.screenHeight/4),
            child: Center(
              child: SvgPicture.asset(
                  "assets/images/logoHeader.svg",
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Opacity(opacity: 0.5,child:
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    color: AppColors.primaryColor,
                    height: ScreenUtil.screenHeight/4,
                  ),
                ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    color: AppColors.primaryColor,
                    height: ScreenUtil.screenHeight/4 -20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
