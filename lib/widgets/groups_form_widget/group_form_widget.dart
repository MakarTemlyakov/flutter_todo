import 'package:flutter/material.dart';
import 'package:todo_list/widgets/groups_form_widget/goup_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({Key? key}) : super(key: key);

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupFormModelProvider(model: _model, child: _GroupFormWidgetBody());
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  _GroupFormWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = GroupFormModelProvider.read(context)?.model;
    return Scaffold(
      appBar: AppBar(title: Text('Форма добавления')),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter name group'),
              onEditingComplete: () => model?.save(context),
              onChanged: (value) => model?.groupName = value,
            ),
            SizedBox(height: 20),
            TextButton(
              style: ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 15)),
                  backgroundColor:
                      MaterialStatePropertyAll(Color.fromRGBO(46, 46, 46, 1))),
              onPressed: () => model?.save(context),
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
