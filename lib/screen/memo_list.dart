import 'package:flutter/material.dart';

import 'package:flutter_project/model/memo.dart';
import 'package:flutter_project/screen/memo_view.dart';
import 'package:flutter_project/screen/memo_add.dart';

import '../function/image_io.dart';

class MemoListScreen extends StatelessWidget {
  const MemoListScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemoApp',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MemoListWidget(title: 'MemoApp'),
    );
  }
}

class MemoListWidget extends StatefulWidget {
  const MemoListWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MemoListWidget> createState() => _MemoListWidgetState();
}

class _MemoListWidgetState extends State<MemoListWidget> {

  final ImageIO imageIO = ImageIO();

  List<Memo> lMemo = [];
  bool isLoading = false;

  final GlobalKey shareKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadMemos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => imageIO.shareImageAndText("share", shareKey)
          )
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            primary: true,
            padding: const EdgeInsets.only(bottom: 82),
            child: RepaintBoundary(
              key: shareKey,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                itemCount: lMemo.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MemoViewScreen(memoId: lMemo[index].id ?? 0)),
                      ).then((value) {
                        loadMemos();
                      });
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerLeft,
                      color: Colors.greenAccent,
                      child: Text(
                          lMemo[index].title,
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
            MaterialPageRoute(builder: (context) => MemoAddScreen()),
          ).then((value) {
            loadMemos();
          });
        },
        tooltip: 'Add memo',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  Future<void> loadMemos() async {
    setState(() => isLoading = true);
    lMemo = await Memo.getMemos();
    setState(() => isLoading = false);
  }

}
