import 'dart:io';

import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageListItem extends StatelessWidget {
  final String path;
  const ImageListItem({required this.path,super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children:[
        Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                ),
              ),
            )
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              color: AppColors.primaryColor,
              child: const Text("commentaire pour tester l'affichage",style: TextStyle(
              color: Colors.white,
              ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
