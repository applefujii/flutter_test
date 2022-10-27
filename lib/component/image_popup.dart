import 'package:flutter/material.dart';
import 'dart:io';

class ImagePopup extends StatefulWidget {
  const ImagePopup({Key? key, required this.image, this.text}) : super(key: key);

  final File? image;
  final String? text;

  @override
  State<ImagePopup> createState() => _ImagePopupState(image, text);
}

class _ImagePopupState extends State<ImagePopup> {
  _ImagePopupState(this.image, this.text);

  final File? image;
  final String? text;

  bool _isInfoVisible = false;

  @override
  Widget build(BuildContext context) {
    if(image == null ) {
      return Container();
    }
    return GestureDetector(
      child: Image.file(image!, fit: BoxFit.cover),
      onTap: () {
        setState( (){ _isInfoVisible = true; } );
        showGeneralDialog(
          transitionDuration: const Duration(milliseconds: 1000),
          barrierDismissible: true,
          barrierColor: const Color(0xAA000000),
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return DefaultTextStyle(
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyText1!,
                  child: SafeArea(
                    child: Center(
                      child: Material(
                        color: const Color(0x00000000),
                        child: Stack(
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: GestureDetector(
                                child: InteractiveViewer(
                                  minScale: 0.1,
                                  maxScale: 5,
                                  child: Image.file(image!),
                                ),
                                onTap: () {
                                  setState( (){ _isInfoVisible = !_isInfoVisible; } );
                                },
                              ),
                            ),
                            Visibility(
                              visible: _isInfoVisible,
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 128,
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color(0xDD99AA99),
                                  child: Text(
                                    text ?? "説明文なし。",
                                    style: const TextStyle(color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _isInfoVisible,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xAAFFFFFF),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                          ]
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}