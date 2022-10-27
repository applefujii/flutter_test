import 'package:flutter/material.dart';
import 'package:flutter_project/component/image_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_project/view_model/memories_image_list_view_model.dart';
import 'package:flutter_project/view/memories_image_add_view.dart';

/*
* MVVMモデルを使用
*/
class MemoriesImageListView extends StatelessWidget {
  const MemoriesImageListView({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemoApp',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MemoriesImageListWidget(title: 'MemoApp'),
    );
  }
}

// extends StatefulWidget ではなく ConsumerWidget
class MemoriesImageListWidget extends ConsumerWidget {
  MemoriesImageListWidget({Key? key, required this.title}) : super(key: key);

  final String title;
  final GlobalKey shareKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModelクラス
    final _viewModel = ref.watch(memoriesImageListModelProvider);
    print(_viewModel.lMemoriesImage.length);

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
      body: Container(
        width: double.infinity,
        // これで囲むと画面外も画像化できる
        child: SingleChildScrollView(
          primary: true,
          padding: const EdgeInsets.only(bottom: 82),
          // RepaintBoundary以下が画像化される
          child: RepaintBoundary(
            key: shareKey,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
              itemCount: _viewModel.lMemoriesImage.length,
              primary: false,
              // これを指定しないと縦の大きさが無限大になってしまう
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // TODO: 長押しで選択する
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => MemoViewView(memoId: _viewModel.lMemo[index].id ?? 0)),
                  //   ).then((value) {
                  //     _viewModel.loadMemos();
                  //   });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(
                          color: Colors.black,
                          width: 1,
                      ),
                    ),
                    child: ImagePopup(
                        image:_viewModel.lImage[index],
                        text:_viewModel.lMemoriesImage[index].text
                    ),
                    // Text(
                    //   _viewModel.lMemoriesImage[index].text,
                    //   style: const TextStyle(
                    //     fontSize: 20,
                    //   ),
                    // ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MemoriesImageAddView()),
          ).then((value) async {
            await _viewModel.loadMemoriesImages();
          });
        },
        tooltip: 'Add memo',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
