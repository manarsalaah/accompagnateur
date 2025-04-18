import 'dart:io';
import 'package:accompagnateur/core/data/entity/sejour_edntity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:workmanager/workmanager.dart';
import '../../../../features/photos/data/entity/photo_entity.dart';
import '../../../../objectbox_singleton.dart';
import '../../../directory_manager/directory_manager_service.dart';

abstract class LocalCoreDataSource{
  List<SejourDayEntity> getSejourDays();
  List<SejourDayEntity> saveSejourDays(List<SejourDayEntity> days);
  Future <void> saveMediasToPublishLater(List<XFile> medias,String date);
  List<MediaEntity> getPendingMedias();
  void deleteMedia(MediaEntity media);
  void startService();
  void stopService();
}
class LocalCoreDataSourceImpl extends LocalCoreDataSource{
  final DirectoryManagerService directoryManagerService;
  LocalCoreDataSourceImpl({required this.directoryManagerService});
  @override
  List<SejourDayEntity> getSejourDays() {
    final sejourDayBox = objectBoxSingleton.store.box<SejourDayEntity>();
   var sejourDaysList =  sejourDayBox.getAll();
    sejourDaysList.sort((a,b)=>a.date.compareTo(b.date));
  return sejourDaysList;
  }

  @override
  List<SejourDayEntity> saveSejourDays(List<SejourDayEntity> days) {
    final sejourDayBox = objectBoxSingleton.store.box<SejourDayEntity>();
    sejourDayBox.putMany(days);
    return days;
  }

  @override
  Future<void> saveMediasToPublishLater(List<XFile> medias,String date) async{
    String path = await directoryManagerService.getDirectory();
    for(var elem in medias){
      File file = File(elem.path);
     await saveMedia(file, path, date);
    }
    startService();
  }
  Future<void> saveMedia(File media, String path, String date) async{
    print("---------we Are Saving media----------");
    final mediaBox = objectBoxSingleton.store.box<MediaEntity>();
    final meds = mediaBox.getAll();
    print('this is the total number of media saved ${meds.length}');
    final newMediaPath = path+"/"+basename(media.path);
    print('this is the path $newMediaPath');
    final file = File(newMediaPath);
    await file.writeAsBytes(await media.readAsBytes());
    final date_sej = DateTime.parse(date);
    bool isCommented = false;
    String extension = media.path.split(".").last;
    String mediaName = basename(media.path);
    MediaEntity entity = MediaEntity(path: newMediaPath, isShared: false, name: mediaName, extension: extension, date: date_sej, comment: "", hasComment: isCommented, isPhoto: true);
    mediaBox.put(entity);
    print("----- media saved successfully-----");
    final medias = mediaBox.getAll();
    print('this is the total number of media saved ${medias.length}');
  }
  @override
  List<MediaEntity> getPendingMedias() {
    final mediaBox = objectBoxSingleton.store.box<MediaEntity>();
    return mediaBox.getAll().where((media) => !media.isShared).toList();
  }

  @override
  void deleteMedia(MediaEntity media) {
    final mediaBox = objectBoxSingleton.store.box<MediaEntity>();
    mediaBox.remove(media.id);
  }
  @override
  void startService() {
    try{
      print("we are starting the service");
      Workmanager().registerPeriodicTask(
        "simplePeriodicTask",
        "simplePeriodicTask",
        frequency: Duration(minutes: 15),
      );
    }catch(e){
      print(e.toString());
    }

  }
  @override
  void stopService() {
    Workmanager().cancelByUniqueName("simplePeriodicTask");
  }
}