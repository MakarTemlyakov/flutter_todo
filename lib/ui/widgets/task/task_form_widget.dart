import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/task/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;
  const TaskFormWidget({Key? key, required this.groupKey}) : super(key: key);

  @override
  _TaskFormWidgetState createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskModel _taskModel;

  @override
  void initState() {
    super.initState();
    _taskModel = TaskModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TaskModelProvider(
        model: _taskModel, child: const _TaskFormWidgetBody());
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  const _TaskFormWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final taskModel = TaskModelProvider.watch(context)?.notifier;
    const isDisabledColor =
        MaterialStatePropertyAll(Color.fromRGBO(167, 166, 166, 1));
    const defaultColor =
        MaterialStatePropertyAll(Color.fromRGBO(36, 36, 36, 1));

    return Scaffold(
      appBar: AppBar(title: Text('Форма добавления')),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
                minLines: 4,
                maxLines: 6,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the description'),
                onEditingComplete: () => taskModel?.textTask,
                onChanged: (value) => taskModel?.textTask = value),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => taskModel?.isValid == true
                  ? taskModel?.addTask(context)
                  : null,
              style: ButtonStyle(
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 15)),
                backgroundColor:
                    taskModel?.isValid == true ? defaultColor : isDisabledColor,
              ),
              child: const Text(
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
