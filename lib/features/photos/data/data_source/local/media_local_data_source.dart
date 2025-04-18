import 'dart:io';

import 'package:accompagnateur/core/error/exception.dart';
import 'package:accompagnateur/objectbox_singleton.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../objectbox.dart';
import '../../entity/photo_entity.dart';
import 'package:path/path.dart';

abstract class MediaLocalDataSource {
  Future <void> pickAndSaveMediaFromGallery(String path);
  Future<File> pickMediaFromGallery();
  Future<void> saveMedia(File media,String path,String date);
  Future<File> capturePhoto();
  List<MediaEntity> getMedias();
}
class MediaLocalDataSourceImpl extends MediaLocalDataSource{
  final ImagePicker imagePicker;

  MediaLocalDataSourceImpl({required this.imagePicker});

  @override
  Future<void> pickAndSaveMediaFromGallery(String path) async{
    final mediaBox = objectBoxSingleton.store.box<MediaEntity>();
    final media = await imagePicker.pickMedia();
    if (media != null) {
      if (kDebugMode) {
        print(media.path);
        print(media.name);
      }
      final newMediaPath = path+media.name;
      print('this is the new path $newMediaPath');

    // await media.saveTo(newMediaPath);
      final file = File(newMediaPath);
      await file.writeAsBytes(await media.readAsBytes());
      final date = DateTime.now();
      String extension = media.name.split(".").last;
      MediaEntity entity = MediaEntity(path: newMediaPath, isShared: false, name: media.name, extension: extension, date: date, comment: "", hasComment: false, isPhoto: isImage(extension));
      mediaBox.put(entity);
    }
  }

  @override
  Future<File> pickMediaFromGallery() async{
    final media = await imagePicker.pickMedia();
    if(media!= null){
      return File(media.path);
    }
    throw NoMediaPickedException();

  }

  @override
  Future<void> saveMedia(File media, String path, String date) async{
    print("---------we Are Saving media----------");
    final mediaBox = objectBoxSingleton.store.box<MediaEntity>();
    final meds = mediaBox.getAll();
    print('this is the total number of media saved ${meds.length}');
    final newMediaPath = path+basename(media.path);
    print('this is the path $newMediaPath');
    final file = File(newMediaPath);
    await file.writeAsBytes(await media.readAsBytes());
    final date_sej = DateTime.parse(date);
    bool isCommented = false;
    String extension = media.path.split(".").last;
    String mediaName = basename(media.path);
    MediaEntity entity = MediaEntity(path: newMediaPath, isShared: false, name: mediaName, extension: extension, date: date_sej, comment: "", hasComment: isCommented, isPhoto: isImage(extension));
    mediaBox.put(entity);
    print("----- media saved successfully-----");
    final medias = mediaBox.getAll();
    print('this is the total number of media saved ${medias.length}');
  }

  @override
  Future<File> capturePhoto() async{
   final photo = await  imagePicker.pickImage(source: ImageSource.camera);
   if(photo != null){
     return File(photo.path);
   }
   throw NoMediaPickedException();
  }

  @override
  List<MediaEntity> getMedias() {
    final mediaBox = objectBoxSingleton.store.box<MediaEntity>();
    final medias = mediaBox.getAll();
    return medias;
  }

}
