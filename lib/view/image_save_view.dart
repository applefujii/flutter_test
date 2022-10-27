import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_project/utility/image_io.dart';

class ImageSaveView extends StatelessWidget {
  const ImageSaveView({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemoApp',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const ImageLoadWidget(title: 'ImageSave'),
    );
  }
}

class ImageLoadWidget extends StatefulWidget {
  const ImageLoadWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ImageLoadWidget> createState() => _ImageLoadWidgetState();
}

class _ImageLoadWidgetState extends State<ImageLoadWidget> {

  final ImageIO imageIO = ImageIO();
  File? image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          child: image == null ?
          const Text('画像がありません')
              : Image.file(image!, fit: BoxFit.cover),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          image = await imageIO.pickImage();
          setState(() => {});
          await imageIO.saveImage(image!, "1");
        },
        tooltip: 'pick image',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
