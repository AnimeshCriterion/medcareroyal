import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:medvantage_patient/LiveVital/ptt/ptt_controller.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../bp_watch/device_view.dart';

class PulseTransitTimeReport extends StatefulWidget {
  const PulseTransitTimeReport({super.key});

  @override
  State<PulseTransitTimeReport> createState() => _PulseTransitTimeReportState();
}

class _PulseTransitTimeReportState extends State<PulseTransitTimeReport> {

  PulseTransitTimeController pulseTransitTimeController2 = Get.put(PulseTransitTimeController());

  final GlobalKey<State<StatefulWidget>> _formKey = GlobalKey();

  final GlobalKey<State<StatefulWidget>> _formKey2 = GlobalKey();

  home() {
    if(pulseTransitTimeController2.devicesData!=null) {
      pulseTransitTimeController2.devicesData!.disconnect();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Get.back();
    Get.back();
    Get.delete<PulseTransitTimeController>();
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    pulseTransitTimeController2.scanSubscription!.cancel();
    pulseTransitTimeController2.liveSubscription!.cancel();
    pulseTransitTimeController2.hrSubscription!.cancel();
    pulseTransitTimeController2.spO2PrSubscription!.cancel();
    pulseTransitTimeController2.bpSubscription!.cancel();
    pulseTransitTimeController2.tempSubscription!.cancel();
    Get.delete<PulseTransitTimeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Patient Report"),
          centerTitle: false,
          actions: [
            // Save Button
            Padding(
              padding: EdgeInsets.all(5),
              child: ElevatedButton.icon(
                icon: Icon(Icons.save, color: Colors.blue),
                label: Text("Save Report",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  saveAsPdf(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: WillPopScope(
            onWillPop: () {
              home();
              return Future.value(false);
            },
            child: Center(
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget> [

                    RepaintBoundary(
                      key: _formKey,
                      child: Column(
                        children: [

                          // Date and PID
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.01,
                              height: 50,
                              // color: Colors.yellow.shade200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${DateFormat("dd MMM yyyy, hh:mm:ss a").format(DateTime.now())}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("UHID : "+userRepository.getUser!.uhID.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                            ),
                          ),

                          // Patient Report (Text)
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.01,
                              height: 200,
                              // color: Colors.yellow.shade200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("PATIENT REPORT",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Patient details start
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.01,
                              height: 150,
                              color: Colors.blue.shade50,
                              child: Column(
                                children: [

                                  // Patient details (Text)
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          color: Colors.green.shade600,
                                          child: Text("Patient details",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Patient details
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("First Name : ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(userRepository.getUser.patientName.toString().contains(' ')?
                                              userRepository.getUser.patientName.toString().split(' ')[0].toString():userRepository.getUser.patientName.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                            child: Row(
                                              children: [
                                                Text("Last Name : ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(userRepository.getUser.patientName.toString().contains(' ')?
                                                userRepository.getUser.patientName.toString().split(' ')[1].toString():userRepository.getUser.patientName.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text("Gender : " ,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(userRepository.getUser.gender.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Age : ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(userRepository.getUser.age.toString()+' '+userRepository.getUser.agetype.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                            child: Row(
                                              children: [
                                                Text("Height : ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(userRepository.getUser.height.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text("Weight : ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(userRepository.getUser!.weight.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),

                          // Parameters details start
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.01,
                              height: 155,
                              color: Colors.blue.shade50,
                              child: Column(
                                children: [

                                  // Parameters details (Text)
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          color: Colors.green.shade600,
                                          child: Text("Parameters details",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Parameters details
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [

                                      // HR and Temp
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          // HR
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
                                                padding:
                                                EdgeInsets.only(left: 10),
                                                child: Text("HR (bpm) : ",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),

                                              // HR Value
                                              // Text((controller.getHrValue.toString()== '0' || controller.getHrValue.toString()=='') ? '00':controller.getHrValue.toString(),
                                              Text(pulseTransitTimeController2.averageHr().toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Temp
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                                                  padding:
                                                  EdgeInsets.only(left: 10),
                                                  child: Text("Temp. (\u2109) : ",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),

                                                // Temp Value
                                                // Text((controller.getTempValue.toString()=='0' || controller.getTempValue.toString()=='') ? '0.0' : controller.getTempValue.toString(),
                                                Text(pulseTransitTimeController2.averageTemp().toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),

                                      // SpO2 and PR
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                padding:
                                                EdgeInsets.only(left: 10),
                                                child: Text("SpO\u2082 (%) : ",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),

                                              // SpO2 Value
                                              // Text((controller.getSpo2Value.toString() == '0' || controller.getSpo2Value.toString()=='') ? '00' : controller.getSpo2Value.toString(),
                                              Text(pulseTransitTimeController2.averageSpO2().toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // PR
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                            child: Row(
                                              children: [
                                                // Pulse SVG
                                                CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.white,
                                                  child: SvgPicture.asset('assets/pulse_rate2.svg', height: 20, color: Colors.red,),
                                                ),

                                                // PR Text
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 10),
                                                  child: Text("PR (bpm) : ",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),

                                                // PR Value
                                                // Text((controller.getPrValue.toString()== '0' || controller.getPrValue.toString()=='') ? '00':controller.getPrValue.toString(),
                                                Text(pulseTransitTimeController2.averagePr().toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),

                                      // SYS and DIA
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          // SYS
                                          Row(
                                            children: [
                                              // BP SVG
                                              CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.white,
                                                child: pulseTransitTimeController2.getBpData['mode'].toString()=='i'?
                                                Lottie.asset('assets/measure.json',) : SvgPicture.asset('assets/bloodPressureImage.svg', height: 30),
                                              ),

                                              // SYS Text
                                              Padding(
                                                padding:
                                                EdgeInsets.only(left: 10),
                                                child: Text("SYS (mmHg) : ",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),

                                              // SYS Value
                                              // Text((controller.getBpData['mode'].toString()=='f' || controller.getBpData['mode'].toString()=='i' || controller.getBpData['mode'].toString()!='e') ? controller.getBpData['systolic'].toString() : '00',
                                              Text(pulseTransitTimeController2.averageBpSys().toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // DIA
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                            child: Row(
                                              children: [
                                                // BP SVG
                                                CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.white,
                                                  child: pulseTransitTimeController2.getBpData['mode'].toString()=='i'?
                                                  Lottie.asset('assets/measure.json',) : SvgPicture.asset('assets/bloodPressureImage.svg', height: 30),
                                                ),

                                                // DIA Text
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 10),
                                                  child: Text("DIA (mmHg) : ",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),

                                                // DIA Value
                                                // Text((controller.getBpData['mode'].toString()=='f' || controller.getBpData['mode'].toString()=='i' || controller.getBpData['mode'].toString()!='e') ? controller.getBpData['diastolic'].toString() : '00',
                                                Text(pulseTransitTimeController2.averageBpDia().toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),

                                      // Battery and PTT
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          // // Battery
                                          // Row(
                                          //   children: [
                                          //     // Battery Icon
                                          //     CircleAvatar(
                                          //       radius: 15,
                                          //       backgroundColor: Colors.white,
                                          //       child: Icon(Icons.battery_std),
                                          //     ),
                                          //
                                          //     // Battery Text
                                          //     Padding(
                                          //       padding:
                                          //       EdgeInsets.only(left: 10),
                                          //       child: Text("Battery (%) : ",
                                          //         style: TextStyle(
                                          //           fontSize: 20,
                                          //           fontWeight: FontWeight.bold,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //
                                          //     // Battery Value
                                          //     // Text((controller.getSpo2Value.toString() == '0' || controller.getSpo2Value.toString()=='') ? '00' : controller.getSpo2Value.toString(),
                                          //     Text(pulseTransitTimeController2.averageBattery().toString(),
                                          //       style: TextStyle(
                                          //         fontSize: 20,
                                          //         fontWeight: FontWeight.bold,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),

                                          // PTT icon and text
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child: Row(
                                              children: [

                                                // PTT Icon
                                                CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.white,
                                                  child: Icon(Icons.heart_broken, size: 25, color: Colors.red),
                                                ),

                                                // PTT Text
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 10),
                                                  child: Text("PTT (ms)",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),

                                          // PTT value
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(40, 5, 0, 0),
                                            child: Row(
                                              children: [
                                                // PTT value
                                                Text(pulseTransitTimeController2.averagePtt().toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),

                          // HR Graph
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.01,
                                  height: 250,
                                  child: SfCartesianChart(
                                    // backgroundColor: Colors.yellow.shade200,
                                    title: ChartTitle(text: "HR", textStyle: TextStyle(fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
                                    plotAreaBorderWidth: 1.0,
                                    plotAreaBorderColor: Colors.black,

                                    primaryXAxis: CategoryAxis(
                                      visibleMaximum: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      interval: 1,
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.transparent),
                                    ),

                                    primaryYAxis: NumericAxis(
                                      desiredIntervals: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      minimum: -500,
                                      maximum: 500,
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.black),
                                    ),

                                    zoomPanBehavior: ZoomPanBehavior(
                                      enablePinching: true,
                                      enablePanning: true,
                                      zoomMode: ZoomMode.x,
                                      enableDoubleTapZooming: true,
                                    ),

                                    series: [
                                      LineSeries<VitalsDate, String>(
                                        dataSource : pulseTransitTimeController2.hrValueListGraph.map(
                                              (e)=>VitalsDate(DateFormat('hh:mm:ss a').format(DateFormat('yyyy-MM-dd, hh:mm:ss a').parse(e['date'])).toString(), int.parse(e['value'].toString())),
                                        ).toList(),

                                        width: 1.5,
                                        color: Colors.red,
                                        dataLabelSettings: DataLabelSettings(isVisible: true, color: Colors.red,),
                                        xValueMapper: (VitalsDate sales, _) => sales.date,
                                        yValueMapper: (VitalsDate sales, _) => sales.value,
                                        markerSettings: MarkerSettings(isVisible: true, color: Colors.red),
                                      ),
                                    ],

                                  )),
                            ),
                          ),

                          // SpO2 Graph
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.01,
                                  height: 250,
                                  child: SfCartesianChart(
                                    // backgroundColor: Colors.yellow.shade200,
                                    title: ChartTitle(text: "SpO\u2082", textStyle: TextStyle(fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
                                    plotAreaBorderWidth: 1.0,
                                    plotAreaBorderColor: Colors.black,

                                    primaryXAxis: CategoryAxis(
                                      visibleMaximum: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      interval: 1,
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.transparent),
                                    ),

                                    primaryYAxis: NumericAxis(
                                      desiredIntervals: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      minimum: -500,
                                      maximum: 500,
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.black),
                                    ),

                                    zoomPanBehavior: ZoomPanBehavior(
                                      enablePinching: true,
                                      enablePanning: true,
                                      zoomMode: ZoomMode.x,
                                      enableDoubleTapZooming: true,
                                    ),

                                    series: [
                                      LineSeries<VitalsDate, String>(
                                        dataSource : pulseTransitTimeController2.spO2ValueListGraph.map(
                                              (e)=>VitalsDate(DateFormat('hh:mm:ss a').format(DateFormat('yyyy-MM-dd, hh:mm:ss a').parse(e['date'])).toString(), int.parse(e['value'].toString())),
                                        ).toList(),

                                        width: 1.5,
                                        color: Colors.green,
                                        dataLabelSettings: DataLabelSettings(isVisible: true, color: Colors.green,),
                                        xValueMapper: (VitalsDate sales, _) => sales.date,
                                        yValueMapper: (VitalsDate sales, _) => sales.value,
                                        markerSettings: MarkerSettings(isVisible: true, color: Colors.green),
                                      ),
                                    ],

                                  )),
                            ),
                          ),

                          // PR Graph
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.01,
                                  height: 250,
                                  child: SfCartesianChart(
                                    // backgroundColor: Colors.yellow.shade200,
                                    title: ChartTitle(text: "PR", textStyle: TextStyle(fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
                                    plotAreaBorderWidth: 1.0,
                                    plotAreaBorderColor: Colors.black,

                                    primaryXAxis: CategoryAxis(
                                      visibleMaximum: 4,
                                      // initialVisibleMaximum: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      interval: 1,
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.transparent),
                                    ),

                                    primaryYAxis: NumericAxis(
                                      desiredIntervals: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      minimum: -500,
                                      maximum: 500,
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.black),
                                    ),

                                    zoomPanBehavior: ZoomPanBehavior(
                                      enablePinching: true,
                                      enablePanning: true,
                                      zoomMode: ZoomMode.x,
                                      enableDoubleTapZooming: true,
                                    ),

                                    series: [
                                      LineSeries<VitalsDate, String>(
                                        dataSource : pulseTransitTimeController2.prValueListGraph.map(
                                              (e)=>VitalsDate(DateFormat('hh:mm:ss a').format(DateFormat('yyyy-MM-dd, hh:mm:ss a').parse(e['date'])).toString(), int.parse(e['value'].toString())),
                                        ).toList(),

                                        width: 1.5,
                                        color: Colors.blue,
                                        dataLabelSettings: DataLabelSettings(isVisible: true, color: Colors.blue,),
                                        xValueMapper: (VitalsDate sales, _) => sales.date,
                                        yValueMapper: (VitalsDate sales, _) => sales.value,
                                        markerSettings: MarkerSettings(isVisible: true, color: Colors.blue),
                                      ),
                                    ],

                                  )),
                            ),
                          ),

                          // Temp Graph
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.01,
                                  height: 250,
                                  child: SfCartesianChart(
                                    // backgroundColor: Colors.yellow.shade200,
                                    title: ChartTitle(text: "Temp.", textStyle: TextStyle(fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
                                    plotAreaBorderWidth: 1.0,
                                    plotAreaBorderColor: Colors.black,

                                    primaryXAxis: CategoryAxis(
                                      visibleMaximum: 4,
                                      // initialVisibleMaximum: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      interval: 1,
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.transparent),
                                    ),

                                    primaryYAxis: NumericAxis(
                                      desiredIntervals: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      minimum: -500,
                                      maximum: 500,
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.black),
                                    ),

                                    zoomPanBehavior: ZoomPanBehavior(
                                      enablePinching: true,
                                      enablePanning: true,
                                      zoomMode: ZoomMode.x,
                                      enableDoubleTapZooming: true,
                                    ),

                                    series: [
                                      LineSeries<VitalsTemp, String>(
                                        dataSource : pulseTransitTimeController2.tempValueListGraph.map(
                                              (e)=>VitalsTemp(DateFormat('hh:mm:ss a').format(DateFormat('yyyy-MM-dd, hh:mm:ss a').parse(e['date'])).toString(), double.parse(e['value'].toString())),
                                        ).toList(),

                                        width: 1.5,
                                        color: Colors.orange,
                                        dataLabelSettings: DataLabelSettings(isVisible: true, color: Colors.orange,),
                                        xValueMapper: (VitalsTemp sales, _) => sales.date,
                                        yValueMapper: (VitalsTemp sales, _) => sales.value,
                                        markerSettings: MarkerSettings(isVisible: true, color: Colors.orange),
                                      ),
                                    ],

                                  )),
                            ),
                          ),

                        ],
                      ),
                    ),

                    RepaintBoundary(
                      key: _formKey2,
                      child: Column(
                        children: [

                          // Divider
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Divider(
                              color: Colors.blue,
                              thickness: 2,
                            ),
                          ),

                          // // Battery Graph
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(1.0),
                          //     ),
                          //     child: SizedBox(
                          //         width: MediaQuery.of(context).size.width/1.01,
                          //         height: 250,
                          //         child: SfCartesianChart(
                          //           // backgroundColor: Colors.yellow.shade200,
                          //           title: ChartTitle(text: "Battery", textStyle: TextStyle(fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
                          //           plotAreaBorderWidth: 1.0,
                          //           plotAreaBorderColor: Colors.black,
                          //
                          //           primaryXAxis: CategoryAxis(
                          //             visibleMaximum: 4,
                          //             // initialVisibleMaximum: 4,
                          //             axisLine: AxisLine(color: Colors.black),
                          //             labelStyle: TextStyle(fontSize: 10),
                          //             tickPosition: TickPosition.inside,
                          //             majorTickLines: MajorTickLines(color: Colors.transparent),
                          //             interval: 1,
                          //             majorGridLines: MajorGridLines(width: 1, color: Colors.transparent),
                          //           ),
                          //
                          //           primaryYAxis: NumericAxis(
                          //             desiredIntervals: 4,
                          //             axisLine: AxisLine(color: Colors.black),
                          //             minimum: -500,
                          //             maximum: 500,
                          //             labelStyle: TextStyle(fontSize: 10),
                          //             tickPosition: TickPosition.inside,
                          //             majorTickLines: MajorTickLines(color: Colors.transparent),
                          //             majorGridLines: MajorGridLines(width: 1, color: Colors.black),
                          //           ),
                          //
                          //           zoomPanBehavior: ZoomPanBehavior(
                          //             enablePinching: true,
                          //             enablePanning: true,
                          //             zoomMode: ZoomMode.x,
                          //             enableDoubleTapZooming: true,
                          //           ),
                          //
                          //           series: [
                          //             LineSeries<VitalsTemp, String>(
                          //               dataSource : pulseTransitTimeController2.batteryValueListGraph.map(
                          //                     (e)=>VitalsTemp(DateFormat('hh:mm:ss a').format(DateFormat('yyyy-MM-dd, hh:mm:ss a').parse(e['date'])).toString(), double.parse(e['value'].toString())),
                          //               ).toList(),
                          //
                          //               width: 1.5,
                          //               color: Colors.blue,
                          //               dataLabelSettings: DataLabelSettings(isVisible: true, color: Colors.blue,),
                          //               xValueMapper: (VitalsTemp sales, _) => sales.date,
                          //               yValueMapper: (VitalsTemp sales, _) => sales.value,
                          //               markerSettings: MarkerSettings(isVisible: true, color: Colors.blue),
                          //             ),
                          //           ],
                          //
                          //         )),
                          //   ),
                          // ),

                          // PTT Graph
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.01,
                                  height: 250,
                                  child: SfCartesianChart(
                                    // backgroundColor: Colors.yellow.shade200,
                                    title: ChartTitle(text: "PTT", textStyle: TextStyle(fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
                                    plotAreaBorderWidth: 1.0,
                                    plotAreaBorderColor: Colors.black,

                                    primaryXAxis: CategoryAxis(
                                      visibleMaximum: 4,
                                      // initialVisibleMaximum: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      interval: 1,
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.transparent),
                                    ),

                                    primaryYAxis: NumericAxis(
                                      desiredIntervals: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      minimum: -2500,
                                      maximum: 2500,
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.black),
                                    ),

                                    zoomPanBehavior: ZoomPanBehavior(
                                      enablePinching: true,
                                      enablePanning: true,
                                      zoomMode: ZoomMode.x,
                                      enableDoubleTapZooming: true,
                                    ),

                                    series: [
                                      LineSeries<VitalsTemp, String>(
                                        dataSource : pulseTransitTimeController2.pttValueListGraph.map(
                                              (e)=>VitalsTemp(DateFormat('hh:mm:ss a').format(DateFormat('yyyy-MM-dd, hh:mm:ss a').parse(e['date'])).toString(), double.parse(e['value'].toString())),
                                        ).toList(),

                                        width: 1.5,
                                        color: Colors.blue,
                                        dataLabelSettings: DataLabelSettings(isVisible: true, color: Colors.blue,),
                                        xValueMapper: (VitalsTemp sales, _) => sales.date,
                                        yValueMapper: (VitalsTemp sales, _) => sales.value,
                                        markerSettings: MarkerSettings(isVisible: true, color: Colors.blue),
                                      ),
                                    ],

                                  )),
                            ),
                          ),

                          // SYS Graph
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.01,
                                  height: 250,
                                  child: SfCartesianChart(
                                    // backgroundColor: Colors.yellow.shade200,
                                    title: ChartTitle(text: "SYS", textStyle: TextStyle(fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
                                    plotAreaBorderWidth: 1.0,
                                    plotAreaBorderColor: Colors.black,

                                    primaryXAxis: CategoryAxis(
                                      visibleMaximum: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      interval: 1,
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.transparent),
                                    ),

                                    primaryYAxis: NumericAxis(
                                      desiredIntervals: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      minimum: -500,
                                      maximum: 500,
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.black),
                                    ),

                                    zoomPanBehavior: ZoomPanBehavior(
                                      enablePinching: true,
                                      enablePanning: true,
                                      zoomMode: ZoomMode.x,
                                      enableDoubleTapZooming: true,
                                    ),

                                    series: [
                                      LineSeries<VitalsDate, String>(

                                        dataSource : pulseTransitTimeController2.bpValueListGraph.map(
                                              (e)=>VitalsDate(DateFormat('hh:mm:ss a').format(DateFormat('yyyy-MM-dd, hh:mm:ss a').parse(e['date'])).toString(),
                                              int.parse(e['value'].toString()=='0'?'0':e['value'].split(',')[1].toString())),
                                        ).toList(),



                                        width: 1.5,
                                        color: Colors.indigo,
                                        dataLabelSettings: DataLabelSettings(isVisible: true, color: Colors.indigo,),
                                        xValueMapper: (VitalsDate sales, _) => sales.date,
                                        yValueMapper: (VitalsDate sales, _) => sales.value,
                                        markerSettings: MarkerSettings(isVisible: true, color: Colors.indigo),
                                      ),
                                    ],

                                  )),
                            ),
                          ),

                          // DIA Graph
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.01,
                                  height: 250,
                                  child: SfCartesianChart(
                                    // backgroundColor: Colors.yellow.shade200,
                                    title: ChartTitle(text: "DIA", textStyle: TextStyle(fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
                                    plotAreaBorderWidth: 1.0,
                                    plotAreaBorderColor: Colors.black,

                                    primaryXAxis: CategoryAxis(
                                      visibleMaximum: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      interval: 1,
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.transparent),
                                    ),

                                    primaryYAxis: NumericAxis(
                                      desiredIntervals: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      minimum: -500,
                                      maximum: 500,
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.black),
                                    ),

                                    zoomPanBehavior: ZoomPanBehavior(
                                      enablePinching: true,
                                      enablePanning: true,
                                      zoomMode: ZoomMode.x,
                                      enableDoubleTapZooming: true,
                                    ),



                                    series: [
                                      LineSeries<VitalsDate, String>(

                                        dataSource : pulseTransitTimeController2.bpValueListGraph.map(
                                              (e)=>VitalsDate(DateFormat('hh:mm:ss a').format(DateFormat('yyyy-MM-dd, hh:mm:ss a').parse(e['date'])).toString(),
                                              int.parse(e['value'].toString()=='0'?'0':e['value'].split(',')[2].toString())),
                                        ).toList(),



                                        width: 1.5,
                                        color: Colors.purple,
                                        dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                          color: Colors.purple,
                                        ),
                                        xValueMapper: (VitalsDate sales, _) => sales.date,
                                        yValueMapper: (VitalsDate sales, _) => sales.value,
                                        markerSettings: MarkerSettings(isVisible: true, color: Colors.purple),
                                      ),
                                    ],

                                  )),
                            ),
                          ),

                          // ECG Graph (Text)
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text("ECG Graph",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // Speed and Chest
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 18, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Speed : 25 mm/sec",),
                                SizedBox(width: 50,),
                                Text("Chest : 10 mm/mV"),
                              ],
                            ),
                          ),

                          // ECG Graph
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.01,
                                  height: MediaQuery.of(context).size.height > 600 ? 250 : 190,
                                  child: SfCartesianChart(
                                    // backgroundColor: Colors.yellow.shade200,
                                    plotAreaBorderWidth: 1.0,
                                    plotAreaBorderColor: Colors.red.shade900,

                                    primaryXAxis: CategoryAxis(
                                      visibleMaximum: 720,
                                      autoScrollingMode: AutoScrollingMode.end,
                                      desiredIntervals: 36,
                                      axisLine: AxisLine(color: Colors.red.shade900),
                                      labelStyle: TextStyle(fontSize: 0),
                                      tickPosition: TickPosition.inside,
                                      interval: 20, // Interval * MajorGridLines = ECG Data (20*36=720)
                                      minorTicksPerInterval: 4,
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.red.shade900),
                                      minorGridLines: MinorGridLines(width: 1, color: Colors.red.shade100),
                                    ),

                                    primaryYAxis: NumericAxis(
                                      desiredIntervals: 8,
                                      axisLine: AxisLine(color: Colors.red.shade900),
                                      minimum: -4000,
                                      maximum: 4000,
                                      labelStyle: TextStyle(fontSize: 0),
                                      tickPosition: TickPosition.inside,
                                      minorTicksPerInterval: 4,
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.red.shade900),
                                      minorGridLines: MinorGridLines(width: 1, color: Colors.red.shade100),
                                    ),

                                    zoomPanBehavior: ZoomPanBehavior(
                                      // enablePinching: true,
                                      enablePanning: true,
                                      // zoomMode: ZoomMode.x,
                                      // enableDoubleTapZooming: true,
                                    ),

                                    series: [
                                      LineSeries<VitalsData, int>(
                                        dataSource: List.generate(
                                            (pulseTransitTimeController2.hrList.toList().length < 1080 ? pulseTransitTimeController2.hrList.toList() : pulseTransitTimeController2.hrList.toList().getRange((pulseTransitTimeController2.hrList.toList().length - 1080),
                                                pulseTransitTimeController2.hrList.toList().length).toList()).length, (index) {
                                          var vital = (pulseTransitTimeController2.hrList.toList().length < 1080 ? pulseTransitTimeController2.hrList.toList() : pulseTransitTimeController2.hrList.toList().getRange((pulseTransitTimeController2.hrList.toList().length - 1080),
                                              pulseTransitTimeController2.hrList.toList().length).toList())[index];

                                          return VitalsData(
                                              index,
                                              double.parse(vital.toString()));
                                        }),

                                        width: 1.0,
                                        color: Colors.black,
                                        xValueMapper: (VitalsData sales, _) => sales.date,
                                        yValueMapper: (VitalsData sales, _) => sales.value,
                                      ),
                                    ],
                                  )),
                            ),
                          ),

                          // SpO2 Graph
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.01,
                                  height: 250,
                                  child: SfCartesianChart(
                                    // backgroundColor: Colors.yellow.shade200,
                                    title: ChartTitle(text: "SpO\u2082 Graph", textStyle: TextStyle(fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
                                    plotAreaBorderWidth: 1.0,
                                    plotAreaBorderColor: Colors.black,

                                    primaryXAxis: CategoryAxis(
                                      visibleMinimum: 500,
                                      axisLine: AxisLine(color: Colors.black),
                                      labelStyle: TextStyle(fontSize: 0),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      interval: 1,
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.transparent),
                                    ),

                                    primaryYAxis: NumericAxis(
                                      desiredIntervals: 4,
                                      axisLine: AxisLine(color: Colors.black),
                                      minimum: -1000,
                                      maximum: 1000,
                                      labelStyle: TextStyle(fontSize: 10),
                                      tickPosition: TickPosition.inside,
                                      majorTickLines: MajorTickLines(color: Colors.transparent),
                                      majorGridLines: MajorGridLines(width: 1, color: Colors.black),
                                    ),

                                    zoomPanBehavior: ZoomPanBehavior(
                                      // enablePinching: true,
                                      enablePanning: true,
                                      // zoomMode: ZoomMode.x,
                                      // enableDoubleTapZooming: true,
                                    ),



                                    series: [
                                      LineSeries<VitalsData, int>(
                                        dataSource: List.generate(
                                            (pulseTransitTimeController2.spO2List.toList().length < 1000 ? pulseTransitTimeController2.spO2List.toList() : pulseTransitTimeController2.spO2List.toList().getRange((pulseTransitTimeController2.spO2List.toList().length - 1000),
                                                pulseTransitTimeController2.spO2List.toList().length).toList()).length, (index) {
                                          var vital = (pulseTransitTimeController2.spO2List.toList().length < 1000 ? pulseTransitTimeController2.spO2List.toList() : pulseTransitTimeController2.spO2List.toList().getRange((pulseTransitTimeController2.spO2List.toList().length - 1000),
                                              pulseTransitTimeController2.spO2List.toList().length).toList())[index];

                                          return VitalsData(
                                              index,
                                              double.parse(vital.toString()));
                                        }),

                                        width: 1.5,
                                        color: Colors.blue,
                                        xValueMapper: (VitalsData sales, _) => sales.date,
                                        yValueMapper: (VitalsData sales, _) => sales.value,
                                      ),
                                    ],

                                  )),
                            ),
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveAsPdf(BuildContext context) async {

    final pdf = pw.Document();
    //
    // final image = await WidgetWraper.fromKey(
    //   key: _formKey,
    //   pixelRatio: 2.0,
    // );
    //
    // final images = await WidgetWraper.fromKey(
    //   key: _formKey2,
    //   pixelRatio: 2.0,
    // );
    //
    // pdf.addPage(
    //   pw.Page(
    //     // pageFormat: format,
    //       pageFormat: PdfPageFormat.a4,
    //       margin: pw.EdgeInsets.all(20),
    //       orientation: pw.PageOrientation.portrait,
    //       build: (pw.Context context) {
    //         return
    //           pw.Center(
    //             child: pw.Expanded(
    //               child: pw.Image(image),
    //             ),
    //           );
    //       }),
    // );
    //
    // pdf.addPage(
    //   pw.Page(
    //     // pageFormat: format,
    //       pageFormat: PdfPageFormat.a4,
    //       margin: pw.EdgeInsets.all(20),
    //       orientation: pw.PageOrientation.portrait,
    //       build: (pw.Context context) {
    //         return
    //           pw.Center(
    //             child: pw.Expanded(
    //               child: pw.Image(images),
    //             ),
    //           );
    //       }),
    // );


    // Save the PDF file in the download folder
    // final output = await getTemporaryDirectory();
    final output = await getApplicationDocumentsDirectory();
    final filePath = '${output.path}/${DateFormat('dd MMM yyyy, hh.mm.ss a').format(DateTime.now())}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the share dialog to allow the user to share the PDF file
    await Printing.sharePdf(bytes: await file.readAsBytes(), filename: '${DateFormat('dd MMM yyyy, hh.mm.ss a').format(DateTime.now())}.pdf');
    // await OpenFile.open(filePath);

  }

}

class VitalsData {
  final int date;
  final double value;
  VitalsData(this.date, this.value);
}

class VitalsDate {
  final String date;
  final int value;
  VitalsDate(this.date, this.value);
}

class VitalsTemp {
  final String date;
  final double value;
  VitalsTemp(this.date, this.value);
}
