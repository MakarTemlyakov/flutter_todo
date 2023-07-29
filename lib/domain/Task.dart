import 'package:hive/hive.dart';

part 'Task.g.dart';

@HiveType(typeId: 2)
class Task extends HiveObject {
  Task({required this.description, required this.isDone});

  @HiveField(0)
  String description;

  @HiveField(1)
  bool isDone;
}
