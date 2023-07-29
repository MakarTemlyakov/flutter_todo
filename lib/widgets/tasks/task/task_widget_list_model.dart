import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/Group.dart';
import 'package:todo_list/domain/Task.dart';

class TaskListModel extends ChangeNotifier {
  int groupKey;
  late final Box<Group> _groupBox;
  Group? _group;
  Group? get group => _group;
  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

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
    _groupBox = await Hive.openBox<Group>('groups');
    _loadGroup();
    _setupListner();
  }

  void _setupListner() async {
    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: [groupKey]).addListener(_readTasks);
  }

  void redirectToForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/tasks/form', arguments: groupKey);
  }

  void _readTasks() {
    _tasks = _group?.tasks ?? [];
    notifyListeners();
  }

  void _deleteTask(int taskIndex) async {
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

  @override
  bool updateShouldNotify(TaskListModelProvider oldWidget) {
    return true;
  }
}
