import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/photos/domain/repository/photo_repository.dart';
import 'package:dartz/dartz.dart';

class UploadMediaFromGallery{
  final MediaRepository repository;
  UploadMediaFromGallery({required this.repository});
  Future<Either<Failure, void>> call(String path)async{
    return await repository.uploadMediaFromGallery(path);
  }
}