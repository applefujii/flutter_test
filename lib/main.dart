import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter_project/view/memo_list.dart';
import 'package:flutter_project/view/second_screen.dart';
import 'package:flutter_project/view/image_save.dart';
import 'package:flutter_project/view/image_load.dart';

void main() {
  sqfliteFfiInit();
  // runApp(const MyApp());
  runApp(ProviderScope(child: const MyApp()));
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'お気に入り'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'お知らせ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
        ],
        type: BottomNavigationBarType.fixed,
      ));
  }
}
