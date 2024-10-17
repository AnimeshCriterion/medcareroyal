


import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';

import '../../../common_libs.dart';
import '../../../theme/theme.dart';
import '../../app_color.dart';
import '../../constant/constant.dart';




// class PrimaryButton extends StatelessWidget {
//
//   final Function onPressed;
//   final String title;
//   final EdgeInsetsGeometry? padding;
//   final Color? color;
//   final Color? borderColor;
//   final bool expanded;
//   final double? width;
//   final double? elevation;
//   final Widget? icon;
//   final Color? titleColor;
//   final TextStyle? textStyle;
//   final double? borderRadius;
//
//   const PrimaryButton({Key? key,
//     required this.onPressed,
//     required this.title,
//     this.padding,
//     this.color,
//     this.borderColor,
//     this.expanded=true,
//     this.width,
//     this.elevation,
//     this.icon,
//     this.titleColor,
//     this.textStyle,
//     this.borderRadius,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 35,
//      width: width?? (expanded?double.infinity:width),
//       child: TextButton(
//         style: TextButton.styleFrom(
//           elevation: elevation??5,
//             shape:  RoundedRectangleBorder(
//                 borderRadius:  BorderRadius.all(Radius.circular(borderRadius??Constant.globalRadius)),
//                 side: BorderSide(color: borderColor??color??AppColor.primaryColorLight)
//             ),
//             padding: padding??  const EdgeInsets.all(0),
//           backgroundColor: color??AppColor.primaryColor,
//           shadowColor: AppColor.grey,
//
//         ),onPressed: (){
//         onPressed();
//
//       },child: Wrap(
//         crossAxisAlignment: WrapCrossAlignment.center,
//           alignment: WrapAlignment.center,
//         children: [
//           icon==null?Container():Padding(
//             padding: const EdgeInsets.fromLTRB(0,0,5,0,),
//             child: icon,
//           ),
//           Text(title,
//           style: textStyle??   TextStyle(
//             color: AppColor.white,
//             fontSize: 14
//           )),
//         ],
//       )),
//     );
//   }
// }

class PrimaryButton extends StatelessWidget {

  final Function onPressed;
  final String title;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final bool expanded;
  final double? width;
  final double? elevation;
  final Widget? icon;
  final Color? titleColor;
  final TextStyle? textStyle;
  final double? borderRadius;

  const PrimaryButton({Key? key,
    required this.onPressed,
    required this.title,
    this.padding,
    this.color,
    this.borderColor,
    this.expanded=true,
    this.width,
    this.elevation,
    this.icon,
    this.titleColor,
    this.textStyle,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    return InkWell(
      onTap: (){
        onPressed();
      },
      child: SizedBox(
        height: 35,
       width: width?? (expanded?double.infinity:width),
        child: customContainerButton2( borderRadius??15.0, outerHeight: 35.0, outerWidth: double.infinity, theme: themeChange.darkTheme, borderRadius: borderRadius,
        child: Text(title,style: MyTextTheme.largeWCN.copyWith(           color:themeChange.darkTheme==false?Colors.white:Colors.black,)),
        ),
      ),
    );
  }
}

customContainerButton2(context,
    {required borderRadius,required outerHeight,required outerWidth,  child, required bool theme, Color? color}){
  return Consumer<ThemeProviderLd>(
      builder:  (BuildContext context, value,_) {
        return Container(alignment: Alignment.center,
            decoration: BoxDecoration(
              color:theme?Colors.white:Colors.black,
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(borderRadius??15.0),
            ),
            height: outerHeight??35.0,
            width: outerWidth??double.infinity,
            child: Center(
              child: child,
            )
        );
      }
  );


}
