import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/*
  画像のセーブ、ロード
 */
class ImageIO {

  final ImagePicker picker = ImagePicker();

  /*
    画像をアルバムから選択する
   */
  Future<File?> pickImage() async {
    File? image;
    final XFile? _image = await picker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      image = File(_image.path);
    }
    return image;
  }

  /*
    画像をアプリの保存領域に保存する
   */
  Future<void> saveImage(File image) async {
    String path = (await getApplicationDocumentsDirectory()).path + '/';
    String fileName = '1.jpg';
    print(path + fileName);
    image.copy(path + fileName);
  }

  /*
    画像をアプリの保存領域から読み込む
   */
  Future<File?> loadImage() async {
    String path = (await getApplicationDocumentsDirectory()).path + '/';
    String fileName = '1.jpg';
    print(path + fileName);
    File image = await File(path + fileName);
    print(image.exists());
    if(image.exists() == false) return null;
    return File(path + fileName);
  }

}