import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/domain/Group.dart';
import 'package:todo_list/domain/Task.dart';

class TaskModel with ChangeNotifier {
  final int groupKey;
  var text = '';
  bool isDone = false;
  TaskModel({required this.groupKey});

  void addTask(BuildContext context) async {
    if (text.isEmpty) return;
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GroupAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TaskAdapter());
    final groupBox = await Hive.openBox<Group>('groups');
    final taskBox = await Hive.openBox<Task>('tasks');
    final task = Task(description: text, isDone: isDone);

    await taskBox.add(task);

    final group = groupBox.get(groupKey);
    group?.addTask(taskBox, task);

    Navigator.of(context).pop();
  }
}

class TaskModelProvider extends InheritedNotifier<TaskModel> {
  const TaskModelProvider(
      {super.key, required TaskModel model, required super.child})
      : super(
          notifier: model,
        );

  static TaskModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskModelProvider>();
  }

  static TaskModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskModelProvider>()
        ?.widget;
    return widget is TaskModelProvider ? widget : null;
  }
}
