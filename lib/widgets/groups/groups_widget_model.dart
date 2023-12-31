import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/Group.dart';

class GroupsWidgetModel with ChangeNotifier {
  List<Group> _groups = [];
  late Box<Group> _boxGroup;
  List<Group> get groups => _groups;

  GroupsWidgetModel() {
    _setup();
  }

  void _readGroupBox(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GroupAdapter());
    _boxGroup = await Hive.openBox<Group>('groups');

    _readGroupBox(_boxGroup);

    _boxGroup.listenable().addListener(() => _readGroupBox(_boxGroup));
  }

  void addGroup(BuildContext context) {
    Navigator.pushNamed(context, '/group_form');
  }

  void remove(int index) async {
    await _boxGroup.deleteAt(index);
  }

  void showTasks(BuildContext context, int groupIndex) async {
    final groupKey = _boxGroup.keyAt(groupIndex);

    unawaited(
        Navigator.of(context).pushNamed('/groups/tasks', arguments: groupKey));
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
