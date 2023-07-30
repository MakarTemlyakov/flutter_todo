import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/domain/Task.dart';
import 'package:todo_list/ui/widgets/tasks/task/task_widget_list_model.dart';

class TaskWidgetModelSettings {
  int groupKey;
  final String title;
  TaskWidgetModelSettings({required this.groupKey, required this.title});
}

class TaskWidgetScreen extends StatefulWidget {
  final TaskWidgetModelSettings settings;
  const TaskWidgetScreen({super.key, required this.settings});

  @override
  State<TaskWidgetScreen> createState() => _TaskWidgetScreenState();
}

class _TaskWidgetScreenState extends State<TaskWidgetScreen> {
  late final TaskListModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskListModel(settings: widget.settings);
  }

  @override
  Widget build(BuildContext context) {
    return TaskListModelProvider(model: _model, child: const TaskWidgetList());
  }

  // @override
  // void dispose() async {
  //   await _model.dispose();
  //   super.dispose();
  // }
}

class TaskWidgetList extends StatelessWidget {
  const TaskWidgetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskListModelProvider.of(context)?.notifier;

    final groupName = model?.settings.title ?? 'Задачи';
    return Scaffold(
        appBar: AppBar(
            title: Text(groupName),
            backgroundColor: const Color.fromRGBO(36, 36, 36, 1)),
        backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
        body: const _TaskWidgetListBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => model?.redirectToForm(context),
          backgroundColor: const Color.fromRGBO(46, 46, 46, 1),
          child: const Icon(Icons.add),
        ));
  }
}

class _TaskWidgetListBody extends StatelessWidget {
  const _TaskWidgetListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countItems =
        TaskListModelProvider.of(context)?.notifier?.tasks.length ?? 0;
    return ListView.separated(
        itemCount: countItems,
        itemBuilder: (BuildContext context, int index) {
          return _TaskWidgetRow(
            indexInList: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 15,
          );
        });
  }
}

class _TaskWidgetRow extends StatelessWidget {
  final int indexInList;
  const _TaskWidgetRow({Key? key, required this.indexInList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskListModelProvider.of(context)?.notifier;
    final task =
        model?.tasks[indexInList] ?? Task(description: '1', isDone: false);
    final iconStatus = model?.tasks[indexInList].isDone == true
        ? const Icon(Icons.done)
        : null;
    return Slidable(
      key: ValueKey(indexInList),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) => model?.deleteTask(indexInList),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Revome',
          ),
          const SlidableAction(
            onPressed: null,
            backgroundColor: Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Material(
        child: InkWell(
          onDoubleTap: () => model?.toggleStatus(indexInList),
          child: ColoredBox(
            color: const Color.fromRGBO(46, 46, 46, 1),
            child: ListTile(
                onTap: () => model?.redirectToForm(context),
                trailing: iconStatus,
                iconColor: const Color.fromRGBO(132, 132, 132, 0.50),
                title: Text(task.description,
                    style: const TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }
}
