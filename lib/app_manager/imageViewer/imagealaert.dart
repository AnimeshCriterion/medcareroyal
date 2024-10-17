import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photo_view/photo_view.dart';

class ImageAlertDialog extends StatelessWidget {
  final String imageUrl;

  const ImageAlertDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  PhotoView(
        imageProvider: AssetImage(imageUrl.toString()),
      )
    );
  }
}