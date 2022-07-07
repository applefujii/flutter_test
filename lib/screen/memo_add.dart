import 'package:flutter/material.dart';

import 'package:flutter_project/model/memo.dart';

class MemoAddScreen extends StatelessWidget {
  // const SecondScreen({Key? key}) : super(key: key);
  const MemoAddScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemoApp"),
      ),
      body: const MemoFormWidget(),
    );
  }
}

class MemoFormWidget extends StatefulWidget {
  const MemoFormWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MemoFormWidgetState();
}

class _MemoFormWidgetState extends State<MemoFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String title, text;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("タイトル"),
          TextFormField(
            decoration: const InputDecoration(
              hintText: '',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (text) {
              title = text;
            },
            autofocus: true,
          ),
          const Text("本文"),
          TextFormField(
            decoration: const InputDecoration(
              hintText: '',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (text) {
              this.text = text;
            },
            maxLines: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                insertMemo();
                Navigator.pop(context);
                if (_formKey.currentState!.validate()) {
                  // Process data.
                }
              },
              child: const Text('登録'),
            ),
          ),
        ],
      ),
    );
  }



  Future<void> insertMemo() async {
    Memo memo = Memo(title:title, text:text);
    await Memo.insertMemo(memo);
  }

}
