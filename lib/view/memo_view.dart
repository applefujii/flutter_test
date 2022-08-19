import 'package:flutter/material.dart';

import 'package:flutter_project/model/memo.dart';

class MemoViewView extends StatefulWidget {
  const MemoViewView({Key? key, required this.memoId}) : super(key: key);

  final int memoId;

  @override
  State<StatefulWidget> createState() => _MemoViewViewState(memoId);
}

class _MemoViewViewState extends State<MemoViewView> {
  _MemoViewViewState(this.memoId);

  final int memoId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Memo memo = Memo(id:0, title: "", text: "");


  @override
  void initState() {
    super.initState();
    loadMemo(memoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemoApp"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("タイトル"),
                Text(memo.title),
                const Text("本文"),
                Text(memo.text),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      deleteMemo(memo.id ?? -1);
                      Navigator.pop(context);
                    },
                    child: const Text('削除'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> loadMemo(int id) async {
    memo = await Memo.getMemo(id);
    setState(() {});
  }

  Future<void> deleteMemo(int id) async {
    await Memo.deleteMemo(id);
  }

}
