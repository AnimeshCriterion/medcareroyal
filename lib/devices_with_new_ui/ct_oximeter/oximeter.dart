

import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oximeter/flutter_oximeter.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../LiveVital/live_vital_controller.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/neomorphic/neomorphic.dart';
import '../../LiveVital/pmd/my_text_theme.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/tab_responsive.dart';
import '../../theme/theme.dart';
import '../add_device_connect.dart';
import '../device_connnect_controller.dart';
import '../device_list_data_data_modal.dart';


class Oximeters extends StatefulWidget {
  const Oximeters({Key? key}) : super(key: key);

  @override
  State<Oximeters> createState() => _OximetersState();
}

class _OximetersState extends State<Oximeters> {

  DeviceConnectController controller=Get.put(DeviceConnectController());
  bool isScanning = false;
  bool isConnected = false;
  bool foundDevice = false;
  String macAddress = '';

  StreamSubscription? subscriptionss;


  FlutterOximeter oxi=FlutterOximeter();
  StreamSubscription? subscription;


  @override
  void initState() {
    super.initState();
    initPlatformState();


  }

  @override
  void dispose() {

    super.dispose();
    subscription!.cancel();
    oxi.disConnect(macAddress: macAddress);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {

      controller.updatePr='00';
      controller.updateBpSys='00';
      controller.updateBpDia='00';
      controller.updateSpo2='00';
    });

    subscriptionss=  oxi.detectedDataStream.listen((event) {
      controller.updateSpo2=event.spo2.toString();
      controller.updatePr=event.heartRate.toString();
    });
  }

  onPressBack() async {
    try{
      controller.updateSelectedDeviceIndex = '';
      oxi.disConnect(macAddress: controller.macAddress.toString());
      controller.selectedDevice =
          DeviceListDataModal.fromJson(Map<String, dynamic>.from({}));

        // controller.timer!.cancel();
        // controller.subscriptions!.cancel();

        await subscription!.cancel();

    }catch(e){

    } Get.back();
  }
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return    GetBuilder(
        init: DeviceConnectController(),
    builder: (_) {
    return  Container(
      color: AppColor.white,
      child: SafeArea(
        child: Scaffold(
          // appBar: CustomAppBar(
          //     titleColor:
          //     themeChange.darkTheme ? AppColor.white : AppColor.greyDark,
          //     color: themeChange.darkTheme == true
          //         ? AppColor.blackDark2
          //         : AppColor.neoBGWhite1,
          //     primaryBackColor:
          //     themeChange.darkTheme ? AppColor.white : AppColor.greyDark,
          //     title: controller.getSelectedDevice.name.toString()),
          body: WillPopScope(
            onWillPop: () async {
              await onPressBack();
              return Future.value(false);
            },
            child: Column(
              children: [
                Row(children: [
                  InkWell(
                    onTap: () async {
                      await onPressBack();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  Text(controller.getSelectedDevice.name.toString(),style: MyTextTheme().largeBCB,)
                ],),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            themeChange.darkTheme == true
                                ? AppColor.blackDark2
                                : AppColor.neoBGWhite1,
                            themeChange.darkTheme == true
                                ? AppColor.blackDark2
                                : AppColor.neoBGWhite1,
                            themeChange.darkTheme == true
                                ? AppColor.blackDark2
                                : AppColor.neoBGWhite1,
                            themeChange.darkTheme == true
                                ? AppColor.black.withOpacity(.8)
                                : AppColor.neoBGWhite1,
                          ]),
                      color: Colors.grey.shade800,
                    ),
                    child: deviceConnected(image: controller.getSelectedDevice.image.toString()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    }
    );
  }


  deviceConnected({image}) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    return GetBuilder(
        init: DeviceConnectController(),
        builder: (_) {
          return Column(
            children: [
              Image.asset(
                image.toString(),
                fit: BoxFit.fitWidth,
                width: 200,

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/add_device/mobile_conn.png",
                      color: AppColor.green),
                  SizedBox(
                    width: 3,
                  ),
                  Text( controller.isConnected?
                  "Connected": "Disconnect",
                    style: MyTextTheme().mediumBCB.copyWith(color: AppColor.green),
                  ),
                ],
              ),
            SizedBox(height: 15,),
            controller.getSelectedDevice.deviceType=='BP Machine'?  Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                child: Row(
                  children: [
                    Expanded(child: dataWidget(bpdata: controller.getBpSys.toString(),
                        dataType: "Systolic",
                        dataTypeImage: "assets/add_device/bp_guage.png",
                        unit: "mmHg")),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: dataWidget(bpdata:  controller.getBpDia.toString(),
                        dataType: "Diastolic",
                        dataTypeImage: "assets/add_device/bp_guage.png",
                        unit: "mmHg"))
                  ],
                ),
              ):SizedBox(),
              SizedBox(height: 10,),
              controller.getSelectedDevice.deviceType=='Oximeter'?Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child:dataWidget(
                      dataType: "Spo2",
                      bpdata: controller.getSpo2.toString(),
                      dataTypeImage: "assets/add_device/heart_attack.png",
                      unit: "min"
                  )):SizedBox(),
              SizedBox(height: 10,),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child:dataWidget(
                      dataType: "Pulse Rate",
                      bpdata: controller.getPr.toString(),
                      dataTypeImage: "assets/add_device/heart_attack.png",
                      unit: "min"
                  )),

              SizedBox(height: 10,),
              RichText(
                  text: TextSpan(children: [
                    controller.getSelectedDevice.deviceType!='Oximeter'? TextSpan(
                        text: "${"Your blood pressure reading Score " } ",
                        style:
                        MyTextTheme().smallWCN.copyWith(color: themeChange.darkTheme?AppColor.grey:AppColor.greyDark,
                        )):TextSpan(
                        text: "${"Your SPO2 and Pulse reading Score " } ",
                        style:
                        MyTextTheme().smallWCN.copyWith(color: themeChange.darkTheme?AppColor.grey:AppColor.greyDark,
                        )),
                    // TextSpan(
                    //     text:"normal range",
                    //     style:
                    //     MyTextTheme().smallWCN.copyWith(
                    //         color: Colors.green
                    //     )),
                  ])),

              // Text("Your blood pressure reading Score\n are With a ",
              // style: MyTextTheme().mediumWCN.copyWith(color: themeChange.darkTheme?AppColor.grey:AppColor.greyDark,
              // fontWeight: FontWeight.w500,fontSize: 13),),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: NeoButton(
                    title: "Save",

                    func: () async {
                      await  LiveVitalModal(). addVitals(context,

                          pr: controller.getPr.toString(),
                          spo2: controller.getSpo2.toString()
                      );
                    }),
              ),

            ],
          );
        }
    );
  }

  dataWidget({required String bpdata, required String dataType ,required String dataTypeImage, required String unit}) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeChange.darkTheme
              ? AppColor.neoBGGrey1.withOpacity(.5)
              : AppColor.grey.withOpacity(.5)),
      child: Column(
        children: [
          Text(
            bpdata.toString(),
            style: MyTextTheme().mediumWCB.copyWith(
                fontSize: 25,
                color:
                themeChange.darkTheme ? AppColor.white : AppColor.greyDark),
          ),
          Text(
            unit.toString(),
            style: MyTextTheme().smallWCB.copyWith(
                color:
                themeChange.darkTheme ? AppColor.grey : AppColor.greyDark,
                height: .6),
          ),
          SizedBox(height: 3,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(dataTypeImage.toString()),
              SizedBox(width: 5,),
              Text(
                dataType,
                style: MyTextTheme().mediumWCN.copyWith(
                    fontSize: 18,
                    color:
                    themeChange.darkTheme ? AppColor.grey : AppColor.greyDark,
                    fontWeight: FontWeight.w600),
              ),

            ],
          )
        ],
      ),
    );
  }
}
