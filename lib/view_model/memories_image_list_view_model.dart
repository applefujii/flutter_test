import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_project/model/memories_image.dart';
import 'package:flutter_project/utility/image_io.dart';


// ViewModelの実体
final memoriesImageListModelProvider = ChangeNotifierProvider((ref) => MemoriesImageListViewModel());

// ViewModelは ChangeNotifierを継承
class MemoriesImageListViewModel extends ChangeNotifier {

  final ImageIO imageIO = ImageIO();

  List<MemoriesImage> _lMemoriesImage = [];
  List<File?> _lImage = [];
  bool _isLoading = false;

  // TODO:長押しで(複数)選択 → 削除

  MemoriesImageListViewModel() {
    loadMemoriesImages();
  }

  /// MemoriesImageを全て読み込む
  Future<void> loadMemoriesImages() async {
    _isLoading = true;
    notifyListeners();
    _lMemoriesImage = await MemoriesImage.getAll();
    _lImage.clear();
    _lMemoriesImage.forEach( (item) async {
      _lImage.add(await imageIO.loadImage(item.fileName));
    });
    _isLoading = false;
    // これを呼ぶとviewが更新される
    notifyListeners();
  }

  /// スクリーンショットを撮ってシェア
  void shareScreenShot(GlobalKey shareKey) {
    imageIO.shareImageAndText("share", shareKey);
  }

  //------------------- getter -------------------------
  List<MemoriesImage> get lMemoriesImage => _lMemoriesImage;
  List<File?> get lImage => _lImage;
  bool get isLoading => _isLoading;

}
