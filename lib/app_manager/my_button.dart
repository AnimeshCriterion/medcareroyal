

import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'app_color.dart';


class MyButton extends StatelessWidget {
  final String title;
  final double? height;
  final double? elevation;
  final double? width;
  final Function? onPress;
  final Color? color;
  final bool? animate;
  final TextStyle? textStyle;
  final Widget? suffixIcon;
  final double? buttonRadius;

  const MyButton({Key? key, required this.title, this.onPress,
    this.color,
    this.height,
    this.textStyle,
    this.elevation,
    this.animate,
    this.suffixIcon,
    this.width,
    this.buttonRadius,  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width:  MediaQuery.of(context).size.width>600?  600: width,
      height: height?? 40,
      child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black, shadowColor: AppColor.primaryColor,
            elevation: elevation??0,
            backgroundColor: color??AppColor.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius:buttonRadius==null? BorderRadius.circular( 5.0):BorderRadius.circular(buttonRadius!),
            ),
          ),
          onPressed: (){
            onPress!();
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      suffixIcon?? Container(),
                      Visibility(
                          visible: suffixIcon!=null,
                          child: const SizedBox(width: 2,)),

                      Text(title,
                          textAlign: TextAlign.center,
                          style: textStyle?? MyTextTheme.mediumWCB),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}



