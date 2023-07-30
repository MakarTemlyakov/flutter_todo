import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/groups_form_widget/goup_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({Key? key}) : super(key: key);

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupFormModelProvider(
        model: _model, child: const _GroupFormWidgetBody());
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = GroupFormModelProvider.watch(context)?.model;
    var error = model?.errorMessage;
    return Scaffold(
      appBar: AppBar(title: const Text('Форма добавления')),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter name group',
                  errorText: error),
              onEditingComplete: () => model?.save(context),
              onChanged: (value) => model?.groupName = value,
            ),
            const SizedBox(height: 20),
            TextButton(
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 15)),
                  backgroundColor:
                      MaterialStatePropertyAll(Color.fromRGBO(46, 46, 46, 1))),
              onPressed: () => model?.save(context),
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
