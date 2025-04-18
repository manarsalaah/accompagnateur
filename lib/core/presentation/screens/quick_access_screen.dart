import 'package:accompagnateur/core/presentation/screens/recording_screen.dart';
import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service_locator.dart';
import '../../permissions/bloc/permission_bloc.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_strings.dart';
import '../../utils/utils.dart';
import '../bloc/day_description/day_description_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/sejour_days/sejour_days_bloc.dart';
import '../bloc/upload_visual_attachment/upload_visual_attachment_bloc.dart';

class QuickAccessScreen extends StatefulWidget {
  const QuickAccessScreen({super.key});

  @override
  State<QuickAccessScreen> createState() => _QuickAccessScreenState();
}

class _QuickAccessScreenState extends State<QuickAccessScreen> {
  String codeSejour = "";
  String sejourTheme = "";
  String dateString= "";
  String nbEnfant = "";
  Future<void> _loadInitialValues() async {
    SharedPreferences prefs = locator();
    codeSejour = prefs.getString(AppStrings.codeSejourKey)!;
    sejourTheme = prefs.getString(AppStrings.themeSejourKey)!;
    dateString = prefs.getString(AppStrings.dateStringKey)!;
    nbEnfant = prefs.getInt(AppStrings.nbEnfantKey)!.toString();
  }
  @override
  void initState() {
    super.initState();
    _loadInitialValues();
  }
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
        lazy: false,
        create: (context) => UploadVisualAttachmentBloc(
            usecase: locator(),
            uploadFromCamera: locator(),
            deleteAttachment: locator(),
            addorUpdateComment: locator(),
            deleteComment: locator(),
            sendSMS: locator()
        )
    ),
    BlocProvider(create: (context) => DayDescriptionBloc(getDayDescription: locator(), addOrUpdateDayDescription: locator(), deleteDayDescription: locator())),
  ],
  child: Scaffold(
      resizeToAvoidBottomInset:false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primaryColor
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Column(
                              children: [
                                Text("Code séjour",style: TextStyle(
                                fontFamily: AppStrings.fontName,
                                fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                                ),
                                ),
                                Text(codeSejour,style: TextStyle(
                                fontFamily: AppStrings.fontName,
                                fontSize: 14,
                                    color: Colors.white
                                ),
                                ),
                              ],
                            ),
                          Column(
                              children: [
                                Text("Thème de séjour",style: TextStyle(
                                fontFamily: AppStrings.fontName,
                                fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                                ),
                                ),
                                Text(sejourTheme,style: TextStyle(
                                fontFamily: AppStrings.fontName,
                                fontSize: 14,
                                    color: Colors.white
                                ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text(dateString,style: TextStyle(
                          fontFamily: AppStrings.fontName,
                          fontSize: 16,
                          color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                  child: SizedBox()
              ),
              Expanded(
                  flex:4,
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primaryColor
                ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Nombre d'enfants",style: TextStyle(
                                      fontFamily: AppStrings.fontName,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                  ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(nbEnfant,style: TextStyle(
                                      fontFamily: AppStrings.fontName,
                                      fontSize: 12,
                                      color: Colors.white
                                  ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Parents connectés",style: TextStyle(
                                      fontFamily: AppStrings.fontName,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                  ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("0",style: TextStyle(
                                      fontFamily: AppStrings.fontName,
                                      fontSize: 12,
                                      color: Colors.white
                                  ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // Ensures both columns start at the same height
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start, // Align text to the top
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20, // Ensures same height for alignment
                                    child: Text(
                                      "J'aime sur les photos",
                                      style: TextStyle(
                                        fontFamily: AppStrings.fontName,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontFamily: AppStrings.fontName,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start, // Align text to the top
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20, // Ensures same height for alignment
                                    child: Text(
                                      "Attachements publiés",
                                      style: TextStyle(
                                        fontFamily: AppStrings.fontName,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontFamily: AppStrings.fontName,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              )
              ),
              Expanded(
                  flex: 1,
                  child: SizedBox()
              ),
              Expanded(
                flex: 10,
                child: Center(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Builder(
                                builder: (parentContext) {
                                  return GestureDetector(
                                    onTap: (){
                                      var day_state = BlocProvider.of<SejourDaysBloc>(parentContext).state;
                                      if(day_state is SejourDaysLoaded ){
                                        SharedPreferences prefs = locator();
                                        BlocProvider.of<UploadVisualAttachmentBloc>(parentContext).add(
                                            UploadAttachmentFromCameraEvent(
                                                codeSejour: prefs.getString(AppStrings.codeSejourKey)!,
                                                date: formatDate(day_state.sejourDays[day_state.selectedDayIndex].date)
                                            )
                                        );
                                      }
                                    },
                                    child: SizedBox(
                                      height: 120, // Set a fixed height for consistency
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.primaryColor, width: 2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Prendre une photo",
                                                style: TextStyle(
                                                  fontFamily: AppStrings.fontName,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.primaryColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 5),
                                              Icon(Icons.camera_alt, color: AppColors.primaryColor),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                            Expanded(flex: 1, child: SizedBox()),
                            Expanded(
                              flex: 7,
                              child: Builder(
                                builder: (parentContext) {
                                  return GestureDetector(
                                    onTap: (){
                                      var day_state = BlocProvider.of<SejourDaysBloc>(parentContext).state;
                                      if(day_state is SejourDaysLoaded ){
                                        SharedPreferences prefs = locator();
                                        BlocProvider.of<UploadVisualAttachmentBloc>(parentContext).add(
                                            UploadVisualAttachmentsEvent(
                                                context: parentContext,
                                                codeSejour: prefs.getString(AppStrings.codeSejourKey)!,
                                                date: formatDate(day_state.sejourDays[day_state.selectedDayIndex].date)
                                            )
                                        );
                                      }
                                    },
                                    child: SizedBox(
                                      height: 120, // Same height as the other container
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.primaryColor, width: 2),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Importer depuis la galerie",
                                                style: TextStyle(
                                                  fontFamily: AppStrings.fontName,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.primaryColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 5),
                                              Icon(Icons.image, color: AppColors.primaryColor),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Builder(
                                builder: (parentContext) {
                                  return GestureDetector(
                                    onTap: (){
                                      final navigationBloc = BlocProvider.of<NavigationBloc>(parentContext);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RecordingScreen(navigationBloc: navigationBloc,)),
                                      );
                                    },
                                    child: SizedBox(
                                      height: 120, // Consistent height
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.primaryColor, width: 2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Enregistrer un message audio",
                                                style: TextStyle(
                                                  fontFamily: AppStrings.fontName,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.primaryColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 5),
                                              Icon(Icons.mic, color: AppColors.primaryColor),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                            Expanded(flex: 1, child: SizedBox()),
                            Expanded(
                              flex: 7,
                              child: Builder(
                                builder: (parentContext) {
                                  return GestureDetector(
                                    onTap: ()async{
                                      String? description = await showDescriptionDialog(context);
                                      if(description != null){
                                        var dayState = BlocProvider.of<SejourDaysBloc>(parentContext).state;
                                        if (dayState is SejourDaysLoaded) {
                                          SharedPreferences prefs = locator();
                                          var dateString = formatDate(dayState.sejourDays[dayState.selectedDayIndex].date);
                                          BlocProvider.of<DayDescriptionBloc>(parentContext).add(AddOrUpdateDayDescriptionEvent(
                                            codeSejour: prefs.getString(AppStrings.codeSejourKey)!,
                                            date: dateString,
                                            description: description,
                                          ));
                                        }
                                      }
                                    },
                                    child: SizedBox(
                                      height: 120, // Consistent height
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.primaryColor, width: 2),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Ajouter une description de la journée",
                                                style: TextStyle(
                                                  fontFamily: AppStrings.fontName,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.primaryColor,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 5),
                                              Icon(Icons.edit_outlined, color: AppColors.primaryColor),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex:2,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.mainScreen,(Route<dynamic> route) => false);
                  },
                  child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primaryColor
                  ),
                  child: Center(
                    child: Text("Visiter le site",style: TextStyle(
                        fontFamily: AppStrings.fontName,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),),
                  ),
                                ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
);
  }
}
