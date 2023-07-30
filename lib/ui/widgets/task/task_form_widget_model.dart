import 'package:flutter/material.dart';
import 'package:todo_list/domain/Task.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';

class TaskModel with ChangeNotifier {
  final int groupKey;
  String _text = '';
  String get textTask => _text;
  set textTask(String value) {
    final isTaslTextIsEmpty = _text.trim().isEmpty;
    _text = value;
    if (value.trim().isEmpty != isTaslTextIsEmpty) {
      notifyListeners();
    }
  }

  bool get isValid => _text.trim().isNotEmpty;

  bool isDone = false;
  TaskModel({required this.groupKey});

  void addTask(BuildContext context) async {
    var text = _text.trim();
    if (text.isEmpty) return;
    final task = Task(description: text, isDone: isDone);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    await box.add(task);

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
