import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/domain/Group.dart';
import 'package:todo_list/widgets/groups_form_widget/group_form_widget.dart';

class GroupFormWidgetModel {
  var groupName = '';

  void save(BuildContext context) async {
    if (groupName.isEmpty) return;
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GroupAdapter());
    final box = await Hive.openBox<Group>('groups');
    final group = Group(name: groupName);
    await box.add(group);

    Navigator.pushReplacementNamed(context, '/groups');
  }
}

class GroupFormModelProvider extends InheritedWidget {
  final GroupFormWidgetModel model;
  const GroupFormModelProvider(
      {super.key, required this.model, required Widget child})
      : super(child: child);

  static GroupFormModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GroupFormModelProvider>();
  }

  static GroupFormModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormModelProvider>()
        ?.widget;
    return widget is GroupFormModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupFormModelProvider oldWidget) {
    return true;
  }
}
