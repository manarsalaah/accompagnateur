import 'package:accompagnateur/core/error/failure.dart';
import 'package:accompagnateur/features/photos/domain/repository/photo_repository.dart';
import 'package:dartz/dartz.dart';

import '../entity/photo.dart';

class GetMedias{
  final MediaRepository repository;
  GetMedias({required this.repository});
  Either<Failure,List<Media>> call (){
    return repository.getMedias();
  }
}