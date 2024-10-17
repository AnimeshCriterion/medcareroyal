
import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'hex.dart';

import '../../theme/style.dart';



// class NeoButton extends StatefulWidget {
//
//   final String title;
//   final Function func;
//   final double? height;
//   final double? width;
//   final Color? color;
//   final TextStyle? textStyle;
//
//   const NeoButton({super.key, required this.title, required this.func, this.height, this.width, this.color, this.textStyle});
//
//   @override
//   State<NeoButton> createState() => _NeoButtonState();
// }
//
// class _NeoButtonState extends State<NeoButton> {
//
//   @override
//   Widget build(BuildContext context) {
//     final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
//     return  InkWell(
//         splashColor:Colors.transparent,
//         onTap: (){
//           widget.func();
//         },
//         child:customContainerButton(context,
//            borderRadius: BorderRadius.circular(30),
//            outerHeight: widget.height??60.0,
//            outerWidth: double.infinity,
//           child:Center(child: Text(widget.title,
//             style:widget.textStyle?? MyTextTheme.mediumBCN.copyWith(color:widget.color?? AppColor.greyDark,fontSize: 18),textAlign: TextAlign.center,)),)
//     );
//   }
// }
//



class NeoButton extends StatefulWidget {

  final String title;
  final Function func;
  final double? height;
  final double? width;
  final Color? color;
  final TextStyle? textStyle;

  const NeoButton({super.key, required this.title, required this.func, this.height, this.width, this.color, this.textStyle});

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return  InkWell(
        splashColor:Colors.transparent,
        onTap: (){
          widget.func();
        },
        child:
        customContainerButton2(context,
          borderRadius: BorderRadius.circular(30),
          outerHeight: widget.height??46.0,
          outerWidth: double.infinity,
          child:Center(child: Text(widget.title,
            style:widget.textStyle?? MyTextTheme.mediumBCN.copyWith(color:(themeChange.darkTheme?Colors.black:Colors.white), ),textAlign: TextAlign.center,)),theme:themeChange.darkTheme)
    );
  }
}



// class NeoConcaveButton extends StatefulWidget {
//
//   final String title;
//   final Function func;
//   final double? height;
//   final double? width;
//
//   const NeoConcaveButton({super.key, required this.title, required this.func, this.height, this.width});
//
//   @override
//   State<NeoConcaveButton> createState() => _NeoConcaveButtonState();
// }
//
// class _NeoConcaveButtonState extends State<NeoConcaveButton> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
//     return  InkWell(
//         splashColor:Colors.transparent,
//         onTap: (){
//           widget.func();
//         },
//         child:Visibility(
//           visible: themeChange.darkTheme==true,
//           replacement:  ClayContainer(
//             parentColor:AppColor.grey,
//             color:Colors.grey.shade900,
//             surfaceColor:Colors.white38,
//             height: widget.height??60,
//             width: double.infinity,
//             borderRadius:30,
//             curveType: CurveType.concave,
//             spread: 15,
//             // emboss: true,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Center(
//                 child: ClayContainer(
//                   color:Colors.grey.shade300,
//                   parentColor:Colors.grey.shade200,
//                   spread: 3,
//                   depth: 50,
//                   // emboss: true,
//                   surfaceColor:Colors.white70,
//                   height:widget.height == null?45: widget.height!-15,
//                   width: widget.width == null ?370: widget.width!-15,
//                   borderRadius:30,
//                   curveType: CurveType.concave,
//                   // spread: 10,
//                   child: Center(child: Text(widget.title,style: TextStyle(color: AppColor.greydark12),)),
//                 ),
//               ),
//             ),
//           ),
//           child: ClayContainer(
//             parentColor:hexToColor('#303238'),
//             surfaceColor:Colors.black26,
//             height: widget.height??60,
//             width: double.infinity,
//             borderRadius:30,
//             curveType: CurveType.concave,
//             spread: 5,
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: ClayContainer(
//                   color:hexToColor('#303238'),
//                   surfaceColor:Colors.black26,
//                   parentColor:hexToColor('#303238'),
//                   height:widget.height == null?45: widget.height!-15,
//                   width: widget.width == null ?370: widget.width!-15,
//                   borderRadius:30,
//                   curveType: CurveType.convex,
//                   emboss: true,
//                   // spread: 10,
//                   child: Center(child: Text(widget.title,style: TextStyle(color: hexToColor('#1BD15D')),)),
//                 ),
//               ),
//             ),
//           ),
//         )
//
//
//     );
//   }
// }


// class NeoButton2 extends StatefulWidget {
//
//   final String title;
//   final Function func;
//   final double? height;
//   final double? width;
//
//   const NeoButton2({super.key, required this.title, required this.func, this.height, this.width});
//
//   @override
//   State<NeoButton2> createState() => _NeoButton2State();
// }
//
// class _NeoButton2State extends State<NeoButton2> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
//     return  InkWell(
//         splashColor:Colors.transparent,
//       radius: 30,
//         onTap: (){
//           widget.func();
//         },
//         child:Visibility(
//
//           visible: themeChange.darkTheme==true ,
//           replacement:  ClayContainer(
//             parentColor:AppColor.grey,
//             color:Colors.grey.shade900,
//             surfaceColor:Colors.white38,
//             height: widget.height??60,
//             width: double.infinity,
//             borderRadius:30,
//             curveType: CurveType.concave,
//             spread: 10,
//             // emboss: true,
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: ClayContainer(
//                   color:Colors.grey.shade900,
//                   parentColor:Colors.grey.shade300,
//                   spread: 4,
//                   // emboss: true,
//                   surfaceColor:Colors.white12,
//                   // height:widget.height == null?45: widget.height!-15,
//                   // width:widget.width ?? 370,
//                   borderRadius:30,
//                   curveType: CurveType.convex,
//                   // spread: 10,
//                   child: Center(child: Text(widget.title,style: TextStyle(color: AppColor.greydark12),)),
//                 ),
//               ),
//             ),
//           ),
//           child: ClayContainer(
//             parentColor:hexToColor('#303238'),
//             surfaceColor:Colors.black26,
//             height: widget.height??60,
//             width: double.infinity,
//             borderRadius:30,
//             curveType: CurveType.concave,
//             spread: 5,
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: ClayContainer(
//                   color:hexToColor('#303238'),
//                   surfaceColor:Colors.black26,
//                   // height:widget.height == null?45: widget.height!-15,
//                   // width:widget.width ?? 370,
//                   borderRadius:30,
//                   curveType: CurveType.convex,
//                   // spread: 10,
//                   child: Center(child: Text(widget.title,style: TextStyle(color: hexToColor('#1BD15D')),)),
//                 ),
//               ),
//             ),
//           ),
//         )
//     );
//   }
// }




customContainerButton(context,
    {borderRadius, outerHeight, outerWidth,  child}){


  return Consumer<ThemeProviderLd>(
      builder:  (BuildContext context, value,_) {
        return Container(alignment: Alignment.center,
          decoration: BoxDecoration(
              color: style.themeData(value.darkTheme, context).primaryColor,
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(101),
              gradient:LinearGradient(
                colors: [
                  // value.darkTheme?AppColor.buttonColor.withOpacity(0.8):AppColor.buttonColor.withOpacity(0.8),
                  // value.darkTheme?AppColor.buttonColor.withOpacity(0.5):AppColor.buttonColor.withOpacity(0.8),
                  // value.darkTheme?AppColor.buttonColor.withOpacity(0.8):AppColor.buttonColor.withOpacity(0.8),
                  // value.darkTheme?AppColor.buttonColor.withOpacity(0.3):AppColor.buttonColor.withOpacity(0.8),

                  value.darkTheme?AppColor.neoBGGrey2:Colors.grey.shade700,
                  value.darkTheme?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                  value.darkTheme?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                  value.darkTheme?AppColor.neoBGGrey2:Colors.grey.shade700,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                    color: value.darkTheme?
                    Colors.black87: AppColor.buttonColor.withOpacity(0.1),
                    blurRadius: 25,offset: const Offset(0,10),
                    spreadRadius: 7
                )
              ]
          ),
          height: outerHeight,
          width: outerWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                // color:style.themeData(value.darkTheme, context).backgroundColor,
                // border: Border.all(color: Colors.grey),
                  borderRadius:borderRadius,
                  gradient:LinearGradient(
                    colors: [
                      // value.darkTheme?AppColor.buttonColor.withOpacity(0.8):AppColor.buttonColor.withOpacity(0.7) ,
                      // value.darkTheme?AppColor.buttonColor.withOpacity(0.1):AppColor.buttonColor.withOpacity(0.7) ,
                      // value.darkTheme?AppColor.buttonColor.withOpacity(0.2):AppColor.buttonColor.withOpacity(0.9),
                      // value.darkTheme?AppColor.buttonColor.withOpacity(0.6):AppColor.buttonColor.withOpacity(0.9),

                      value.darkTheme?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                      value.darkTheme?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                      value.darkTheme?AppColor.neoBGGrey2:Colors.grey.shade500,
                      value.darkTheme?AppColor.neoBGGrey2:Colors.grey.shade700,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color:   value.darkTheme?
                        // AppColor.buttonColor.withOpacity(0.1):
                        // AppColor.buttonColor.withOpacity(0.1),

                        // value.darkTheme==false?
                        Colors.grey.shade600:Colors.grey.shade600,

                        blurRadius: 10,offset: const Offset(0,1),
                        spreadRadius: 2
                    )
                  ]
              ),
              child:child,
            ),
          ),
        );
      }
  );


}


customContainerButton2(context,
    {borderRadius, outerHeight, outerWidth,  child, required bool theme}){


  return Consumer<ThemeProviderLd>(
      builder:  (BuildContext context, value,_) {
        return Container(alignment: Alignment.center,
          decoration: BoxDecoration(
              color: theme?Colors.white:Colors.black,
              // border: Border.all(color: Colors.grey),
              borderRadius: borderRadius,
          ),
          height: outerHeight,
          width: outerWidth,
          child: Center(
            child: child,
          )
        );
      }
  );


}
