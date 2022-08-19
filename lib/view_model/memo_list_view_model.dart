import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_project/model/memo.dart';
import 'package:flutter_project/utility/image_io.dart';


final memoListModelProvider = ChangeNotifierProvider((ref) => MemoListViewModel());

class MemoListViewModel extends ChangeNotifier {

  final ImageIO imageIO = ImageIO();

  List<Memo> _lMemo = [];
  bool _isLoading = false;

  MemoListViewModel() {
    loadMemos();
    notifyListeners();
  }

  Future<void> loadMemos() async {
    _isLoading = true;
    notifyListeners();
    _lMemo = await Memo.getMemos();
    _isLoading = false;
    notifyListeners();
  }

  void shareScreenShot(GlobalKey shareKey) {
    imageIO.shareImageAndText("share", shareKey);
  }

  List<Memo> get lMemo => _lMemo;
  bool get isLoading => _isLoading;

}
