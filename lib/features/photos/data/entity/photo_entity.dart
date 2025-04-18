import 'package:accompagnateur/features/audio_messages/domain/entity/audio_message.dart';
import 'package:accompagnateur/features/photos/domain/entity/photo.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class MediaEntity  {
  @Id()
  int id = 0;
  bool isPhoto;
  String path;
  bool isShared;
  String name;
  String extension;
  DateTime date;
  String comment;
  bool hasComment;
  MediaEntity({
    required this.path,
    required this.isShared,
    required this.name,
    required this.extension,
    required this.date,
    required this.comment,
    required this.hasComment,
    required this.isPhoto
  });
  factory MediaEntity.fromPhoto(Media media) {
    return MediaEntity(
        path: media.path,
        isShared: media.isShared,
        date: media.date,
        name:  media.name,
        extension: media.extension,
        comment: media.comment,
        hasComment: media.hasComment,
        isPhoto: media.isPhoto,
    );
  }
  Media toMedia(){
    return Media(isShared: isShared, name: name, extension: extension, path: path, comment: comment, hasComment: hasComment, date: date, isPhoto: isPhoto);
  }
}
