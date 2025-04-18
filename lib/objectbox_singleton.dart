import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'core/data/entity/sejour_edntity.dart';
import 'features/audio_messages/data/entity/audio_message_entity.dart';
import 'features/photos/data/entity/photo_entity.dart';
import 'objectbox.g.dart';

class ObjectBoxSingleton {
  static final ObjectBoxSingleton _singleton = ObjectBoxSingleton._internal();
  late Store _store;
  bool _isInitialized = false;

  factory ObjectBoxSingleton() {
    return _singleton;
  }

  ObjectBoxSingleton._internal();

  Future<void> init() async {
    if (!_isInitialized) {
      final directory = await getApplicationDocumentsDirectory();
      _store = Store(getObjectBoxModel(), directory: '${directory.path}/obx-example');
      _isInitialized = true;
    }
  }

  bool isInitialized() {
    return _isInitialized;
  }

  Store get store {
    if (!_isInitialized) {
      throw StateError('ObjectBox store has not been initialized. Call init() first.');
    }
    return _store;
  }
  /// Method to clear all data in the ObjectBox database.
  void clearDatabase() {
    // Add your entity boxes here to clear their data
    final box1 = _store.box<AudioMessageEntity>(); // Replace with your entity names
    final box2 = store.box<SejourDayEntity>();
    final box3 = store.box<MediaEntity>();

    box1.removeAll();
    box2.removeAll();
    box3.removeAll();
  }
}

final objectBoxSingleton = ObjectBoxSingleton();
