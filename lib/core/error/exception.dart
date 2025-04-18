import 'package:image_picker/image_picker.dart';

class RecordException implements Exception{
  final String message;
  RecordException({required this.message});
}
class NoMediaPickedException implements Exception{
}
class NoInternetConnectionException implements Exception{
  List<XFile> medias;
  String date;
  NoInternetConnectionException({required this.medias,required this.date});
}
class ServerException implements Exception{
  final String message;
  ServerException({required this.message});
}
class UnAuthorizedException implements Exception{
  final String message;
  UnAuthorizedException({required this.message});
}


