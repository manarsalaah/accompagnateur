import 'package:accompagnateur/core/data/entity/sejourAttachment.dart';
import 'package:accompagnateur/core/domain/entities/sejour_day.dart';
import 'package:accompagnateur/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

abstract class CoreRepository{
  Future<Either<Failure,List<SejourDay>>> getSejourDays();
  Future<Either<Failure,List<SejourAttachment>>> getSejourAttachements(String codeSejour, String date);
  Future<Either<Failure,void>> uploadVisualAttachment(String codeSejour, String date,BuildContext context);
  Future<Either<Failure,void>> uploadAudioAttachment(String codeSejour, String date);
  Future<Either<Failure,void>> uploadAttachmentFromCamera(String codeSejour,String date);
  Future<Either<Failure,void>> deleteAttachment(String attachmentId);
  Future<Either<Failure,void>> addOrUpdateComment(String comment,String attId);
  Future<Either<Failure,void>> deleteComment(String attachmentId);
  Future<void> uploadPendingMedias();
  Future<Either<Failure,String?>> getDayDescription(String codeSejour, String date);
  Future<Either<Failure,void>> deleteDayDescription(String codeSejour, String date);
  Future<Either<Failure,void>> sendSms(String codeSejour, String type);
  Future<Either<Failure,void>> addOrUpdateDayDescription(String codeSejour, String date,String description);

}