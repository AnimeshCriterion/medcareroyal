
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../app_manager/alert_dialogue.dart';
import '../../../app_manager/alert_toast.dart';
import '../../../app_manager/app_color.dart';
import '../../../app_manager/widgets/text_field/custom_sd.dart';
import '../stethoscope_controller.dart';

class MeasringPointModuleView extends StatefulWidget {
  const MeasringPointModuleView({super.key});

  @override
  State<MeasringPointModuleView> createState() => _MeasringPointModuleViewState();
}

class _MeasringPointModuleViewState extends State<MeasringPointModuleView>
   {

     StethoscopeController stethoController = Get.put(StethoscopeController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    List bodyPartList = [frontHeart(), frontLungs(), backLungs()];
    return Container(
      color: Colors.blue,
      child: SafeArea(child:
      Scaffold(appBar: AppBar(title: const Text('Select Measuring Point')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: 350,
                child: CustomSD(
                    listToSearch: stethoController.bodyList,
                    valFrom: 'name',
                    hideSearch: true,
                    borderColor: Colors.grey,
                    height: 150,
                    label: 'Select Body',
                    onChanged: (val) {
                      if (val != null) {
                        stethoController.updateSelectedBodyTab =
                            int.parse(val['id'].toString());
                      }
                    }),
              ),

              Visibility(
                  child: bodyPartList[stethoController.getSelectedBodyTab]),
            ],
          ),
        )
      )),
    );
  }

     frontLungs() {
       return Stack(
         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
               child: Image.asset(
                 'assets/front_lungs.png',
                 fit: BoxFit.fitWidth,
               ),
             ),
           ),
           Positioned(
               left: 158.w,
               top: 30.h,
               child: measurePointWidget(
                 'Tracheal site',
               )),
           Positioned(
               left: 125.w,
               top: 50.h,
               child: measurePointWidget("First Right intercostal space")),
           Positioned(
               right: 125.w,
               top: 50.h,
               child: measurePointWidget(
                 'First left instercostal space',
               )),
           Positioned(
               left: 80.w,
               top: 125.h,
               child: measurePointWidget(
                 'Lower anterior',
               )),
           Positioned(
               right: 80.w,
               top: 125.h,
               child: measurePointWidget(
                 'Lower anterior',
               )),
           Positioned(
               left: 75.w,
               bottom: 120.h,
               child: measurePointWidget(
                 'Miduxillary',
               )),
           Positioned(
               right: 83.w,
               bottom: 120.h,
               child: measurePointWidget(
                 'Miduxillarys',
               )),
         ],
       );
     }

     frontHeart() {
       return Center(
         child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: Stack(
             children: [
               Image.asset(
                 'assets/front_heart.png',
                 fit: BoxFit.fitWidth,
               ),
               Positioned(
                   left: 125.w,
                   top: 65.h,
                   child: measurePointWidget('Base Right', isGreen: true)),
               Positioned(
                   top: 80.h,
                   right: 125.w,
                   child: measurePointWidget('Base Left', isGreen: true)),
               Positioned(
                   bottom: 150.h,
                   right: 155.w,
                   child: measurePointWidget('Lower Left Sternal Border',
                       isGreen: true)),
               Positioned(
                   top: 150.h,
                   left: 185.w,
                   child: measurePointWidget('Apex', isGreen: true)),
             ],
           ),
         ),
       );
     }

     backLungs() {
       return Center(
         child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Stack(children: [
               Image.asset('assets/back_lungs.png'),
               Positioned(
                   left: 120.w,
                   top: 100.h,
                   child: measurePointWidget(
                     'Left Upper Zone',
                   )),
               Positioned(
                   right: 125.w,
                   top: 100.h,
                   child: measurePointWidget(
                     'Right Upper Zone',
                   )),
               Positioned(
                   left: 105.w,
                   top: 130.h,
                   child: measurePointWidget('Left Mid Zone')),
               Positioned(
                   right: 110.w,
                   top: 130.h,
                   child: measurePointWidget('Right Mid Zone')),
               Positioned(
                   left: 95.w,
                   bottom: 125.h,
                   child: measurePointWidget('Left Lower Zone')),
               Positioned(
                   right: 110.w,
                   bottom: 125.h,
                   child: measurePointWidget('Right Lower Zone')),
               Positioned(
                   left: 45.w,
                   bottom: 110.h,
                   child: measurePointWidget('Left Axilla')),
               Positioned(
                   right: 60.w,
                   bottom: 110.h,
                   child: measurePointWidget(
                     'Right Axilla',
                   )),
             ])),
       );
     }

     cardiac() {
       return Center(
         child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: Stack(
             children: [
               Image.asset(
                 'assets/cardiac.png',
                 fit: BoxFit.fitWidth,
               ),
               Positioned(
                   left: 0.w,
                   right: 0.w,
                   top: 30.h,
                   child: measurePointWidget('Tracheal Site')),
               Positioned(
                   left: 0.w,
                   right: 80.w,
                   top: 80.h,
                   child: measurePointWidget('First Right Intercostal Space')),
               Positioned(
                   right: 0.w,
                   left: 90.w,
                   top: 85.h,
                   child: measurePointWidget('First Left Intercostal Space')),
               Positioned(
                   right: 0.w,
                   left: 80.w,
                   top: 125.h,
                   child: measurePointWidget('Second Left Intercostal Space')),
               Positioned(
                   right: 80.w,
                   left: 0.w,
                   top: 130.h,
                   child: measurePointWidget('Second Right Intercostal Space')),
               Positioned(
                   right: 0.w,
                   left: 90.w,
                   top: 160.h,
                   child: measurePointWidget('Third Left Intercostal Space')),
               Positioned(
                   right: 0.w,
                   left: 80.w,
                   top: 200.h,
                   child: measurePointWidget('Fourth Left Intercostal Space')),
               Positioned(
                   right: 0.w,
                   left: 110.w,
                   top: 230.h,
                   child: measurePointWidget('Apex')),
               Positioned(
                   right: 15.w,
                   left: 0.w,
                   top: 200.h,
                   child: measurePointWidget('Lower Left Sternum')),
               Positioned(
                   right: 0.w,
                   left: 220.w,
                   top: 240.h,
                   child: measurePointWidget('Lower Anterior Left')),
               Positioned(
                   right: 220.w,
                   left: 0.w,
                   top: 240.h,
                   child: measurePointWidget('Lower Anterior Right')),
               Positioned(
                   right: 0.w,
                   left: 220.w,
                   top: 290.h,
                   child: measurePointWidget('Anterior Midaxillary Left')),
               Positioned(
                   right: 220.w,
                   left: 0.w,
                   top: 290.h,
                   child: measurePointWidget('Anterior Midaxillary Right')),
             ],
           ),
         ),
       );
     }

     measurePointWidget(tapedPoint, {isGreen}) {
       return GetBuilder(
           init: StethoscopeController(),
           builder: (_) {
             return Center(
               child: InkWell(
                   onTap: () async {
                     if (stethoController.getIsDeviceConnected) {
                       if (stethoController.getTappedBodyPoint == '') {
                         stethoController.updateTappedBodyPoint =
                             tapedPoint.toString();
                         stethoController.updateIsTimeComplete = false;
                         Timer(const Duration(seconds: 15), () async {
                           stethoController.updateTappedBodyPoint = '';
                           stethoController.updateIsTimeComplete = true;
                         });
                       } else {

                         Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: 'Measuring ${stethoController.getTappedBodyPoint.toString()}'));
                         // alertToast(context,
                         //     'Measuring ${stethoController.getTappedBodyPoint.toString()}');
                       }
                     } else {
                       Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Connect your device'));
                       // alertToast(context, 'Connect your device');
                     }
                   },
                   child: stethoController.getTappedBodyPoint.toString() ==
                       tapedPoint.toString() &&
                       !stethoController.getIsTimeComplete == true
                       ? CircleAvatar(
                     backgroundColor: AppColor.greyVeryLight,
                     radius: 18,
                     child: Lottie.asset(
                       'assets/bp_json.json',
                     ),
                   )
                       : CircleAvatar(
                     backgroundColor: AppColor.white,
                     radius: 12,
                     child: CircleAvatar(
                       backgroundColor: (isGreen ?? false)
                           ? AppColor.green
                           : AppColor.primaryColorDark,
                       radius: 10,
                     ),
                   )),
             );
           });
     }
}
