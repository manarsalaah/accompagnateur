import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class AudioMessage extends Equatable {
  final String path;
  final bool isShared;
  final double duration;
  final String name;
  final String extension;
  final DateTime recordedDate;
  Uint8List? audioData;
  String? attachmentId;
  AudioMessage(
      {required this.path,
      required this.isShared,
      required this.duration,
      required this.name,
      required this.extension,
      required this.recordedDate,
      this.audioData,
        this.attachmentId,
      });

  @override
  List<Object?> get props =>
      [path, isShared, duration, name, extension, recordedDate,audioData,attachmentId];
}
