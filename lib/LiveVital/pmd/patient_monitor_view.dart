import 'dart:io';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:medvantage_patient/LiveVital/pmd/patient_monitor_controller.dart';
import 'package:medvantage_patient/LiveVital/pmd/patient_monitor_report.dart';
import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../View/widget/common_method/show_progress_dialog.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';


class MyPatientMonitorScreen extends StatefulWidget {
  const MyPatientMonitorScreen({Key? key}) : super(key: key);

  @override
  State<MyPatientMonitorScreen> createState() => _PatientMonitorScreenState();
}

class _PatientMonitorScreenState extends State<MyPatientMonitorScreen> {

  MyPatientMonitorController controller = Get.put(MyPatientMonitorController());



  /// Method for IOS
  ECGGraphDataFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/2510394_ECG_Graph_100Hz.txt');
    await file.writeAsString(controller.getHrGraphDataList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  SpO2GraphDataFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/2510394_SpO2_Graph.txt');
    await file.writeAsString(controller.getSpO2GraphDataList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  HRValueDataFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/2510394_HR.txt');
    await file.writeAsString(controller.getHrValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  SpO2ValueDataFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/2510394_SpO2.txt');
    await file.writeAsString(controller.getSpO2ValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  PRValueDataFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/2510394_PR.txt');
    await file.writeAsString(controller.getPrValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  TempValueDataFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/2510394_Temperature.txt');
    await file.writeAsString(controller.getTempValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  BpValueDataFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/2510394_BP.txt');
    await file.writeAsString(controller.getBpValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }



  /// Method for Android
  // graphDataFile() async {
  //   final Directory? directory = await getExternalStorageDirectory();
  //   final File file = File('${directory!.path}/2510394_${DateFormat("dd MMM yyyy, hh:mm:ss a").format(DateTime.now())}.txt');
  //   await file.writeAsString("ECG Graph Data : " + controller.getHrList.toString() + "\n\n"
  //       "SpO2 Graph Data : " + controller.getSpo2List.toString());
  // }
  //
  // valueDataFile() async {
  //   final Directory? directory = await getExternalStorageDirectory();
  //   final File file = File('${directory!.path}/2510394_2_${DateFormat("dd MMM yyyy, hh:mm:ss a").format(DateTime.now())}.txt');
  //   await file.writeAsString("Heart Rate Value : " + controller.getHrValueList.toString() + "\n\n"
  //       "SpO2 Value : " + controller.getSpO2ValueList.toString() + "\n\n"
  //       "Pulse Rate Value : " + controller.getPrValueList.toString() + "\n\n"
  //       "Temperature  Value : " + controller.getTempValueList.toString() + "\n\n"
  //       "Blood Pressure Value : " + controller.getBpValueList.toString());
  // }



  get() async {
         SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

   controller.pTimer(context);
   await controller.scanDevices();
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
    controller.timer1.cancel();
    controller.timer2.cancel();
    Get.delete<MyPatientMonitorController>();
    controller.scanSubscription!.cancel();
    controller.subscription1!.cancel();
    controller.subscription2!.cancel();
    controller.subscription3!.cancel();
    controller.subscription4!.cancel();
    controller.subscription5!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    return Container(
      color: AppColor.primaryColor,
      child: SafeArea(
        child: GetBuilder(
            init: MyPatientMonitorController(),
            builder: (_) {
            return Scaffold(
              appBar: AppBar(backgroundColor: AppColor.primaryColor,
                title: const Text("Patient Monitor"),
                actions: [

                  Visibility(
                    visible: controller.getIsDeviceFound && !controller.getIsDeviceScanning,
                    child: Container(
                      child: Row(
                        children: [

                          // Connect button
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: ElevatedButton(
                              child: Text(controller.getIsDeviceConnected? 'Connected':'Connect',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () async {
                                if(!controller.getIsDeviceConnected) {
                                  await controller.devicesData!.device.connect(autoConnect: true);
                                  await controller.onPressedConnect();
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, fixedSize: const Size(150, 45)),
                            ),
                          ),

                          // Save data button
                          Visibility(
                            visible: controller.getIsDeviceConnected,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: ElevatedButton(
                                onPressed: () async {

                                  ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
                                  ECGGraphDataFile();
                                  SpO2GraphDataFile();
                                  HRValueDataFile();
                                  SpO2ValueDataFile();
                                  PRValueDataFile();
                                  TempValueDataFile();
                                  BpValueDataFile();
                                  ProgressDialogue().hide();

                                  Get.to(const PatientReport());

                                  // controller.devicesData!.device.disconnect();
                                },
                                child:  Text(localization.getLocaleData.save.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, fixedSize: const Size(150, 45)),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColor.white,
              body: WillPopScope(
                onWillPop: () {
                  return controller.onPressedBack();
                },
                child: Column(
                  children: <Widget> [

                          (!controller.getIsDeviceScanning && !controller.getIsDeviceFound) ?
                          _searchAgainWidget() : controller.getIsDeviceScanning ? scanDevice() :

                          Expanded(
                            child: Padding( 
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [

                                  // HR Graph and Value
                                  Expanded(flex: 4,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        // HR Graph
                                        Expanded(
                                          flex: 8,
                                          child: Container(
                                            // height: MediaQuery.of(context).size.height / 3.5,
                                            padding: const EdgeInsets.all(8),
                                            child: Sparkline(
                                              data: controller.hrList.toList().length < 150 ? controller.hrList.toList() : controller.hrList.toList()
                                                  .getRange((controller.hrList.toList().length - 150), controller.hrList.toList().length).toList(),
                                              lineWidth: 2.0,
                                              enableGridLines: true,
                                              lineColor: Colors.blue,
                                            ),
                                          ),
                                        ),

                                        // HR Details
                                        Expanded(
                                          flex: 3,
                                          child: Row( 
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  // height: MediaQuery.of(context).size.height / 3.5,
                                                  decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(10, 21, 51, 1),
                                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 5,10, 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [

                                                        // HR Icon, Text and Value
                                                        Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  // HR Icon
                                                                  const CircleAvatar(
                                                                    radius: 15,
                                                                    backgroundColor: Colors.white,
                                                                    child: Icon(
                                                                      Icons.monitor_heart,
                                                                      color: Colors.red,
                                                                      size: 25,
                                                                    ),
                                                                  ),

                                                                  const SizedBox(width: 5,),

                                                                  // HR Text
                                                                  Text('HR (bpm)',
                                                                    style: MyTextTheme.largeBCB.copyWith(color: Colors.greenAccent,)

                                                                  ),

                                                                  const SizedBox(width: 5,),

                                                                  // HR Value
                                                                  Text((controller.getHrValue.toString()== '0' || controller.getHrValue.toString()=='') ? '00':controller.getHrValue.toString(),
                                                                      style: MyTextTheme.largeBCB.copyWith(color: Colors.greenAccent,)

                                                                    ),
                                                                ],
                                                              ),
                                                            ]
                                                        ),

                                                        const SizedBox(width: 10,),
                                                        // HR Step Progress Indicator
                                                        Column(
                                                          children: [
                                                            Expanded(
                                                              child: RotatedBox(
                                                                quarterTurns: 2,
                                                                child: StepProgressIndicator(
                                                                  direction: Axis.vertical,
                                                                  totalSteps: 10,
                                                                  fallbackLength: 5,
                                                                  unselectedSize: 20,
                                                                  selectedSize: 20,
                                                                  currentStep: controller.getEcgStepper,
                                                                  selectedColor: Colors.greenAccent,
                                                                  unselectedColor: Colors.grey,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )

                                      ],
                                    ),
                                  ),

                                  // SpO2 Graph and Values
                                  Expanded(flex: 4,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        // SpO2 Graph
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  // height:  MediaQuery.of(context).size.height / 3.4,
                                                  padding: const EdgeInsets.all(8),
                                                  child: Sparkline(data:controller.spo2List.toList().length < 150 ? controller.spo2List.toList() : controller.spo2List.toList()
                                                      .getRange((controller.spo2List.toList().length - 150), controller.spo2List.toList().length).toList(),
                                                    lineWidth: 2.0,
                                                    enableGridLines: true,
                                                    lineColor: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              // Spo2Graph(),
                                            ],
                                          ),
                                        ),

                                        // SpO2 and Pulse Details
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Column(
                                              children: [
                                                Expanded( 
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          // height: MediaQuery.of(context).size.height / 3.4,
                                                          decoration: const BoxDecoration(
                                                              color: Color.fromRGBO(10, 21, 51, 1),
                                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [

                                                                // SpO2 and Pulse
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [

                                                                      // SpO2
                                                                      Row(
                                                                        children: [
                                                                          // SpO2 SVG
                                                                          CircleAvatar(
                                                                            radius: 15,
                                                                            backgroundColor: Colors.white,
                                                                            child: SvgPicture.asset('assets/spO2.svg', height: 30,),
                                                                          ),

                                                                          const SizedBox(width: 10,),

                                                                          // SpO2 Text
                                                                          Text('SpO2 (%)',
                                                                            style:  MyTextTheme.largeBCB.copyWith(color: Colors.yellow,)

                                                                          ),

                                                                          const SizedBox(width: 5,),

                                                                          // SpO2 Value
                                                                          Text((controller.getSpo2Value.toString() == '0' || controller.getSpo2Value.toString()=='') ? '00' : controller.getSpo2Value.toString(),
                                                                            style:  MyTextTheme.largeBCB.copyWith(color: Colors.yellow,)

                                                                          ),
                                                                        ],
                                                                      ),

                                                                      // Pulse
                                                                      Row(
                                                                        children: [
                                                                          // Pulse SVG
                                                                          CircleAvatar(
                                                                            radius: 15,
                                                                            backgroundColor: Colors.white,
                                                                            child: SvgPicture.asset('assets/pulse_rate2.svg', height: 20, color: Colors.red,),
                                                                          ),

                                                                          const SizedBox(width: 5,),

                                                                          // Pulse Text
                                                                          Text('PR (bpm)',
                                                                            style: MyTextTheme.largeBCB.copyWith(color: Colors.white,)

                                                                          ),

                                                                          const SizedBox(width: 5,),

                                                                          // Pulse Value
                                                                          Text((controller.getPrValue.toString()== '0' || controller.getPrValue.toString()=='') ? '00':controller.getPrValue.toString(),
                                                                            style:MyTextTheme.largeBCB.copyWith(color: Colors.white,)
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    ]
                                                                ),
                                                                const SizedBox(width: 10,),
                                                                // SpO2 Step Progress Indicator
                                                                Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child: RotatedBox(
                                                                        quarterTurns: 2,
                                                                        child: StepProgressIndicator(
                                                                          direction: Axis.vertical,
                                                                          totalSteps: 10,
                                                                          fallbackLength: 5,
                                                                          unselectedSize: 20,
                                                                          selectedSize: 20,
                                                                          currentStep: controller.getSpo2Stepper,
                                                                          selectedColor: Colors.yellow,
                                                                          unselectedColor:
                                                                          Colors.grey,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10,),

                                  // Blood Pressure and Temperature
                                  Expanded(flex: 2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // BP
                                        Expanded(
                                        flex: 5,
                                          child: Container(
                                            height: 54,
                                            padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
                                            color: const Color.fromRGBO(10, 21, 51, 1),
                                            child: Row(
                                              children: [
                                                // BP SVG
                                                CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: Colors.white,
                                                  child: controller.getBpData['mode'].toString()=='i'?
                                                  Lottie.asset('assets/measure.json',) : SvgPicture.asset('assets/bloodPressureImage.svg', height: 25),
                                                ),

                                                const SizedBox(width: 10,),

                                                // BP Text
                                                Text('BP (mmHg) :',
                                                  style:MyTextTheme.largeBCB.copyWith(color: Colors.white,)
                                                ),

                                                const SizedBox(width: 7,),

                                                // BP Value
                                                Text((controller.getBpData['mode'].toString()=='f'
                                                    || controller.getBpData['mode'].toString()=='i'
                                                    || controller.getBpData['mode'].toString()!='e') ?
                                                controller.getBpData['systolic'].toString()+' '+'/'+' '+
                                                    controller.getBpData['diastolic'].toString() : 'SYS / DIA',
                                                  style: MyTextTheme.largeBCB.copyWith(color: Colors.white,)
                                                ),

                                                const SizedBox(width: 45,),

                                                // ElevatedButton.icon(
                                                //     onPressed: () {
                                                //       Get.to(CareTaker());
                                                //     },
                                                //     icon: Icon(Icons.settings, color: Colors.white, size: 32,),
                                                //     label: Text(""),
                                                //   style: ElevatedButton.styleFrom(
                                                //     fixedSize: Size(70, 40),
                                                //     backgroundColor: Color.fromRGBO(10, 21, 51, 1),
                                                //     alignment: Alignment(8, 0)
                                                //   ),
                                                // ),

                                              ],
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 10,),
                                        // Temperature
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            height: 54,
                                            padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
                                            color: const Color.fromRGBO(10, 21, 51, 1),
                                            child: Row(
                                              children: [
                                                // Temp SVG
                                                CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: Colors.white,
                                                  child: SvgPicture.asset('assets/temperature.svg', height: 25,),
                                                ),

                                                const SizedBox(width: 10,),

                                                // Temp Text
                                                Text(
                                                  'Temp (\u2109) :',
                                                  style:MyTextTheme.largeBCB.copyWith(color: Colors.white,)
                                                ),

                                                const SizedBox(width: 7,),

                                                // Temp Value
                                                Text((controller.getTempValue.toString()=='0' || controller.getTempValue.toString()=='') ? '00' : controller.getTempValue.toString(),
                                                  style: MyTextTheme.largeBCB.copyWith(color: Colors.white,)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),

                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _searchAgainWidget() {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset('assets/search.json',
                width:300,
                fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(localization.getLocaleData.noDataFound.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                   controller.scanDevices();
                  },
                  child: const Text("Search Again"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    fixedSize: const Size.fromWidth(150),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  scanDevice() {
    return Center(
        child: Lottie.asset('assets/scanning.json',
            width: 340,
            height: 100,
            fit: BoxFit.fitWidth,
        ),
    );
  }

}
