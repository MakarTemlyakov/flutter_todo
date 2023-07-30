import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/Group.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';
import 'package:todo_list/ui/widgets/tasks/task/task_widget_list.dart';

class GroupsWidgetModel with ChangeNotifier {
  List<Group> _groups = [];
  late Box<Group> _boxGroup;
  List<Group> get groups => _groups;
  late ValueListenable listenable;

  GroupsWidgetModel() {
    _setup();
  }

  void _readGroupBox() {
    _groups = _boxGroup.values.toList();
    notifyListeners();
  }

  void _setup() async {
    _boxGroup = await BoxManager.instance.openGroupBox();
    _readGroupBox();

    listenable = _boxGroup.listenable();

    listenable.addListener(_readGroupBox);
  }

  void addGroup(BuildContext context) {
    Navigator.pushNamed(context, MainNavigation.groupFrom);
  }

  void remove(int index) async {
    final groupKey = _boxGroup.keyAt(index) as int;
    final boxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(boxName);
    await _boxGroup.deleteAt(index);
  }

  void showTasks(BuildContext context, int groupIndex) async {
    final group = _boxGroup.getAt(groupIndex);
    if (group == null) return;
    final modalSettings =
        TaskWidgetModelSettings(groupKey: group.key, title: group.name);
    unawaited(Navigator.of(context)
        .pushNamed(MainNavigation.tasks, arguments: modalSettings));
  }

  @override
  Future<void> dispose() async {
    await BoxManager.instance.closeBox(_boxGroup);
    listenable.removeListener(_readGroupBox);
    super.dispose();
  }
}

class GroupsWidgetProvider extends InheritedNotifier<GroupsWidgetModel> {
  final GroupsWidgetModel model;
  const GroupsWidgetProvider(
      {super.key, required this.model, required super.child})
      : super(
          notifier: model,
        );

  static GroupsWidgetProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GroupsWidgetProvider>();
  }

  static GroupsWidgetProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetProvider>()
        ?.widget;
    return widget is GroupsWidgetProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(
      covariant InheritedNotifier<GroupsWidgetModel> oldWidget) {
    return notifier!.groups != oldWidget.notifier!.groups;
  }
}
