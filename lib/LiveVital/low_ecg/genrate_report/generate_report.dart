import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../../../app_manager/theme/text_theme.dart';
import '../../../authenticaton/user_repository.dart';
import '../../../medcare_utill.dart';
import '../ecg_controller.dart';
import 'genrate_report_controller.dart';

class GenerateReport extends StatefulWidget {
  GenerateReport({Key? key}) : super(key: key);

  @override
  State<GenerateReport> createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> {

  GenerateReportController controller = Get.put(GenerateReportController());

  final zoomTransformationController = TransformationController();

  String now = DateFormat.yMEd().add_jms().format(DateTime.now());

  final GlobalKey<State<StatefulWidget>> _formKey = GlobalKey();

  final GlobalKey<State<StatefulWidget>> _formKeyy = GlobalKey();

  get() async {
    await controller.saveECGBMData(context);
    await controller.saveDeviceVital(context,  controller.getPerLead.isEmpty ? '0'
        : controller.getPerLead[
    'Lead_II'][
    'Heart_Rate']
    ['V'].toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    get();
  }

  void _zoomIn(){
    zoomTransformationController.value.scale(1.1);
  }

  void _zoomOut(){
    zoomTransformationController.value.scale(0.9);
  }

  void _resetZoom(){
    zoomTransformationController.value = Matrix4.identity();
    dPrint('reset zoom');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<EcgController>();
    Get.delete<GenerateReportController>();
    controller.ecgController.subscription!.cancel();
    controller.ecgController.timer!.cancel();
  }

  Back() async {
    if (controller.ecgController.devicesData != null) {
      controller.ecgController.devicesData!.device.disconnect();
    }
    Get.back( );
    Get.back( );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text("Lead II ECG Report"),
          actions: [
            // Save Button
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        saveAsPdf(context);
                      },
                      label: Text("Save",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                      icon: Icon(Icons.save, color: Colors.blue),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(120, 45)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: () {
            return Back();
          },
          child: SingleChildScrollView(
            child: GetBuilder(
                init: GenerateReportController(),
                builder: (_) {
                  return Center(
                    child: Container(
                      // color: Colors.orange,
                      width: MediaQuery.of(context).size.width/1.02,
                      child: Column(
                        children: <Widget>[

                          RepaintBoundary(
                            key: _formKey,
                            child: Column(
                              children: [

                                // ECG Report (Text)
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("ECG Report",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),

                                // Date and Time
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("${DateFormat("dd MMM yyyy, hh:mm:ss a").format(DateTime.now())}",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                // Patient details start
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.blue.shade50,
                                    child: Column(
                                      children: [

                                        // Patient details (Text)
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                color: Colors.green.shade600,
                                                child: Text("Patient details",
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
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5,),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                        EdgeInsets.all(4.0),
                                                        child: Text('Patient Name: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                      Text(userRepository.getUser.patientName.toString()
                                                      // userRepository.getUser.patientName!.split(' ')[0].toString().toUpperCase()
                                                      //     :userRepository.getUser.patientName.toString().toUpperCase(),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                        EdgeInsets.all(4.0),
                                                        child: Text(
                                                          "UHID : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                      Text(userRepository.getUser.uhID.toString()
                                                      // userRepository.getUser.patientName!.split(' ')[1].toString().toUpperCase():'',
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.all(4.0),
                                                        child: Text("Gender : ",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(userRepository.getUser.gender.toString(),
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
                                                      Padding(padding: EdgeInsets.all(4.0),
                                                        child: Text("Age : ",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Text('${DateTime.now().year - int.parse(userRepository.getUser.dob!.split('/')[2])} Year' ,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.all(4.0),
                                                        child: Text("Height : ",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(userRepository.getUser.height.toString()+' cm',
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.all(4.0),
                                                        child: Text("Weight : ",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(userRepository.getUser.weight.toString()+' kg',
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),

                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                        size: 28,
                                                      ),
                                                      Padding(
                                                        padding:  EdgeInsets.only(left: 5),
                                                        child: Text("Heart Rate",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text(
                                                      controller.genrateReportTableData(interval: 'Heart_Rate', intervalValue: 'V',emptyReturn: '0').toString()+' '+
                                                          controller.genrateReportTableData(interval: 'Heart_Rate', intervalValue: 'U',emptyReturn: 'bpm')
                                                              .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
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

                                // Conclusion start
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.blue.shade50,
                                    child: Column(
                                      children: [

                                        // Conclusion (Text)
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                color: Colors.red,
                                                child: Text("Conclusion",
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

                                        // Table
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Table(
                                            border: TableBorder.all(
                                              color: Colors.grey,
                                              width: 1,
                                            ),

                                            columnWidths: {
                                              0: FlexColumnWidth(1),
                                              1: FlexColumnWidth(1),
                                              2: FlexColumnWidth(1),
                                              3: FlexColumnWidth(1),
                                            },

                                            children: [

                                              TableRow(
                                                children: [
                                                  Container(
                                                    color: Colors.green.shade600,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        "Parameters",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.green.shade600,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        "Observed Values",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.green.shade600,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        "Standard Range",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.green.shade600,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        "Units",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "PP Interval",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'pp_Interval', intervalValue: 'V',emptyReturn: '0')
                                                        .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller.getPerLead.isEmpty ? Colors.black
                                                            :double.parse(controller.genrateReportTableData(interval: 'pp_Interval', intervalValue: 'V',emptyReturn: '0').toString()) > 1200 ?
                                                        Colors.red
                                                            : double.parse(controller.genrateReportTableData(interval: 'pp_Interval', intervalValue: 'V',emptyReturn: '0').toString()) < 500 ?
                                                        Colors.red : Colors.black,

                                                        fontWeight: controller.getPerLead.isEmpty ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'pp_Interval', intervalValue: 'V',emptyReturn: '0').toString()) > 1200 ? FontWeight.bold
                                                            : double.parse(controller.genrateReportTableData(interval: 'pp_Interval', intervalValue: 'V',emptyReturn: '0').toString()) < 500 ? FontWeight.bold : FontWeight.w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'pp_Interval', intervalValue: 'NR',emptyReturn: '0').toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval:
                                                    'pp_Interval', intervalValue: 'U',emptyReturn:'-' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "RR Interval",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'RR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        // color: controller.getPerLead.isEmpty ? Colors.black : (controller.getPerLead['Lead_II']['PR_Interval']['V'] > 100 && controller.getPerLead['Lead_II']['PR_Interval']['V'] < 200)  ? Colors.green : Colors.red,
                                                        color: controller.getPerLead.isEmpty ? Colors.black
                                                            : double.parse(controller.genrateReportTableData(interval: 'RR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) > 1200 ? Colors.red
                                                            : double.parse(controller.genrateReportTableData(interval: 'RR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) < 600 ? Colors.red : Colors.black,
                                                        fontWeight: controller.getPerLead.isEmpty ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'RR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) > 1200 ? FontWeight.bold
                                                            :double.parse(controller.genrateReportTableData(interval: 'RR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) < 600 ? FontWeight.bold : FontWeight.w400,
                                                      ),

                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(
                                                        interval: 'RR_Interval',
                                                        intervalValue: 'NR',emptyReturn:'0' ).toString() ,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(
                                                        interval: 'RR_Interval',
                                                        intervalValue: 'U',emptyReturn:'-' )
                                                        .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "PR Interval",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'PR_Interval', intervalValue: 'V',emptyReturn:'0' )
                                                        .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller.getPerLead.isEmpty ? Colors.black
                                                            : double.parse(controller.genrateReportTableData(interval: 'PR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) > 200 ? Colors.red
                                                            : double.parse(controller.genrateReportTableData(interval: 'PR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) < 120 ? Colors.red : Colors.black,
                                                        fontWeight: controller.getPerLead.isEmpty ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'PR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) > 200 ? FontWeight.bold
                                                            : double.parse(controller.genrateReportTableData(interval: 'PR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) < 120 ? FontWeight.bold : FontWeight.w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'PR_Interval', intervalValue: 'NR',emptyReturn:'0' ).toString()
                                                      ,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(
                                                      controller.genrateReportTableData(interval: 'PR_Interval', intervalValue: 'U',emptyReturn:'-' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(padding: EdgeInsets.only(left: 8, top: 5),
                                                    child: Text("ST Interval",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),


                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'ST_Interval', intervalValue: 'V',emptyReturn:'0' )
                                                        .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller.getPerLead.isEmpty ? Colors.black
                                                            : double.parse(controller.genrateReportTableData(interval: 'ST_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) > 200 ? Colors.red
                                                            : double.parse(controller.genrateReportTableData(interval: 'ST_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) < 120 ? Colors.red : Colors.black,
                                                        fontWeight: controller.getPerLead.isEmpty ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'ST_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) > 200 ? FontWeight.bold
                                                            : double.parse(controller.genrateReportTableData(interval: 'ST_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) < 120 ? FontWeight.bold : FontWeight.w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'ST_Interval', intervalValue: 'NR',emptyReturn:'0' ).toString()
                                                      ,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(
                                                      controller.genrateReportTableData(interval: 'ST_Interval', intervalValue: 'U',emptyReturn:'-' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "QT Interval",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'QT_Interval', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? Colors.black
                                                            : double.parse(controller.genrateReportTableData(interval: 'QT_Interval', intervalValue: 'V',emptyReturn:'0' ).toString(),) >
                                                            450
                                                            ? Colors.red
                                                            :  double.parse(controller.genrateReportTableData(interval: 'QT_Interval', intervalValue: 'V',emptyReturn:'0' ).toString(),) <
                                                            350
                                                            ? Colors.red
                                                            : Colors
                                                            .black,
                                                        fontWeight: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? FontWeight.w400
                                                            :  double.parse(controller.genrateReportTableData(interval: 'QT_Interval', intervalValue: 'V',emptyReturn:'0' ).toString(),) >
                                                            450
                                                            ? FontWeight.bold
                                                            :  double.parse(controller.genrateReportTableData(interval: 'QT_Interval', intervalValue: 'V',emptyReturn:'0' ).toString(),) <
                                                            350
                                                            ? FontWeight
                                                            .bold
                                                            : FontWeight
                                                            .w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'QT_Interval', intervalValue: 'NR',emptyReturn:'0' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'QT_Interval', intervalValue: 'U',emptyReturn:'-' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "QTc Interval",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'QTc_Interval', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? Colors.black
                                                            : double.parse(controller.genrateReportTableData(interval: 'QTc_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) >
                                                            460
                                                            ? Colors.red
                                                            : double.parse(controller.genrateReportTableData(interval: 'QTc_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) <
                                                            360
                                                            ? Colors.red
                                                            : Colors
                                                            .black,
                                                        fontWeight: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'QTc_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) >
                                                            460
                                                            ? FontWeight.bold
                                                            : double.parse(controller.genrateReportTableData(interval: 'QTc_Interval', intervalValue: 'V',emptyReturn:'0' ).toString()) <
                                                            360
                                                            ? FontWeight
                                                            .bold
                                                            : FontWeight
                                                            .w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'QTc_Interval', intervalValue: 'NR',emptyReturn:'0' ).toString()

                                                      ,style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'QTc_Interval', intervalValue: 'U',emptyReturn:'-' ).toString()
                                                      ,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "QRS Duration",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'QRS_Duration', intervalValue: 'V',emptyReturn:'0' ).toString()
                                                      ,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? Colors.black
                                                            : double.parse(controller.genrateReportTableData(interval: 'QRS_Duration', intervalValue: 'V',emptyReturn:'0' ).toString()) >
                                                            120
                                                            ? Colors.red
                                                            : double.parse(controller.genrateReportTableData(interval: 'QRS_Duration', intervalValue: 'V',emptyReturn:'0' ).toString()) <
                                                            70
                                                            ? Colors.red
                                                            : Colors
                                                            .black,
                                                        fontWeight: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'QRS_Duration', intervalValue: 'V',emptyReturn:'0' ).toString()) >
                                                            120
                                                            ? FontWeight.bold
                                                            : double.parse(controller.genrateReportTableData(interval: 'QRS_Duration', intervalValue: 'V',emptyReturn:'0' ).toString())<
                                                            70
                                                            ? FontWeight
                                                            .bold
                                                            : FontWeight
                                                            .w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'QRS_Duration', intervalValue: 'NR',emptyReturn:'0' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'QRS_Duration', intervalValue: 'U',emptyReturn:'-' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "P Duration",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'P_duration', intervalValue: 'V',emptyReturn:'0' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'P_duration', intervalValue: 'NR',emptyReturn:'0' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'P_duration', intervalValue: 'U',emptyReturn:'-' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "Q Duration",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'Q_Duration', intervalValue: 'V',emptyReturn:'0' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'Q_Duration', intervalValue: 'NR',emptyReturn:'0' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'Q_Duration', intervalValue: 'U',emptyReturn:'-' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "R Duration",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'R_Duration', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? Colors.black
                                                            : double.parse(controller.genrateReportTableData(interval: 'R_Duration', intervalValue: 'V',emptyReturn:'0' ).toString(),) >
                                                            100
                                                            ? Colors.red
                                                            :double.parse(controller.genrateReportTableData(interval: 'R_Duration', intervalValue: 'V',emptyReturn:'0' ).toString(),) <
                                                            70
                                                            ? Colors.red
                                                            : Colors
                                                            .black,
                                                        fontWeight: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'R_Duration', intervalValue: 'V',emptyReturn:'0' ).toString(),)>
                                                            100
                                                            ? FontWeight.bold
                                                            :double.parse(controller.genrateReportTableData(interval: 'R_Duration', intervalValue: 'V',emptyReturn:'0' ).toString(),) <
                                                            70
                                                            ? FontWeight
                                                            .bold
                                                            : FontWeight
                                                            .w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'R_Duration', intervalValue: 'NR',emptyReturn:'0' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'R_Duration', intervalValue: 'U',emptyReturn:'-' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "S Duration",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'S_Duration', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'S_Duration', intervalValue: 'NR',emptyReturn:'0' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'S_Duration', intervalValue: 'U',emptyReturn:'-' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "P Amplitude",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'P_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? Colors.black
                                                            :double.parse(controller.genrateReportTableData(interval: 'P_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),)>
                                                            0.25
                                                            ? Colors.red
                                                            :double.parse(controller.genrateReportTableData(interval: 'P_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),) <
                                                            0.10
                                                            ? Colors.red
                                                            : Colors
                                                            .black,
                                                        fontWeight: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'P_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),) >
                                                            0.25
                                                            ? FontWeight.bold
                                                            : double.parse(controller.genrateReportTableData(interval: 'P_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),) <
                                                            0.10
                                                            ? FontWeight
                                                            .bold
                                                            : FontWeight
                                                            .w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'P_Amplitude', intervalValue: 'NR',emptyReturn:'0' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'P_Amplitude', intervalValue: 'U',emptyReturn:'-' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "Q Amplitude",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'Q_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'Q_Amplitude', intervalValue: 'NR',emptyReturn:'0' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'Q_Amplitude', intervalValue: 'U',emptyReturn:'-' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "R Amplitude",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'R_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? Colors.black
                                                            :double.parse(controller.genrateReportTableData(interval: 'R_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),) >
                                                            2
                                                            ? Colors.red
                                                            :double.parse(controller.genrateReportTableData(interval: 'R_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),) <
                                                            0.5
                                                            ? Colors.red
                                                            : Colors
                                                            .black,
                                                        fontWeight: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'R_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),)>
                                                            2
                                                            ? FontWeight.bold
                                                            : double.parse(controller.genrateReportTableData(interval: 'R_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),) <
                                                            0.5
                                                            ? FontWeight
                                                            .bold
                                                            : FontWeight
                                                            .w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'R_Amplitude', intervalValue: 'NR',emptyReturn:'0' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'R_Amplitude', intervalValue: 'U',emptyReturn:'-' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "S Amplitude",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'S_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'S_Amplitude', intervalValue: 'NR',emptyReturn:'0' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'S_Amplitude', intervalValue: 'U',emptyReturn:'-' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "T Amplitude",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'T_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller.getPerLead.isEmpty ? Colors.black
                                                            : double.parse(controller.genrateReportTableData(interval: 'T_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),) > 0.6 ? Colors.red
                                                            : double.parse(controller.genrateReportTableData(interval: 'T_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),) < 0.2 ? Colors.red : Colors.black,
                                                        fontWeight: controller.getPerLead.isEmpty ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'T_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),) > 0.6 ? FontWeight.bold
                                                            :double.parse(controller.genrateReportTableData(interval: 'T_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),)< 0.2 ? FontWeight.bold : FontWeight.w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'T_Amplitude', intervalValue: 'NR',emptyReturn:'0' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'T_Amplitude', intervalValue: 'U',emptyReturn:'-' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "Heart Rate",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'Heart_Rate', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? Colors.black
                                                            : double.parse(controller.genrateReportTableData(interval: 'Heart_Rate', intervalValue: 'V',emptyReturn:'0' ).toString(),) >
                                                            100
                                                            ? Colors.red
                                                            :  double.parse(controller.genrateReportTableData(interval: 'Heart_Rate', intervalValue: 'V',emptyReturn:'0' ).toString(),) <
                                                            60
                                                            ? Colors.red
                                                            : Colors
                                                            .black,
                                                        fontWeight: controller
                                                            .getPerLead
                                                            .isEmpty
                                                            ? FontWeight.w400
                                                            : double.parse(controller.genrateReportTableData(interval: 'Heart_Rate', intervalValue: 'V',emptyReturn:'0' ).toString(),) >
                                                            100
                                                            ? FontWeight.bold
                                                            :  double.parse(controller.genrateReportTableData(interval: 'Heart_Rate', intervalValue: 'V',emptyReturn:'0' ).toString(),) <
                                                            60
                                                            ? FontWeight
                                                            .bold
                                                            : FontWeight
                                                            .w400,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text( controller.genrateReportTableData(interval: 'Heart_Rate', intervalValue: 'NR',emptyReturn:'0' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text( controller.genrateReportTableData(interval: 'Heart_Rate', intervalValue: 'U',emptyReturn:'-' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child: Text(
                                                      "RR Rhythm",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'RR_Rhythm', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'RR_Rhythm', intervalValue: 'NR',emptyReturn:'0' ).toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(controller.genrateReportTableData(interval: 'RR_Rhythm', intervalValue: 'U',emptyReturn:'-' ).toString(),

                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),

                                        // Diagnosis
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(" * Diagnosis : ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(controller.getPerLead.isEmpty ? '-' : controller.getPerLead['Lead_II']['Diagonosis'].toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                                // ECG Graph (Text)
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("ECG Graph : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                // Speed and Chest
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                // Padding(
                                //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(1.0),
                                //     ),
                                //     child: SizedBox(
                                //         // width: 1056,
                                //         width: MediaQuery.of(context).size.width,
                                //         height: 250,
                                //         child: SfCartesianChart(
                                //           plotAreaBorderWidth: 1.0,
                                //           plotAreaBorderColor: Colors.red.shade900,
                                //
                                //           primaryXAxis: CategoryAxis(
                                //             desiredIntervals: 36,
                                //             axisLine: AxisLine(color: Colors.red.shade900),
                                //             labelStyle: TextStyle(fontSize: 0),
                                //             tickPosition: TickPosition.inside,
                                //             interval: 20, // Interval * MajorGridLines = ECG Data (20*36=720)
                                //             minorTicksPerInterval: 4,
                                //             majorGridLines: MajorGridLines(width: 1, color: Colors.red.shade900),
                                //             minorGridLines: MinorGridLines(width: 1, color: Colors.red.shade100),
                                //           ),
                                //
                                //           primaryYAxis: NumericAxis(
                                //             desiredIntervals: 8,
                                //             axisLine: AxisLine(color: Colors.red.shade900),
                                //             minimum: -2,
                                //             maximum: 2,
                                //             labelStyle: TextStyle(fontSize: 0),
                                //             tickPosition: TickPosition.inside,
                                //             minorTicksPerInterval: 4,
                                //             majorGridLines: MajorGridLines(width: 1, color: Colors.red.shade900),
                                //             minorGridLines: MinorGridLines(width: 1, color: Colors.red.shade100),
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
                                //             LineSeries<VitalsData, int>(
                                //               dataSource: List.generate(
                                //                   (controller.ecgController.ecgData.toList().length < 720 ? controller.ecgController.ecgData.toList()
                                //                           : controller.ecgController.ecgData.toList()
                                //                       .getRange((controller.ecgController.ecgData.toList().length - 720),
                                //                                   controller.ecgController.ecgData.toList().length).toList()).length, (index) {
                                //                 var vital = (controller.ecgController.ecgData.toList().length < 720 ? controller.ecgController.ecgData.toList()
                                //                     : controller.ecgController.ecgData.toList()
                                //                     .getRange((controller.ecgController.ecgData.toList().length - 720),
                                //                     controller.ecgController.ecgData.toList().length).toList())[index];
                                //
                                //                 return VitalsData(
                                //                     index,
                                //                     double.parse(vital.toString()));
                                //               }),
                                //               width: 1.0,
                                //               color: Colors.black,
                                //               xValueMapper: (VitalsData sales, _) => sales.date,
                                //               yValueMapper: (VitalsData sales, _) => sales.value,
                                //             ),
                                //           ],
                                //         )),
                                //   ),
                                // ),


                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 1,
                                    height:
                                    MediaQuery.of(context).size.shortestSide >
                                        600
                                        ? MediaQuery.of(context).size.height *
                                        0.37
                                        : MediaQuery.of(context).size.height *
                                        0.45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.0),
                                    ),
                                    child: SfCartesianChart(
                                      plotAreaBorderWidth: 1.0,
                                      plotAreaBorderColor: Colors.red.shade900,
                                      primaryXAxis: CategoryAxis(
                                        desiredIntervals: 36,
                                        axisLine:
                                        AxisLine(color: Colors.red.shade900),
                                        labelStyle: TextStyle(fontSize: 0),
                                        tickPosition: TickPosition.inside,
                                        interval: 20,
                                        // Interval * MajorGridLines = ECG Data (20*36=720)
                                        minorTicksPerInterval: 4,
                                        majorGridLines: MajorGridLines(
                                            width: 1, color: Colors.red.shade900),
                                        minorGridLines: MinorGridLines(
                                            width: 1, color: Colors.red.shade100),
                                      ),
                                      primaryYAxis: NumericAxis(
                                        desiredIntervals: 8,
                                        axisLine:
                                        AxisLine(color: Colors.red.shade900),
                                        minimum: -2,
                                        maximum: 2,
                                        labelStyle: TextStyle(fontSize: 0),
                                        tickPosition: TickPosition.inside,
                                        minorTicksPerInterval: 4,
                                        majorGridLines: MajorGridLines(
                                            width: 1, color: Colors.red.shade900),
                                        minorGridLines: MinorGridLines(
                                            width: 1, color: Colors.red.shade100),
                                      ),
                                      zoomPanBehavior: ZoomPanBehavior(
                                        enablePinching: true,
                                        enablePanning: true,
                                        zoomMode: ZoomMode.x,
                                        enableDoubleTapZooming: true,
                                      ),
                                      series: [
                                        LineSeries<VitalsData, int>(
                                          dataSource: List.generate(
                                              (controller.ecgController.ecgData
                                                  .toList()
                                                  .length <
                                                  720
                                                  ? controller
                                                  .ecgController.ecgData
                                                  .toList()
                                                  : controller
                                                  .ecgController.ecgData
                                                  .toList()
                                                  .getRange(
                                                  (controller
                                                      .ecgController
                                                      .ecgData
                                                      .toList()
                                                      .length -
                                                      720),
                                                  controller
                                                      .ecgController
                                                      .ecgData
                                                      .toList()
                                                      .length)
                                                  .toList())
                                                  .length, (index) {
                                            var vital = (controller
                                                .ecgController.ecgData
                                                .toList()
                                                .length <
                                                720
                                                ? controller.ecgController.ecgData
                                                .toList()
                                                : controller.ecgController.ecgData
                                                .toList()
                                                .getRange(
                                                (controller.ecgController
                                                    .ecgData
                                                    .toList()
                                                    .length -
                                                    720),
                                                controller
                                                    .ecgController.ecgData
                                                    .toList()
                                                    .length)
                                                .toList())[index];
                                            return VitalsData(index,
                                                double.parse(vital.toString()));
                                          }),
                                          width: 1.5,
                                          color: Colors.blue.shade700,
                                          xValueMapper: (VitalsData sales, _) =>
                                          sales.date,
                                          yValueMapper: (VitalsData sales, _) =>
                                          sales.value,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Square image detail, Disclaimer and Notes
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(32, 10, 32, 10),
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                              child: Image.asset('assets/square_detail.png', height: 200, width: 200,),
                                            ),
                                          ],
                                        ),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Disclaimer : ',style: MyTextTheme.smallBCB,),
                                                  Expanded(child: Text('This ECG report generated is the interpretation of electrical parameters. Hence, it can vary in respect of time. Please consult your pysician for more details.',style: MyTextTheme.smallBCN,))
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Notes : ',style: MyTextTheme.smallBCB,),
                                                  Expanded(child: Text(controller.ecgController.notesController.text.toString(),style: MyTextTheme.smallBCN,))
                                                ],
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

                          RepaintBoundary(
                            key: _formKeyy,
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

                                // Comparative ECG Graph (Text)
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("Comparative ECG Graph : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                // ECG Compare Graph
                      Stack(    children: [      // ECG Fix Data
                           Padding(
                                padding: MediaQuery.of(context).size.shortestSide > 600 ?
                  EdgeInsets.only(left: 8, right: 8, top: 28)
                      : EdgeInsets.only(left: 8, right: 8, top: 15),
                  child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: SfSparkLineChart(
                  axisLineColor: Colors.green,
                  axisLineWidth: 2.0,
                                                    color: Colors.blue.shade700,
                    // Heart rate 72 bpm, 250 data points
                    data: [              -0.0413838, -0.0308594, -0.0208164, -0.016782599999999998, -0.0169652, -0.0140768, -0.00581, 0.0022244, 0.005229, 0.0055112, 0.00747, 0.011105400000000001, 0.013197, 0.013446, 0.015305200000000001, 0.020102599999999998, 0.0238874, 0.023157, 0.0202188,
                      0.019422, 0.0211982, 0.0226092, 0.0213974, 0.0175628,
                      0.0141266, 0.0117694, 0.0086154, 0.00332, -0.0017098,
                      -0.005063, -0.0093624, -0.0152056, -0.0133962, 0.0090636, 0.052788,
                      0.0994506, 0.1237032, 0.1108382, 0.06454080000000001, 0.0040836,
                      -0.0455836, -0.06985279999999999, -0.07304, -0.0687406, -0.069637,
                      -0.09193080000000001, -0.1374812, -0.1334308, 0.0576186, 0.4627416,
                      0.8485422, 0.8899592000000001, 0.5312830000000001, 0.061635800000000004,
                      -0.21098599999999998, -0.245348, -0.1895886, -0.1539152, -0.1442872, -0.1362196,
                      -0.12423440000000001, -0.11327839999999999, -0.1031856, -0.0876314,
                      -0.0609552, -0.025896, 0.0085988, 0.0388108, 0.0721768, 0.117611,
                      0.1715278, 0.21722760000000002, 0.2362512, 0.2162316, 0.1538986,
                      0.0635282, -0.0211318, -0.0683588, -0.0767252, -0.0683422,
                      -0.0618184, -0.0582162, -0.052456, -0.0443386, -0.0374662, -0.031955,
                      -0.024319, -0.013761399999999998, -0.0049302, -0.0011619999999999998,
                      0.0008798, 0.00581, 0.0119354, 0.014110000000000001, 0.011288, 0.008715,
                      0.0110058, 0.0167328, 0.021065399999999998, 0.0224432, 0.023572,
                      0.026095200000000002, 0.0276556, 0.0260122, 0.022659000000000002,
                      0.0197706, 0.0158032, 0.0097442, 0.0041002, 0.0026394, 0.0037847999999999996,
                      0.0032038, -0.0012118, -0.0074202, -0.0136784, -0.0159692, -0.0035358,
                      0.0323534, 0.0824356, 0.1203998, 0.12217599999999999, 0.082834, 0.0202022,
                      -0.035822799999999995, -0.0659352, -0.0747, -0.07622720000000001, -0.0771236,
                      -0.0874156, -0.12284, -0.1465946, -0.0302452, 0.3187532, 0.7525444,
                      0.930928, 0.6764998, 0.19410380000000002, -0.1617504, -0.2545942,
                      -0.2049104, -0.1572186, -0.1427434, -0.134958, -0.12303920000000002,
                      -0.1112698, -0.09867039999999999, -0.080095, -0.0553776, -0.029896600000000002,
                      -0.007453400000000001, 0.0160854, 0.0498, 0.0991684, 0.1583308,
                      0.2107204, 0.2380108, 0.22796780000000003, 0.17582720000000002,
                      0.08955700000000001, -0.0033034, -0.0669976, -0.08681799999999999,
                      -0.0774722, -0.0632128, -0.0547468,
                      -0.0495344, -0.0424794, -0.0340964, -0.0267924,
                      -0.0212148, -0.0158198, -0.0091964, -0.0018592, 0.004233,
                      0.0079182, 0.0104082, 0.013197, 0.0153384, 0.0156206,
                      0.0150728, 0.0153218, 0.016384199999999998, 0.0175462,
                      0.018940600000000002, 0.0206504, 0.021862200000000002,
                      0.0212148, 0.018608600000000003, 0.0162182, 0.0152056,
                      0.0139606, 0.011852399999999999, 0.011288, 0.0132136,
                      0.0131804, 0.005477999999999999, -0.008134, -0.0202852,
                      -0.0246344, -0.014574799999999999, 0.017596, 0.0690892,
                      0.1167644, 0.1305922, 0.0984048, 0.0359058,
                      -0.026344199999999998, -0.0653708, -0.0796136,
                      -0.08036059999999999, -0.0770074, -0.0798958,
                      -0.10638940000000001, -0.14144859999999998,
                      -0.0818214, 0.19617880000000001, 0.6322774,
                      0.9227442, 0.8022282, 0.35630239999999996, -0.0700188,
                      -0.249747, -0.23689860000000001, -0.18671680000000002,
                      -0.16525299999999998, -0.1565712, -0.1432248, -0.1260604,
                      -0.10768420000000001, -0.08837840000000001, -0.0684418,
                      -0.0459488, -0.0172806, 0.018177, 0.0575688, 0.1003636,
                      0.1486862, 0.1980878, 0.233645, 0.2386748, 0.2027358,
                      0.12738839999999998, 0.0339304, -0.041317400000000004,
                      -0.0744676, -0.073123, -0.0613204, -0.0542986, -0.0522734,
                      -0.0490032,            ],
                  ),        ),      ),
                     Padding(
                       padding: EdgeInsets.only(left: 8, right: 8),
                       child: Container(
                         width: MediaQuery.of(context).size.width * 1,
                         height: MediaQuery.of(context).size.height * 0.4,
                         child: InteractiveViewer(
                                         boundaryMargin: EdgeInsets.zero,
                                         transformationController: zoomTransformationController,
                                         maxScale: 3.0,
                                         minScale: 1,

                           child: SfCartesianChart(
                             plotAreaBorderColor: Colors.transparent,
                             plotAreaBorderWidth: 2.0,
                             primaryXAxis: CategoryAxis(
                               autoScrollingMode: AutoScrollingMode.end,
                               // visibleMinimum: 758, // for mobile
                               visibleMinimum: MediaQuery.of(context).size.shortestSide > 600 ? 755 : 758,
                               desiredIntervals: 1,
                               axisLine: AxisLine(color: Colors.transparent),
                               labelStyle: TextStyle(fontSize: 0),
                               tickPosition: TickPosition.inside,
                               isVisible: false,
                               minorTicksPerInterval: 4,
                               majorGridLines: MajorGridLines(width: 2, color: Colors.red.shade900),
                               minorGridLines: MinorGridLines(width: 1, color: Colors.red.shade100),
                               ),
                               primaryYAxis: NumericAxis(
                               desiredIntervals: 8,
                               axisLine: AxisLine(color: Colors.transparent),
                               minimum: -2,
                               maximum: 2,
                               labelStyle: TextStyle(fontSize: 0),
                               tickPosition: TickPosition.inside,
                               isVisible: false,
                               minorTicksPerInterval: 4,
                               majorGridLines: MajorGridLines(width: 2, color: Colors.transparent),
                               minorGridLines: MinorGridLines(width: 1, color: Colors.transparent),
                               ),
                               zoomPanBehavior: ZoomPanBehavior(
                               enablePanning: true,            ),
                               series: [
                               LineSeries<VitalsData, int>(
                               dataSource: List.generate(
                               (controller.ecgController.ecgData.toList().length < 1000 ?
                               controller.ecgController.ecgData.toList()
                               : controller.ecgController.ecgData.toList()
                               .getRange((controller.ecgController.ecgData.toList().length - 1000),
                               controller.ecgController.ecgData.toList().length).toList()).length,
                               (index) {
                               var vital = (controller.ecgController.ecgData.toList().length < 1000 ?
                               controller.ecgController.ecgData.toList()
                               : controller.ecgController.ecgData.toList()
                               .getRange((controller.ecgController.ecgData.toList().length - 1000),
                               controller.ecgController.ecgData.toList().length).toList())[index];
                               return VitalsData(
                               index,
                               double.parse(vital.toString()));
                               }),                width: 2.0,
                                 color: Colors.red,
                                 xValueMapper: (VitalsData sales, _) => sales.date,
                                 yValueMapper: (VitalsData sales, _) => sales.value,
                               ),            ],          ),
                         ),        ),      ),    ]),




                                // Stack(clipBehavior: Clip.none,
                                //   children: [
                                //
                                //     // ECG Fix Data
                                //     Padding(
                                //       padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                                //       child: Container(
                                //         width: MediaQuery.of(context).size.width/1.03,
                                //         height: 210,
                                //         child: SfSparkLineChart(
                                //           axisLineColor: Colors.green,
                                //           // Heart rate 72 bpm, 250 data points
                                //           data: [
                                //             -0.0413838, -0.0308594, -0.0208164, -0.016782599999999998, -0.0169652, -0.0140768, -0.00581, 0.0022244, 0.005229, 0.0055112, 0.00747, 0.011105400000000001, 0.013197, 0.013446, 0.015305200000000001, 0.020102599999999998, 0.0238874, 0.023157, 0.0202188, 0.019422, 0.0211982, 0.0226092, 0.0213974, 0.0175628, 0.0141266, 0.0117694, 0.0086154, 0.00332, -0.0017098, -0.005063, -0.0093624, -0.0152056, -0.0133962, 0.0090636, 0.052788, 0.0994506, 0.1237032, 0.1108382, 0.06454080000000001, 0.0040836, -0.0455836, -0.06985279999999999, -0.07304, -0.0687406, -0.069637, -0.09193080000000001, -0.1374812, -0.1334308, 0.0576186, 0.4627416, 0.8485422, 0.8899592000000001, 0.5312830000000001, 0.061635800000000004, -0.21098599999999998, -0.245348, -0.1895886, -0.1539152, -0.1442872, -0.1362196, -0.12423440000000001, -0.11327839999999999, -0.1031856, -0.0876314, -0.0609552, -0.025896, 0.0085988, 0.0388108, 0.0721768, 0.117611, 0.1715278, 0.21722760000000002, 0.2362512, 0.2162316, 0.1538986, 0.0635282, -0.0211318, -0.0683588, -0.0767252, -0.0683422, -0.0618184, -0.0582162, -0.052456, -0.0443386, -0.0374662, -0.031955, -0.024319, -0.013761399999999998, -0.0049302, -0.0011619999999999998, 0.0008798, 0.00581, 0.0119354, 0.014110000000000001, 0.011288, 0.008715, 0.0110058, 0.0167328, 0.021065399999999998, 0.0224432, 0.023572, 0.026095200000000002, 0.0276556, 0.0260122, 0.022659000000000002, 0.0197706, 0.0158032, 0.0097442, 0.0041002, 0.0026394, 0.0037847999999999996, 0.0032038, -0.0012118, -0.0074202, -0.0136784, -0.0159692, -0.0035358, 0.0323534, 0.0824356, 0.1203998, 0.12217599999999999, 0.082834, 0.0202022, -0.035822799999999995, -0.0659352, -0.0747, -0.07622720000000001, -0.0771236, -0.0874156, -0.12284, -0.1465946, -0.0302452, 0.3187532, 0.7525444, 0.930928, 0.6764998, 0.19410380000000002, -0.1617504, -0.2545942, -0.2049104, -0.1572186, -0.1427434, -0.134958, -0.12303920000000002, -0.1112698, -0.09867039999999999, -0.080095, -0.0553776, -0.029896600000000002, -0.007453400000000001, 0.0160854, 0.0498, 0.0991684, 0.1583308, 0.2107204, 0.2380108, 0.22796780000000003, 0.17582720000000002, 0.08955700000000001, -0.0033034, -0.0669976, -0.08681799999999999, -0.0774722, -0.0632128, -0.0547468, -0.0495344, -0.0424794, -0.0340964, -0.0267924, -0.0212148, -0.0158198, -0.0091964, -0.0018592, 0.004233, 0.0079182, 0.0104082, 0.013197, 0.0153384, 0.0156206, 0.0150728, 0.0153218, 0.016384199999999998, 0.0175462, 0.018940600000000002, 0.0206504, 0.021862200000000002, 0.0212148, 0.018608600000000003, 0.0162182, 0.0152056, 0.0139606, 0.011852399999999999, 0.011288, 0.0132136, 0.0131804, 0.005477999999999999, -0.008134, -0.0202852, -0.0246344, -0.014574799999999999, 0.017596, 0.0690892, 0.1167644, 0.1305922, 0.0984048, 0.0359058, -0.026344199999999998, -0.0653708, -0.0796136, -0.08036059999999999, -0.0770074, -0.0798958, -0.10638940000000001, -0.14144859999999998, -0.0818214, 0.19617880000000001, 0.6322774, 0.9227442, 0.8022282, 0.35630239999999996, -0.0700188, -0.249747, -0.23689860000000001, -0.18671680000000002, -0.16525299999999998, -0.1565712, -0.1432248, -0.1260604, -0.10768420000000001, -0.08837840000000001, -0.0684418, -0.0459488, -0.0172806, 0.018177, 0.0575688, 0.1003636, 0.1486862, 0.1980878, 0.233645, 0.2386748, 0.2027358, 0.12738839999999998, 0.0339304, -0.041317400000000004, -0.0744676, -0.073123, -0.0613204, -0.0542986, -0.0522734, -0.0490032,
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //
                                //     // ECG Live data
                                //     Padding(
                                //       padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(1.0),
                                //         ),
                                //         child: SizedBox(
                                //             // width: 1056,
                                //           width: MediaQuery.of(context).size.width/1.03,
                                //             height: 210,
                                //
                                //             child: InteractiveViewer(
                                //               boundaryMargin: EdgeInsets.zero,
                                //               transformationController: zoomTransformationController,
                                //               maxScale: 3.0,
                                //               minScale: 1,
                                //               child: SfCartesianChart(
                                //                 plotAreaBorderWidth: 2.0,
                                //                 plotAreaBorderColor: Colors.white,
                                //
                                //                 primaryXAxis: CategoryAxis(
                                //                   autoScrollingMode: AutoScrollingMode.end,
                                //                   visibleMinimum: 750, // For IOS
                                //                   // visibleMinimum: 744, // For Android
                                //                   desiredIntervals: 1,
                                //                   axisLine: AxisLine(color: Colors.white),
                                //                   labelStyle: TextStyle(fontSize: 0),
                                //                   tickPosition: TickPosition.inside,
                                //                   // interval: 50, // Interval * MajorGridLines = ECG Data (50*9=450)
                                //                   interval: 1000,
                                //                   minorTicksPerInterval: 0,
                                //                   majorGridLines: MajorGridLines(width: 2, color: Colors.red.shade900),
                                //                   minorGridLines: MinorGridLines(width: 1, color: Colors.red.shade100),
                                //                 ),
                                //
                                //                 primaryYAxis: NumericAxis(
                                //                   desiredIntervals: 1,
                                //                   axisLine: AxisLine(color: Colors.white),
                                //                   minimum: -1,
                                //                   maximum: 1,
                                //                   labelStyle: TextStyle(fontSize: 0),
                                //                   tickPosition: TickPosition.inside,
                                //                   minorTicksPerInterval: 0,
                                //                   majorGridLines: MajorGridLines(width: 2, color: Colors.red.shade900),
                                //                   minorGridLines: MinorGridLines(width: 1, color: Colors.red.shade100),
                                //                 ),
                                //
                                //                 zoomPanBehavior: ZoomPanBehavior(
                                //                   // enablePinching: true,
                                //                   enablePanning: true,
                                //                   // zoomMode: ZoomMode.x,
                                //                   // enableDoubleTapZooming: true,
                                //                 ),
                                //
                                //                 series: [
                                //                   LineSeries<VitalsData, int>(
                                //                     dataSource: List.generate(
                                //                         (controller.ecgController.ecgData.toList().length < 1000 ? controller.ecgController.ecgData.toList()
                                //                             : controller.ecgController.ecgData.toList()
                                //                             .getRange((controller.ecgController.ecgData.toList().length - 1000),
                                //                             controller.ecgController.ecgData.toList().length).toList()).length, (index) {
                                //                       var vital = (controller.ecgController.ecgData.toList().length < 1000 ? controller.ecgController.ecgData.toList()
                                //                           : controller.ecgController.ecgData.toList()
                                //                           .getRange((controller.ecgController.ecgData.toList().length - 1000),
                                //                           controller.ecgController.ecgData.toList().length).toList())[index];
                                //
                                //                       return VitalsData(
                                //                           index,
                                //                           double.parse(vital.toString()));
                                //                     }),
                                //                     width: 2.0,
                                //                     color: Colors.red,
                                //                     xValueMapper: (VitalsData sales, _) => sales.date,
                                //                     yValueMapper: (VitalsData sales, _) => sales.value,
                                //                   ),
                                //                 ],
                                //
                                //               ),
                                //             ),
                                //         ),
                                //       ),
                                //     ),
                                //
                                //   ]
                                // ),

                                // Zoom In, Zoom Out and Zoom Reset Button
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    // color: Colors.green.shade400,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _zoomIn();
                                              });
                                            },
                                            child: Icon(Icons.zoom_in, size: 30,)
                                        ),

                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _zoomOut();
                                              });
                                            },
                                            child: Icon(Icons.zoom_out, size: 30,)
                                        ),

                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _resetZoom();
                                              });
                                            },
                                            child: Icon(Icons.restart_alt, size: 30,)
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // ECG Image with Parameters
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Center(
                                    child: Stack(
                                      children: [

                                        Container(
                                          child: Image.asset('assets/eccg.JPG', height: 430, width: 700,),
                                        ),

                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(88, 179, 0, 0),
                                            child: RotatedBox(
                                              quarterTurns: 3,
                                              child:Text( controller.genrateReportTableData(interval:
                                              'P_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                                style: const TextStyle(fontSize: 11),
                                              ),

                                            ),
                                          ),
                                        ),

                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(130, 131, 0, 0),
                                            child: RotatedBox(
                                              quarterTurns: 3,
                                              child:  Text( controller.genrateReportTableData(interval: 'R_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),
                                                style: const TextStyle(fontSize: 11),
                                              ),

                                            ),
                                          ),
                                        ),

                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(232, 46, 0, 0),
                                            child:Text(controller.genrateReportTableData(interval: 'QRS_Duration', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                              style: const TextStyle(fontSize: 11),
                                            ),

                                          ),
                                        ),

                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(318, 61, 0, 0),
                                            child:Text(controller.genrateReportTableData(interval: 'RR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                              style: const TextStyle(fontSize: 11),
                                            ),

                                          ),
                                        ),

                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(314, 190, 0, 0),
                                            child:Text(controller.genrateReportTableData(interval: 'T_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                              style: const TextStyle(fontSize: 11),
                                            ),

                                          ),
                                        ),

                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(148, 240, 0, 0),
                                            child: Text(controller.genrateReportTableData(interval: 'Q_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                              style: const TextStyle(fontSize: 11),
                                            ),

                                          ),
                                        ),

                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(239, 249, 0, 0),
                                            child:  Text(controller.genrateReportTableData(interval: 'S_Amplitude', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                              style: const TextStyle(fontSize: 11),
                                            ),

                                          ),
                                        ),

                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(145, 279, 0, 0),
                                            child: Text(controller.genrateReportTableData(interval: 'PR_Interval', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                              style: const TextStyle(fontSize: 11),
                                            ),

                                          ),
                                        ),

                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(244, 328, 0, 0),
                                            child: Text(controller.genrateReportTableData(interval: 'QT_Interval', intervalValue: 'V',emptyReturn:'0' ).toString(),

                                              style: const TextStyle(fontSize: 11),
                                            ),

                                          ),
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
                  );
                }
            ),
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
    await  Printing.sharePdf(bytes: await file.readAsBytes(), filename: '${DateFormat('dd MMM yyyy, hh.mm.ss a').format(DateTime.now())}.pdf');
    // await OpenFile.open(filePath);

  }

}

class VitalsData {
  final int date;
  final double value;
  VitalsData(this.date, this.value);
}
