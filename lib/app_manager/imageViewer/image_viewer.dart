import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/imageViewer/image_view.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/custom_ink_well.dart';



class ImageViewer extends StatelessWidget {

  final String url;
  final Widget child;

  const ImageViewer({Key? key,

  required this.url,
  required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
        padding: const EdgeInsets.all(2),
        onTap: (){

      MyNavigator.push(context, ImageView(
        url: url
      ));
    }, child: child);
  }
}
