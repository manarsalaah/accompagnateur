import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../utils/screen_util.dart';

class DayWidget extends StatelessWidget {
  final int day;
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isScrolled = true;
  final bool isSelectable ;
  bool? hasAttachments = false;

final daysOfWeek = ["","Lun","Mar","Mer","Jeu","Ven","Sam","Dim"];
  DayWidget({required this.isSelectable,required this.day, required this.date, this.isSelected = false, required this.onTap,this.hasAttachments = true,super.key});

  @override
  Widget build(BuildContext context) {
    if(isScrolled){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: ScreenUtil.screenWidth * 0.18,
            height: ScreenUtil.screenWidth * 0.22,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.primaryColor,width: 1.5)
            ),
            child: Column(
              children: [
                Text(
                  daysOfWeek[day],
                  style: TextStyle(fontWeight: FontWeight.w500,color: isSelected ? Colors.white : (isSelectable)?Colors.black:Colors.grey,),
                ),
                //SizedBox(height: 5),
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : (isSelectable)?Colors.black:Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasAttachments! ? isSelected ? Colors.white :  AppColors.primaryColor : Colors.transparent,

                  ),
                ),

              ],
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 18),
        width: 24,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryColor : Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}