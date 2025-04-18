import 'dart:io';
import 'package:accompagnateur/core/directory_manager/directory_manager_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dartz/dartz.dart';

import '../error/failure.dart';

class DirectoryManagerService implements DirectoryManagerRepository {
  @override
  Future<Either<Failure, String>> getOrCreateDirectory(String path) async {
    Directory? storageDirectory = await getApplicationDocumentsDirectory();
    if (storageDirectory != null) {
      print(storageDirectory.path);
      Directory directory = Directory(storageDirectory.path+path);
      if (!(await directory.exists())) {
        directory = await directory.create(recursive: true);
      }
      return Right(directory.path);
    }
    return Left(DirectoryManagerFailure());
  }
  Future<String> getDirectory() async {
    Directory? storageDirectory = await getApplicationDocumentsDirectory();
      print(storageDirectory.path);
      Directory directory = Directory(storageDirectory.path);
      if (!(await directory.exists())) {
        directory = await directory.create(recursive: true);
      }
      return directory.path;
  }
}
