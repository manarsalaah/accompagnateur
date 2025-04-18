import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'app_colors.dart';

bool isImage(String extension) {
  // List of image file extensions
  final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];

  // Get the file extension from the file path
  extension = extension.toLowerCase();

  // Check if the extension is in the list of image extensions
  return imageExtensions.contains('.$extension');
}
String getMediaType(String path) {
  // Extract the file extension from the path
  String extension = path.split('.').last.toLowerCase();
print("this is the file extension -> $extension");
  // Define lists of known file extensions for each media type
  List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg'];
  List<String> videoExtensions = ['mp4', 'avi', 'mov', 'mkv', 'flv', 'wmv'];
  List<String> audioExtensions = ['mp3', 'wav', 'aac', 'flac', 'ogg'];

  // Determine the media type based on the extension
  if (imageExtensions.contains(extension)) {
    return 'image';
  } else if (videoExtensions.contains(extension)) {
    return 'video';
  } else if (audioExtensions.contains(extension)) {
    return 'audio';
  } else {
    throw Exception("unkown type");
  }
}

String formatPublicationTime(DateTime uploadDate) {
  final now = DateTime.now();
  final difference = now.difference(uploadDate);

  if (difference.inMinutes < 60) {
    return "publié il y'a ${difference.inMinutes} minutes";
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours == 1 && minutes < 45) {
      return "publié il y'a une heure";
    } else if (hours == 1) {
      return "publié il y'a une heure";
    } else if (minutes < 45) {
      return "publié il y'a ${hours} heures";
    } else {
      return "publié il y'a ${hours} heures";
    }
  } else {
    return "publié il y'a ${difference.inHours ~/ 24} jours";
  }
}
List<DateTime> getAllDaysBetween(DateTime dateDeb, DateTime dateFin) {
  List<DateTime> days = [];
  DateTime currentDate = dateDeb;

  while (currentDate.isBefore(dateFin) || currentDate.isAtSameMomentAs(dateFin)) {
    days.add(currentDate);
    currentDate = currentDate.add(Duration(days: 1));
  }

  return days;
}
String formatDate(DateTime date){
  String year = date.year.toString();
  String month = date.month.toString();
  String day = date.day.toString();
  if(day.length <2){
    day = "0"+day;
  }
  if(month.length <2){
    month = "0"+month;
  }
  return "$year-$month-$day";
}
String formatDateToFrench(DateTime dateTime, int listLength, int index) {
  String prefix = "";
  if(index == 0) {
    prefix = "le premier jour,";
  }else if (index == listLength-1){
    prefix = "le dernier jour,";
  }else {
    var prefix_tab = [
      "le deuxième jour,",
      "le troisième jour,",
      "le quatrième jour,",
      "le cinquième jour,",
      "le sixième jour,",
      "le septième jour,",
      "le huitième jour,",
      "le neuvième jour,",
      "le dixième jour,",
      "le onzième jour,",
      "le douzième jour,",
      "le treizième jour,",
      "le quatorzième jour,",
      "le quinzième jour,",
      "le seizième jour,",
      "le dix-septième jour,",
      "le dix-huitième jour,",
      "le dix-neuvième jour,",
      "le vingtième jour,",
      "le vingt et unième jour,",
      "le vingt-deuxième jour,",
      "le vingt-troisième jour,",
      "le vingt-quatrième jour,",
      "le vingt-cinquième jour,",
      "le vingt-sixième jour,",
      "le vingt-septième jour,",
      "le vingt-huitième jour,",
      "le vingt-neuvième jour,"
    ];
    prefix = prefix_tab[index-1];
  }
  // Define a list of French month names
  const List<String> months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];

  // Extract the day and month
  int day = dateTime.day;
  String month = months[dateTime.month - 1]; // Get the French month name

  // Format the date
  return '$prefix $day $month';
}
Future<bool> showMyDepublierDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Dépublier',style: TextStyle(color: AppColors.primaryColor)),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Voulez vous vraiment supprimer cet attachement?'),
            ],
          ),
        ),
        actions: <Widget>[

          TextButton(
            child: const Text('Annuler',style: TextStyle(color: AppColors.secondaryColor),),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Valider',style: TextStyle(color: AppColors.primaryColor)),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}Future<bool> showDeleteCommentDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Supprimer le commentaire',style: TextStyle(color: AppColors.primaryColor)),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Voulez vous vraiment supprimer ce commentaire?'),
            ],
          ),
        ),
        actions: <Widget>[

          TextButton(
            child: const Text('Annuler',style: TextStyle(color: AppColors.secondaryColor),),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Valider',style: TextStyle(color: AppColors.primaryColor)),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
Future<String?> showCommentDialog(BuildContext context) async {
  TextEditingController _commentController = TextEditingController();

  return showDialog<String?>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ajouter un commenter',style: TextStyle(color: AppColors.primaryColor)),
        content: TextField(
          controller: _commentController,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            labelText: 'Écrire un commentaire',
            labelStyle: TextStyle(color: AppColors.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
          cursorColor: AppColors.primaryColor,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Annuler',style: TextStyle(color: AppColors.secondaryColor)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Valider',style: TextStyle(color: AppColors.primaryColor)),
            onPressed: () {
              Navigator.of(context).pop(_commentController.text);
            },
          ),
        ],
      );
    },
  );
}
Future<String?> showDescriptionDialog(BuildContext context) async {
  TextEditingController _descController = TextEditingController();

  return showDialog<String?>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ajouter un commenter',style: TextStyle(color: AppColors.primaryColor)),
        content: TextField(
          controller: _descController,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            labelText: 'Racontez votre journée',
            labelStyle: TextStyle(color: AppColors.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
          cursorColor: AppColors.primaryColor,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Annuler',style: TextStyle(color: AppColors.secondaryColor)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Valider',style: TextStyle(color: AppColors.primaryColor)),
            onPressed: () {
              Navigator.of(context).pop(_descController.text);
            },
          ),
        ],
      );
    },
  );
}
Future<String?> showUpdateCommentDialog(BuildContext context,String oldComment) async {
  TextEditingController _commentController = TextEditingController()..text =oldComment;

  return showDialog<String?>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Modifier un commenter',style: TextStyle(color: AppColors.primaryColor)),
        content: TextField(
          controller: _commentController,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            labelText: 'Modifier un commentaire',
            labelStyle: TextStyle(color: AppColors.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
          cursorColor: AppColors.primaryColor,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Annuler',style: TextStyle(color: AppColors.secondaryColor)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Valider',style: TextStyle(color: AppColors.primaryColor)),
            onPressed: () {
              Navigator.of(context).pop(_commentController.text);
            },
          ),
        ],
      );
    },
  );
}
Future<int?> showCommentOptionsDialog(BuildContext context) async {
  return showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Choisissez une action',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  elevation: 0,
                  textStyle: TextStyle(
                    fontSize: 16,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Modifier", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(2);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  elevation: 0,
                  textStyle: TextStyle(
                    fontSize: 16,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Supprimer", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.secondaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
        ],
      );
    },
  );
}
Future<void> clearDirectory(String directoryName) async {
  final directory = await getTemporaryDirectory();
  final path = '${directory.path}/$directoryName';
  final dir = Directory(path);
  if (await dir.exists()) {
    dir.listSync().forEach((file) {
      if (file is File) file.deleteSync();
    });
  }
}

Future<File> saveMediaToFile(Uint8List mediaData, String fileName, String directoryName) async {
  final tempDir = await getTemporaryDirectory();
  final directory = Directory('${tempDir.path}/$directoryName');
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  final tempFile = File('${directory.path}/$fileName');
  return tempFile.writeAsBytes(mediaData);
}

Future<void> clearTemporaryFiles(String directoryName) async {
  final tempDir = await getTemporaryDirectory();
  final directory = Directory('${tempDir.path}/$directoryName');
  if (await directory.exists()) {
    directory.listSync().forEach((file) {
      if (file is File) {
        file.deleteSync();
      }
    });
    await directory.delete(recursive: true);
  }
}
String inverseDate(DateTime date){
  var day = date.day.toString();
  var month = date.month.toString();
  var minute = date.minute.toString();
  var second = date.second.toString();
  if(day.length<2){
    day = "0$day";
  }
  if(month.length<2){
    month = "0$month";
  }
  if(minute.length<2){
    minute = "0$minute";
  }
  if(second.length<2){
    second = "0$second";
  }
  return '$day-$month-${date.year} ${date.hour}:$minute:$second';
}
String inverseDateShort(DateTime date){
  var day = date.day.toString();
  var month = date.month.toString();
  if(day.length<2){
    day = "0$day";
  }
  if(month.length<2){
    month = "0$month";
  }

  return '$day-$month-${date.year}';
}
String getFrenchMonthName(int month) {
  const months = [
    "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
    "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
  ];

  if (month < 1 || month > 12) {
    throw ArgumentError("Le numéro du mois doit être entre 1 et 12.");
  }

  return months[month - 1];
}
String formatNumber(int num){
  if(num <10) {
    return "0$num";
  }
  return"$num";
}
String toNewDateString(DateTime dateDeb,DateTime dateFin){
  String startDay = formatNumber(dateDeb.day);
  String endDay = formatNumber(dateFin.day);
  if(dateDeb.month == dateFin.month) {
    String newMonth = getFrenchMonthName(dateDeb.month);
    return"De $startDay au $endDay $newMonth";
  }
  String debMonth = getFrenchMonthName(dateDeb.month);
  String endMonth = getFrenchMonthName(dateDeb.month);
  return "De $startDay $debMonth au $endDay $endMonth";
}