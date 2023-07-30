import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/Task.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';
import 'package:todo_list/ui/widgets/tasks/task/task_widget_list.dart';

class TaskListModel extends ChangeNotifier {
  TaskWidgetModelSettings settings;

  late final Box<Task> _taskBox;

  List<Task> _tasks = [];
  late ValueListenable listenable;
  List<Task> get tasks => _tasks;

  TaskListModel({required this.settings}) {
    _setup();
  }

  void _setup() async {
    _taskBox = await BoxManager.instance.openTaskBox(settings.groupKey);
    _readTasks();
    listenable = _taskBox.listenable();
    listenable.addListener(_readTasks);
  }

  void toggleStatus(int taskIndex) async {
    final task = _taskBox.getAt(taskIndex);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  void redirectToForm(BuildContext context) {
    Navigator.of(context)
        .pushNamed(MainNavigation.tasksForm, arguments: settings);
  }

  void _readTasks() {
    _tasks = _taskBox.values.toList();
    notifyListeners();
  }

  void deleteTask(int taskIndex) async {
    await _taskBox.deleteAt(taskIndex);
  }

  @override
  Future<void> dispose() async {
    listenable.removeListener(_readTasks);
    if (_taskBox.isOpen) {
      await BoxManager.instance.closeBox(_taskBox);
    }

    super.dispose();
  }
}

class TaskListModelProvider extends InheritedNotifier<TaskListModel> {
  const TaskListModelProvider(
      {super.key, required TaskListModel model, required Widget child})
      : super(child: child, notifier: model);

  static TaskListModelProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskListModelProvider>();
  }
}
