import 'package:hive/hive.dart';
import 'package:todo_list/domain/Group.dart';
import 'package:todo_list/domain/Task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();

  BoxManager._();

  Future<Box<Group>> openGroupBox() async {
    return _openBox(1, 'groups', GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    final boxName = makeTaskBoxName(groupKey);
    return _openBox(2, boxName, TaskAdapter());
  }

  Future<Box<T>> _openBox<T>(
      int typeId, String nameBox, TypeAdapter<T> adapter) async {
    if (!Hive.isAdapterRegistered(typeId)) Hive.registerAdapter(adapter);
    return await Hive.openBox<T>(nameBox);
  }

  String makeTaskBoxName(int groupKey) {
    return 'tasks_$groupKey';
  }

  Future<void> closeBox<T>(Box<T> box) async {
    box.compact();
    box.close();
  }
}
