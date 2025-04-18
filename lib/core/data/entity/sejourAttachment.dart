import 'dart:typed_data';

class SejourAttachment{
   Uint8List? data;
  final String id;
  final String path;
  final int likes;
  final String? comment;
  final String type;
  final DateTime uploadDate;
 String? filePath;
  SejourAttachment({required this.id,required this.path, required this.likes, required this.comment,required this.type,required this.uploadDate,this.filePath,this.data});
  factory SejourAttachment.fromJson(Map<String, dynamic> json) {
    return SejourAttachment(
      id: json['id'],
      path: json['pathnonstream'],
      likes: json['likes'],
      comment: json['comment'],
      type: json['type'],
      uploadDate: DateTime.parse(json['dateCreate'])
    );
  }
}