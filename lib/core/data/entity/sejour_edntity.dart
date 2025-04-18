
import 'package:accompagnateur/core/domain/entities/sejour_day.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class SejourDayEntity  {
  @Id()
  int id = 0;
  String description;
  bool isFirstDay;
  bool isLastDay;
  DateTime date;
SejourDayEntity({
    required this.description,
    required this.isFirstDay,
    required this.isLastDay,
    required this.date,
  });
  factory SejourDayEntity.fromSejourDay(SejourDay day) {
    return SejourDayEntity(description: day.description, isFirstDay: day.isFirstDay, isLastDay: day.isLastDay, date: day.date);
  }
  SejourDay toSejourDay(){
    return SejourDay(date: date, description: description, isFirstDay: isFirstDay, isLastDay: isLastDay);
  }
}
