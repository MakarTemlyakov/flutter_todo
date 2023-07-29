import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/widgets/groups/groups_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/widgets/groups_form_widget/group_form_widget.dart';
import 'package:todo_list/widgets/task/task_form_widget.dart';
import 'package:todo_list/widgets/tasks/task/task_widget_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/group_form': (context) => GroupFormWidget(),
        '/groups': (context) => GroupsWidgetList(),
        '/groups/tasks/form': (context) => TaskFormWidget(),
        '/groups/tasks': (context) => TaskWidgetScreen(),
      },
      initialRoute: '/groups',
      theme: ThemeData(primaryColor: Colors.black),
    );
  }
}
