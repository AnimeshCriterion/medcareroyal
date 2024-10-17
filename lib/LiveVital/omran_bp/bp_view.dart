
import 'package:bluetooth_state/bluetooth_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Localization/app_localization.dart';
import '../../View/widget/common_method/show_progress_dialog.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../common_libs.dart';
import '../live_vital_controller.dart';
import 'bp_controller.dart';

class bpscreen extends StatefulWidget {
  const bpscreen({super.key});

  @override
  State<bpscreen> createState() => _bpscreenState();
}

class _bpscreenState extends State<bpscreen> {

  BPController controller=Get.put(BPController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
    controller.devicesData=null;
    controller.update();
  await  controller.scanDevices();


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<BPController>();
  }
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Blood Pressure Data'),
             centerTitle: true,
          foregroundColor: AppColor.black,
          backgroundColor: AppColor.white,
        ),
        body: WillPopScope(
          onWillPop: ( ){
            try{
              Get.back();
              BluetoothState().requestDisableBluetooth();
              controller.subscription!.cancel();
              controller.subscription1!.cancel();
              controller.devicesData!.disconnect();
            }catch(e){

            }
            return Future.value(false);
          },
          child: GetBuilder(
            init: BPController(),
            builder: (_) {
              return    Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [],
                  ),
                  SizedBox(height: 15,),
                 ( controller.getIsScanning && !controller.getIsFound)  ?  Text('Scanning...',style: MyTextTheme.mediumBCB,):
                 Column(
                   children: [
                     SizedBox(
                       width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.05 : MediaQuery.of(context).size.width/1.2,
                       height: 60,
                       child: ElevatedButton(
                         style: ElevatedButton.styleFrom(
                           backgroundColor:AppColor.green,
                         ),
                         child: Text('Scan',
                           style: TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.w600,
                             color: Colors.white,
                           ),
                         ),
                         onPressed: () async {
                           await controller.scanDevices();
                         },
                       ),
                     ),

                     !controller.getIsFound? Column(
                       children: [
                         SizedBox(height: 101,),
                         Text('Device Not Found',style: MyTextTheme.mediumBCB),
                       ],
                     ):SizedBox(),
                   ],
                 ),

                  /// device scan code
                  controller.getIsFound?   Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.05 : MediaQuery.of(context).size.width/1.2,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.green,
                            ),
                            child: Text('Get Data',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
                              Future.delayed(Duration(seconds: 3)).then((value) async {

                                await controller.tempData(context);
                                ProgressDialogue().hide();
                              });

                            },
                          ),
                        ),
                      ),

                      Row(

                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.74,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.green, width: 2.5),
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              child: Text(
                                 'Systolic (mmHg): '+controller.getSys.toString() ,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color:AppColor.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              alignment: Alignment.center,
                            ),
                          ),

                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.74,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                  border: Border.all(color:AppColor.green, width: 2.5),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: Text(
                                'Diastolic (mmHg) :'+controller.getDia.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              alignment: Alignment.center,
                            ),
                          ),

                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.74,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                  border: Border.all(color:AppColor.green, width: 2.5),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: Text(
                                'Pluse Rate (min): '+controller.getPr.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color:AppColor.black,
                                ),
                                //textAlign: TextAlign.center,
                              ),
                              alignment: Alignment.center,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ):SizedBox(),
                  // controller.getSys==''? SizedBox():Padding(
                  //   padding: const EdgeInsets.only(top: 10.0),
                  //   child: SizedBox(
                  //     width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.05 : MediaQuery.of(context).size.width/1.2,
                  //     height: 60,
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: AppColor.primaryColor,
                  //       ),
                  //       child: Text('Save Data',
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.w600,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //       onPressed: () async {
                  //         await  LiveVitalModal().addVitalsData(context,BPDias: controller.getDia.toString(),
                  //             BPSys: controller.getSys,pr: controller.getPr.toString() );
                  //       },
                  //     ),
                  //   ),
                  // ),

                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
