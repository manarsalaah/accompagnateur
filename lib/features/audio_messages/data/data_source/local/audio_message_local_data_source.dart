import 'dart:io';

import 'package:accompagnateur/core/error/exception.dart';
import 'package:accompagnateur/features/audio_messages/data/entity/audio_message_entity.dart';
import 'package:accompagnateur/features/audio_messages/domain/entity/audio_message.dart';
import 'package:accompagnateur/objectbox_singleton.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

abstract class AudioMessageLocalDataSource {
  Future<void> record(String path);
  Future<String> stopRecording();
  Future<void> pause();
  Future<void> deleteAudioMessage(String path);
  Future<void> renameAudioMessage(String path,String newName);
  List<AudioMessageEntity> getAllAudioMessagesFromLocal();
  Future<AudioMessageEntity> saveAudioMessage(String path, double duration, bool isShared);
  Future<void>startPlayer(AudioMessage audioMessage);
  Future<void>pausePlayer();
  Future<void>stopPlayer();
  Future<void>cancelRecording();
  Future<void>resumeRecording();
}

class AudioMessageLocalDataSourceImpl implements AudioMessageLocalDataSource {



  final AudioPlayer audioPlayer;
  final AudioRecorder audioRecorder;
  AudioMessageLocalDataSourceImpl(
      {required this.audioPlayer,required this.audioRecorder});

  @override
  Future<void> deleteAudioMessage(String path) async{
    try{
      print("we are deleting the file");
      final audioMessageBox = objectBoxSingleton.store.box<AudioMessageEntity>();
      final listAudio = audioMessageBox.getAll();
      AudioMessageEntity? entity = getEntityByPath(listAudio, path);
      if(entity!= null){
      final isRemoved =  audioMessageBox.remove(entity.id);
      if(isRemoved){
        if (await File(path).exists()) {
            await File(path).delete();
            var check = await File(path).exists();
            print("does the file still exists ? : $check");
    return;
    } else {
    throw Exception('File not found');
    }
      }
      else {
        throw Exception('could not delete record');
      }
      }
      throw Exception('File not found');
    }catch (e){
      throw Exception(e);
    }


  }

  @override
  Future<void> pause() async {
    try {
     // await recorderController.pause();
      await audioRecorder.pause();
    } catch (e) {
      throw RecordException(message: e.toString());
    }
  }

  @override
  Future<void> record(String path) async {
    try {
     // await recorderController.record(path: path);
      var permissionRequest = await Permission.microphone.request();
      if(permissionRequest.isGranted) {
        await audioRecorder.start(const RecordConfig(), path: path);
      }else if(permissionRequest.isDenied){
        throw RecordException(message: "permission requise");
      }else if(permissionRequest.isPermanentlyDenied){
        await openAppSettings();
      }
    } catch (e) {
      throw RecordException(message: e.toString());
    }
  }

  @override
  Future<void> renameAudioMessage(String path,String newName) async{
    File file = File(path);
    try{
      bool exists = await file.exists();
      if (exists) {
        String newPath = getNewPath(path, newName);
        await file.rename(newPath);
        final audioMessageBox = objectBoxSingleton.store.box<AudioMessageEntity>();
        final listAudio = audioMessageBox.getAll();
        AudioMessageEntity? entity = getEntityByPath(listAudio, path);
        if(entity!= null){
          entity.path = newPath;
          entity.name = newName;
          audioMessageBox.put(entity);
          return ;
        }
        throw Exception("entity null");
      }
      throw Exception("file doesn't exist");
    }catch(e){
throw Exception(e);
    }
  }

  @override
  Future<String> stopRecording() async {
    try {
      String? path = await audioRecorder.stop();

      if (path != null) {
        return path;
      }
      throw RecordException(message: "path is null");
    } catch (e) {
      throw RecordException(message: e.toString());
    }
  }

  @override
  List<AudioMessageEntity> getAllAudioMessagesFromLocal() {
    final audioMessageBox = objectBoxSingleton.store.box<AudioMessageEntity>();
    final audios = audioMessageBox.getAll();
    //print(audios.length);
    return audios;
  }

  @override
  Future<AudioMessageEntity> saveAudioMessage(
      String path, double duration, bool isShared) async {
    String nameAndExtension = path.split("/").last;
    String name = nameAndExtension.split(".").first;
    String extension = nameAndExtension.split(".").last;
    DateTime recordDate = DateTime.now();
    final audioMessageBox = objectBoxSingleton.store.box<AudioMessageEntity>();
    final audioMessage =
        AudioMessageEntity(path: path, isShared: isShared, duration: duration,name: name,extension: extension,recordedDate: recordDate);
    audioMessageBox.put(audioMessage);
    return audioMessage;
  }

  @override
  Future<void> pausePlayer() async{
    await audioPlayer.pause();
  }

  @override
  Future<void> startPlayer(AudioMessage audioMessage) async{
    //playerController.preparePlayer(path: path);
   // await playerController.startPlayer();
      await audioPlayer.play(DeviceFileSource("file://${audioMessage.path}"));
  }

  @override
  Future<void> stopPlayer() async{
   // await playerController.startPlayer();
    await audioPlayer.stop();
  }

  @override
  Future<void> cancelRecording() async{
    await audioRecorder.cancel();
  }

  @override
  Future<void> resumeRecording() async{
    await audioRecorder.resume();
  }

}
String getNewPath(String path, String newFileName) {
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var extension = path.split(".").last;
  var newPath = "${path.substring(0, lastSeparator + 1)}$newFileName.$extension";
  return newPath;
}
AudioMessageEntity ? getEntityByPath(List<AudioMessageEntity> list, String path){
  for (var element in list){
    if(element.path == path) {
      return element;
    }
  }
  return null;
}