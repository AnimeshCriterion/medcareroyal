


import 'dart:io' show Platform;


import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:lottie/lottie.dart';
//
// import 'package:new_version/new_version.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

import '../my_button.dart';
import '../updater.dart';

import 'package:get/get.dart';
Version latestVersion=Version(0, 0, 0);
Version currentVersion=Version(0, 0, 0);



class Updater{
  static const _appStoreUrl =
      'https://apps.apple.com/us/app/shfc-companion-app/id6471412492';
  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.criteriontech.shfc';

  var cancelResponse = {'status': 0, 'message': 'Try Again...'};


  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {

      print(('nnnnvnnv '+info.updateAvailability .toString()));
      if(info.updateAvailability ==
          UpdateAvailability.updateAvailable){
        InAppUpdate.performImmediateUpdate()
            .catchError((e) {
              print(('nnnnvnnv '+e.toString()));
              return alert(e.toString());
            });
      }
    }).catchError((e) {
      print(('nnnnvnnv '+e.toString()));
      alert(e.toString());
    });
  }

  alert(message){
    Fluttertoast.showToast(
      msg: message,
    );
  }

  // checkVersion(context) async{
  //
  //
  //
  //   if(Platform.isAndroid){
  //     print('nnnnnvnnnvnn');
  //
  //    await checkForUpdate();
  //
  //     print('nnnnnvnnnvnn3');
  //   }
  //   else{
  //
  //     // print('nnnnnvnnnvnn1');
  //     // final newVersion = NewVersion();
  //     //
  //     // VersionStatus? status = await newVersion.getVersionStatus();
  //     //
  //
  //
  //     if(status!=null){
  //       try {
  //
  //         currentVersion = Version.parse(status.localVersion.toString());
  //         // Version currentVersion = Version.parse('1.0.2');
  //         latestVersion = Version.parse(status.storeVersion.toString());
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
  //         print('nnnnvnnnvvnn '+e.toString());
  //         var retry=await apiDialogue(context,'Alert', 'Internet connection issue, try to reconnect.',
  //             showCanCelButton: true
  //         );
  //         if(retry){
  //           var data= await  checkVersion(context);
  //           return data;
  //         }
  //         else{
  //           return cancelResponse;
  //         }
  //       }
  //     }
  //   }
  //
  //
  //
  //
  //
  // }


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
                        Text('('+lat.toString()+')',
                            style: MyTextTheme.mediumPCB),
                        SizedBox(height: 2,),
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
                            Expanded(
                              child: MyButton(title: 'Update', onPress: () {
                                if (Platform.isAndroid) {
                                  _launchURL(_playStoreUrl);
                                } else if (Platform.isIOS) {
                                  _launchURL(_appStoreUrl);
                                }
                              },),
                            ),
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
          decoration: BoxDecoration(
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
                      child: Text('version '+latestVersion.toString()+' is available',
                        style: MyTextTheme.mediumBCN,),
                    ),
                    const SizedBox(width: 15,),
                    MyButton(
                      width: 120,
                      title: 'Update',
                      onPress: (){
                        if (Platform.isAndroid) {
                          _launchURL(_playStoreUrl);
                        } else if (Platform.isIOS) {
                          _launchURL(_appStoreUrl);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}


_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}