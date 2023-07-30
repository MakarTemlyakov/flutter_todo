import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/ui/widgets/groups/groups_widget_model.dart';

class GroupsWidgetList extends StatefulWidget {
  const GroupsWidgetList({Key? key}) : super(key: key);

  @override
  State<GroupsWidgetList> createState() => _GroupsWidgetListState();
}

class _GroupsWidgetListState extends State<GroupsWidgetList> {
  final GroupsWidgetModel model = GroupsWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupsWidgetProvider(
      model: model,
      child: GroupsWidget(),
    );
  }

  @override
  void dispose() async {
    await model.dispose();
    super.dispose();
  }
}

class GroupsWidget extends StatelessWidget {
  GroupsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetProvider.read(context)?.model;
    return Scaffold(
        appBar: AppBar(
            title: Text('Группы'),
            backgroundColor: Color.fromRGBO(36, 36, 36, 1)),
        backgroundColor: Color.fromRGBO(36, 36, 36, 1),
        body: _GroupsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => model?.addGroup(context),
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(46, 46, 46, 1),
        ));
  }
}

class _GroupsList extends StatelessWidget {
  const _GroupsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemslength =
        GroupsWidgetProvider.watch(context)?.model.groups.length ?? 0;
    return ListView.separated(
        itemCount: itemslength,
        itemBuilder: (BuildContext context, int index) {
          return _GroupRowListWidget(
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

class _GroupRowListWidget extends StatelessWidget {
  final int indexInList;
  _GroupRowListWidget({Key? key, required this.indexInList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetProvider.watch(context)?.model;
    return Slidable(
      key: ValueKey(indexInList),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model!.remove(indexInList),
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
          onTap: () => GroupsWidgetProvider.read(context)
              ?.model
              .showTasks(context, indexInList),
          child: ColoredBox(
            color: Color.fromRGBO(46, 46, 46, 1),
            child: ListTile(
                trailing: Icon(Icons.chevron_right),
                iconColor: Color.fromRGBO(132, 132, 132, 0.50),
                title: Text(model!.groups[indexInList].name,
                    style: TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }
}
