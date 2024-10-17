import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/devices_with_new_ui/device_connnect_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../LiveVital/pmd/my_text_theme.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/neomorphic/neomorphic.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import '../LiveVital/live_vital_controller.dart';
import 'add_device_connect.dart';
import 'device_list_data_data_modal.dart';

class BpDeviceDataView extends StatefulWidget {

  const BpDeviceDataView({super.key, });

  @override
  State<BpDeviceDataView> createState() => _BpDeviceDataViewState();
}

class _BpDeviceDataViewState extends State<BpDeviceDataView> {

  DeviceConnectController controller=Get.put(DeviceConnectController());





  onPressBack() async {
    try{

      await controller.subscription1!.cancel();
      controller.updateSelectedDeviceIndex = '';
      await controller.devicesData!.disconnect();


      await  controller.subscription!.cancel();
      controller.update();
    }
    catch(e){

      if(controller.subscription!=null){
        await  controller.subscription!.cancel();
      }

    }
    Get.back();
    controller.updateSelectedDevice = Map.from({});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) => get());

  }

  get() async {
    controller.updateMesasringbpValue='0.0';
    controller.updateIsMeasring=false;
    controller.updatePr='00';
    controller.updateBpSys='00';
    controller.updateBpDia='00';
    controller.updateSpo2='00';

      await controller.deviceData();

    await controller.connectionState();

  }
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return GetBuilder(
        init: DeviceConnectController(),
        builder: (_) {
        return Container(
          color: AppColor.green,
          child: SafeArea(
            child: Scaffold(
              // appBar: CustomAppBar(
              //     titleColor:
              //         themeChange.darkTheme ? AppColor.white : AppColor.greyDark,
              //     color: themeChange.darkTheme == true
              //         ? AppColor.blackDark2
              //         : AppColor.neoBGWhite1,
              //     primaryBackColor:
              //         themeChange.darkTheme ? AppColor.white : AppColor.greyDark,
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
                    color: controller.isConnected?  AppColor.green:AppColor.red),
                SizedBox(
                  width: 3,
                ),
                controller.isConnected?   Text(
                  "Connected" ,
                  style: MyTextTheme().mediumBCB.copyWith(color: AppColor.green),
                ):Text(
                  "Disconnected" ,
                  style: MyTextTheme().mediumBCB.copyWith(color: AppColor.red),
                ),
              ],
            ),
            SizedBox(height: 15,),

            controller.getIsMeasring?   Column(
              children: [
                JumpingText(
                  "Measuring...",
                  style: MyTextTheme().mediumGCN.copyWith(
                      color: AppColor.green,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 15,),
              ],
            ):SizedBox(),

            // Column(
            controller.getMeasringbpValue!='0.0'?   Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SvgPicture.asset('assets/blood_pressure.svg',color: Colors.green,),
                    Positioned(
                      top: 51,
                      left: 0,
                      right: 0,
                      child: CircularPercentIndicator(
                        circularStrokeCap: CircularStrokeCap.round,
                        radius: 100.0,
                        lineWidth: 10.0,
                        percent: double.parse(
                            controller.getMeasringbpValue.toString())>=200.0? 200:double.parse(
                            controller.getMeasringbpValue.toString()) / 300,

                        center: Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Text(' '.toString()),
                        ),
                        progressColor: AppColor.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Text( controller.getMeasringbpValue.toString()+' mmHg' ,style: MyTextTheme().largePCB)
              ],
            ):  Column(
              children: [
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
                controller.getSelectedDevice.deviceType=='Oximeter'?Column(
                  children: [
                    SizedBox(height: 10,),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child:dataWidget(
                            dataType: "Spo2",
                            bpdata: controller.getSpo2.toString(),
                            dataTypeImage: "assets/add_device/heart_attack.png",
                            unit: "min"
                        )),
                    SizedBox(height: 10,),
                  ],
                ):SizedBox(),
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
                      //    MyTextTheme().smallWCN.copyWith(
                      //      color: Colors.green
                      //    )),
                    ])),
              ],
            ),

            // Text("Your blood pressure reading Score\n are With a ",
            // style: MyTextTheme().mediumWCN.copyWith(color: themeChange.darkTheme?AppColor.grey:AppColor.greyDark,
            // fontWeight: FontWeight.w500,fontSize: 13),),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: NeoButton(
                  title: "Save",

                  func: () async {
                    // await controller.deviceData();
                    await  LiveVitalModal(). addVitals(context,
                        BPSys: controller.getBpSys.toString(),
                        BPDias:controller.getBpDia.toString(),
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
