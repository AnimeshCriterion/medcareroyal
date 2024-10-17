


import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/constant/constant.dart';



class CustomInkWell extends StatelessWidget {

  final Widget child;
  final Function onTap;
  final double? radius;
  final EdgeInsets? padding;
  final Color? color;

  const CustomInkWell({Key? key, required this.onTap,
    required this.child,
    this.radius,
    this.padding,
    this.color,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Material(
      color: color??Colors.transparent,
      borderRadius:  BorderRadius.all(Radius.circular(radius??Constant.globalRadius)),
      child: InkWell(

        customBorder:  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius??Constant.globalRadius)),
        ),
        onTap: (){
          onTap();
        },
        child: Padding(
          padding: padding??const EdgeInsets.fromLTRB(4,4,4,4),
          child: child,
        ),
      ),
    );
  }
}
