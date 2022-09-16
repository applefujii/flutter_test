import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_project/model/memo.dart';
import 'package:flutter_project/utility/image_io.dart';


// ViewModelの実体
final memoListModelProvider = ChangeNotifierProvider((ref) => MemoListViewModel());

// ViewModelは ChangeNotifierを継承
class MemoListViewModel extends ChangeNotifier {

  final ImageIO imageIO = ImageIO();

  List<Memo> _lMemo = [];
  bool _isLoading = false;

  MemoListViewModel() {
    loadMemos();
  }

  /// メモを全て読み込む
  Future<void> loadMemos() async {
    _isLoading = true;
    notifyListeners();
    _lMemo = await Memo.getMemos();
    _isLoading = false;
    // これを呼ぶとviewが更新される
    notifyListeners();
  }

  /// スクリーンショットを撮ってシェア
  void shareScreenShot(GlobalKey shareKey) {
    imageIO.shareImageAndText("share", shareKey);
  }

  //------------------- getter -------------------------
  List<Memo> get lMemo => _lMemo;
  bool get isLoading => _isLoading;

}
