

import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/material.dart';

import '../../../app_manager/app_color.dart';
import '../../../medcare_utill.dart';

late BuildContext currentContext;

class ProgressDialogue {
  show(
    context, {
    required String loadingText,
  }) async {
    showProgressDialogue(context, loadingText);
  }

  hide() async {
    try {
     Get.back();
    } catch (e) {
      dPrint(e);
    }
  }

  showProgressDialogue(context, loadingText) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          currentContext = dialogContext;
          return Material(
            color:Colors.transparent,
            child: WillPopScope(
              onWillPop: () {
                ProgressDialogue().hide();
                return Future.value(false);
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(0.0),
                            child: SizedBox(
                              height: 400,
                              child: Lottie.asset("assets/loadingAnimation.json",width: 150,height: 150),

                            ),
                          ),
                          Text(loadingText??"Default",style: MyTextTheme.mediumWCB,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showProgressDialoguse(String? loadingText) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          Get.back(); // Hide dialog when trying to pop
          return false; // Prevent dialog from being dismissed by back button
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  child: Lottie.asset("assets/loadingAnimation.json", width: 150, height: 150),
                ),
                SizedBox(height: 20), // Add some space between animation and text
                Text(
                  loadingText ?? "Loading...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevents dialog from being dismissed by tapping outside
    );
  }
}
