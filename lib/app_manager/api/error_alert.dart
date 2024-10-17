import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:lottie/lottie.dart';

import 'package:get/get.dart';
import 'package:get/get.dart';
Future<bool> errorAlert(context,alert,msg,{
  bool? showCanCelButton
}){
  var canPressOk=true;
  var retry=false;
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(
            builder: (context,setState)
            {
              return Transform.scale(
                scale: a1.value,
                child: Opacity(
                  opacity: a1.value,
                  child: WillPopScope(
                    onWillPop: (){
                      return Future.value(false);
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              child: Lottie.asset('assets/no_internet_found.json'),),
                            Text(msg.toString(),
                                textAlign: TextAlign.center,
                                style: MyTextTheme.mediumWCB),
                            const SizedBox(height: 20,),
                            Row(
                              children: [
                                const Expanded(child: SizedBox()),
                                Visibility(
                                  visible: showCanCelButton?? true,
                                  child: Expanded(
                                      flex: 2,
                                      child: PrimaryButton(
                                          color: AppColor.grey,
                                          onPressed: (){
                                            if(canPressOk)
                                            {
                                              canPressOk=false;
                                               Get.back();
                                              retry=false;
                                            }
                                          },
                                          title: 'Cancel')),
                                ),
                                Visibility(
                                  visible: showCanCelButton?? true,
                                  child: const Expanded(child: SizedBox()),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: PrimaryButton(
                                        onPressed: (){
                                          if(canPressOk)
                                          {
                                            canPressOk=false;
                                             Get.back();
                                            retry=true;
                                          }
                                        },
                                        title: 'Retry')),
                                const Expanded(child: SizedBox()),
                              ],
                            )
                            // Container(
                            //     decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         borderRadius: BorderRadius.all(Radius.circular(0)),
                            //         border: Border.all(
                            //             color: Colors.red,
                            //             width: 2
                            //         )
                            //     ),
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.end,
                            //       children: [
                            //         Column(
                            //           children: [
                            //             Row(
                            //               children: [
                            //                 Expanded(
                            //                   child: Text(msg.toString(),
                            //                     textAlign: TextAlign.center,
                            //                     style: TextStyle(
                            //                         fontWeight: FontWeight.bold
                            //                     ),),
                            //                 ),
                            //                 TextButton(
                            //                   style: TextButton.styleFrom(
                            //                     primary: Colors.black,
                            //                     padding: EdgeInsets.all(8),
                            //                   ),
                            //                   onPressed: () {
                            //                     if(canPressOk)
                            //                     {
                            //                       canPressOk=false;
                            //                        Get.back();
                            //                       retry=false;
                            //                     }
                            //                   },
                            //                   child: Text(
                            //                     'CANCEL',
                            //                     style: TextStyle(color: Colors.red,
                            //                         fontWeight: FontWeight.bold,
                            //                     fontSize: 12),
                            //                   ),
                            //                 ),
                            //
                            //                 TextButton(
                            //                   style: TextButton.styleFrom(
                            //                     primary: Colors.black,
                            //                     padding: EdgeInsets.all(8),
                            //                   ),
                            //                   onPressed: () {
                            //                     if(canPressOk)
                            //                     {
                            //                       canPressOk=false;
                            //                        Get.back();
                            //                       retry=true;
                            //                     }
                            //                   },
                            //                   child: Text(
                            //                     'RETRY',
                            //                     style: TextStyle(color: Colors.red,
                            //                         fontWeight: FontWeight.bold,
                            //                         fontSize: 12),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      }).then((val){
    canPressOk=false;
    return retry;
  });
}