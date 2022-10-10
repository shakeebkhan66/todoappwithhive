import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel{
  
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? details;
  @HiveField(2)
  bool? isCompleted;

  TodoModel({this.title, this.details, this.isCompleted});
}