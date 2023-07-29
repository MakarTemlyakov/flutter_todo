import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/domain/Task.dart';
import 'package:todo_list/widgets/tasks/task/task_widget_list_model.dart';

class TaskWidgetScreen extends StatefulWidget {
  const TaskWidgetScreen({super.key});

  @override
  State<TaskWidgetScreen> createState() => _TaskWidgetScreenState();
}

class _TaskWidgetScreenState extends State<TaskWidgetScreen> {
  TaskListModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TaskListModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskListModelProvider(model: _model!, child: TaskWidgetList());
  }
}

class TaskWidgetList extends StatelessWidget {
  TaskWidgetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskListModelProvider.of(context)?.notifier;

    final groupName = model?.group?.name ?? 'Задачи';
    return Scaffold(
        appBar: AppBar(
            title: Text(groupName),
            backgroundColor: Color.fromRGBO(36, 36, 36, 1)),
        backgroundColor: Color.fromRGBO(36, 36, 36, 1),
        body: _TaskWidgetListBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => model?.redirectToForm(context),
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(46, 46, 46, 1),
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
          return Divider(
            height: 15,
          );
        });
  }
}

class _TaskWidgetRow extends StatelessWidget {
  final int indexInList;
  _TaskWidgetRow({Key? key, required this.indexInList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskListModelProvider.of(context)?.notifier;
    final task =
        model?.tasks[indexInList] ?? Task(description: '1', isDone: false);
    return Slidable(
      key: ValueKey(indexInList),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: null,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Revome',
          ),
          SlidableAction(
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
          child: ColoredBox(
            color: Color.fromRGBO(46, 46, 46, 1),
            child: ListTile(
                onTap: () => Navigator.pushNamed(context, '/groups/tasks/form'),
                trailing: Icon(Icons.chevron_right),
                iconColor: Color.fromRGBO(132, 132, 132, 0.50),
                title: Text(task.description,
                    style: TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }
}
