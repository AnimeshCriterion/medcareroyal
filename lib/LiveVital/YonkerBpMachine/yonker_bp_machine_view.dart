import 'dart:async';

import 'package:medvantage_patient/LiveVital/YonkerBpMachine/yonker_bp_machine_controller.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../app_manager/alert_toast.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import '../live_vital_controller.dart';


class YonkerBpMachineView extends StatefulWidget {
  const YonkerBpMachineView({Key? key}) : super(key: key);

  @override
  State<YonkerBpMachineView> createState() => _YonkerBpMachineViewState();
}

class _YonkerBpMachineViewState extends State<YonkerBpMachineView> {
  YonkerBpMachineController controller = Get.put(YonkerBpMachineController());


  get() async {
    controller.updateIsMeasuring=true;
    await controller.getDevices();


    // controller.timer =
    //     Timer.periodic(const Duration(seconds: 15), (timer) async {
    //       controller.CheckUserConnection();
    //
    //       /// callback will be executed every 1 second, increament a count value
    //       /// on each callback
    //
    //       if (controller.getActiveConnection) {
    //         await controller.addVitalsData(context,BPDias: controller.getBpData['dia'],BPSys: controller.getBpData['sys'],pr: controller.getBpData['pr']
    //
    //         );
    //       }
    //       // tempList.add(val);
    //     });
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
    Get.delete<YonkerBpMachineController>();
    controller.timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(
          child: GetBuilder(
              init: YonkerBpMachineController(),
              builder: (_) {
                return Scaffold(
                  backgroundColor: themeChange.darkTheme
                      ? AppColor.darkshadowColor1
                      : AppColor.lightshadowColor1,
                  appBar: CustomAppBar(color:  themeChange.darkTheme
                      ? AppColor.darkshadowColor1
                      : AppColor.lightshadowColor1,
                      title: "Yonker BP Machine", actions: [
                    Visibility(
                      visible: controller.getIsDeviceFound,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 110,
                          child: PrimaryButton(
                            title: controller.getIsConnected
                                ? 'Connected'
                                : 'Connect',
                            onPressed: () async {
                              if (!controller.getIsConnected) {
                                await controller.getData(context);
                              } else {
                                Alert.show( 'Device already connected');
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ]),
                  body:   !controller.getIsDeviceFound
                      ? controller.getIsScanning
                      ? scanDevice()
                      : connectDevice()
                      :Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.55,
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(45),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                                spreadRadius: 5,
                                offset: Offset(10, -10))
                          ]),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.54,
                        width: MediaQuery.of(context).size.width / 1.2,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(45)),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 2.1,
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(45)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 10, 5, 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'SYS',
                                              style: MyTextTheme.largeBCB,
                                            ),
                                            const Text('mmHg')
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'DIA',
                                              style: MyTextTheme.largeBCB,
                                            ),
                                            const Text('mmHg')
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'PLUSE',
                                              style: MyTextTheme.largeBCB,
                                            ),
                                            const Text('/min')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        2.8,
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade700,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: controller.getIsMeasuring
                                        ? Center(
                                            child: Text(
                                              controller.getMeasuringData
                                                  .toString(),
                                              style: MyTextTheme
                                                  .veryLargeBCB
                                                  .copyWith(fontSize: 45),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                25, 0, 10, 8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller.getBpData['sys']
                                                      .toString(),
                                                  style: MyTextTheme
                                                      .veryLargeBCB
                                                      .copyWith(fontSize: 45),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      55,
                                                ),
                                                Text(
                                                  controller.getBpData['dia']
                                                      .toString(),
                                                  style: MyTextTheme
                                                      .veryLargeBCB
                                                      .copyWith(fontSize: 45),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      55,
                                                ),
                                                Text(
                                                  controller.getBpData['pr']
                                                      .toString(),
                                                  style: MyTextTheme
                                                      .veryLargeBCB
                                                      .copyWith(fontSize: 45),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: !controller.getIsMeasuring,
                                      child: InkWell(
                                        onTap: () async {
                                        await  LiveVitalModal().addVitalsData(context,BPDias: controller.getBpData['dia'],
                                              BPSys: controller.getBpData['sys'],pr: controller.getBpData['pr'] );

                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          decoration: BoxDecoration(
                                              color: AppColor.primaryColor,
                                              borderRadius: BorderRadius.circular(45),
                                              border: Border.all(
                                                  color: Colors.black45, width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: controller.getIsConnected
                                                        ? AppColor.primaryColor
                                                        : Colors.grey,
                                                    spreadRadius:
                                                    controller.getIsConnected
                                                        ? 4
                                                        : 2,
                                                    blurRadius: 10)
                                              ]),
                                          child: Text(
                                            'Save',
                                            style: MyTextTheme.smallWCB,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(

                                      onTap: () async {
                                        if(controller.getIsDeviceFound){
                                          if (!controller.getIsConnected) {
                                            await controller.getData(context);
                                          } else {
                                            Alert.show(
                                                'Device already connected');
                                          }
                                        }else{

                                          Alert.show(
                                            'Connect your Device');

                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: AppColor.primaryColor,
                                            borderRadius: BorderRadius.circular(45),
                                            border: Border.all(
                                                color: Colors.black45, width: 2),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: controller.getIsConnected
                                                      ? AppColor.primaryColor
                                                      : Colors.grey,
                                                  spreadRadius:
                                                      controller.getIsConnected
                                                          ? 4
                                                          : 2,
                                                  blurRadius: 10)
                                            ]),
                                        child: Text(
                                          'Start|Stop',
                                          style: MyTextTheme.smallWCB,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }



  connectDevice() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Device Not Found',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 15,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 35,
              ),
            ),
            onPressed: () async {
              await controller.getDevices();
            },
          ),
        ],
      ),
    );
  }

  scanDevice() {
    return Center(
        child: Lottie.asset('assets/scanning.json', fit: BoxFit.fill));
  }
}
