

import 'dart:io';

import 'package:accompagnateur/core/domain/usecases/upload_attachment_from_camera.dart';
import 'package:accompagnateur/core/permissions/bloc/permission_bloc.dart';
import 'package:accompagnateur/core/presentation/bloc/day_description/day_description_bloc.dart';
import 'package:accompagnateur/core/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:accompagnateur/core/presentation/bloc/sejour_attachments/sejour_attachments_bloc.dart';
import 'package:accompagnateur/core/presentation/bloc/sejour_days/sejour_days_bloc.dart';
import 'package:accompagnateur/core/presentation/bloc/upload_visual_attachment/upload_visual_attachment_bloc.dart';
import 'package:accompagnateur/core/presentation/screens/recording_screen.dart';
import 'package:accompagnateur/core/presentation/widgets/image_widget.dart';
import 'package:accompagnateur/core/presentation/widgets/video_widget.dart';
import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:accompagnateur/core/utils/app_strings.dart';
import 'package:accompagnateur/core/utils/screen_util.dart';
import 'package:accompagnateur/service_locator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/login/presentation/screen/login_screen.dart';
import '../../utils/utils.dart';
import '../widgets/day_widget.dart';
import '../widgets/error_popover.dart';
import '../widgets/media_widget.dart';

class HomeFragment extends StatefulWidget {
  HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
SharedPreferences preferences = locator();
late ScrollController _scrollController;
late TextEditingController descriptionController;
bool _showBackButton = false;
bool _showForwardButton = false;
bool _initialLoad = true;
bool _isEventTriggered = false;
FocusNode descriptionFocusNode = FocusNode();
void _showModal(BuildContext parentContext) {
  showModalBottomSheet(
    context: parentContext,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
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
                      //BlocProvider.of<PermissionBloc>(parentContext).add(CheckPermission(permission: Permissions.manageExternalStorage.permission));
                      //BlocProvider.of<PermissionBloc>(parentContext).add(RequestPermission(permission: Permissions.manageExternalStorage.permission));
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.image, color: Colors.white,),
                      SizedBox(width: 3,),
                      Text(
                        "Galerie",
                        style: TextStyle(
                            fontFamily: AppStrings.fontName,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                        ),
                      )
                    ],
                  )
              ),
            ),
            Padding(
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white,),
                      SizedBox(width: 3,),
                      Text(
                        "Caméra",
                        style: TextStyle(
                            fontFamily: AppStrings.fontName,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
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
void _scrollToSelectedDay(int selectedIndex) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients && _initialLoad) {
      double position = selectedIndex * 100;
      _scrollController.animateTo(
        position,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ).then((_) {
        _initialLoad = false;
      });
    }
  });
}
void _scrollListener() {
  setState(() {
    _showBackButton = _scrollController.position.pixels > 0;
    _showForwardButton = _scrollController.position.pixels < _scrollController.position.maxScrollExtent;
  });
}
@override
  void initState() {
  descriptionController = TextEditingController();
  _scrollController = ScrollController();
  _scrollController.addListener(_scrollListener);

    super.initState();
  }
  @override
  void dispose() {
  descriptionController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
void _addFocusListener(BuildContext context) {
  descriptionFocusNode.addListener(() {
    if (!descriptionFocusNode.hasFocus && !_isEventTriggered) {
      _isEventTriggered = true;

      var dayDescriptionState = BlocProvider.of<DayDescriptionBloc>(context).state;
      var dayState = BlocProvider.of<SejourDaysBloc>(context).state;

      if (dayDescriptionState is DayDescriptionSuccess) {
        if (descriptionController.text.isNotEmpty) {
          // add a new description
          print("adding description");
          if (dayState is SejourDaysLoaded) {
            var dateString = formatDate(dayState.sejourDays[dayState.selectedDayIndex].date);
            BlocProvider.of<DayDescriptionBloc>(context).add(AddOrUpdateDayDescriptionEvent(
              codeSejour: preferences.getString(AppStrings.codeSejourKey)!,
              date: dateString,
              description: descriptionController.text,
            ));
          }
        }  else if (dayDescriptionState.description != null &&
            descriptionController.text != dayDescriptionState.description &&
            descriptionController.text.isEmpty) {
          // delete the description
          print("deleting description");
          if (dayState is SejourDaysLoaded) {
            var dateString = formatDate(dayState.sejourDays[dayState.selectedDayIndex].date);
            BlocProvider.of<DayDescriptionBloc>(context).add(DeleteDayDescriptionEvent(
              codeSejour: preferences.getString(AppStrings.codeSejourKey)!,
              date: dateString,
            ));
          }
        }
      }

      Future.delayed(Duration(milliseconds: 200), () {
        _isEventTriggered = false;
      });
    }
  });
}
  @override
  Widget build(BuildContext context) {
    _addFocusListener(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<SejourAttachmentsBloc, SejourAttachmentsState>(
      listener: (context, state) async {
        if (state is SejourAttachmentsError){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: ErrorPopover(
    message: state.message,
    onClose: () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    },
        ),
        duration: Duration(seconds: 3),
      ),
    );
        }
        if(state is UnAuthorizedSejourAttachment){
    await preferences.setBool(AppStrings.isConnectedKey,false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
        }
      },
    ),
        BlocListener<UploadVisualAttachmentBloc, UploadVisualAttachmentState>(
      listener: (context, state) async {
        if (state is VisualUploadDeleted || state is CommentAttachmentSuccess){
    var day_state = BlocProvider.of<SejourDaysBloc>(context).state;
    if(day_state is SejourDaysLoaded){

      BlocProvider.of<SejourAttachmentsBloc>(context).add(LoadSejourAttachmentEvent(codeSejour: preferences.getString(AppStrings.codeSejourKey)!, date: formatDate(day_state.sejourDays[day_state.selectedDayIndex].date)));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryColor,
          content: Text("Action terminée avec succès",style: TextStyle(color: Colors.white,fontFamily: AppStrings.fontName),),
          duration: Duration(seconds: 2),
        ),
      );
    }
        } if (state is UploadingVisualAttachmentSucces ){
    var day_state = BlocProvider.of<SejourDaysBloc>(context).state;
    if(day_state is SejourDaysLoaded){

      BlocProvider.of<SejourAttachmentsBloc>(context).add(LoadSejourAttachmentEvent(codeSejour: preferences.getString(AppStrings.codeSejourKey)!, date: formatDate(day_state.sejourDays[day_state.selectedDayIndex].date)));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryColor,
          content: Text("Publication ajoutée avec succès",style: TextStyle(color: Colors.white,fontFamily: AppStrings.fontName),),
          duration: Duration(seconds: 2),
        ),
      );
    }
        }
        if(state is SmsSentSuccess){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryColor,
        content: Text("SMS envoyé avec succès",style: TextStyle(color: Colors.white,fontFamily: AppStrings.fontName),),
        duration: Duration(seconds: 2),
      ),
    );
        }
        if(state is UnAuthorizedUpload){
    await preferences.setBool(AppStrings.isConnectedKey,false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
        }
        if(state is UploadingVisualAttachmentError){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: ErrorPopover(
          message: state.message,
          onClose: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        duration: Duration(seconds: 3),
      ),
    );
        }
        if(state is NoInternetUploadError){

        }
      },
    ),

        BlocListener<SejourDaysBloc, SejourDaysState>(
    listener: (context, state) async {
      if(state is UnAuthorizedSejourDay){
        await preferences.setBool(AppStrings.isConnectedKey,false);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
        );
      }
    },
        ),
        BlocListener<DayDescriptionBloc,DayDescriptionState>(listener: (context,state){
    if(state is DayDescriptionSuccess){
      if(state.description != null){
        descriptionController.text = state.description!;
      }
    }else{
      descriptionController.clear();
    }
        }),
      ],
      child: Container(
        width: ScreenUtil.screenWidth ,
        color: Colors.white,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<SejourDaysBloc, SejourDaysState>(builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex:2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(25),
                        color: Colors.transparent,
                      ),
                     // height: ScreenUtil.screenHeight / 10,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: AutoSizeText(
                            (preferences.getString(AppStrings.codeSejourKey) != null)
                                ? preferences.getString(AppStrings.codeSejourKey)!
                                : "2025",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppStrings.fontName),
                            maxLines: 1,
                            minFontSize: 8,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(25),
                        color: Colors.transparent,
                      ),
                     // height: ScreenUtil.screenHeight / 10,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: AutoSizeText(
                            (preferences.getString(AppStrings.themeSejourKey) != null)
                                ? preferences.getString(AppStrings.themeSejourKey)!
                                : "",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppStrings.fontName),
                            maxLines: 1,
                            minFontSize: 8,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          BlocBuilder<SejourDaysBloc, SejourDaysState>(
            builder: (context, state) {
              if (state is SejourDaysLoaded) {
                _scrollToSelectedDay(state.selectedDayIndex);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          height: ScreenUtil.screenWidth/6 +20,
                          width: ScreenUtil.screenWidth * 0.7,
                          child: Center(
                            child: Align(
                              alignment: Alignment.center,
                              child: ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: state.sejourDays.length,
                                itemBuilder: (context, index) {
                                  final day = state.sejourDays[index];
                                  final bool isSelectable = day.date.compareTo(DateTime.now())<0 ;
                                  return DayWidget(
                                    onTap: () {
                                      if(isSelectable){
                                        BlocProvider.of<SejourDaysBloc>(context).add(
                                          ChangeSejourDay(
                                            sejourDays: state.sejourDays,
                                            newSelectedDayIndex: index,
                                          ),
                                        );
                                        // Scroll to the appropriate position
                                        double position;
                                        if (index < 4) {
                                          position = 0; // Scroll to the start of the list
                                        } else if (index > state.sejourDays.length - 4) {
                                          position = _scrollController.position.maxScrollExtent; // Scroll to the end of the list
                                        } else {
                                          int listlength = state.sejourDays.length ;
                                          if(listlength <10) {
                                            position = index * 20; // Adjust based on item width
                                          } else {
                                            position = index * 35;
                                          }
                                        }
                                        _scrollController.animateTo(
                                          position,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }

                                    },
                                    day: day.date.weekday,
                                    date: day.date,
                                    isSelected: index == state.selectedDayIndex,
                                    isSelectable: isSelectable,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
            Text("Vendredi 21 Fev 2025",style: TextStyle(
              fontFamily: AppStrings.fontName,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            ),
           /* Row(
              children: [
                Image.asset("assets/images/content.png",height: 25,),
                //SvgPicture.asset("assets/images/content.svg",),
                SizedBox(
                  width: 3,
                ),
                Text("Contenu de ce jour",style: TextStyle(
                fontFamily: AppStrings.fontName,
                fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ],
            ),*/
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
               return ConstrainedBox(
                 constraints: BoxConstraints(minHeight: constraints.minHeight),
                 child: SingleChildScrollView(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(top:5,left:4,right: 4),
                         child: BlocBuilder<DayDescriptionBloc, DayDescriptionState>(
                                              builder: (context, state) {
                         return TextField(
                           focusNode: descriptionFocusNode,
                           controller: descriptionController,
                           decoration: InputDecoration(
                             floatingLabelBehavior: FloatingLabelBehavior.never,
                             label: AutoSizeText(
                               maxLines: 1,
                               "Racontez la journée ici",
                               style: TextStyle(
                                 fontSize: 10,
                                 fontWeight: FontWeight.w300,
                                 fontFamily: AppStrings.fontName,
                               ) ,
                             ),
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(20.0),
                               borderSide: BorderSide.none,
                             ),
                             filled: true,
                             fillColor: Colors.grey[200], // Background color
                             contentPadding: EdgeInsets.symmetric(
                                 vertical: 16.0, horizontal: 20.0),
                           ),
                         );
                                              },
                                            ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                       children: [
                         Expanded(
                           flex:1,
                           child: GestureDetector(
                             onTap: () {
                               _showModal(context);
                             },
                             child: Container(
                               decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor,
                               ),
                               child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: SvgPicture.asset("assets/images/photo.svg",width: 30,height: 30,),
                               ),
                             ),
                           ),
                         ),
                         BlocBuilder<SejourDaysBloc, SejourDaysState>(
                           builder: (context, state) {
                             if(state is SejourDaysLoaded){
                               if(state.sejourDays[state.selectedDayIndex].isFirstDay){
                                 return Visibility(
                                  visible: true,
                                  child: GestureDetector(
                     onTap: () {
                       var codeSejour =  preferences.getString(AppStrings.codeSejourKey);
                       if(codeSejour != null){
                         BlocProvider.of<UploadVisualAttachmentBloc>(context).add(SendSMSEvent(codeSejour: codeSejour, type: "arrive"));
                       }
                     },
                     child: SvgPicture.asset(
                       "assets/images/sms_logo_orange.svg",
                       width: 50,
                     )),
                                 );
                               }
                               else if(state.sejourDays[state.selectedDayIndex].isLastDay){
                                 return Visibility(
                                  visible: true,
                                  child: GestureDetector(
                     onTap: () {
                       var codeSejour =  preferences.getString(AppStrings.codeSejourKey);
                       if(codeSejour != null){
                         BlocProvider.of<UploadVisualAttachmentBloc>(context).add(SendSMSEvent(codeSejour: codeSejour, type: "depart"));
                       }
                     },
                     child: SvgPicture.asset(
                       "assets/images/sms_logo_orange.svg",
                       width: 50,
                     )),
                                 );
                               }
                               else {
                                 return Container(
                                   width: 50,
                                 );
                               }
                             }
                             return Container(
                               width: 50,
                             );
                           },
                         ),

                         Expanded(
                           flex: 1,
                           child: GestureDetector(
                             onTap: () {
                               final navigationBloc = BlocProvider.of<NavigationBloc>(context);
                               Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>RecordingScreen(navigationBloc: navigationBloc,)),
                               );
                               // context.read<NavigationBloc>().add(NavigationItemSelected(2));
                             },
                             child: Container(
                               decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor,
                               ),
                               child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset("assets/images/message.png",width: 30,height: 30,),
                               ),
                             ),
                           ),
                         ),
                       ],
                     )
                       ),
                 BlocBuilder<SejourAttachmentsBloc, SejourAttachmentsState>(
               builder: (context, state) {
                 if (state is SejourAttachmentsLoaded) {
                   if (state.sejourAttachmentsList.isEmpty) {
                     return Padding(
                       padding: const EdgeInsets.only(top: 150),
                       child: Center(
                         child: Text(
                           "Vous n'avez pas de contenu sur ce jour",
                           style: TextStyle(
                             fontFamily: AppStrings.fontName,
                             fontSize: 14,
                           ),
                         ),
                       ),
                     );
                   }

                   List<String> images = state.sejourAttachmentsList
                       .where((attachment) => attachment.type == 'image')
                       .map((attachment) => attachment.path)
                       .toList();

                   return Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                     child: StaggeredGrid.count(
                       crossAxisCount: 3, // 3 columns
                       mainAxisSpacing: 3,
                       crossAxisSpacing: 2,
                       children: state.sejourAttachmentsList.map((attachment) {
                         bool hasComment = attachment.comment != null && attachment.comment!.isNotEmpty;
                         return StaggeredGridTile.count(
                           crossAxisCellCount: hasComment ? 2 : 1, // Wider if it has a comment
                           mainAxisCellCount: 1, // Keep height uniform for now
                           child: MediaWidget(
                             id: attachment.id,
                             likesNumber: attachment.likes,
                             comment: attachment.comment,
                             path: attachment.path,
                             uploadDate: attachment.uploadDate,
                             filePath: attachment.filePath,
                             images: images,
                             index: state.sejourAttachmentsList.indexOf(attachment),
                             isVideo: attachment.type == "video",
                             imageData: null,
                           ),
                         );
                       }).toList(),
                     ),
                   );
                 }

                 if (state is LoadingSejourAttachments) {
                   return Padding(
                     padding: const EdgeInsets.only(top: 50),
                     child: Center(
                       child: SizedBox(
                         width: 50,
                         height: 50,
                         child: const CircularProgressIndicator(color: Colors.grey),
                       ),
                     ),
                   );
                 } else {
                   return const SizedBox();
                 }
               },
               )

                 ],
                   ),
                 ),
               );
              },

            ),
          ),
        ],
      ),
      ),
    );
  }
}
