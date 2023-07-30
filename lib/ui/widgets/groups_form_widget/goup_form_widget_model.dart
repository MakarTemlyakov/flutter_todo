import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:todo_list/domain/Group.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  var _groupName = '';
  String? errorMessage;
  set groupName(String value) {
    if (errorMessage != null && value.trim().isNotEmpty) {
      errorMessage = null;
      notifyListeners();
    }
    _groupName = value;
  }

  void save(BuildContext context) async {
    final groupName = _groupName.trim();
    if (groupName.trim().isEmpty) {
      errorMessage = 'Заполните поле';
      notifyListeners();
      return;
    }

    final box = await BoxManager.instance.openGroupBox();
    final group = Group(name: groupName);
    await box.add(group);

    unawaited(Navigator.pushReplacementNamed(context, MainNavigation.groups));
  }
}

class GroupFormModelProvider extends InheritedNotifier {
  final GroupFormWidgetModel model;
  const GroupFormModelProvider(
      {super.key, required this.model, required Widget child})
      : super(child: child, notifier: model);

  static GroupFormModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GroupFormModelProvider>();
  }

  static GroupFormModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormModelProvider>()
        ?.widget;
    return widget is GroupFormModelProvider ? widget : null;
  }
}
