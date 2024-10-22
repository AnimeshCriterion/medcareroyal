


import 'dart:io' show Platform;

import 'package:get/get.dart';

import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
//
// import 'package:new_version/new_version.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';
import 'package:in_app_update/in_app_update.dart';

import 'alert_dialogue.dart';
import 'alert_toast.dart';
import 'app_color.dart';
import 'my_button.dart';


Version latestVersion=Version(0, 0, 0);
Version currentVersion=Version(0, 0, 0);

class Updater{
  static const APP_STORE_URL =
      'https://apps.apple.com/us/app/medvantage_patient/id1517201659';
  static const PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.medvantage_patientconnect.android';


  Future<void> checkForUpdate(context) async {
    InAppUpdate.checkForUpdate().then((info) {

      if(info.updateAvailability ==
          UpdateAvailability.updateAvailable){
        InAppUpdate.performImmediateUpdate()
            .catchError((e) =>
            Get.showSnackbar( MySnackbar.ErrorSnackBar(  message:  e.toString()))
            // alertToast(context,e.toString())
      );

      }
    }).catchError((e) {

      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message:  e.toString()));
      // alertToast(context,e.toString());
    });
  }


  // checkVersion(context) async{
  //
  //
  //   if(Platform.isAndroid){
  //     checkForUpdate(context);
  //   }
  //   else{
  //
  //    // final newVersion = NewVersion();
  //
  //     //VersionStatus? status = await newVersion.getVersionStatus();
  //     // if(status!=null){
  //     //   try {
  //     //
  //     //     currentVersion = Version.parse(status.localVersion.toString());
  //     //     // Version currentVersion = Version.parse('1.0.2');
  //     //     latestVersion = Version.parse(status.storeVersion.toString());
  //
  //         //
  //         // print(currentVersion.toString()+' '+latestVersion.toString()+' uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu');
  //         //
  //         // print(currentVersion.toString()+'\n'+latestVersion.toString());
  //         if(latestVersion > currentVersion){
  //           showUpdateDialogue(latestVersion, context,
  //               showCancelButton: true);
  //         }
  //
  //       }
  //       catch (e){
  //         print(e);
  //         var retry=await apiDialogue(context,'Alert', 'Internet connection issue, try to reconnect.',
  //             showCanCelButton: true
  //         );
  //         if(retry){
  //           var data= await  checkVersion(context);
  //           return data;
  //         }
  //
  //       }
  //     }
  //   }





  }


  showUpdateDialogue(lat,context,{
    bool showCancelButton=false
  }){
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){
            return Future.value(false);
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 150,
                            child: Lottie.asset('assets/update.json'),),
                        ),
                        Text('New version available',
                            style: MyTextTheme.mediumPCB),
                        Text('($lat)',
                            style: MyTextTheme.mediumPCB),
                        const SizedBox(height: 2,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Looks like you have an older version of the app.\n'
                              'Please update to get latest features and better experience.',
                              textAlign: TextAlign.center,
                              style: MyTextTheme.mediumBCN),
                        ),

                        Row(
                          children: [

                            showCancelButton? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,20,0),
                                child: MyButton(
                                  color: Colors.red,
                                  title: 'Cancel', onPress: () {
                                   Get.back();
                                },),
                              ),
                            ):Container(),
                            // Expanded(
                            //   child: MyButton(title: 'Update', onPress: () {
                            //     if (Platform.isAndroid) {
                            //       _launchURL(PLAY_STORE_URL);
                            //     } else if (Platform.isIOS) {
                            //       _launchURL(APP_STORE_URL);
                            //     }
                            //   },),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  updateContainer(){
    return Visibility(
      visible: latestVersion > currentVersion,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0,0,0,20,),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            // border: Border.all(color: AppColor().greyDark,
            // width: 1)
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text('version $latestVersion is available',
                        style: MyTextTheme.mediumBCN,),
                    ),
                    const SizedBox(width: 15,),
                    // MyButton(
                    //   width: 120,
                    //   title: 'Update',
                    //   onPress: (){
                    //     if (Platform.isAndroid) {
                    //       _launchURL(PLAY_STORE_URL);
                    //     } else if (Platform.isIOS) {
                    //       _launchURL(APP_STORE_URL);
                    //     }
                    //   },
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

// }


_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}apiDialogue(context, alert, msg, {bool? showCanCelButton}) {
  var canPressOk = true;
  var retry = false;
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(builder: (context, setState) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: WillPopScope(
                onWillPop: () {
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
                          child: Lottie.asset('assets/noInterNet.json'),
                        ),
                        Text(msg.toString(),
                            textAlign: TextAlign.center,
                            style: MyTextTheme.smallBCB),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            Visibility(
                              visible: showCanCelButton ?? true,
                              child: Expanded(
                                  flex: 2,
                                  child: MyButton(
                                      color: AppColor.greyVeryLight,
                                      onPress: () {
                                        if (canPressOk) {
                                          canPressOk = false;
                                           Get.back();
                                          retry = false;
                                        }
                                      },
                                      title: 'Cancel')),
                            ),
                            Visibility(
                              visible: showCanCelButton ?? true,
                              child: const Expanded(child: SizedBox()),
                            ),
                            Expanded(
                                flex: 2,
                                child: MyButton(
                                    onPress: () {
                                      if (canPressOk) {
                                        canPressOk = false;
                                         Get.back();
                                        retry = true;
                                      }
                                    },
                                    title: 'Retry')),
                            const Expanded(child: SizedBox()),
                          ],
                        )
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
      }).then((val) {
    canPressOk = false;
    return retry;
  });
}