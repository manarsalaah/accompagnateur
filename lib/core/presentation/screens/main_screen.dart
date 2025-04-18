import 'package:accompagnateur/core/presentation/bloc/sejour_days/sejour_days_bloc.dart';
import 'package:accompagnateur/core/presentation/bloc/settings/settings_bloc.dart';
import 'package:accompagnateur/core/presentation/screens/info_5sur5_screen.dart';
import 'package:accompagnateur/core/presentation/screens/recording_screen.dart';
import 'package:accompagnateur/core/presentation/user_info_getter/user_info_getter_bloc.dart';
import 'package:accompagnateur/features/audio_messages/presentation/fragment/audio_message_fragment.dart';
import 'package:accompagnateur/features/photos/presentation/fragment/photo_fragment.dart';
import 'package:accompagnateur/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_navbar_with_indicator/bottom_navbar_with_indicator.dart';

import '../../permissions/bloc/permission_bloc.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/screen_util.dart';
import '../../utils/utils.dart';
import '../bloc/day_description/day_description_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/sejour_attachments/sejour_attachments_bloc.dart';
import '../bloc/upload_visual_attachment/upload_visual_attachment_bloc.dart';
import '../fragments/album_fragment.dart';
import '../fragments/home_fragment.dart';
import '../fragments/settings_fragment.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  final List<Widget> widgetList = [
    BlocListener<SejourDaysBloc, SejourDaysState>(
  listener: (context, state) {
    if(state is SejourDaysLoaded){
      String formatedDate = formatDate(state.sejourDays[state.selectedDayIndex].date);
      BlocProvider.of<DayDescriptionBloc>(context).add(GetDayDescriptionEvent(codeSejour: locator<SharedPreferences>().getString(AppStrings.codeSejourKey)!, date: formatedDate));
      BlocProvider.of<SejourAttachmentsBloc>(context).add(LoadSejourAttachmentEvent(codeSejour: locator<SharedPreferences>().getString(AppStrings.codeSejourKey)!, date: formatedDate));
    }
  },
  child: HomeFragment(),
),
    AudioMessageFragment(),
    PhotoFragment(),
    AlbumFragment(),
    MultiBlocProvider(
  providers: [
    BlocProvider(
  create: (context) => SettingsBloc(),
),
    BlocProvider(
      create: (context) => UserInfoGetterBloc()..add(GetUserInfo())
  ),
  ],
  child: SettingsFragment(),
),
  ];

  SharedPreferences preferences = locator();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NavigationBloc(),
        ),
        BlocProvider(create: (context) => PermissionBloc(service: locator())),
        BlocProvider(
          lazy: false,
          create: (context) => SejourDaysBloc(usecase: locator())..add(LoadSejourDays()),
        ),
        BlocProvider(
            create: (context)=>SejourAttachmentsBloc(usecase: locator())
        ),
        BlocProvider(
            lazy: false,
            create: (context) => UploadVisualAttachmentBloc(
                usecase: locator(),
                uploadFromCamera: locator(),
                deleteAttachment: locator(),
                addorUpdateComment: locator(),
                deleteComment: locator(),
                sendSMS: locator())),
        BlocProvider(create: (context) => DayDescriptionBloc(getDayDescription: locator(), addOrUpdateDayDescription: locator(), deleteDayDescription: locator())),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: SvgPicture.asset("assets/images/logo_rond_bleu.svg", width: 40, height: 40),
          leadingWidth: ScreenUtil.screenHeight / 10,
          centerTitle: false,
          actions: [
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<SejourDaysBloc, SejourDaysState>(builder: (context, state) {
                var logoUrl = preferences.getString(AppStrings.logoUrlKey);
                if (logoUrl != null) {
                  return ImageIcon(NetworkImage(logoUrl), size: 60);
                } else {
                  return
                  Text("Icone de partenaire",style: TextStyle(
                  fontSize: 12,
                    fontFamily: AppStrings.fontName
                  ),
                  );
                }
              }),
            ),*/
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Infos5Sur5Screen()));
                  },
                  child: SvgPicture.asset("assets/images/info.svg", width: 25, height: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () async{
                    SharedPreferences preferences = locator();
                    await preferences.setBool(AppStrings.isConnectedKey, false);
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.loginScreen,(Route<dynamic> route) => false);
                  },
                  child: SvgPicture.asset("assets/images/exit.svg", width: 25, height: 25),
              ),
            ),
          ],
        ),
        body: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is NavigationSuccess) {
              return widgetList[state.index];
            }
            return widgetList[0]; // default to first tab
          },
        ),

        bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            int currentIndex = 0;
            if (state is NavigationSuccess) {
              currentIndex = state.index;
            }
            return CustomLineIndicatorBottomNavbar(
              selectedFontSize: 10,
              unselectedFontSize: 10,
              selectedColor: Colors.white,
              unSelectedColor: Colors.white,
              backgroundColor: AppColors.primaryColor,
              currentIndex: currentIndex,
              unselectedIconSize: 30,
              selectedIconSize: 30,
              onTap: (int newIndex) {
                print("the new index -> $newIndex");
                if (newIndex != 2 && newIndex !=0) {
                  context.read<NavigationBloc>().add(NavigationItemSelected(newIndex));
                } else if(newIndex == 2) {
                  final navigationBloc = BlocProvider.of<NavigationBloc>(context);
                  _showAddAttModal(context, preferences, navigationBloc);
                }
                else if(newIndex ==0){
                  context.read<NavigationBloc>().add(NavigationItemSelected(newIndex));
                  var day_state = BlocProvider.of<SejourDaysBloc>(context).state;
                  if(day_state is SejourDaysLoaded) {
                    context.read<SejourDaysBloc>().add(ChangeSejourDay(sejourDays: day_state.sejourDays, newSelectedDayIndex: day_state.selectedDayIndex));
                  }
                }
              },
              enableLineIndicator: false,
              lineIndicatorWidth: 5,
              indicatorType: IndicatorType.top,
              customBottomBarItems: [
                CustomBottomBarItems(
                  label: 'Publications',
                  assetsImagePath: "assets/images/home.png",
                  isAssetsImage: true,
                ),
                CustomBottomBarItems(
                  label: 'Messages',
                  assetsImagePath: "assets/images/message.png",
                  isAssetsImage: true,
                ),
                CustomBottomBarItems(
                  icon: Icons.add_circle_rounded,
                  label: '',
                  isAssetsImage: false,
                 // isResizeable: true,
                 // iconSize: 50,
                //  showLabel: false,
                ),
                CustomBottomBarItems(
                  label: 'Album séjour',
                  assetsImagePath: "assets/images/album.png",
                  isAssetsImage: true,
                ),
                CustomBottomBarItems(
                  label: 'Paramètres',
                  assetsImagePath: "assets/images/settings.png",
                  isAssetsImage: true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void _showAddAttModal(BuildContext parentContext, SharedPreferences preferences, NavigationBloc navigationBloc) {
  showModalBottomSheet(
    context: parentContext,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                  onPressed: (){
                    var day_state = BlocProvider.of<SejourDaysBloc>(parentContext).state;
                    if(day_state is SejourDaysLoaded ){
                      Navigator.pop(context);
                      BlocProvider.of<UploadVisualAttachmentBloc>(parentContext).add(
                          UploadVisualAttachmentsEvent(
                            context: parentContext,
                              codeSejour: preferences.getString(AppStrings.codeSejourKey)!,
                              date: formatDate(day_state.sejourDays[day_state.selectedDayIndex].date)
                          )
                      );
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.image, color: Colors.white,),
                      SizedBox(width: 3,),
                      Text(
                        "Galerie",
                        style: TextStyle(
                            fontFamily: AppStrings.fontName,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 16
                        ),
                      )
                    ],
                  )
              ),
            ),
            Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                        onPressed: () {
                          var day_state = BlocProvider.of<SejourDaysBloc>(parentContext).state;
                          if(day_state is SejourDaysLoaded ){
                            BlocProvider.of<UploadVisualAttachmentBloc>(parentContext).add(
                                UploadAttachmentFromCameraEvent(
                                    codeSejour: preferences.getString(AppStrings.codeSejourKey)!,
                                    date: formatDate(day_state.sejourDays[day_state.selectedDayIndex].date)
                                )
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.camera_alt, color: Colors.white,),
                            SizedBox(width: 3,),
                            Text(
                              "Caméra",
                              style: TextStyle(
                                  fontFamily: AppStrings.fontName,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            )
                          ],
                        )
                    ),
                  );
                }
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecordingScreen(navigationBloc: navigationBloc,)),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.mic, color: Colors.white,),
                      SizedBox(width: 3,),
                      Text(
                        "Message audio",
                        style: TextStyle(
                            fontFamily: AppStrings.fontName,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 16
                        ),
                      )
                    ],
                  )
              ),
            ),
          ],
        ),
      );
    },
  );
}
