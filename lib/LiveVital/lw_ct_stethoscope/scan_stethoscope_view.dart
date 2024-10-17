
import 'package:medvantage_patient/LiveVital/lw_ct_stethoscope/stetho_recording/stetho_recording_view.dart';
import 'package:medvantage_patient/LiveVital/lw_ct_stethoscope/stethoscope_controller.dart';
import 'package:medvantage_patient/LiveVital/lw_ct_stethoscope/stethoscope_screen.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:lottie/lottie.dart';

import '../../View/widget/common_method/show_progress_dialog.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/my_button.dart';
import '../../app_manager/theme/text_theme.dart';
import 'about_stetho.dart';
import 'module/listen_module.dart';

class ScanStethoScopeView extends StatefulWidget {
  const ScanStethoScopeView({Key? key}) : super(key: key);

  @override
  State<ScanStethoScopeView> createState() => _ScanStethoScopeViewState();
}

class _ScanStethoScopeViewState extends State<ScanStethoScopeView> {
  StethoscopeController controller = Get.put(StethoscopeController());

  get() async {
    controller.getDevices();
  }

  @override
  void initState() {
    get();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<StethoscopeController>();
    controller.timer.cancel();
    controller.connectionStream!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primaryColor,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Scan Devices",
              ),
              // Text(
              //   UserData().getUserName.toString() +
              //       ' (' +
              //       UserData().getUserPid.toString() +
              //       ')',
              //   style: MyTextTheme().smallWCN,
              // ),
            ],
          ),
          actions: [
            PopupMenuButton<int>(
              onSelected: (val) {
                if(val==0){
                 MyNavigator.push(context, AboutStetho());
                }
                if(val==1){
                  MyNavigator.push(context, StethoRecordingView());
                }
              },
              itemBuilder: (context) {
                return <PopupMenuEntry<int>>[
                  PopupMenuItem(child: Text('About Stethoscope'), value: 0),
                  PopupMenuItem(child: Text('Recordings'), value: 1),
                ];
              },
            ),

          ],
        ),
        body: GetBuilder(
            init: StethoscopeController(),
            builder: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: MyTextField2(
                        //       controller: controller.pidTextC.value,
                        //       maxLength: 8,
                        //       keyboardType: TextInputType.number,
                        //       label: Text('PID'),
                        //       hintText: 'Enter PID',
                        //     ),
                        //   ),
                        // ),

                        Expanded(
                          child: MyButton(
                              title: 'Listen Stethoscope Audio',
                              color: AppColor.orange,
                              textStyle: MyTextTheme.mediumWCB,
                              onPress: () async {
                                MyNavigator.push(
                                    context,
                                    ListenAudioView(
                                      isScanPage: true,
                                    ));

                                // if (controller.pidTextC.value.text.isNotEmpty) {
                                //   if (controller.pidTextC.value.text.length > 5) {
                                //     await controller.listenData(context);
                                //   } else {
                                //     alertToast(context, 'Please enter valid pid');
                                //   }
                                // } else {
                                //   alertToast(context, 'Please enter PID');
                                // }
                              }),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: MyButton(
                  //     color: AppColor.primaryColor,
                  //     title: 'Recordings',
                  //     onPress: () async {
                  //       App().navigate(context, StethoRecordingView());
                  //     },
                  //   ),
                  // ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: Column(
                      children: [
                        Text(
                          'Devices List',
                          style: MyTextTheme.mediumBCB,
                        ),
                      ],
                    ),
                  ),
                  (controller.getIsDeviceScanning &&
                          controller.getDeviceList!.isEmpty)
                      ? scanDevice()
                      : (controller.getDeviceList ?? []).isEmpty
                          ? _searchAgainWidget()
                          : Expanded(
                              child: Visibility(
                                  visible: controller.getDeviceList != null,
                                  child: ListView(
                                      children: List.generate(
                                          controller.getDeviceList!.length,
                                          (index) {
                                    return Visibility(
                                      visible: controller.getDeviceList![index]
                                              .device.name !=
                                          '',
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [

                                            Expanded(
                                                child: Text(
                                              controller.getDeviceList![index]
                                                  .device.name
                                                  .toString(),
                                              style: MyTextTheme.mediumBCN,
                                            )) ,

                                            MyButton(
                                              width: 115,
                                              title: 'Connect',
                                              onPress: () async {
                                                ProgressDialogue().show(context,
                                                    loadingText:
                                                        'Connecting...');
                                                print('nnnnnnnnnnn' +
                                                    controller
                                                        .getIsDeviceConnected
                                                        .toString());
                                                if (!controller
                                                    .getIsDeviceConnected) {
                                                  controller
                                                      .getDeviceList![index]
                                                      .device
                                                      .connect();
                                                }

                                                controller
                                                        .updateConnectedDevice =
                                                    controller
                                                        .getDeviceList![index];
                                                controller
                                                    .checkDeviceConnection();
                                                controller
                                                    .updateSelectedTabIndex = 0;
                                                controller
                                                        .updateIsDeviceConnected =
                                                    false;
                                                controller.pTimer(context);
                                                new Future.delayed(
                                                    Duration(seconds: 1),
                                                    () async {
                                                  await controller
                                                      .readStethoData(context,
                                                          'mode_enquiry',
                                                          isConnectStetho:
                                                              true);
                                                });
                                                new Future.delayed(
                                                    Duration(seconds: 3),
                                                    () async {
                                                  await controller
                                                      .readStethoData(context,
                                                          'authentication');
                                                  ProgressDialogue().hide();
                                                  Get.to(() =>
                                                      StethoScopeScreen());
                                                });
                                              },
                                            )


                                          ],
                                        ),
                                      ),
                                    );
                                  }))),
                            )
                ],
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            get();
          },
          child: Icon(Icons.search),
        ),
      )),
    );
  }

  Widget _searchAgainWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset('assets/search.json',
                width: 300, fit: BoxFit.fitWidth),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Device Found',
                style: MyTextTheme.mediumBCB,
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                width: 200,
                color: AppColor.orange,
                title: 'Search Again',
                onPress: () {
                  controller.getDevices();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  scanDevice() {
    return Center(
        child: Lottie.asset('assets/scanning.json',
            width: 340, fit: BoxFit.fitWidth));
  }
}
