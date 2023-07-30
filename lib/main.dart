import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final baseNavigation = BaseNavigationRoute();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: baseNavigation.routes,
      initialRoute: baseNavigation.initialRoute,
      onGenerateRoute: onGenerateRoute,
      theme: ThemeData(primaryColor: Colors.black),
    );
  }
}
