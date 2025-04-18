class Media{
  bool isPhoto;
  bool isShared;
  String name;
  String extension;
  String path;
  String comment;
  bool hasComment;
  DateTime date;
  Media({required this.isShared, required this.name, required this.extension, required this.path, required this.comment, required this.hasComment, required this.date,required this.isPhoto});

}