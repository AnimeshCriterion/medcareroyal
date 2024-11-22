import 'dart:io';
import 'package:medvantage_patient/LiveVital/pmd/patient_monitor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../app_manager/app_color.dart';
import '../../authenticaton/user_repository.dart';
import '../device_view.dart';

class PatientReport extends StatefulWidget {
  const PatientReport({Key? key}) : super(key: key);

  @override
  State<PatientReport> createState() => _PatientReportState();
}

class _PatientReportState extends State<PatientReport> {
  MyPatientMonitorController controller = Get.put(MyPatientMonitorController());

  final GlobalKey<State<StatefulWidget>> _formKey = GlobalKey();

  final GlobalKey<State<StatefulWidget>> _formKeyy = GlobalKey();



  Back() {
    if (controller.devicesData != null) {
      controller.devicesData!.device.disconnect();
    }
    Get.offAll(DeviceView());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (controller.devicesData != null) {
      controller.devicesData!.device.disconnect();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<MyPatientMonitorController>();
    controller.scanSubscription!.cancel();
    controller.subscription1!.cancel();
    controller.subscription2!.cancel();
    controller.subscription3!.cancel();
    controller.subscription4!.cancel();
    controller.subscription5!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    return Container(
      color: AppColor.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(backgroundColor:  AppColor.primaryColor,
            title: Text("Patient Report"),
            actions: [
              // Save Button
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    saveAsPdf(context);
                  },
                  icon: Icon(Icons.save, color: Colors.blue),
                  label: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: GetBuilder(
           init: MyPatientMonitorController(),
            builder: (_) {
              return RawScrollbar(
                radius: Radius.circular(15),
                thumbColor: Colors.grey,
                trackVisibility: true,
                interactive: true,
                thumbVisibility: true,
                thickness: 6,
                child: SingleChildScrollView(
                  child: WillPopScope(
                    onWillPop: () {
                      return Back();
                    },
                    child: Center(
                      child: Container(
                        color: Colors.white,
                        width: 1200,
                        // height: 1100,
                        child: Column(
                          children: <Widget>[
                            RepaintBoundary(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Date and PID
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: Container(
                                      height: 48,
                                      // color: Colors.yellow.shade200,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Date : "
                                                "${DateFormat("dd MMM yyyy, hh:mm:ss a").format(DateTime.now())}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "PID : 2510394",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                // textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Patient Monitor (Text)
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                      height: 150,
                                      // color: Colors.yellow.shade200,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Text(
                                          "PATIENT REPORT",
                                          style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Patient details start
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                      width: 1150,
                                      color: Colors.blue.shade50,
                                      child: Column(
                                        children: [
                                          // Patient details (Text)
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.fromLTRB(15, 15, 0, 5),
                                                child: Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  color: Colors.green.shade600,
                                                  child: Text(
                                                    "Patient details",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Patient details
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(4.0),
                                                          child: Text(
                                                            "First Name : ",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          userRepository.getUser.patientName
                                                                  .toString()
                                                                  .contains(' ')
                                                              ? userRepository.getUser.patientName
                                                                  .toString()
                                                                  .split(' ')[0]
                                                                  .toString().toUpperCase()
                                                              : userRepository.getUser.patientName
                                                                  .toString().toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(4.0),
                                                          child: Text(
                                                            "Last Name : ",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          userRepository.getUser.patientName
                                                                  .toString()
                                                                  .contains(' ')
                                                              ? userRepository.getUser.patientName
                                                                  .toString()
                                                                  .split(' ')[1]
                                                                  .toString().toUpperCase()
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(4.0),
                                                          child: Text(
                                                            "Gender : ",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          userRepository.getUser.gender
                                                                      .toString() ==
                                                                  '1'
                                                              ? 'Male'
                                                              : 'Female',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(4.0),
                                                          child: Text(
                                                            "Age : ",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          (DateTime.now().year -
                                                                  int.parse(userRepository.getUser.dob!
                                                                      .split('/')[2]))
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(4.0),
                                                          child: Text(
                                                            "Height : ",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          userRepository.getUser.height
                                                                  .toString() +
                                                              ' cm',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(4.0),
                                                          child: Text(
                                                            "Weight : ",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          userRepository.getUser.weight
                                                                  .toString() +
                                                              ' kg',
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Parameters details start
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                      width: 1150,
                                      color: Colors.blue.shade50,
                                      child: Column(
                                        children: [
                                          // Parameters details (Text)
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.fromLTRB(15, 15, 0, 5),
                                                child: Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  color: Colors.green.shade600,
                                                  child: Text(
                                                    "Parameters details",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Parameters details
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // HR and Temp
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // HR
                                                    Row(
                                                      children: [
                                                        // HR Icon
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Icon(
                                                            Icons.monitor_heart,
                                                            color: Colors.red,
                                                            size: 25,
                                                          ),
                                                        ),

                                                        // HR Text
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            "HR (bpm) : ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),

                                                        // HR Value
                                                        // Text((controller.getHrValue.toString()== '0' || controller.getHrValue.toString()=='') ? '00':controller.getHrValue.toString(),
                                                        Text(
                                                          controller
                                                              .averagehr()
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 30,
                                                    ),

                                                    // Temp
                                                    Row(
                                                      children: [
                                                        // Temp SVG
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: SvgPicture.asset(
                                                            'assets/temperature.svg',
                                                            height: 30,
                                                          ),
                                                        ),

                                                        // Temp Text
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            "Temp (\u2109) : ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),

                                                        // Temp Value
                                                        // Text((controller.getTempValue.toString()=='0' || controller.getTempValue.toString()=='') ? '0.0' : controller.getTempValue.toString(),
                                                        Text(
                                                          controller
                                                              .averagetemp()
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                // SpO2 and PR
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // SpO2
                                                    Row(
                                                      children: [
                                                        // SpO2 SVG
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: SvgPicture.asset(
                                                            'assets/spO2.svg',
                                                            height: 30,
                                                          ),
                                                        ),

                                                        // SpO2 Text
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            "SpO2 (%) : ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),

                                                        // SpO2 Value
                                                        // Text((controller.getSpo2Value.toString() == '0' || controller.getSpo2Value.toString()=='') ? '00' : controller.getSpo2Value.toString(),
                                                        Text(
                                                          controller
                                                              .averagespO2()
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 30,
                                                    ),

                                                    // PR
                                                    Row(
                                                      children: [
                                                        // Pulse SVG
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: SvgPicture.asset(
                                                            'assets/pulse_rate2.svg',
                                                            height: 20,
                                                            color: Colors.red,
                                                          ),
                                                        ),

                                                        // PR Text
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            "PR (bpm) : ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),

                                                        // PR Value
                                                        // Text((controller.getPrValue.toString()== '0' || controller.getPrValue.toString()=='') ? '00':controller.getPrValue.toString(),
                                                        Text(
                                                          controller
                                                              .averagepr()
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                // SYS and DIA
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // SYS
                                                    Row(
                                                      children: [
                                                        // BP SVG
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: controller.getBpData[
                                                                          'mode']
                                                                      .toString() ==
                                                                  'i'
                                                              ? Lottie.asset(
                                                                  'assets/measure.json',
                                                                )
                                                              : SvgPicture.asset(
                                                                  'assets/bloodPressureImage.svg',
                                                                  height: 30),
                                                        ),

                                                        // SYS Text
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            "SYS (mmHg) : ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),

                                                        // SYS Value
                                                        // Text((controller.getBpData['mode'].toString()=='f' || controller.getBpData['mode'].toString()=='i' || controller.getBpData['mode'].toString()!='e') ? controller.getBpData['systolic'].toString() : '00',
                                                        Text(
                                                          controller
                                                              .averagebpsys()
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 30,
                                                    ),

                                                    // DIA
                                                    Row(
                                                      children: [
                                                        // BP SVG
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: controller.getBpData[
                                                                          'mode']
                                                                      .toString() ==
                                                                  'i'
                                                              ? Lottie.asset(
                                                                  'assets/measure.json',
                                                                )
                                                              : SvgPicture.asset(
                                                                  'assets/bloodPressureImage.svg',
                                                                  height: 30),
                                                        ),

                                                        // DIA Text
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            "DIA (mmHg) : ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),

                                                        // DIA Value
                                                        // Text((controller.getBpData['mode'].toString()=='f' || controller.getBpData['mode'].toString()=='i' || controller.getBpData['mode'].toString()!='e') ? controller.getBpData['diastolic'].toString() : '00',
                                                        Text(
                                                          controller
                                                              .averagebpdia()
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
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
                                          width: 1150,
                                          height: 250,
                                          child: SfCartesianChart(
                                            title: ChartTitle(
                                                text: "HR",
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                                alignment: ChartAlignment.near),
                                            plotAreaBorderWidth: 1.0,
                                            plotAreaBorderColor: Colors.black,
                                            primaryXAxis: CategoryAxis(
                                              visibleMaximum: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              interval: 1,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              desiredIntervals: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              minimum: -500,
                                              maximum: 500,
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              majorGridLines: MajorGridLines(
                                                  width: 1, color: Colors.black),
                                            ),
                                            zoomPanBehavior: ZoomPanBehavior(
                                              enablePinching: true,
                                              enablePanning: true,
                                              zoomMode: ZoomMode.x,
                                              enableDoubleTapZooming: true,
                                            ),
                                            series: [
                                              LineSeries<VitalsDate, String>(
                                                dataSource: controller
                                                    .hrValueListGraph
                                                    .map(
                                                      (e) => VitalsDate(
                                                          DateFormat('hh:mm:ss a')
                                                              .format(DateFormat(
                                                                      'yyyy-MM-dd, hh:mm:ss a')
                                                                  .parse(e['date']))
                                                              .toString(),
                                                          int.parse(
                                                              e['value'].toString())),
                                                    )
                                                    .toList(),
                                                width: 1.5,
                                                color: Colors.red,
                                                dataLabelSettings: DataLabelSettings(
                                                  isVisible: true,
                                                  color: Colors.red,
                                                ),
                                                xValueMapper: (VitalsDate sales, _) =>
                                                    sales.date,
                                                yValueMapper: (VitalsDate sales, _) =>
                                                    sales.value,
                                                markerSettings: MarkerSettings(
                                                    isVisible: true,
                                                    color: Colors.red),
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
                                          width: 1150,
                                          height: 250,
                                          child: SfCartesianChart(
                                            title: ChartTitle(
                                                text: "SpO2",
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                                alignment: ChartAlignment.near),
                                            plotAreaBorderWidth: 1.0,
                                            plotAreaBorderColor: Colors.black,
                                            primaryXAxis: CategoryAxis(
                                              visibleMaximum: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              interval: 1,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              desiredIntervals: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              minimum: -500,
                                              maximum: 500,
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              majorGridLines: MajorGridLines(
                                                  width: 1, color: Colors.black),
                                            ),
                                            zoomPanBehavior: ZoomPanBehavior(
                                              enablePinching: true,
                                              enablePanning: true,
                                              zoomMode: ZoomMode.x,
                                              enableDoubleTapZooming: true,
                                            ),
                                            series: [
                                              LineSeries<VitalsDate, String>(
                                                dataSource: controller
                                                    .spO2ValueListGraph
                                                    .map(
                                                      (e) => VitalsDate(
                                                          DateFormat('hh:mm:ss a')
                                                              .format(DateFormat(
                                                                      'yyyy-MM-dd, hh:mm:ss a')
                                                                  .parse(e['date']))
                                                              .toString(),
                                                          int.parse(
                                                              e['value'].toString())),
                                                    )
                                                    .toList(),
                                                width: 1.5,
                                                color: Colors.green,
                                                dataLabelSettings: DataLabelSettings(
                                                  isVisible: true,
                                                  color: Colors.green,
                                                ),
                                                xValueMapper: (VitalsDate sales, _) =>
                                                    sales.date,
                                                yValueMapper: (VitalsDate sales, _) =>
                                                    sales.value,
                                                markerSettings: MarkerSettings(
                                                    isVisible: true,
                                                    color: Colors.green),
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
                                          width: 1150,
                                          height: 250,
                                          child: SfCartesianChart(
                                            title: ChartTitle(
                                                text: "PR",
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                                alignment: ChartAlignment.near),
                                            plotAreaBorderWidth: 1.0,
                                            plotAreaBorderColor: Colors.black,
                                            primaryXAxis: CategoryAxis(
                                              visibleMaximum: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              interval: 1,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              desiredIntervals: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              minimum: -500,
                                              maximum: 500,
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              majorGridLines: MajorGridLines(
                                                  width: 1, color: Colors.black),
                                            ),
                                            zoomPanBehavior: ZoomPanBehavior(
                                              enablePinching: true,
                                              enablePanning: true,
                                              zoomMode: ZoomMode.x,
                                              enableDoubleTapZooming: true,
                                            ),
                                            series: [
                                              LineSeries<VitalsDate, String>(
                                                dataSource: controller
                                                    .prValueListGraph
                                                    .map(
                                                      (e) => VitalsDate(
                                                          DateFormat('hh:mm:ss a')
                                                              .format(DateFormat(
                                                                      'yyyy-MM-dd, hh:mm:ss a')
                                                                  .parse(e['date']))
                                                              .toString(),
                                                          int.parse(
                                                              e['value'].toString())),
                                                    )
                                                    .toList(),
                                                width: 1.5,
                                                color: Colors.blue,
                                                dataLabelSettings: DataLabelSettings(
                                                  isVisible: true,
                                                  color: Colors.blue,
                                                ),
                                                xValueMapper: (VitalsDate sales, _) =>
                                                    sales.date,
                                                yValueMapper: (VitalsDate sales, _) =>
                                                    sales.value,
                                                markerSettings: MarkerSettings(
                                                    isVisible: true,
                                                    color: Colors.blue),
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
                                          width: 1150,
                                          height: 250,
                                          child: SfCartesianChart(
                                            title: ChartTitle(
                                                text: "Temp",
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                                alignment: ChartAlignment.near),
                                            plotAreaBorderWidth: 1.0,
                                            plotAreaBorderColor: Colors.black,
                                            primaryXAxis: CategoryAxis(
                                              visibleMaximum: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              interval: 1,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              desiredIntervals: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              minimum: -500,
                                              maximum: 500,
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              majorGridLines: MajorGridLines(
                                                  width: 1, color: Colors.black),
                                            ),
                                            zoomPanBehavior: ZoomPanBehavior(
                                              enablePinching: true,
                                              enablePanning: true,
                                              zoomMode: ZoomMode.x,
                                              enableDoubleTapZooming: true,
                                            ),
                                            series: [
                                              LineSeries<VitalsTemp, String>(
                                                dataSource: controller
                                                    .tempValueListGraph
                                                    .map(
                                                      (e) => VitalsTemp(
                                                          DateFormat('hh:mm:ss a')
                                                              .format(DateFormat(
                                                                      'yyyy-MM-dd, hh:mm:ss a')
                                                                  .parse(e['date']))
                                                              .toString(),
                                                          double.parse(
                                                              e['value'].toString())),
                                                    )
                                                    .toList(),
                                                width: 1.5,
                                                color: Colors.orange,
                                                dataLabelSettings: DataLabelSettings(
                                                  isVisible: true,
                                                  color: Colors.orange,
                                                ),
                                                xValueMapper: (VitalsTemp sales, _) =>
                                                    sales.date,
                                                yValueMapper: (VitalsTemp sales, _) =>
                                                    sales.value,
                                                markerSettings: MarkerSettings(
                                                    isVisible: true,
                                                    color: Colors.orange),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RepaintBoundary(
                              key: _formKeyy,
                              child: Column(
                                children: [
                                  // Divider
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Divider(
                                      color: Colors.blue,
                                      thickness: 2,
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
                                          width: 1150,
                                          height: 250,
                                          child: SfCartesianChart(
                                            title: ChartTitle(
                                                text: "SYS",
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                                alignment: ChartAlignment.near),
                                            plotAreaBorderWidth: 1.0,
                                            plotAreaBorderColor: Colors.black,
                                            primaryXAxis: CategoryAxis(
                                              visibleMaximum: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              interval: 1,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              desiredIntervals: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              minimum: -500,
                                              maximum: 500,
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              majorGridLines: MajorGridLines(
                                                  width: 1, color: Colors.black),
                                            ),
                                            zoomPanBehavior: ZoomPanBehavior(
                                              enablePinching: true,
                                              enablePanning: true,
                                              zoomMode: ZoomMode.x,
                                              enableDoubleTapZooming: true,
                                            ),
                                            series: [
                                              LineSeries<VitalsDate, String>(
                                                dataSource: controller
                                                    .bpValueListGraph
                                                    .map(
                                                      (e) => VitalsDate(
                                                          DateFormat('hh:mm:ss a')
                                                              .format(DateFormat(
                                                                      'yyyy-MM-dd, hh:mm:ss a')
                                                                  .parse(e['date']))
                                                              .toString(),
                                                          int.parse(
                                                              e['value'].toString() ==
                                                                      '0'
                                                                  ? '0'
                                                                  : e['value']
                                                                      .split(',')[1]
                                                                      .toString())),
                                                    )
                                                    .toList(),
                                                width: 1.5,
                                                color: Colors.indigo,
                                                dataLabelSettings: DataLabelSettings(
                                                  isVisible: true,
                                                  color: Colors.indigo,
                                                ),
                                                xValueMapper: (VitalsDate sales, _) =>
                                                    sales.date,
                                                yValueMapper: (VitalsDate sales, _) =>
                                                    sales.value,
                                                markerSettings: MarkerSettings(
                                                    isVisible: true,
                                                    color: Colors.indigo),
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
                                          width: 1150,
                                          height: 250,
                                          child: SfCartesianChart(
                                            title: ChartTitle(
                                                text: "DIA",
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                                alignment: ChartAlignment.near),
                                            plotAreaBorderWidth: 1.0,
                                            plotAreaBorderColor: Colors.black,
                                            primaryXAxis: CategoryAxis(
                                              visibleMaximum: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              interval: 1,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              desiredIntervals: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              minimum: -500,
                                              maximum: 500,
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              majorGridLines: MajorGridLines(
                                                  width: 1, color: Colors.black),
                                            ),
                                            zoomPanBehavior: ZoomPanBehavior(
                                              enablePinching: true,
                                              enablePanning: true,
                                              zoomMode: ZoomMode.x,
                                              enableDoubleTapZooming: true,
                                            ),
                                            series: [
                                              LineSeries<VitalsDate, String>(
                                                dataSource: controller
                                                    .bpValueListGraph
                                                    .map(
                                                      (e) => VitalsDate(
                                                          DateFormat('hh:mm:ss a')
                                                              .format(DateFormat(
                                                                      'yyyy-MM-dd, hh:mm:ss a')
                                                                  .parse(e['date']))
                                                              .toString(),
                                                          int.parse(
                                                              e['value'].toString() ==
                                                                      '0'
                                                                  ? '0'
                                                                  : e['value']
                                                                      .split(',')[2]
                                                                      .toString())),
                                                    )
                                                    .toList(),
                                                width: 1.5,
                                                color: Colors.purple,
                                                dataLabelSettings: DataLabelSettings(
                                                  isVisible: true,
                                                  color: Colors.purple,
                                                ),
                                                xValueMapper: (VitalsDate sales, _) =>
                                                    sales.date,
                                                yValueMapper: (VitalsDate sales, _) =>
                                                    sales.value,
                                                markerSettings: MarkerSettings(
                                                    isVisible: true,
                                                    color: Colors.purple),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),

                                  // ECG Graph (Text)
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(50, 30, 50, 0),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "ECG Live Graph",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Speed and Chest
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(50, 0, 35, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Speed : 25 mm/sec",
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text("Chest : 10 mm/mV"),
                                      ],
                                    ),
                                  ),

                                  // ECG Live Graph
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(40, 0, 20, 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(1.0),
                                      ),
                                      child: SizedBox(
                                          width: 1150,
                                          height: 250,
                                          child: SfCartesianChart(
                                            plotAreaBorderWidth: 1.0,
                                            plotAreaBorderColor: Colors.red.shade900,
                                            primaryXAxis: CategoryAxis(
                                              visibleMaximum: 720,
                                              autoScrollingMode:
                                                  AutoScrollingMode.end,
                                              desiredIntervals: 36,
                                              axisLine: AxisLine(
                                                  color: Colors.red.shade900),
                                              labelStyle: TextStyle(fontSize: 0),
                                              tickPosition: TickPosition.inside,
                                              interval: 20,
                                              // Interval * MajorGridLines = ECG Data (20*36=720)
                                              minorTicksPerInterval: 4,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.red.shade900),
                                              minorGridLines: MinorGridLines(
                                                  width: 1,
                                                  color: Colors.red.shade100),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              desiredIntervals: 8,
                                              axisLine: AxisLine(
                                                  color: Colors.red.shade900),
                                              minimum: -4000,
                                              maximum: 4000,
                                              labelStyle: TextStyle(fontSize: 0),
                                              tickPosition: TickPosition.inside,
                                              minorTicksPerInterval: 4,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.red.shade900),
                                              minorGridLines: MinorGridLines(
                                                  width: 1,
                                                  color: Colors.red.shade100),
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
                                                    (controller.hrList.toList().length <
                                                                1080
                                                            ? controller.hrList
                                                                .toList()
                                                            : controller.hrList
                                                                .toList()
                                                                .getRange(
                                                                    (controller.hrList
                                                                            .toList()
                                                                            .length -
                                                                        1080),
                                                                    controller.hrList
                                                                        .toList()
                                                                        .length)
                                                                .toList())
                                                        .length, (index) {
                                                  var vital = (controller.hrList
                                                              .toList()
                                                              .length <
                                                          1080
                                                      ? controller.hrList.toList()
                                                      : controller.hrList
                                                          .toList()
                                                          .getRange(
                                                              (controller.hrList
                                                                      .toList()
                                                                      .length -
                                                                  1080),
                                                              controller.hrList
                                                                  .toList()
                                                                  .length)
                                                          .toList())[index];

                                                  return VitalsData(index,
                                                      double.parse(vital.toString()));
                                                }),
                                                width: 1.0,
                                                color: Colors.black,
                                                xValueMapper: (VitalsData sales, _) =>
                                                    sales.date,
                                                yValueMapper: (VitalsData sales, _) =>
                                                    sales.value,
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),

                                  // SpO2 Live Graph
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 20, 30),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(1.0),
                                      ),
                                      child: SizedBox(
                                          width: 1150,
                                          height: 250,
                                          child: SfCartesianChart(
                                            title: ChartTitle(
                                                text: "SpO2 Live Graph",
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                                alignment: ChartAlignment.near),
                                            plotAreaBorderWidth: 1.0,
                                            plotAreaBorderColor: Colors.black,
                                            primaryXAxis: CategoryAxis(
                                              visibleMinimum: 500,
                                              axisLine: AxisLine(color: Colors.black),
                                              labelStyle: TextStyle(fontSize: 0),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              interval: 1,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              desiredIntervals: 4,
                                              axisLine: AxisLine(color: Colors.black),
                                              minimum: -1000,
                                              maximum: 1000,
                                              labelStyle: TextStyle(fontSize: 10),
                                              tickPosition: TickPosition.inside,
                                              majorTickLines: MajorTickLines(
                                                  color: Colors.transparent),
                                              majorGridLines: MajorGridLines(
                                                  width: 1, color: Colors.black),
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
                                                    (controller.spo2List.toList().length <
                                                                1000
                                                            ? controller.spo2List
                                                                .toList()
                                                            : controller.spo2List
                                                                .toList()
                                                                .getRange(
                                                                    (controller
                                                                            .spo2List
                                                                            .toList()
                                                                            .length -
                                                                        1000),
                                                                    controller.hrList
                                                                        .toList()
                                                                        .length)
                                                                .toList())
                                                        .length, (index) {
                                                  var vital = (controller.spo2List
                                                              .toList()
                                                              .length <
                                                          1000
                                                      ? controller.spo2List.toList()
                                                      : controller.spo2List
                                                          .toList()
                                                          .getRange(
                                                              (controller.spo2List
                                                                      .toList()
                                                                      .length -
                                                                  1000),
                                                              controller.spo2List
                                                                  .toList()
                                                                  .length)
                                                          .toList())[index];

                                                  return VitalsData(index,
                                                      double.parse(vital.toString()));
                                                }),
                                                width: 1.5,
                                                color: Colors.blue,
                                                xValueMapper: (VitalsData sales, _) =>
                                                    sales.date,
                                                yValueMapper: (VitalsData sales, _) =>
                                                    sales.value,
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
              );
            }
          ),
        ),
      ),
    );
  }

  Future<void> saveAsPdf(BuildContext context) async {
    final pdf = pw.Document();

    // final image = await WidgetWraper.fromKey(
    //   key: _formKey,
    //   pixelRatio: 2.0,
    // );
    //
    // final images = await WidgetWraper.fromKey(
    //   key: _formKeyy,
    //   pixelRatio: 2.0,
    // );
    //
    // pdf.addPage(
    //   pw.Page(
    //       // pageFormat: format,
    //       pageFormat: PdfPageFormat.a4,
    //       margin: pw.EdgeInsets.all(20),
    //       orientation: pw.PageOrientation.portrait,
    //       build: (pw.Context context) {
    //         return pw.Center(
    //           child: pw.Expanded(
    //             child: pw.Image(image),
    //           ),
    //         );
    //       }),
    // );
    //
    // pdf.addPage(
    //   pw.Page(
    //       // pageFormat: format,
    //       pageFormat: PdfPageFormat.a4,
    //       margin: pw.EdgeInsets.all(20),
    //       orientation: pw.PageOrientation.portrait,
    //       build: (pw.Context context) {
    //         return pw.Center(
    //           child: pw.Expanded(
    //             child: pw.Image(images),
    //           ),
    //         );
    //       }),
    // );

    // Save the PDF file in the download folder
    // final output = await getTemporaryDirectory();
    final output = await getApplicationDocumentsDirectory();
    final filePath =
        '${output.path}/${DateFormat('dd MMM yyyy, hh.mm.ss a').format(DateTime.now())}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the share dialog to allow the user to share the PDF file
    await  Printing.sharePdf(
        bytes: await file.readAsBytes(),
        filename:
            '${DateFormat('dd MMM yyyy, hh.mm.ss a').format(DateTime.now())}.pdf');
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
