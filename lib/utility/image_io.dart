import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

/*
  画像のセーブ、ロード
 */
class ImageIO {

  final ImagePicker picker = ImagePicker();

  /// 画像をアルバムから選択する
  Future<File?> pickImage() async {
    File? image;
    final XFile? _image = await picker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      image = File(_image.path);
    }
    return image;
  }

  /// 画像をリサイズ、Jpeg形式に変換してアプリの保存領域に保存する
  Future<void> saveImage(File image) async {
    // 制限サイズ
    const maxSize = 3840;

    // imgLib.Image img = imgLib.decodeImage(File(image.path).readAsBytesSync())!;

    // flutter_image_compressで指定サイズ／品質のjpegに圧縮
    Uint8List? result = await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      minWidth: maxSize,
      minHeight: maxSize,
      quality: 100,
      format: CompressFormat.jpeg,
    );

    String path = (await getApplicationDocumentsDirectory()).path + '/';
    String fileName = '1.jpg';
    print(path + fileName);

    // 保存
    File(path + fileName).writeAsBytesSync(result!);
  }

  /// 画像をアプリの保存領域から読み込む
  Future<File?> loadImage() async {
    String path = (await getApplicationDocumentsDirectory()).path + '/';
    String fileName = '1.jpg';
    print(path + fileName);
    File image = await File(path + fileName);
    print(image.exists());
    if(image.exists() == false) return null;
    return File(path + fileName);
  }


  /// グローバルキーの部分を画像(byteData)にする
  Future<ByteData> _exportGlobalKeyToImage(GlobalKey globalKey) async {
    final boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(
      pixelRatio: 1,
    );
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!;
  }

  /// ファイルに保存
  Future<File> _getApplicationDocumentsFile(String text, List<int> imageData) async {
    final directory = await getTemporaryDirectory();

    final exportFile = File('${directory.path}/$text.png');
    if (!await exportFile.exists()) {
      await exportFile.create(recursive: true);
    }
    final file = await exportFile.writeAsBytes(imageData);
    return file;
  }

  /// グローバルキーの部分を画像にしてシェア
  void shareImageAndText(String text, GlobalKey globalKey) async {
    try {
      final bytes = await _exportGlobalKeyToImage(globalKey);
      //byte data→Uint8List
      final widgetImageBytes =
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      //App directoryファイルに保存
      final applicationDocumentsFile = await _getApplicationDocumentsFile(text, widgetImageBytes);

      final path = applicationDocumentsFile.path;
      print("保存完了 ${path}");
      await ShareExtend.share(path, "image");
      // applicationDocumentsFile.delete();
    } catch (error) {
      print(error);
    }
  }

}