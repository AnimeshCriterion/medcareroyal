



import 'package:flutter/material.dart';

import 'app_color.dart';
import 'constant/constant.dart';


class ShadowContainer extends StatelessWidget {

  final Widget? child;
  final Color? color;
  final Color? gradientColor;
  final EdgeInsets? padding;
  final DecorationImage? decorationImage;
  final double? height;
  final double? width;
  final BoxShape? shape;
  final double? radius;
  final double? blurRadius;


  const ShadowContainer({Key? key, this.child,
  this.color,
  this.gradientColor,
  this.padding,
  this.decorationImage,
  this.height,
  this.width,
  this.shape,
  this.radius,
  this.blurRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColor.primaryColorLight,
            borderRadius:shape!=null? null:  BorderRadius.only(
              topLeft: Radius.circular(radius??3),
              topRight: Radius.circular(radius??3),

            ),
          ),
          height: 2,

        ),
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            shape: shape??BoxShape.rectangle,

              boxShadow: [
                BoxShadow(
                  color: AppColor.grey,
                  spreadRadius: 0.8,
                  blurRadius: blurRadius?? 2,
                  offset: const Offset(0, 0),
                ),
              ],
            borderRadius:shape!=null? null:  BorderRadius.only(
              bottomRight: Radius.circular(radius??3),
              bottomLeft: Radius.circular(radius??3),

            ),

          ),
          child: Container(
              decoration:  BoxDecoration(
                  shape: shape??BoxShape.rectangle,
                  gradient: gradientColor==null?null:
                  Constant.getGradient(gradientColor),
                  image: decorationImage,
                color: color??Colors.white,
                borderRadius:shape!=null? null:  BorderRadius.only(
                  bottomRight: Radius.circular(radius??3),
                  bottomLeft: Radius.circular(radius??3),

                ),
              ),
              child: Padding(
                padding: padding??const EdgeInsets.all(8.0),
                child: child,
              )),
        ),
      ],
    );
  }
}
