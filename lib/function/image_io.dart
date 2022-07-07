import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageIO {

  final ImagePicker picker = ImagePicker();

  Future<File?> pickImage() async {
    File? image;
    final XFile? _image = await picker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      image = File(_image.path);
    }
    return image;
  }

  Future<void> saveImage(File image) async {
    String path = (await getApplicationDocumentsDirectory()).path + '/';
    String fileName = '1.jpg';
    print(path + fileName);
    image.copy(path + fileName);
  }

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