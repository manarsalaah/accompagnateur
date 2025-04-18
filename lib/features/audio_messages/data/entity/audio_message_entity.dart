import 'dart:typed_data';

import 'package:accompagnateur/features/audio_messages/domain/entity/audio_message.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AudioMessageEntity  {
  @Id()
  int id = 0;
   String path;
   bool isShared;
   double duration;
   String name;
   String extension;
   DateTime recordedDate;
   String? attachmentId;
  Uint8List? audioData;
  AudioMessageEntity({
    required this.path,
    required this.isShared,
    required this.duration,
    required this.name,
    required this.extension,
    required this.recordedDate,
    this.attachmentId,
    this.audioData
  });
  factory AudioMessageEntity.fromAudioMessage(AudioMessage audioMessage) {
    return AudioMessageEntity(
      attachmentId: audioMessage.attachmentId,
      path: audioMessage.path,
      isShared: audioMessage.isShared,
      duration: audioMessage.duration,
      name:  audioMessage.name,
      extension: audioMessage.extension,
      recordedDate:  audioMessage.recordedDate
    );
  }
  AudioMessage toAudioMessage(){
    return AudioMessage(path: path, isShared: isShared, duration: duration, name: name, extension: extension, recordedDate: recordedDate, attachmentId: attachmentId );
  }
  factory AudioMessageEntity.fromJson(Map<String, dynamic> json) {
    return AudioMessageEntity(attachmentId: json["id"],path: json['path'], isShared: true, duration: 0, name: json["path"].toString().split("/").last, extension: "mp3", recordedDate: DateTime.parse(json['dateCreate']));
  }
}
