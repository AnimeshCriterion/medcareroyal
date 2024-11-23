
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/LiveVital/bp_watch/watch_controller.dart';

import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';

class Watch extends StatefulWidget {
  const Watch({super.key});

  @override
  State<Watch> createState() => _WatchState();
}

class _WatchState extends State<Watch> {

  WatchController watchController = Get.put(WatchController());

  get() async {
    watchController.updateIsDeviceConnected=false;
    await watchController.scanDevices();
  }

  @override
  void initState() {
    get();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<WatchController>();
       watchController.devicesData!.device.disconnect();
    watchController.scanSubscription!.cancel();
    watchController.bpSubscription!.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return SafeArea(
      child: Container(
        color: AppColor.green,
        child: GetBuilder(
          init: WatchController(),
          builder: (_) {
            return WillPopScope(
              onWillPop: ( ) async {
                Get.back();
              Get.delete<WatchController>();
              await watchController.devicesData!.device.disconnect();
              watchController.scanSubscription!.cancel();
              watchController.bpSubscription!.cancel();
              return Future.value(false);
            },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor:
                  themeChange.darkTheme ? AppColor.greyDark: AppColor.white ,
                  foregroundColor:  themeChange.darkTheme ? AppColor.white : AppColor.black,
                  title: Text('BP Watch',
                    style: MyTextTheme.largeBCN,),

                  actions: [
                    // Connect button
                    Visibility(
                      visible: watchController.getIsDeviceFound && !watchController.getIsDeviceScanning,
                      child: Padding(
                        padding:  EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () async {
                            dPrint('Connected Device Name : ${watchController.devicesData!.device.platformName}');
                            dPrint('Device Remote Id : ${watchController.devicesData!.device.remoteId}');

                              try{
                                // showAlertDialog(context);
                                await watchController.devicesData!.device.connect();
                              if(!watchController.getIsDeviceConnected) {
                                watchController.onPressConnect(context);
                                // Navigator.pop(context);
                              }
                            } catch (e) {
                                dPrint('Device connecting related issues : $e');
                              }

                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          child: Text(watchController.getIsDeviceConnected ? 'Connected':'Connect',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !watchController.getIsDeviceFound && !watchController.getIsDeviceScanning,
                      child: Padding(
                        padding:  EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(watchController.devicesData!=null){
                              await  watchController.devicesData!.device.disconnect();
                            }

                            await watchController.scanDevices();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: Text( 'Scan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                body: WillPopScope(
                  onWillPop: () {
                    watchController.onPressBack();
                    return Future.value(false);
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // gradient: LinearGradient(
                            //   begin: Alignment.topLeft,
                            //   end: Alignment.bottomLeft,
                            //   colors: [
                            //     Colors.white,
                            //     Colors.purple.shade100,
                            //   ]
                            // ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColor.green,
                                  Colors.green.shade100,
                                ],
                                stops: [0.0, 1.0],
                                tileMode: TileMode.repeated,
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Heading and Date Time
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                height: MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                       AppColor.green,
                                        AppColor.green,
                                      ],
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.repeated,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Blood Pressure',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black
                                          ),
                                        ),


                                      ],
                                    )
                                  ],
                                ),
                              ),

                              // Systolic
                              Padding(
                                padding: EdgeInsets.only(left: 15, top: 20),
                                child: Row(
                                  children: [
                                    Text('Systolic (mmHg) : ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black
                                      ),
                                    ),

                                    Text(watchController.getBpSysData.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              // Diastolic
                              Padding(
                                padding: EdgeInsets.only(left: 15, top: 20),
                                child: Row(
                                  children: [
                                    Text('Diastolic (mmHg) : ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black
                                      ),
                                    ),

                                    Text(watchController.getBpDiaData.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Pulse
                              Padding(
                                padding: EdgeInsets.only(left: 15, top: 20),
                                child: Row(
                                  children: [
                                    Text('Pulse (min) : ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black
                                      ),
                                    ),

                                    Text(watchController.getBpPulData.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // watchController.getBpDiaData.toString()==''? SizedBox():  MyButton(title: 'Save',
                      //     width: 150,onPress: () async {
                      //   await  LiveVitalModal().addVitalsData(context,
                      //       BPDias: watchController.getBpDiaData.toString(),
                      //       BPSys: watchController.getBpSysData.toString(),
                      //       pr: watchController.getBpPulData.toString() );
                      //
                      // },)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text("Connecting" ),
          ),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

}
