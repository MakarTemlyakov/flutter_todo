import 'package:flutter/material.dart';
import 'package:todo_list/widgets/task/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  const TaskFormWidget({Key? key}) : super(key: key);

  @override
  _TaskFormWidgetState createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  TaskModel? _taskModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_taskModel == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _taskModel = TaskModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskModelProvider(model: _taskModel!, child: _TaskFormWidgetBody());
    ;
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  _TaskFormWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Форма добавления')),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
                minLines: 4,
                maxLines: 6,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the description'),
                onEditingComplete: () =>
                    TaskModelProvider.read(context)?.notifier?.text,
                onChanged: (value) =>
                    TaskModelProvider.read(context)?.notifier?.text = value),
            SizedBox(height: 20),
            TextButton(
              style: ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 15)),
                  backgroundColor:
                      MaterialStatePropertyAll(Color.fromRGBO(46, 46, 46, 1))),
              onPressed: () =>
                  TaskModelProvider.read(context)?.notifier?.addTask(context),
              child: Text(
                'Добавить',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
