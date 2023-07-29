import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/Group.dart';
import 'package:todo_list/domain/Task.dart';

class TaskListModel extends ChangeNotifier {
  int groupKey;
  late final Box<Group> _groupBox;
  late final Box<Task> _taskBox;
  Group? _group;
  List<Task> _tasks = [];
  Group? get group => _group;
  List<Task> get tasks => _tasks;

  TaskListModel({required this.groupKey}) {
    _setup();
  }

  void _loadGroup() {
    final box = _groupBox;
    _group = box.get(groupKey);
    notifyListeners();
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GroupAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TaskAdapter());
    _groupBox = await Hive.openBox<Group>('groups');
    _taskBox = await Hive.openBox<Task>('tasks');

    _loadGroup();
    _setupListner();
  }

  void _setupListner() async {
    final box = await _groupBox;
    final taskBox = await _taskBox;

    _readTasks();
    taskBox.listenable().addListener(_readTasks);
    box.listenable(keys: [groupKey]).addListener(_readTasks);
  }

  void toggleStatus(int taskIndex) {
    var taskStatus = _group?.tasks?[taskIndex].isDone;
    if (taskStatus == true) {
      taskStatus = false;
    } else {
      taskStatus = true;
    }
    _group?.tasks?[taskIndex].isDone = taskStatus;
    _readTasks();
  }

  void redirectToForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/tasks/form', arguments: groupKey);
  }

  void _readTasks() {
    _tasks = _group?.tasks ?? [];
    notifyListeners();
  }

  void deleteTask(int taskIndex) async {
    _group?.tasks?.deleteFromHive(taskIndex);
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
