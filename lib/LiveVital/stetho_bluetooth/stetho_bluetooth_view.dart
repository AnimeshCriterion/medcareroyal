


import 'dart:async';
import 'dart:io';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:app_settings/app_settings.dart';
import 'package:audio_input_type_plugin/audio_input_type_plugin.dart';
import 'package:audio_session/audio_session.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:medvantage_patient/LiveVital/stetho_bluetooth/stetho_bluetooth_controller.dart';
import 'package:medvantage_patient/app_manager/alert_dialogue.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/neomorphic/neomorphic.dart';
import 'package:medvantage_patient/app_manager/theme/theme_provider.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/custom_ink_well.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/custom_sd.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../authenticaton/user_repository.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import 'archive/archive_view.dart';


class StethoBluetoothView extends StatefulWidget {

  const StethoBluetoothView({super.key,  });

  @override
  _StethoBluetoothViewState createState() => _StethoBluetoothViewState();
}

class _StethoBluetoothViewState extends State<StethoBluetoothView> {

  StethoBluetoothController stethoController = Get.put(StethoBluetoothController());

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    stethoController.audioRecorder = AudioRecorder();
    if(Platform.isAndroid){
      await AndroidAudioManager().startBluetoothSco();
      await AndroidAudioManager().setBluetoothScoOn(true);
    }
    AudioSession.instance;

    AudioSessionConfiguration(
      // avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
      avAudioSessionMode: AVAudioSessionMode.defaultMode, );

    stethoController.update();
    await stethoController.webSocketConnect(context);
    await stethoController.initPlugin();
  }

  @override
  void dispose() {
     Get.delete<StethoBluetoothController>();
    stethoController.micStream.cancel();
    stethoController.timer!.cancel();
    stethoController.audioRecorder.dispose();
    stethoController.subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    List bodyPartList = [frontHeart(), frontLungs(), backLungs()];

    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    return Container(color: AppColor.bgDark,
      child: SafeArea(
        child: GetBuilder(
          init: StethoBluetoothController(),
          builder: (_) {
            return Scaffold(
              backgroundColor:
            themeChange.darkTheme ? AppColor.bgDark :
            AppColor.bgWhite,
              appBar: AppBar(
                backgroundColor: themeChange.darkTheme ? AppColor.bgDark :
                AppColor.bgWhite,
                foregroundColor: themeChange.darkTheme?Colors.white:Colors.grey,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Stethoscope'),
                    Text('${userRepository.getUser.patientName} (${userRepository.getUser.uhID})',style: MyTextTheme.smallWCN.copyWith(color:themeChange.darkTheme==false ? AppColor.bgDark : AppColor.bgWhite),)
                  ],
                ),
                actions: [

                  // Bluetooth ON/OFF
                  // Container(
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: EdgeInsets.only(right: 5),
                  //         child: ElevatedButton(
                  //           child: Text('Pair',
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w500,
                  //               color: Colors.blue,
                  //             ),
                  //           ),
                  //           onPressed: () async {
                  //
                  //             // await AndroidAudioManager().startBluetoothSco();
                  //             // await AndroidAudioManager().setBluetoothScoOn(true);
                  //
                  //             AppSettings.openAppSettings(
                  //               type: AppSettingsType.bluetooth,);
                  //
                  //
                  //           },
                  //           style: ElevatedButton.styleFrom(
                  //             backgroundColor: Colors.white,
                  //             fixedSize: Size(101, 45),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                      PopupMenuButton(
                          shadowColor: Colors.grey,
                      child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.more_vert,color: Colors.black,size: 35,),
            ),
            itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 1,
                child: Text('History',style: MyTextTheme.mediumBCB),
              ),];
            },
            onSelected: (val) async {
            print('nnnnnnnn$val');
            switch(val) {
            case 1:
      // BluetoothState().requestDisableBluetooth();
              //
              // await AndroidAudioManager().stopBluetoothSco();
              // await AndroidAudioManager().setBluetoothScoOn(false);

              Get.to(ArchiveView());

            break;
            case 2:
            break;
            } } )
                ],
              ),
              body:  WillPopScope(
                onWillPop: () {
                   Get.back();
                  stethoController.micStream.cancel();
                  stethoController.audioRecorder.dispose();
                  stethoController.subscription!.cancel();
                  Get.delete<StethoBluetoothController>();
                  stethoController.timer!.cancel();
              return  Future.value(false);
            },
                child: Container(
                  height: Get.height,
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      themeChange.darkTheme ? AppColor.bgDark : AppColor.bgWhite,
                      themeChange.darkTheme ? AppColor.bgDark : AppColor.bgWhite,
                      themeChange.darkTheme ? AppColor.bgDark : AppColor.bgWhite,
                    ],
                  ),
                ),
                  child: SingleChildScrollView(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: MyButton2(title: 'Pair Your Stethoscope',
                        //     onPress: () async {
                        //     // stethoController.isRecording=true;
                        //     //   AndroidAudioManager().currentScoAudioState;
                        //     // await AndroidAudioManager().startBluetoothSco();
                        //     // await AndroidAudioManager().setBluetoothScoOn(true);
                        //     // await stethoController.initPlugin();
                        //     // await stethoController.onPressesStartStropRecording();
                        //     //   Get.to(StethoRecordingView());
                        //
                        //       await AndroidAudioManager().startBluetoothSco();
                        //       await AndroidAudioManager().setBluetoothScoOn(true);
                        //
                        //       AppSettings.openAppSettings(
                        //         type: AppSettingsType.bluetooth, );
                        //
                        //
                        //   },),
                        // ),
                        ///
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: CustomSD(
                        //       listToSearch: stethoController.bodyList,
                        //       valFrom: 'name',
                        //       hideSearch: true,
                        //       borderColor: Colors.grey,
                        //       initialValue: const [
                        //         {
                        //           'parameter': 'name',
                        //           'value':'Cardiac Auscultation (Front Heart)',
                        //         }
                        //       ],
                        //       height: 150,
                        //       label: 'Select Body Part',
                        //       onChanged: (val) {
                        //         if (val != null) {
                        //           stethoController.updateSelectedBodyTab =
                        //               int.parse(val['id'].toString());
                        //
                        //
                        //         }
                        //       }),
                        // ),

                        Visibility(
                            child: bodyPartList[stethoController.getSelectedBodyTab]),

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Click on the points to record data:',style: MyTextTheme.mediumGCN.copyWith(fontStyle: FontStyle.italic)),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0,left: 10,bottom: 10),
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white,width: 3),
                                      color: Colors.green,
                                      shape: BoxShape.circle
                                  ),),
                              )
                            ],
                          ),
                        ),

                        SizedBox(
                          child: Row(
                            children: [
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: (){
                                  if(stethoController.getSelectedBodyTab>0){
                                    stethoController.updateSelectedBodyTab=stethoController.getSelectedBodyTab-1;
                                  }else{
                                    stethoController.updateSelectedBodyTab=stethoController.bodyList.length-1;
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child:  Center(child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.arrow_back_ios,color: AppColor.green,size: 20,),
                                  )),
                                ),
                              ),
                              Expanded(
                                child:  Column(
                                  children: [
                                    Text(stethoController.bodyList[stethoController.getSelectedBodyTab]['name'].toString(),style: MyTextTheme.mediumBCB.copyWith(fontSize: 18,color: themeChange.darkTheme?Colors.white:Colors.black),textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  if(stethoController.getSelectedBodyTab<stethoController.bodyList.length-1){
                                    stethoController.updateSelectedBodyTab=stethoController.getSelectedBodyTab+1;
                                  }else{
                                    stethoController.updateSelectedBodyTab=0;
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child:  Center(child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Icon(Icons.arrow_forward_ios_outlined,color: AppColor.green,size: 20,),
                                  )),
                                ),
                              ),
                              const SizedBox(width: 20,),

                            ],),
                        ),

                        const SizedBox(height: 10,),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text('Click on these point to record data : ',style:themeChange.darkTheme ?
                        //       MyTextTheme.mediumWCB:MyTextTheme.mediumPCB,),
                        //       const SizedBox(width: 15,),
                        //       CircleAvatar(
                        //         backgroundColor: AppColor.white,
                        //         radius: 12,
                        //         child: CircleAvatar(
                        //           backgroundColor:   AppColor.primaryColorDark,
                        //           radius: 10,
                        //         ),
                        //       ),
                        //       SizedBox(width: 15,),
                        //       CircleAvatar(
                        //         backgroundColor: AppColor.white,
                        //         radius: 12,
                        //         child: CircleAvatar(
                        //           backgroundColor: AppColor.green,
                        //           radius: 10,
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),

                        stethoController.getTappedBodyPoint.toString()==''?const SizedBox(height: 35,):  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Measuring Point : ',style:themeChange.darkTheme ?
                              MyTextTheme.mediumGCN:MyTextTheme.mediumPCN),
                              Expanded(child: Text(stethoController.getTappedBodyPoint.toString(),style:themeChange.darkTheme ?
                              MyTextTheme.mediumWCN: MyTextTheme.mediumBCN,)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        stethoController.getTimerVal<1?  Column(
                          children: [
                            SizedBox(
                              height: 35,
                              child: Sparkline(fillColor: Colors.green,
                                // pointsMode: PointsMode.last,
                                gridLineAmount: 50,gridLineColor: Colors.green,gridLineWidth: 3,
                                fillMode: FillMode.below,
                                lineWidth: 3 ,
                                lineColor: AppColor.green,


                                data: stethoController.getGraphData.toList().length < 74
                                    ? stethoController.getGraphData.toList()
                                    : stethoController.getGraphData
                                    .toList()
                                    .getRange(
                                    (stethoController.getGraphData.toList().length -
                                        74 ),
                                    stethoController.getGraphData.toList().length)
                                    .toList(),
                              ),
                            ),
                            Transform.rotate(
                              angle: 3.14159,
                              child:   SizedBox(
                                height: 35,
                                child: Sparkline(fillColor: Colors.green,
                                  // pointsMode: PointsMode.last,
                                  gridLineAmount: 50,gridLineColor: Colors.green,gridLineWidth: 3,
                                  fillMode: FillMode.below,
                                  lineWidth: 3 ,
                                  lineColor: AppColor.green,


                                  data: stethoController.getGraphData.toList().length < 74
                                      ? stethoController.getGraphData.toList()
                                      : stethoController.getGraphData
                                      .toList()
                                      .getRange(
                                      (stethoController.getGraphData.toList().length -
                                          74 ),
                                      stethoController.getGraphData.toList().length)
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ):

                        LinearPercentIndicator(
                          lineHeight: 15.0,
                          percent: stethoController.getTimerVal/15, // 50% progress
                          backgroundColor: Colors.grey[300],
                          progressColor: Colors.blue,
                          center: Text(
                            " ",
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            // InkWell(
                            //   onTap: () async {
                            //     stethoController.updateIsPlay=!stethoController.getIsPlay;
                            //    await stethoController.player.stopPlayer();
                            //
                            //   },
                            //   child: Container(
                            //     width: 150,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(15),
                            //         color: AppColor().orangeButtonColor
                            //     ),
                            //     child: Center(
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(15),
                            //         child: Text(stethoController.getIsPlay? 'Stop':'Play',style: MyTextTheme().mediumWCB,),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            //  SizedBox(width: 15,),

                            InkWell(
                              onTap: () async {
            String? microphone = await AudioInputTypePlugin.getConnectedMicrophone();
            // print("Connected Microphone: $microphone");

            if((microphone??'')=='Bluetooth Microphone'){
                                 // BluetoothState().requestEnableBluetooth();
                                if(stethoController.getTappedBodyPoint!=''){
                                  stethoController.updateTimerVal=1;
                                  if(!stethoController.isRecording){

                                    if(Platform.isAndroid){

                                  await AndroidAudioManager().startBluetoothSco();
                                  await AndroidAudioManager().setBluetoothScoOn(true);

                                  if (await AndroidAudioManager().isBluetoothScoOn()) {
                                  await stethoController.onPressesStartStropRecording(context);
                                  }
                                  else{
                                    Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Please turn on Bluetooth SCO'.toString()));
                                    // alertToast(context,'Please turn on Bluetooth SCO');
                                  }
                                }else{
                                  await stethoController.onPressesStartStropRecording(context);
                                }

                                }else{
                                    Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: 'Already Recording'.toString()));
                                    // alertToast(context,'Already Recording');
                                }
                                }else{
                                  Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: "Select Measuring Point".toString()));
                                  // alertToast(context,"Select Measuring Point");
                                }
            }
            else{
              Alert.show( 'Please pair your stethoscope.');
            }
                              },
                              child: Container(
                                width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColor.orangeButtonColor
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:stethoController.isRecording? countDown(): Text('Record',style: MyTextTheme.mediumWCB,),
                                    ),
                                  ),
                              ),
                            ),
                          ],
                        ),
                        //
                        // CustomShimmer().shimmerEffect(
                        //   shimmerValue: false,
                        //   showNoData: false,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //             child: Text(
                        //               "Ledger Report List",
                        //               style: MyTextTheme().largePCB,
                        //             )),
                        //         MyButton2(
                        //           title: 'Show',
                        //           color: Colors.grey,
                        //           width: 121,
                        //           onPress: () async {
                        //             // ProgressDialogues().show(context,);
                        //
                        //
                        //             CustomBottomSheet().show(context,
                        //               title: 'nnn',
                        //                 newWidget: [
                        //                   Container(
                        //                     height: 101,
                        //                   ),
                        //                 ],
                        //
                        //             );
                        //
                        //           },
                        //         )
                        //       ],
                        //     ),
                        //   ),),


                        // Start and stop with timer
                        // ElevatedButton(
                        //   onPressed: () async {
                        //    await stethoController.onPressesStartStropRecording();
                        //   },
                        //   child: Text(stethoController.isRecording
                        //       ? '${stethoController.minutes}:${stethoController.seconds.toString().padLeft(2,'0')}\n' + 'Stop'
                        //       : '${stethoController.minutes}:${stethoController.seconds.toString().padLeft(2,'0')}\n' + 'Start',
                        //     style: TextStyle(
                        //       fontSize: 15,
                        //       fontWeight: FontWeight.w500,
                        //       color: Colors.white,
                        //     ),
                        //     textAlign: TextAlign.center,
                        //   ),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.blue,
                        //     fixedSize: Size(150, 150),
                        //     shape: CircleBorder(
                        //         side: BorderSide(
                        //           style: BorderStyle.solid,
                        //           width: 2,
                        //           color: Colors.red,
                        //         )
                        //     ),
                        //   ),
                        // ),

                        // Recorded files
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }




  frontLungs() {
    return SizedBox(
      width: 400,
      child: Stack(
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
                'Right Lower anterior',
              )),
          Positioned(
              right: 80.w,
              top: 125.h,
              child: measurePointWidget(
                'Left Lower anterior',
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
      ),
    );
  }

  frontHeart() {
    return SizedBox(
      width: 400,
      height: 390,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Image.asset(
                    height: 370,
                    'assets/stethoMan.png',
                    fit: BoxFit.fitHeight,
                  ),
                  Positioned(
                    left: 135.w,
                    top: 120.h,
                    child: Image.asset(
                      'assets/stethoHeart.png',
                      height: 100,
                    ),
                  ),
                  Positioned(
                      left: 140.w,
                      top: 140.h,
                      child: measurePointWidget('Base Right (Aortic area)', isGreen: true)),
                  Positioned(
                      top: 140.h,
                      right: 90.w,
                      child: measurePointWidget('Base Left (Pulmonic area)', isGreen: true)),
                  Positioned(
                      top: 170.h,
                      right: 100.w,
                      child: measurePointWidget('Lower Left Sternal Border (Tricuspid area)',
                          isGreen: true)),
                  Positioned(
                      top: 174.h,
                      left: 135.w,
                      child: measurePointWidget('Apex (Mitral area)', isGreen: true)),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  backLungs() {
    return SizedBox(
      width: 400,
      height: 390,
      child: Center(
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
      ),
    );
  }


  measurePointWidget(tapedPoint, {isGreen}) {
    return GetBuilder(
        init: StethoBluetoothController(),
        builder: (_) {
          return Center(
            child: InkWell(
                onTap: () async {
                  stethoController.updateTappedBodyPoint = tapedPoint.toString();
                  // if(stethoController.getTappedBodyPoint!=' '){
                  //
                  //   stethoController.updateTappedBodyPoint = tapedPoint.toString();
                  //
                  //   // await AndroidAudioManager().startBluetoothSco();
                  //   // await AndroidAudioManager().setBluetoothScoOn(true);
                  //   //
                  //   // if(await AndroidAudioManager().isBluetoothScoOn()){
                  //   //   await stethoController.onPressesStartStropRecording(context);
                  //   // }else{
                  //   //   alert('Please turn on Bluetooth SCO');
                  //   // }
                  // }else{
                  //   alert("Already Measuring : ${stethoController.getTappedBodyPoint}");
                  // }
                },
                child: stethoController.getTappedBodyPoint.toString() ==
                    tapedPoint.toString()
                // &&
                // !controller.getIsTimeComplete == true
                    ? CircleAvatar(
                    backgroundColor: AppColor.black,
                    radius: 21,
                    child:     Lottie.asset(
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


  countDown(){
    return   SlideCountdown(style: MyTextTheme.mediumWCB,
      onChanged: (val){
      print('nnnnvnnnvnnnnnn '+val.toString());
      if(stethoController.getTimerVal<15){
          stethoController.updateTimerVal = stethoController.getTimerVal + 1;
        }
      },
      onDone: () => {

        // stethoController.updateTappedBodyPoint='',
      },
      duration:  const Duration(seconds: 16,),
      // fade: false,
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(5)
      ),
      // textStyle: MyTextTheme.mediumBCN.copyWith(
      //     color: Colors.grey[600]
      // )
    );
  }

}
