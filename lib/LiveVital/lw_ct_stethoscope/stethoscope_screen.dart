import 'dart:async';

import 'package:medvantage_patient/LiveVital/lw_ct_stethoscope/stethoscope_controller.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../app_manager/alert_dialogue.dart';
import '../../app_manager/alert_toast.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/my_button.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/text_field/custom_sd.dart';
import 'module/about_stethoscope.dart';
import 'module/listen_module.dart';
import 'module/add_patient_module.dart';
import 'module/measuring_point_module.dart';
import 'module/update_wifi_module.dart';

class StethoScopeScreen extends StatefulWidget {
  const StethoScopeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StethoScopeScreen> createState() => _StethoScopeScreenState();
}

class _StethoScopeScreenState extends State<StethoScopeScreen>
      {


  StethoscopeController stethoController = Get.put(StethoscopeController());

  bool isoBscureText = false;

  get() {

    // stethoController.updateSelectedTabIndex = 0;
    // stethoController.updateIsDeviceConnected = false;
    // stethoController.checkDeviceConnection();
    // stethoController.getDevices();
  }

  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    List<Widget> stethoWidget = [
      // stethoD(),
      // bodyPart(),

      settingWidget(),
    ];

    return Container(
      color: AppColor.primaryColor,
      child: SafeArea(
        child: GetBuilder(
            init: StethoscopeController(),
            builder: (_) {
              return Scaffold(
                  backgroundColor: Colors.blue.shade100,
                  appBar: AppBar(
                    title: const Text("Stethoscope"),
                    actions: [
                      Visibility(
                        visible: (!stethoController.getIsDeviceScanning),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white),
                              onPressed: () async {
                                if (!stethoController.getIsDeviceConnected) {
                                  await stethoController.connectedDevice!.device
                                      .connect();
                                }
                                stethoController.checkDeviceConnection();
                              },
                              child: Text(
                                stethoController.getIsDeviceConnected
                                    ? 'Connected'
                                    : 'Disconnected',
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.blue),
                              )),
                        ),
                      )
                    ],
                  ),
                  body:WillPopScope(
                      onWillPop: () {
                        return stethoController.onPressedBack();
                      },
                    child: GetBuilder(
                        init:StethoscopeController() ,
                        builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: AppColor.white, borderRadius: BorderRadius.circular(15)),
                              child: ListView(
                              //  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Stethoscope Remote Control',
                                    style: MyTextTheme.mediumBCB,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        InkWell(
                                          onTap: (){
                                            if (stethoController.getIsDeviceConnected) {
                                              if (!stethoController.getIsHeartMode) {
                                                stethoController.readStethoData(
                                                    context, 'mode_change');
                                              }
                                            } else {
                                              Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Connect your device'));
                                              // alertToast(context, 'Connect your device');
                                            }
                                          },
                                          child: modeWidget(
                                              bgImg: 'assets/stethoImg/bgHeart.svg',
                                              switchImg: !stethoController.getIsHeartMode? 'assets/stethoImg/unSelectedSwitch.svg':'assets/stethoImg/selectedSwitch.svg',
                                              fgImg: 'assets/stethoImg/heart.svg',
                                              title: stethoController.getIsHeartMode?'Heart Mode':'',
                                              isShowShadow: stethoController.getIsHeartMode),
                                        ),


                                        const SizedBox(
                                          width: 15,
                                        ),

                                        InkWell(
                                          onTap: (){
                                            if (stethoController.getIsDeviceConnected) {
                                              if (stethoController.getIsHeartMode) {
                                                stethoController.readStethoData(
                                                    context, 'mode_change');
                                              }
                                            } else {
                                              Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Connect your device'));
                                              // alertToast(context, 'Connect your device');
                                            }
                                          },
                                          child:  modeWidget(
                                              bgImg: 'assets/stethoImg/bgLungs.svg',
                                              switchImg: stethoController.getIsHeartMode? 'assets/stethoImg/unSelectedSwitch.svg':'assets/stethoImg/selectedSwitch.svg',
                                              fgImg: 'assets/stethoImg/lungs.svg',
                                              title: !stethoController.getIsHeartMode?'Lungs Mode':'',
                                              isShowShadow: !stethoController.getIsHeartMode),
                                        )

                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  LinearPercentIndicator(
                                    animation: true,
                                    lineHeight: 70,
                                    animationDuration: 2000,
                                    percent: double.parse(stethoController.getBatteryPercentage.toString())/100,
                                    center: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset('assets/stethoImg/battery.svg'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                                  'Battery',
                                                  style: MyTextTheme
                                                      .mediumBCB
                                                      .copyWith(color: AppColor.green),
                                                )),
                                            Text(stethoController.getBatteryPercentage.toString()+ '%',
                                              style: MyTextTheme.mediumBCB,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    barRadius: const Radius.circular(25),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: Colors.green.shade100,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      MyNavigator.push(context, UpdateWifiView());
                                    },
                                    child: containerListWidget(
                                      img: 'assets/stethoImg/hotspot.svg',
                                      title: 'Update Wifi',
                                      subtitle: 'Click to update your wifi',
                                      color: Colors.pink.shade500,
                                    ),
                                  ),

                                  InkWell(
                                    onTap: (){
                                      MyNavigator.push(context, ListenAudioView(isScanPage: false));
                                    },
                                    child: containerListWidget(
                                      img: 'assets/stethoImg/listenAudio.svg',
                                      title: 'Listen Stethoscope Audio',
                                      subtitle: 'Click to Listen StethoScope audio',
                                      color: Colors.blue.shade500,
                                    ),
                                  ),

                                  InkWell(
                                    onTap: (){
                                      MyNavigator.push(context, MeasringPointModuleView());
                                    },
                                    child:containerListWidget(
                                      img: 'assets/stethoImg/measure.svg',
                                      title: 'Measuring Points',
                                      subtitle: 'Click to Know measuring points',
                                      color: Colors.orange.shade500,
                                    ),
                                  ),
                                  SizedBox(height: 115,),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      onTap: (){
                                        MyNavigator.push(context, AboutStethoScopeView());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('About Stethoscope?',style: MyTextTheme.mediumBCN.copyWith(color: AppColor.primaryColor,decoration: TextDecoration.underline,),),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),

                  // WillPopScope(
                  //   onWillPop: () {
                  //     return stethoController.onPressedBack();
                  //   },
                  //   child: DefaultTabController(
                  //     length: 2,
                  //     child: Center(
                  //       child: Container(
                  //         width: MediaQuery.of(context).size.width > 600
                  //             ? 600
                  //             : MediaQuery.of(context).size.width,
                  //         child: Column(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Container(
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                     border: Border.all(
                  //                         color: AppColor.primaryColor),
                  //                     borderRadius: BorderRadius.circular(50)),
                  //                 child: TabBar(
                  //                   unselectedLabelStyle: const TextStyle(
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.bold),
                  //                   isScrollable: true,
                  //                   labelStyle: const TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 18),
                  //                   onTap: (val) {
                  //                     print(
                  //                         'nvnvnvnvnvnvnvnnv' + val.toString());
                  //                     stethoController.clearData();
                  //                     stethoController.updateSelectedTabIndex =
                  //                         val;
                  //                   },
                  //                   indicator: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(50),
                  //                       // Creates border
                  //                       color: Colors.blue),
                  //                   labelColor: Colors.white,
                  //                   unselectedLabelColor: Colors.black,
                  //                   splashBorderRadius:
                  //                       BorderRadius.circular(50),
                  //                   tabs: [
                  //                     Tab(
                  //                       child: SizedBox(
                  //                         width: MediaQuery.of(context)
                  //                                 .size
                  //                                 .width /
                  //                             2.7,
                  //                         child: Text("Measuring Point",
                  //                             textAlign: TextAlign.center),
                  //                       ),
                  //                     ),
                  //                     Tab(
                  //                       child: SizedBox(
                  //                         width: MediaQuery.of(context)
                  //                                 .size
                  //                                 .width /
                  //                             2.7,
                  //                         child: Text(
                  //                           "Setting",
                  //                           textAlign: TextAlign.center,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //             Expanded(
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: SingleChildScrollView(
                  //                   child: stethoWidget[
                  //                       stethoController.getSelectedTabIndex],
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                  );
            }),
      ),
    );
  }

  modeWidget(
      {required String bgImg,
      required String switchImg,
      required String fgImg,
      required String title,
      required bool isShowShadow}) {
    return GetBuilder(
        init:StethoscopeController() ,
        builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColor.green),
            boxShadow:   [
              isShowShadow? BoxShadow(
                offset: Offset(10, 15),
                color: Colors.grey,
                blurRadius:10,
              ):BoxShadow()
            ]
          ),
          child: Stack(
            children: [
              Container(
                height: 150,
                width: 125,
                child: SvgPicture.asset(
                  bgImg.toString(),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(
                            switchImg.toString(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SvgPicture.asset(
                            fgImg.toString(),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          title.toString(),
                          style: MyTextTheme.mediumBCB,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        );
      }
    );
  }

  containerListWidget({
    required String img,
    required String title,
    String? subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SvgPicture.asset(img.toString()),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title.toString(),
                    style: MyTextTheme.mediumBCB.copyWith(color: color),
                  ),
                  Text(
                    subtitle.toString(),
                    style: MyTextTheme.smallBCN,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  bodyPart() {
    List bodyPartList = [frontHeart(), frontLungs(), backLungs()];
    return GetBuilder(
        init: StethoscopeController(),
        builder: (_) {
          return Column(
            children: [
              // DefaultTabController(
              //   length: 2,
              //   child: Container(
              //     height: 45,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(25),
              //         border: Border.all(color: AppColor.greyLight)),
              //     child: TabBar(
              //       unselectedLabelStyle: const TextStyle(
              //           fontSize: 18, fontWeight: FontWeight.bold),
              //       isScrollable: true,
              //       labelStyle: const TextStyle(
              //           fontWeight: FontWeight.bold, fontSize: 18),
              //       onTap: (val) {
              //         stethoController.updateSelectedBodyTab = val;
              //       },
              //       indicator: BoxDecoration(
              //           borderRadius: BorderRadius.circular(50),
              //           // Creates border
              //           color: Colors.blue),
              //       labelColor: Colors.white,
              //       unselectedLabelColor: Colors.black,
              //       splashBorderRadius: BorderRadius.circular(50),
              //       tabs: const [
              //         Tab(
              //           text: "Front Chest",
              //         ),
              //         Tab(
              //           text: "Back Chest",
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

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

              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColor.white,
                    radius: 10,
                    child: CircleAvatar(
                      backgroundColor: AppColor.green,
                      radius: 8,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Heart Points',
                    style: MyTextTheme.mediumPCN,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColor.white,
                    radius: 10,
                    child: CircleAvatar(
                      backgroundColor: AppColor.primaryColorDark,
                      radius: 8,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Lungs Points',
                    style: MyTextTheme.mediumPCN,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),

              Visibility(
                visible: stethoController.getTappedBodyPoint != '',
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      stethoController.getTappedBodyPoint.toString(),
                      style: MyTextTheme.mediumBCN,
                    )),
                    MyButton(
                      title: 'Record Data',
                      width: 150,
                      onPress: () {
                        if (stethoController.getIsDeviceConnected) {
                          stethoController.readStethoData(
                              context, 'record_data');
                        } else {
                          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Connect your device'));
                          // alertToast(context, 'Connect your device');
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          );
        });
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

  updateWifi() {
    return Form(
      key: stethoController.wifiFormKey.value,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
              controller: stethoController.hotspotName.value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wifi),
                labelText: 'Hotspot Name',
                hintText: 'Enter Hotspot name',
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please Enter Hotspot name';
                }
              }),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: stethoController.hotspotPass.value,
              obscureText: isoBscureText ? true : false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Enter Password',
                prefixIcon: const Icon(Icons.password),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      isoBscureText = !isoBscureText;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(isoBscureText
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
                labelText: 'Hotspot Password',
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please Enter Hotspot Password';
                }
              }),
          const SizedBox(
            height: 25,
          ),
          MyButton(
            title: 'Update Wifi',
            onPress: () {
              if (stethoController.wifiFormKey.value.currentState!.validate()) {
                if (stethoController.getIsDeviceConnected) {
                  stethoController.readStethoData(context, 'update_wifi_name');
                  Future.delayed(const Duration(seconds: 2), () {
                    stethoController.readStethoData(
                        context, 'update_wifi_pass');
                  });
                } else {
                  Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Connect your device'));
                  // alertToast(context, 'Connect your Device');
                }
              }
            },
          )
        ],
      ),
    );
  }

  ListenWidget() {
    return Form(
      key: stethoController.listenFormKey.value,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
              controller: stethoController.pidC.value,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.perm_identity),
                border: OutlineInputBorder(),
                labelText: 'PID',
                hintText: 'Enter PID',
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please Enter PID';
                }
              }),
          const SizedBox(
            height: 25,
          ),
          MyButton(
            title: 'Connect',
            onPress: () async {
              if (stethoController.listenFormKey.value.currentState!
                  .validate()) {
                await stethoController.listenData(context);
              }
            },
          )
        ],
      ),
    );
  }

  settingWidget() {
    return GetBuilder(
        init: StethoscopeController(),
        builder: (_) {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.primaryColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text("StethoScope Remote Control",
                      style: MyTextTheme.mediumBCB),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     if (stethoController.getIsDeviceConnected) {
                      //       if (!stethoController.getIsHeartMode) {
                      //         stethoController.readStethoData(
                      //             context, 'mode_change');
                      //       }
                      //     } else {
                      //       alertToast(context, 'Connect your device');
                      //     }
                      //   },
                      //   child: CircleAvatar(
                      //     backgroundColor: AppColor.white,
                      //     radius: 25,
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(top: 2.5),
                      //       child: stethoController.getIsHeartMode
                      //           ? FadeTransition(
                      //               opacity: _animationController,
                      //               child: SvgPicture.asset(
                      //                   'assets/HeartrateS.svg',
                      //                   width: 35,
                      //                   fit: BoxFit.fitWidth,
                      //                   color: AppColor.red))
                      //           : SvgPicture.asset(
                      //               'assets/HeartrateS.svg',
                      //               width: 35,
                      //               fit: BoxFit.fitWidth,
                      //               color: AppColor.red,
                      //             ),
                      //     ),
                      //   ),
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     if (stethoController.getIsDeviceConnected) {
                      //       if (stethoController.getIsHeartMode) {
                      //         stethoController.readStethoData(
                      //             context, 'mode_change');
                      //       }
                      //     } else {
                      //       alertToast(context, 'Connect your device');
                      //     }
                      //   },
                      //   child: CircleAvatar(
                      //       backgroundColor: AppColor.white,
                      //       radius: 25,
                      //       child: !stethoController.getIsHeartMode
                      //           ? FadeTransition(
                      //               opacity: _animationController,
                      //               child: SvgPicture.asset(
                      //                 'assets/lungs.svg',
                      //                 width: 35,
                      //                 fit: BoxFit.fitWidth,
                      //               ))
                      //           : SvgPicture.asset(
                      //               'assets/lungs.svg',
                      //               width: 35,
                      //               fit: BoxFit.fitWidth,
                      //             )),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: const Size(160, 50),
                            backgroundColor: Colors.orange),
                        onPressed: () async {
                          if (stethoController.getIsDeviceConnected) {
                            await stethoController.batteryPercentage(context);
                          } else {
                            Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Connect your device'));
                            // alertToast(context, 'Connect your device');
                          }
                        },
                        child: Row(
                          children: [
                            Text("Battery ", style: MyTextTheme.mediumWCB),
                            Text(
                                '${stethoController.getBatteryPercentage.toString()}%',
                                style: MyTextTheme.mediumWCB),
                            batteryPer(90)
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: const Size(160, 50),
                            backgroundColor: Colors.orange),
                        onPressed: () {
                          // recodingModule(context);
                          stethoController.readStethoData(
                              context, 'record_data');
                        },
                        child: const Text(
                          "Record Data",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: const Size(160, 50),
                            backgroundColor: Colors.orange),
                        onPressed: () {
                          // updateWifiModule(context);
                        },
                        child: const Text(
                          "Update Wifi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: const Size(160, 50),
                            backgroundColor: Colors.orange),
                        onPressed: () {
                          stethoController.readStethoData(context, 'file_list');
                        },
                        child: const Text(
                          "File List",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            minimumSize: const Size(160, 50),
                            backgroundColor: Colors.orange),
                        onPressed: () {
                          // listenModule(context);
                        },
                        child: const Text(
                          "Listen",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: const Size(160, 50),
                            backgroundColor: Colors.orange),
                        onPressed: () async {
                          // addPatientModule(context);
                          await stethoController.onPressedAddInfo(context);
                        },
                        child: const Text(
                          "Add Patient",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ));
        });
  }

  batteryPer(val) {
    if (val <= 15) {
      return Icon(
        Icons.battery_0_bar,
        color: AppColor.red,
        size: 22,
      );
    } else if (val > 15 && val <= 30) {
      return Icon(
        Icons.battery_1_bar,
        color: AppColor.red,
        size: 22,
      );
    } else if (val > 30 && val <= 45) {
      return Icon(
        Icons.battery_2_bar,
        color: AppColor.green,
        size: 22,
      );
    } else if (val > 45 && val <= 60) {
      return Icon(
        Icons.battery_3_bar,
        color: AppColor.green,
        size: 22,
      );
    } else if (val > 60 && val <= 75) {
      return Icon(
        Icons.battery_4_bar,
        color: AppColor.green,
        size: 22,
      );
    } else if (val > 75 && val <= 90) {
      return Icon(
        Icons.battery_5_bar,
        color: AppColor.green,
        size: 22,
      );
    } else if (val > 90 && val <= 100) {
      return Icon(
        Icons.battery_6_bar,
        color: AppColor.green,
        size: 22,
      );
    }
  }
}
