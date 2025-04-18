import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  final String message;
  ServerFailure({required this.message});
}

class CacheFailure extends Failure {}
class UnAuthorizedFailure extends Failure {}
class NoInternetFailure extends Failure{}

class PermissionFailure extends Failure {
  String message;
  PermissionFailure({required this.message});
}

class DirectoryManagerFailure extends Failure {}

class RecordFailure extends Failure {
  String message;
  RecordFailure({required this.message});
}
class PlayerFailure extends Failure {
  String message;
  PlayerFailure({required this.message});
}
class MediaPickingFailure extends Failure{}
class NoMediaPickedFailure extends Failure{}
class SavingMediaFailure extends Failure{}