import 'dart:io';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medvantage_patient/LiveVital/ptt/ptt_controller.dart';
import 'package:medvantage_patient/LiveVital/ptt/ptt_report.dart';
import 'package:path_provider/path_provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'bp_calibration.dart';

class PulseTransitTimeView extends StatefulWidget {
  const PulseTransitTimeView({super.key});

  @override
  State<PulseTransitTimeView> createState() => _PulseTransitTimeViewState();
}

class _PulseTransitTimeViewState extends State<PulseTransitTimeView> {

  PulseTransitTimeController pulseTransitTimeController = Get.put(PulseTransitTimeController());

  /// Method for Android
  ecgGraphDataFile() async {
    final directory=await getExternalStorageDirectory();
    final file=File('${directory!.path}/2510394_ECG_Graph_100Hz.txt');
    await file.writeAsString(pulseTransitTimeController.getHrGraphDataList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  spO2GraphDataFile() async {
    final directory=await getExternalStorageDirectory();
    final file=File('${directory!.path}/2510394_SpO2_Graph.txt');
    await file.writeAsString(pulseTransitTimeController.getSpO2GraphDataList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  hrValueDataFile() async {
    final directory=await getExternalStorageDirectory();
    final file=File('${directory!.path}/2510394_HR.txt');
    await file.writeAsString(pulseTransitTimeController.getHrValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  spO2ValueDataFile() async {
    final directory=await getExternalStorageDirectory();
    final file=File('${directory!.path}/2510394_SpO2.txt');
    await file.writeAsString(pulseTransitTimeController.getSpO2ValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  prValueDataFile() async {
    final directory=await getExternalStorageDirectory();
    final file=File('${directory!.path}/2510394_PR.txt');
    await file.writeAsString(pulseTransitTimeController.getPrValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  bpValueDataFile() async {
    final directory=await getExternalStorageDirectory();
    final file=File('${directory!.path}/2510394_BP.txt');
    await file.writeAsString(pulseTransitTimeController.getBpValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  tempValueDataFile() async {
    final directory=await getExternalStorageDirectory();
    final file = File('${directory!.path}/2510394_Temperature.txt');
    await file.writeAsString(pulseTransitTimeController.getTempValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  // batteryValueDataFile() async {
  //   final directory=await getExternalStorageDirectory();
  //   final file=File('${directory!.path}/2510394_Battery.txt');
  //   await file.writeAsString(pulseTransitTimeController.getBatteryValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  // }

  pttValueDataFile() async {
    final directory=await getExternalStorageDirectory();
    final file=File('${directory!.path}/2510394_PTT.txt');
    await file.writeAsString(pulseTransitTimeController.getPttValueList.join('').toString().replaceAll('{', '').replaceAllMapped(', {', (match) => '').replaceAll('}', '\n'));
  }

  get() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    if(pulseTransitTimeController.devicesData!=null) {
      pulseTransitTimeController.devicesData!.disconnect();
    }
    await pulseTransitTimeController.scanDevices();
  }

  @override
  void initState() {
    get();
    super.initState();
  }

  @override
  void dispose() {
    pulseTransitTimeController.scanSubscription!.cancel();
    pulseTransitTimeController.liveSubscription?.cancel();
    pulseTransitTimeController.hrSubscription?.cancel();
    pulseTransitTimeController.spO2PrSubscription?.cancel();
    pulseTransitTimeController.bpSubscription?.cancel();
    pulseTransitTimeController.tempSubscription?.cancel();
    Get.delete<PulseTransitTimeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.green,
      child: SafeArea(
        child: GetBuilder(
            init: PulseTransitTimeController(),
            builder: (_) {
              return Scaffold(
                appBar: AppBar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  title: Text("Pulse Transit Time"),
                  centerTitle: false,
                  actions: [
                    // Battery percent and icon
                    Visibility(
                      visible: pulseTransitTimeController.getIsDeviceFound && !pulseTransitTimeController.getIsDeviceScanning,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(' ' + pulseTransitTimeController.getBatteryValue.toString() + '%',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: pulseTransitTimeController.getBatteryText >=1 && pulseTransitTimeController.getBatteryText <=30 ? Colors.red :
                                    pulseTransitTimeController.getBatteryText >=31 && pulseTransitTimeController.getBatteryText <=70 ? Colors.orange :
                                    pulseTransitTimeController.getBatteryText >=71 && pulseTransitTimeController.getBatteryText <=100 ? Colors.green : Colors.blue,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Icon(
                                    pulseTransitTimeController.getBatteryText >=1 && pulseTransitTimeController.getBatteryText <=13 ? Icons.battery_0_bar :
                                    pulseTransitTimeController.getBatteryText >=14 && pulseTransitTimeController.getBatteryText <=26 ? Icons.battery_1_bar :
                                    pulseTransitTimeController.getBatteryText >=27 && pulseTransitTimeController.getBatteryText <=39 ? Icons.battery_2_bar :
                                    pulseTransitTimeController.getBatteryText >=40 && pulseTransitTimeController.getBatteryText <=52 ? Icons.battery_3_bar :
                                    pulseTransitTimeController.getBatteryText >=53 && pulseTransitTimeController.getBatteryText <=65 ? Icons.battery_4_bar :
                                    pulseTransitTimeController.getBatteryText >=66 && pulseTransitTimeController.getBatteryText <=78 ? Icons.battery_5_bar :
                                    pulseTransitTimeController.getBatteryText >=79 && pulseTransitTimeController.getBatteryText <=91 ? Icons.battery_6_bar :
                                    pulseTransitTimeController.getBatteryText >=92 && pulseTransitTimeController.getBatteryText <=100 ? Icons.battery_full : Icons.battery_alert,
                                  size: 30,
                                  color: pulseTransitTimeController.getBatteryText >=1 && pulseTransitTimeController.getBatteryText <=30 ? Colors.red :
                                  pulseTransitTimeController.getBatteryText >=31 && pulseTransitTimeController.getBatteryText <=70 ? Colors.orange :
                                  pulseTransitTimeController.getBatteryText >=71 && pulseTransitTimeController.getBatteryText <=100 ? Colors.green : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Connect button
                    // Visibility(
                    //   visible: pulseTransitTimeController.getIsDeviceFound && !pulseTransitTimeController.getIsDeviceScanning,
                    //   child: Padding(
                    //     padding:  EdgeInsets.fromLTRB(0, 5, 5, 5),
                    //     child: ElevatedButton(
                    //       child: Text(pulseTransitTimeController.getIsDeviceConnected ? 'Connected':'Connect',
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           color: Colors.blue,
                    //         ),
                    //       ),
                    //       onPressed: () async {
                    //         if(!pulseTransitTimeController.getIsDeviceConnected) {
                    //           try{
                    //             showAlertDialog(context);
                    //             await pulseTransitTimeController.devicesData!.device.connect();
                    //             pulseTransitTimeController.onPressConnect();
                    //             Navigator.pop(context);
                    //
                    //           } catch (e) {
                    //             print('Device connecting related issues : $e');
                    //           }
                    //
                    //           // await pulseTransitTimeController.devicesData!.device.connect();
                    //           // pulseTransitTimeController.onPressConnect();
                    //         }
                    //       },
                    //       style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    //     ),
                    //   ),
                    // ),

                    // Save data button
                    Visibility(
                      visible: pulseTransitTimeController.getIsDeviceConnected,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            ecgGraphDataFile();
                            spO2GraphDataFile();
                            hrValueDataFile();
                            spO2ValueDataFile();
                            prValueDataFile();
                            bpValueDataFile();
                            tempValueDataFile();
                            // batteryValueDataFile();
                            pttValueDataFile();
                            Get.to(PulseTransitTimeReport());
                          },
                          child: Text('Save Data',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.blue.shade50,
                body: WillPopScope(
                  onWillPop: () async {
                  await  pulseTransitTimeController.onPressBack();
                  try{
                    pulseTransitTimeController.scanSubscription!.cancel();
                    pulseTransitTimeController.liveSubscription?.cancel();
                    pulseTransitTimeController.hrSubscription?.cancel();
                    pulseTransitTimeController.spO2PrSubscription?.cancel();
                    pulseTransitTimeController.bpSubscription?.cancel();
                    pulseTransitTimeController.tempSubscription?.cancel();
                  }
                  catch(e){

                  }
                    return Future.value(false);
                  },
                  child: Column(
                    children: <Widget> [

                      (!pulseTransitTimeController.getIsDeviceScanning && !pulseTransitTimeController.getIsDeviceFound) ?
                      _searchAgainWidget() : pulseTransitTimeController.getIsDeviceScanning ? scanDevice() :
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [

                            // HR Graph and Value
                            Row(
                                    children: [
                                // HR Graph
                                Expanded(
                                  child: Container(
                                    // height: MediaQuery.of(context).size.height/2.6,
                                    height: MediaQuery.of(context).size.height/3.3,
                                     padding: EdgeInsets.fromLTRB(10, 8, 15, 8),
                                    child: Sparkline(
                                      enableGridLines: true,
                                      gridLineAmount: 7,
                                      gridLineColor: Colors.black,
                                      gridLineLabelPrecision: 2,
                                      gridLineLabelColor: Colors.black,
                                      lineWidth: 1.5,
                                      lineColor: Colors.blue,
                                      data: pulseTransitTimeController.hrList.toList().length < 200 ? pulseTransitTimeController.hrList.toList() : pulseTransitTimeController.hrList.toList()
                                          .getRange((pulseTransitTimeController.hrList.toList().length - 200), pulseTransitTimeController.hrList.toList().length).toList(),
                                    ),
                                  ),
                                ),

                                // HR Details
                                Row(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height/3.3,
                                      width: MediaQuery.of(context).size.width/3.3,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(10, 21, 51, 1),
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(10, 5,10, 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            // HR Icon, Text and Value
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      // HR Icon
                                                      CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor: Colors.white,
                                                        child: Icon(
                                                          Icons.monitor_heart,
                                                          color: Colors.red,
                                                          size: 25,
                                                        ),
                                                      ),

                                                      // HR Text
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        child: Text('HR (bpm)',
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 35 : 20,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.greenAccent,
                                                          ),
                                                        ),
                                                      ),

                                                      // HR Value
                                                      // Text((controller.getHrValue.toString()== '0' || controller.getHrValue.toString()=='') ? '00':controller.getHrValue.toString(),
                                                      Text(pulseTransitTimeController.getHrValue.toString(),
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 45 : 30,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.greenAccent,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            ),

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
                                                      currentStep: pulseTransitTimeController.getEcgStepper,
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
                                    )
                                  ],
                                )
                              ],
                            ),

                            // SpO2 Graph and Values
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  // SpO2 Graph
                                  Expanded(
                                    child: Container(
                                      // height: MediaQuery.of(context).size.height/2.6,
                                      height: MediaQuery.of(context).size.height/3.3,
                                      padding: EdgeInsets.fromLTRB(10, 8, 15, 8),
                                      child: Sparkline(
                                        enableGridLines: true,
                                        gridLineAmount: 7,
                                        gridLineColor: Colors.black,
                                        gridLineLabelPrecision: 2,
                                        gridLineLabelColor: Colors.black,
                                        lineWidth: 1.5,
                                        lineColor: Colors.blue,
                                        data:pulseTransitTimeController.spO2List.toList().length < 200 ? pulseTransitTimeController.spO2List.toList() : pulseTransitTimeController.spO2List.toList()
                                            .getRange((pulseTransitTimeController.spO2List.toList().length - 200), pulseTransitTimeController.spO2List.toList().length).toList(),
                                      ),
                                    ),
                                  ),

                                  // SpO2 and Pulse Details
                                  Row(
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height/3.3,
                                        width: MediaQuery.of(context).size.width/3.3,
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(10, 21, 51, 1),
                                            borderRadius: BorderRadius.all(Radius.circular(8))
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
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

                                                        // SpO2 Text
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                          child: Text('SpO\u2082 (%)',
                                                            style: TextStyle(
                                                              fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 35 : 20,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.yellow,
                                                            ),
                                                          ),
                                                        ),

                                                        // SpO2 Value
                                                        // Text((controller.getSpo2Value.toString() == '0' || controller.getSpo2Value.toString()=='') ? '00' : controller.getSpo2Value.toString(),
                                                        Text(pulseTransitTimeController.getSpO2Value.toString(),
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 45 : 30,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.yellow,
                                                          ),
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

                                                        // Pulse Text
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                          child: Text('PR (bpm)',
                                                            style: TextStyle(
                                                              fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 35 : 20,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),

                                                        // Pulse Value
                                                        // Text((controller.getPrValue.toString()== '0' || controller.getPrValue.toString()=='') ? '00':controller.getPrValue.toString(),
                                                        Text(pulseTransitTimeController.getPrValue.toString(),
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 45 : 30,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ]
                                              ),

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
                                                        currentStep: pulseTransitTimeController.getSpO2Stepper,
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
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Blood Pressure, Temperature and Pulse Transit Time
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  // BP
                                  Container(
                                    width: MediaQuery.of(context).size.width/2.4,
                                    // height: MediaQuery.of(context).size.height/14,
                                    height: MediaQuery.of(context).size.height/11.5,
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    color: Color.fromRGBO(10, 21, 51, 1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        // BP SVG, Text ane Value
                                        Row(
                                          children: [
                                            // BP SVG
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.white,
                                              child: pulseTransitTimeController.getBpData['mode'].toString()=='i'?
                                              Lottie.asset('assets/measure.json',) : SvgPicture.asset('assets/bloodPressureImage.svg', height: 30),
                                            ),

                                            // BP Text
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: Text('BP (mmHg) :',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 20 : 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            // BP Value
                                            Text((pulseTransitTimeController.getBpData['mode'].toString()=='f'
                                                || pulseTransitTimeController.getBpData['mode'].toString()=='i'
                                                || pulseTransitTimeController.getBpData['mode'].toString()!='e') ?
                                            pulseTransitTimeController.getBpData['systolic'].toString()+' '+'/'+' '+pulseTransitTimeController.getBpData['diastolic'].toString() : 'SYS / DIA',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 20 : 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Setting Icon
                                        Visibility(
                                          visible: pulseTransitTimeController.getIsDeviceConnected,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    Get.to(BPCalibration());
                                                  },
                                                  icon: Icon(
                                                    Icons.settings,
                                                    color: Colors.white,
                                                    size: MediaQuery.of(context).size.shortestSide > 600 ? 30 : 28,
                                                  ),
                                                  label: Text('', style: TextStyle(color: Colors.white)),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color.fromRGBO(10, 21, 51, 1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                  // Temperature
                                  Container(
                                    width: MediaQuery.of(context).size.width/3.2,
                                    // height: MediaQuery.of(context).size.height/14,
                                    height: MediaQuery.of(context).size.height/11.5,
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    color: Color.fromRGBO(10, 21, 51, 1),
                                    child: Row(
                                      children: [
                                        // Temp SVG
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.white,
                                          child: SvgPicture.asset('assets/temperature.svg', height: 30,),
                                        ),

                                        // Temp Text
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Text('Temp. (\u2109) :',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 20 : 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),

                                        // Temp Value
                                        // Text((controller.getTempValue.toString()=='0' || controller.getTempValue.toString()=='') ? '00' : controller.getTempValue.toString(),
                                        Text(pulseTransitTimeController.getTempValue.toString(),
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 20 : 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // PTT
                                  Container(
                                    width: MediaQuery.of(context).size.width/4,
                                    // height: MediaQuery.of(context).size.height/14,
                                    height: MediaQuery.of(context).size.height/11.5,
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    color: Color.fromRGBO(10, 21, 51, 1),
                                    child: Row(
                                      children: [

                                        // PTT Text
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: Text('PTT (ms) :',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 20 : 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),

                                        // PTT Value
                                        // Text((controller.getTempValue.toString()=='0' || controller.getTempValue.toString()=='') ? '00' : controller.getTempValue.toString(),
                                        Text(pulseTransitTimeController.getPttValue.toString(),
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.shortestSide > 600 ? 20 : 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
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
                Text('No Device Found',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                  await  pulseTransitTimeController.scanDevices();
                  },
                  child: Text("Search Again"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    fixedSize: Size.fromWidth(150),
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
