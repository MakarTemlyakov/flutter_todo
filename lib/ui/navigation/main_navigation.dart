import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/groups/groups_widget.dart';
import 'package:todo_list/ui/widgets/groups_form_widget/group_form_widget.dart';
import 'package:todo_list/ui/widgets/task/task_form_widget.dart';
import 'package:todo_list/ui/widgets/tasks/task/task_widget_list.dart';

abstract class MainNavigation {
  static const groups = '/';
  static const groupFrom = '/group_form';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}

class BaseNavigationRoute {
  final initialRoute = MainNavigation.groups;

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigation.groupFrom: (context) => const GroupFormWidget(),
    MainNavigation.groups: (context) => const GroupsWidgetList(),
  };
}

T _getRouteArgements<T>(RouteSettings settings) {
  return settings.arguments as T;
}

Route<Object> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MainNavigation.tasks:
      final modelSettings =
          _getRouteArgements<TaskWidgetModelSettings>(settings);
      return MaterialPageRoute(builder: (BuildContext context) {
        return TaskWidgetScreen(settings: modelSettings);
      });
    case MainNavigation.tasksForm:
      final modelSettings =
          _getRouteArgements<TaskWidgetModelSettings>(settings);
      return MaterialPageRoute(builder: (BuildContext context) {
        return TaskFormWidget(groupKey: modelSettings.groupKey);
      });

    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return const Align(
            alignment: Alignment.center, child: Text('Ничего не найдено'));
      });
  }
}
