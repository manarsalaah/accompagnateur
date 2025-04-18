import 'dart:io';

import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:accompagnateur/core/utils/app_strings.dart';
import 'package:accompagnateur/core/utils/screen_util.dart';
import 'package:flutter/material.dart';
import '../../../domain/entity/photo.dart';
import '../../widget/image_list_item.dart';

class ListMediaFragment extends StatelessWidget {
  final Map<String, List<Media>> medias;

  const ListMediaFragment({required this.medias, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('this is medias length ${medias.length}');
    print(medias);
    return SizedBox(
      height: ScreenUtil.screenHeight / 2 -30,
      child: ListView.builder(
        itemCount: medias.length,
        itemBuilder: (context, index) {
          final date = medias.keys.elementAt(index);
          final mediaList = medias[date]!.toList();
          final mediasLength = mediaList.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      date,
                      style: TextStyle(
                        fontFamily: AppStrings.fontName,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10,left: 10),
                    child: Text(
                      mediasLength<2?'$mediasLength élement':'$mediasLength élements',
                      style: TextStyle(
                        fontFamily: AppStrings.fontName,
                        color: AppColors.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200, // Adjust the height according to your needs
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mediaList.length,
                  itemBuilder: (context, index) {
                    if(mediaList[index].isPhoto){
                      return ImageListItem(path: mediaList[index].path,);
                    }
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('this is a video')
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
