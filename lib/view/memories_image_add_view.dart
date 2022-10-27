import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_project/model/memories_image.dart';
import 'package:flutter_project/utility/generate_random.dart';

import '../utility/image_io.dart';

class MemoriesImageAddView extends StatelessWidget {
  // const SecondScreen({Key? key}) : super(key: key);
  const MemoriesImageAddView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemoApp"),
      ),
      body: const MemoriesImageFormWidget(),
    );
  }
}

class MemoriesImageFormWidget extends StatefulWidget {
  const MemoriesImageFormWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MemoriesImageFormWidgetState();
}

class _MemoriesImageFormWidgetState extends State<MemoriesImageFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImageIO imageIO = ImageIO();

  late String text;
  File? image;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("説明文"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: '',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length > 140) {
                  return 'text longer';
                }
                return null;
              },
              onChanged: (text) {
                this.text = text;
              },
              maxLines: 10,
            ),
            // 画像選択ボタン
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black12, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () async {
                image = await imageIO.pickImage();
                setState( (){} );
              },
              child: const Text('画像選択'),
            ),
            SizedBox(
              width: 96,
              height: 96,
              child: image == null ?
              const Text('')
                  : Image.file(image!, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if(image == null) return;
                  await insertMemoriesImage();
                  Navigator.pop(context);
                  if (_formKey.currentState!.validate()) {
                    // Process data.
                  }
                },
                child: const Text('登録'),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> insertMemoriesImage() async {
    String fileName = GenerateRandom.generateString();
    fileName = await imageIO.saveImage(image!, fileName);
    fileName = fileName.split("/").last;
    MemoriesImage memoriesImage = MemoriesImage(fileName:fileName, text:text);
    await MemoriesImage.insert(memoriesImage);
  }

}
