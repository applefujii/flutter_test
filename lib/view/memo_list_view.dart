import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_project/view/memo_view_view.dart';
import 'package:flutter_project/view/memo_add_view.dart';
import 'package:flutter_project/view_model/memo_list_view_model.dart';

/*
* MVVMモデルを使用
*/
class MemoListView extends StatelessWidget {
  const MemoListView({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemoApp',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MemoListWidget(title: 'MemoApp'),
    );
  }
}

// extends StatefulWidget ではなく ConsumerWidget
class MemoListWidget extends ConsumerWidget {
  MemoListWidget({Key? key, required this.title}) : super(key: key);

  final String title;
  final GlobalKey shareKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModelクラス
    final _viewModel = ref.watch(memoListModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _viewModel.shareScreenShot(shareKey)
          )
        ],
      ),
      body: Center(
          child: Container(
            width: double.infinity,
            // これで囲むと画面外も画像化できる
            child: SingleChildScrollView(
              primary: true,
              padding: const EdgeInsets.only(bottom: 82),
              // RepaintBoundary以下が画像化される
              child: RepaintBoundary(
                key: shareKey,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                  itemCount: _viewModel.lMemo.length,
                  primary: false,
                  // これを指定しないと縦の大きさが無限大になってしまう
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MemoViewView(memoId: _viewModel.lMemo[index].id ?? 0)),
                        ).then((value) {
                          _viewModel.loadMemos();
                        });
                      },
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.centerLeft,
                        color: Colors.greenAccent,
                        child: Text(
                          _viewModel.lMemo[index].title,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MemoAddView()),
          ).then((value) {
            _viewModel.loadMemos();
          });
        },
        tooltip: 'Add memo',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
