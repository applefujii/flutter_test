import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter_project/view/memo_list_view.dart';
import 'package:flutter_project/view/second_screen_view.dart';
import 'package:flutter_project/view/image_save_view.dart';
import 'package:flutter_project/view/image_load_view.dart';

void main() {
  sqfliteFfiInit();
  // runApp(const MyApp());
  // MVVMモデル使用時はこちらを使う
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //-- ボトムナビゲーションバーで遷移する画面のクラス
  static const _screens = [
    MemoListView(),
    SecondScreenView(),
    ImageSaveView(),
    ImageLoadView(),
  ];

  //-- 選択された画面番号
  int _selectedIndex = 0;

  //-- 選択された画面番号を代入する （ボトムナビゲーションがタップされたとき
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // メイン画面
      body: _screens[_selectedIndex],
      //-- ボトムナビゲーションバー
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'メモ'),
          BottomNavigationBarItem(icon: Icon(Icons.exposure_plus_1), label: 'カウンター'),
          BottomNavigationBarItem(icon: Icon(Icons.file_upload), label: '画像保存'),
          BottomNavigationBarItem(icon: Icon(Icons.file_download), label: '画像読み込み'),
        ],
        type: BottomNavigationBarType.fixed,
      ));
  }
}
