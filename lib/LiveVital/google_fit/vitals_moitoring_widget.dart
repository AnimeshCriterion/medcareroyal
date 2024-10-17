// import 'package:digi_doctor/AppManager/my_text_theme.dart';
// import 'package:digi_doctor/Pages/VitalPage/LiveVital/google_fit/google_fit_view.dart';
// import 'package:digi_doctor/services/hex_color.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hexcolor/hexcolor.dart';
//
// class VitalsMonitoring extends StatelessWidget {
//   final VitalData? vitalData;
//
//   VitalsMonitoring({
//     Key? key,
//     this.vitalData,
//   }) : super(key: key);
//
//   // VitalData vitalData = VitalData.spo2(spo2: "76");
//
//   @override
//   Widget build(BuildContext context) {
//     return (vitalData!.val ?? '').isEmpty
//         ? Container()
//         : Container(
//             padding: EdgeInsets.all(10),
//             margin: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: vitalData!.bgcolor,
//             ),
//             child: Stack(
//               children: [
//                 Container(
//                   alignment: Alignment.centerRight,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Image.asset(
//                       vitalData!.bgimg.toString(),
//                       height: 80,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   // mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.white,
//                       child: SvgPicture.asset(vitalData!.icon.toString()),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(vitalData!.title.toString(),
//                             style: MyTextTheme().largeBCB),
//                         Text(vitalData!.subtitle.toString(),
//                             style: MyTextTheme().smallGCN.copyWith(
//                                 fontSize: 13, color: '#3F4E6E'.toColor())),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Text(vitalData!.val.toString(),
//                                 style: MyTextTheme().largeBCB.copyWith(
//                                     color: '#23384D'.toColor(), fontSize: 35)),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Text(vitalData!.valName.toString(),
//                                 style: MyTextTheme()
//                                     .smallBCN
//                                     .copyWith(color: '#23384D'.toColor())),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             vitalData!.val2 == null
//                                 ? Container()
//                                 : Text(vitalData!.val2.toString(),
//                                     style: MyTextTheme().largeBCB.copyWith(
//                                         color: '#23384D'.toColor(),
//                                         fontSize: 35)),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             vitalData!.val2Name == null
//                                 ? Container()
//                                 : Text(vitalData!.val2Name.toString(),
//                                     style: MyTextTheme()
//                                         .smallBCN
//                                         .copyWith(color: '#23384D'.toColor())),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//   }
// }
//
// class VitalData {
//   String? valName;
//   String? val;
//   String? val2Name;
//   String? val2;
//   String? icon;
//   String? title;
//   String? subtitle;
//   String? bgimg;
//   Color? bgcolor;
//
//   VitalData.hearRate({required this.val})
//       : bgcolor = "#FFE9E9".toColor(),
//         icon = "assets/HeartrateS.svg",
//         title = "Heart Rate",
//         subtitle = 'Current bpm',
//         valName = 'mmHg',
//         bgimg = 'assets/heartrate.png';
//
//   VitalData.spo2({required this.val})
//       : bgcolor = "#E2EEFF".toColor(),
//         icon = "assets/BloodOxyS.svg",
//         title = "Blood Oxygen",
//         subtitle = 'Current Max & Min/mmHg',
//         valName = 'mmHg',
//         bgimg = 'assets/spo2bg.png';
//
//   VitalData.bloodPressure({
//     required this.val,
//     required this.val2,
//   })  : bgcolor = "#FFEDD4".toColor(),
//         icon = "assets/bpChart.svg",
//         title = "Blood Pressure Chart",
//         subtitle = 'Current SYS/mmHg',
//         valName = 'Sys',
//         val2Name = 'Dys',
//         bgimg = 'assets/BPchartbg.

import 'package:medvantage_patient/app_manager/extentions/hex_color_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_manager/theme/text_theme.dart';

class VitalsMonitoring extends StatelessWidget {
  final VitalData? vitalData;

  const VitalsMonitoring({
    Key? key,
    this.vitalData,
  }) : super(key: key);

  // VitalData vitalData = VitalData.spo2(spo2: "76");

  @override
  Widget build(BuildContext context) {
    return (vitalData!.val ?? '').isEmpty
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: vitalData!.bgcolor,
            ),
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      vitalData!.bgimg.toString(),
                      height: 80,
                    ),
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: SvgPicture.asset(vitalData!.icon.toString()),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(vitalData!.title.toString(),
                            style: MyTextTheme.largeBCB),
                        // Text(vitalData!.subtitle.toString(),
                        //     style: MyTextTheme().smallGCN.copyWith(
                        //         fontSize: 13, color: '#3F4E6E'.toColor())),
                        const SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                                double.parse(vitalData!.val.toString()).toInt().toString(),
                                style: MyTextTheme.largeBCB.copyWith(
                                    color: '#23384D'.toColor(), fontSize: 30)),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(vitalData!.valName.toString(),
                                style: MyTextTheme
                                    .largeBCB
                                    .copyWith(color: '#23384D'.toColor())),
                            const SizedBox(
                              width: 1,
                            ),
                            vitalData!.val2 == null
                                ? Container()
                                : Text((vitalData!.val2.toString()=="")? "":
                                    double.parse(vitalData!.val2.toString()).toInt().toString(),
                                    style: MyTextTheme.largeBCB.copyWith(
                                        color: '#23384D'.toColor(),
                                        fontSize: 30)),
                            const SizedBox(
                              width: 5,
                            ),
                            vitalData!.val2Name == null
                                ? Container()
                                : Text(vitalData!.val2Name.toString(),
                                    style: MyTextTheme
                                        .smallBCB
                                        .copyWith(color: '#23384D'.toColor())),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

class VitalData {
  String? valName;
  String? val;
  String? val2Name;
  String? val2;
  String? icon;
  String? title;
  String? subtitle;
  String? bgimg;
  Color? bgcolor;

  VitalData.hearRate({required this.val})
      : bgcolor = "#FFE9E9".toColor(),
        icon = "assets/HeartrateS.svg",
        title = "Heart Rate",
        subtitle = 'Current bpm',
        valName = 'bpm',
        bgimg = 'assets/heartrate.png';

  VitalData.spo2({required this.val})
      : bgcolor = "#E2EEFF".toColor(),
        icon = "assets/BloodOxyS.svg",
        title = "Blood Oxygen",
        subtitle = 'Current Max & Min/mmHg',
        valName = '%',
        bgimg = 'assets/spo2bg.png';

  VitalData.bloodPressure({
    required this.val,
    required this.val2,
  })  : bgcolor = "#FFEDD4".toColor(),
        icon = "assets/bpChart.svg",
        title = "Blood Pressure Chart",
        subtitle = 'Current SYS/mmHg',
        valName = '\\',
        val2Name = 'mmHg',
        bgimg = 'assets/BPchartbg.webp';
}
