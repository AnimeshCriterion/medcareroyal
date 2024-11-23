import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:get/get.dart';
import '../../medcare_utill.dart';
import '../app_color.dart';

class MyImageView extends StatefulWidget {
  final String url;
  final bool? isFilePath;
  final String? filePathImg;

  const MyImageView(
      {Key? key, required this.url, this.isFilePath, this.filePathImg})
      : super(key: key);

  @override
  _MyImageViewState createState() => _MyImageViewState();
}

class _MyImageViewState extends State<MyImageView> {
  @override
  void initState() {
    dPrint(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            widget.isFilePath == true
                ? Image.file(File(widget.filePathImg.toString()))
                : InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(20.0),
                    minScale: 0.1,
                    maxScale: 1.6,
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                        color: Colors.orange,
                      )),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/noProfileImage.png'),
                    ),
                  ),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () {
                               Get.back();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_outlined,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {

          },
          child: const Icon(Icons.download_rounded, size: 30),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
//
// import 'app_color.dart';
//
// class MyImageView extends StatefulWidget {
//
//   final String tag;
//   final String file;
//
//   const MyImageView({ Key? key, required this.tag, required this.file}) : super(key: key);
//
//
//   @override
//   MyImageViewState createState() => MyImageViewState();
// }
//
// class _MyImageViewState extends State<MyImageView> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColor.primaryColor,
//       child: SafeArea(
//         child: Material(
//           child: Stack(
//             children: [
//               Container(
//                   child: Hero(
//                     tag: widget.tag,
//                     child: PhotoView(
//                       imageProvider: NetworkImage(widget.file.toString()),
//                     ),
//                   )
//               ),
//               IconButton(icon: Icon(Icons.arrow_back,
//                 color: Colors.white,), onPressed: (){
//                  Get.back();
//               })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
