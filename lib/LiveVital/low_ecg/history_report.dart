import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../authenticaton/user_repository.dart';
import 'history_controller.dart';
import 'package:pdf/widgets.dart' as pw;

class HistoryReport extends StatefulWidget {
  const HistoryReport({super.key});

  @override
  State<HistoryReport> createState() => _HistoryReportState();
}

class _HistoryReportState extends State<HistoryReport> {

  HistoryController controller = Get.put(HistoryController());

  final zoomTransformationController = TransformationController();

  String now = DateFormat.yMEd().add_jms().format(DateTime.now());

  final GlobalKey<State<StatefulWidget>> _formKey = GlobalKey();

  void _zoomIn() {
    zoomTransformationController.value.scale(1.1);
  }

  void _zoomOut() {
    zoomTransformationController.value.scale(0.9);
  }

  void _resetZoom() {
    zoomTransformationController.value = Matrix4.identity();
    print('reset zoom');
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

  get() async {
    await controller.fileData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    return SafeArea(
      child: GetBuilder(
        init: HistoryController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Comparative ECG Report"),
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
                          icon: Icon(Icons.save, color: Colors.blue),
                          label: Text("Save",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: Size(120, 45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  color: Colors.white,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Column(
                    children: <Widget>[

                      RepaintBoundary(
                        key: _formKey,
                        child: Column(
                          children: [

                            // Date and Time
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width > 600 ? MediaQuery
                                    .of(context)
                                    .size
                                    .width : MediaQuery
                                    .of(context)
                                    .size
                                    .width / 1,
                                height: 110,
                                // color: Colors.yellow.shade200,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5, right: 5),
                                  child: Text(
                                    "${DateFormat("dd MMM yyyy, hh:mm:ss a")
                                        .format(DateTime.now())}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ),

                            // Comparative ECG Report (Text)
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width > 600 ? MediaQuery
                                    .of(context)
                                    .size
                                    .width : MediaQuery
                                    .of(context)
                                    .size
                                    .width / 1,
                                height: 110,
                                // color: Colors.yellow.shade200,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Text("COMPARATIVE ECG REPORT",
                                    style: TextStyle(
                                      fontSize: MediaQuery
                                          .of(context)
                                          .size
                                          .width > 600 ? 50 : 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),

                            // Patient details start
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width > 600 ? MediaQuery
                                    .of(context)
                                    .size
                                    .width : MediaQuery
                                    .of(context)
                                    .size
                                    .width / 1,
                                color: Colors.blue.shade50,
                                child: Column(
                                  children: [

                                    // Patient details (Text)
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
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
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    userRepository.getUser.patientName
                                                        .toString()
                                                        .contains(' ')
                                                        ? userRepository.getUser.patientName
                                                        .toString()
                                                        .split(' ')[0]
                                                        : userRepository.getUser.patientName
                                                        .toString(),
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
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    userRepository.getUser.patientName
                                                        .toString()
                                                        .contains(' ')
                                                        ? userRepository.getUser.patientName
                                                        .toString()
                                                        .split(' ')[1]
                                                        : '',
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
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    userRepository.getUser.gender
                                                        .toString() ==
                                                        '1'
                                                        ? 'Male'
                                                        : 'Female',
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
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${DateTime
                                                        .now()
                                                        .year -
                                                        int.parse(userRepository.getUser.dob!.split(
                                                            '/')[2])} Year',
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
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    userRepository.getUser.height
                                                        .toString() +
                                                        ' cm',
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
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    userRepository.getUser.weight
                                                        .toString() +
                                                        ' kg',
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

                            // Conclusion start
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width > 600 ? MediaQuery
                                    .of(context)
                                    .size
                                    .width : MediaQuery
                                    .of(context)
                                    .size
                                    .width / 1,
                                color: Colors.blue.shade50,
                                child: Column(
                                  children: [

                                    // Conclusion (Text)
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
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

                                    // Data Table
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [

                                            /// Parameters, Minimum, Maximum Value and Units
                                            DataTable(
                                              dataRowHeight: 30,
                                              headingRowColor: MaterialStatePropertyAll(
                                                  Colors.green.shade600),
                                              horizontalMargin: 10,
                                              columnSpacing: 10,
                                              headingTextStyle: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,),
                                              border: TableBorder.symmetric(
                                                  outside: BorderSide(
                                                      color: Colors.black,
                                                      width: 1),
                                                  inside: BorderSide(
                                                      color: Colors.black,
                                                      width: 1.5)),

                                              columns: [
                                                DataColumn(label: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8),
                                                  child: Text('Parameters'),
                                                ),),
                                                DataColumn(label: Text(
                                                    'Minimum \nValue',
                                                    textAlign: TextAlign
                                                        .center),),
                                                DataColumn(label: Text(
                                                    'Maximum \nValue',
                                                    textAlign: TextAlign
                                                        .center),),
                                                DataColumn(label: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4),
                                                  child: Text('Units'),
                                                ),),
                                              ],

                                              rows: [
                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'PP Interval')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('500')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              '1200')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'RR Interval')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('600')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              '1200')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'PR Interval')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('120')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('200')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'ST Interval')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('120')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('200')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'QT Interval')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('350')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('450')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'QTc Interval')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('360')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('460')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'QRS Duration')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('70')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('120')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'P Duration')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('NA')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('NA')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'Q Duration')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('NA')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('NA')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'R Duration')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('70')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('100')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'S Duration')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('NA')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('NA')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('ms',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'P Amplitude')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('0.1')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              '0.25')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('mV',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'Q Amplitude')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('NA')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('NA')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('mV',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'R Amplitude')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('0.5')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('2')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('mV',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'S Amplitude')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('NA')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('NA')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('mV',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'T Amplitude')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('0.2')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('0.6')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('mV',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'Heart Rate')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('60')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text('100')),),
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                            'bpm',)),),
                                                    ]
                                                ),

                                                DataRow(
                                                    cells: [
                                                      DataCell(Container(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                              'RR Rhythm')),),
                                                      DataCell(Text(''),),
                                                      DataCell(Text(''),),
                                                      DataCell(Text('',),),
                                                    ]
                                                ),
                                              ],

                                            ),

                                            /// Observed value
                                            Row(
                                              children:
                                              List.generate(
                                                  controller.getSelectedData
                                                      .length, (index) {
                                                return Column(
                                                  children: [

                                                  /// Get data from API
                                                  DataTable(
                                                  dataRowHeight : 30,
                                                  headingRowColor: MaterialStatePropertyAll(
                                                      Colors.green.shade600),
                                                  horizontalMargin: 10,
                                                  columnSpacing: 10,
                                                  headingTextStyle: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,),
                                                  border: TableBorder.symmetric(
                                                      outside: BorderSide(
                                                          color: Colors.black,
                                                          width: 1),
                                                      inside: BorderSide(
                                                          color: Colors.black,
                                                          width: 1.5)),

                                                  columns: [
                                                    DataColumn(label: Text(
                                                        "Observed Value \n" +
                                                            controller
                                                                .getSelectedData[index]['Date']
                                                                .split('.')
                                                                .first
                                                                .toString(),
                                                        textAlign: TextAlign
                                                            .center),),
                                                  ],

                                                  rows: [
                                                    DataRow(
                                                      cells: [
                                                        DataCell(Container(
                                                          alignment: Alignment
                                                              .center, child:
                                                        Text(controller
                                                            .historyReportTableData(
                                                            index:
                                                            index,
                                                            intervalValue:
                                                            'pp_Interval',
                                                            value:
                                                            'V')
                                                            .toString()),)),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child:
                                                                    Text(
                                                                        controller
                                                                            .getSelectedData[index]['ColumnData']['Lead_II']['RR_Interval']['V']
                                                                            .toString())),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'PR_Interval',
                                                                        value:
                                                                        'V')
                                                                        .toString())),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                    .historyReportTableData(
                                                index:
                                                index,
                                                intervalValue:
                                                'ST_Interval',
                                                value:
                                                'V')
                                                    .toString()) ),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'QT_Interval',
                                                                        value:
                                                                        'V')
                                                                        .toString())),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'QTc_Interval',
                                                                        value:
                                                                        'V')
                                                                        .toString())),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'QRS_Duration',
                                                                        value:
                                                                        'V')
                                                                        .toStringAsFixed(
                                                                        3))),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'P_duration',
                                                                        value:
                                                                        'V')
                                                                        .toString())),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'Q_Duration',
                                                                        value:
                                                                        'V')
                                                                        .toStringAsFixed(
                                                                        3))),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child:  Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'R_Duration',
                                                                        value:
                                                                        'V')
                                                                        .toStringAsFixed(
                                                                        3))),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'S_Duration',
                                                                        value:
                                                                        'V')
                                                                        .toStringAsFixed(
                                                                        3))),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'P_Amplitude',
                                                                        value:
                                                                        'V')
                                                                        .toStringAsFixed(
                                                                        3))),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'Q_Amplitude',
                                                                        value:
                                                                        'V')
                                                                        .toStringAsFixed(
                                                                        3))),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'R_Amplitude',
                                                                        value:
                                                                        'V')
                                                                        .toStringAsFixed(
                                                                        3))),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'S_Amplitude',
                                                                        value:
                                                                        'V')
                                                                        .toStringAsFixed(
                                                                        3))),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'T_Amplitude',
                                                                        value:
                                                                        'V')
                                                                        .toStringAsFixed(
                                                                        3))),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'Heart_Rate',
                                                                        value:
                                                                        'V')
                                                                        .toStringAsFixed(
                                                                        3))),),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text((controller
                                                                        .historyReportTableData(
                                                                        index:
                                                                        index,
                                                                        intervalValue:
                                                                        'RR_Rhythm',
                                                                        value:
                                                                        'V')
                                                                        .toString()))),),
                                                            ]
                                                        ),
                                                      ],

                                                    ),

                                                  ],
                                                );
                                              }),

                                            ),

                                            /// Difference in Observed Values
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [

                                                      /// Second data - first data
                                                      DataTable(
                                                        dataRowHeight: 30,
                                                        headingRowColor: MaterialStatePropertyAll(
                                                            Colors.green
                                                                .shade600),
                                                        horizontalMargin: 10,
                                                        columnSpacing: 10,
                                                        headingTextStyle: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: Colors.white,),
                                                        border: TableBorder
                                                            .symmetric(
                                                            outside: BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 1),
                                                            inside: BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 1.5)),

                                                        columns: [
                                                          DataColumn(
                                                            label: Text(
                                                                "Difference in \nObserved Values",
                                                                textAlign: TextAlign
                                                                    .center),),
                                                        ],

                                                        rows: [
                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'pp_Interval')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'RR_Interval')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'PR_Interval')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'ST_Interval')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'QT_Interval')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'QTc_Interval')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'QRS_Duration')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'P_duration')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'Q_Duration')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'R_Duration')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'S_Duration')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'P_Amplitude')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'Q_Amplitude')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'R_Amplitude')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'S_Amplitude')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'T_Amplitude')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Container(
                                                                      alignment: Alignment
                                                                          .center,
                                                                      child: Text(
                                                                          controller
                                                                              .subtackObsValue(
                                                                              key: 'Heart_Rate')
                                                                              .toString())),),
                                                              ]
                                                          ),

                                                          DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Text(""),),
                                                              ]
                                                          ),
                                                        ],

                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            ),

                                            /// Difference in observed values from min and max value
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children:
                                              List.generate(
                                                  controller.getSelectedData
                                                      .length, (index) {
                                                return Column(
                                                  children: [

                                                    /// Difference in observed values from min and max value
                                                    DataTable(
                                                      dataRowHeight: 30,
                                                      headingRowColor: MaterialStatePropertyAll(
                                                          Colors.green
                                                              .shade600),
                                                      horizontalMargin: 10,
                                                      columnSpacing: 10,
                                                      headingTextStyle: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: Colors.white,),
                                                      border: TableBorder
                                                          .symmetric(
                                                          outside: BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 1),
                                                          inside: BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 1.5)),

                                                      columns: [
                                                        DataColumn(label: Text(
                                                            "Difference in observed values \n from min and max value \n" +
                                                                controller
                                                                    .getSelectedData[index]['Date']
                                                                    .split('.')
                                                                    .first
                                                                    .toString(),
                                                            textAlign: TextAlign
                                                                .center),),
                                                      ],

                                                      rows: [
                                                        DataRow(
                                                            color: MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'pp_Interval',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                500
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'pp_Interval', value: 'V').toString()) >
                                                                1200
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'pp_Interval',
                                                                        firstValue: 500,
                                                                        secondValue: 1200)
                                                                        .toString(),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'pp_Interval', value: 'V').toString()) <
                                                                          500
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'pp_Interval', value: 'V').toString()) > 1200
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color: MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'RR_Interval',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                600
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'RR_Interval', value: 'V').toString()) >
                                                                1200
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'RR_Interval',
                                                                        firstValue: 600,
                                                                        secondValue: 1200)
                                                                        .toString(),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'RR_Interval', value: 'V').toString()) <
                                                                          600
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'RR_Interval', value: 'V').toString()) > 1200
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color: MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'PR_Interval',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                120
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'PR_Interval', value: 'V').toString()) >
                                                                200
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'PR_Interval',
                                                                        firstValue: 120,
                                                                        secondValue: 200)
                                                                        .toString(),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'PR_Interval', value: 'V').toString()) <
                                                                          120
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'PR_Interval', value: 'V').toString()) > 200
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color: MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'ST_Interval',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                350
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'QT_Interval', value: 'V').toString()) >
                                                                450
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'ST_Interval',
                                                                        firstValue: 350,
                                                                        secondValue: 450)
                                                                        .toString(),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'QT_Interval', value: 'V').toString()) <
                                                                          350
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'QT_Interval', value: 'V').toString()) > 450
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color: MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'QT_Interval',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                360
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'QTc_Interval', value: 'V').toString()) >
                                                                460
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'QT_Interval',
                                                                        firstValue: 350,
                                                                        secondValue: 450)
                                                                        .toString(),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'QT_Interval', value: 'V').toString()) <
                                                                          350
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'QT_Interval', value: 'V').toString()) > 450
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color: MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'QTc_Interval',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                360
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'QTc_Interval', value: 'V').toString()) >
                                                                460
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'QTc_Interval',
                                                                        firstValue: 360,
                                                                        secondValue: 460)
                                                                        .toString(),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'QTc_Interval', value: 'V').toString()) <
                                                                          360
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'QTc_Interval', value: 'V').toString()) > 460
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color:  MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'QRS_Duration',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                70
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'QRS_Duration', value: 'V').toString()) >
                                                                120
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'QRS_Duration',
                                                                        firstValue: 70,
                                                                        secondValue: 120)
                                                                        .toStringAsFixed(3),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'QRS_Duration', value: 'V').toString()) <
                                                                          70
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'QRS_Duration', value: 'V').toString()) > 120
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(
                                                                        "NA")),),
                                                              // P_duration
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(
                                                                        "NA")),),
                                                              // Q_Duration
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color:MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'R_Duration',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                70
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'R_Duration', value: 'V').toString()) >
                                                                100
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child:Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'R_Duration',
                                                                        firstValue: 70,
                                                                        secondValue: 100)
                                                                        .toStringAsFixed(3),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'R_Duration', value: 'V').toString()) <
                                                                          70
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'R_Duration', value: 'V').toString()) > 100
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(
                                                                        "NA")),),
                                                              // S_Duration
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color: MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'P_Amplitude',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                0.1
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'P_Amplitude', value: 'V').toString()) >
                                                                0.25
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'P_Amplitude',
                                                                        firstValue: 0.1,
                                                                        secondValue: 0.25)
                                                                        .toStringAsFixed(3),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'P_Amplitude', value: 'V').toString()) <
                                                                          0.1
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'P_Amplitude', value: 'V').toString()) > 0.25
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(
                                                                        "NA")),),
                                                              // Q_Amplitude
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color: MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'R_Amplitude',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                0.5
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'R_Amplitude', value: 'V').toString()) >
                                                                2
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child:  Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'R_Amplitude',
                                                                        firstValue: 0.5,
                                                                        secondValue: 2)
                                                                        .toStringAsFixed(3),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'R_Amplitude', value: 'V').toString()) <
                                                                          0.5
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'R_Amplitude', value: 'V').toString()) > 2
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    child: Text(
                                                                        "NA")),),
                                                              // S_Amplitude
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color: MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'T_Amplitude',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                0.2
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'T_Amplitude', value: 'V').toString()) >
                                                                0.6
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'T_Amplitude',
                                                                        firstValue: 0.2,
                                                                        secondValue: 0.6)
                                                                        .toStringAsFixed(3),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'T_Amplitude', value: 'V').toString()) <
                                                                          0.2
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'T_Amplitude', value: 'V').toString()) > 0.6
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            color: MaterialStatePropertyAll(double.parse(controller
                                                                .historyReportTableData(
                                                                index:
                                                                index,
                                                                intervalValue:
                                                                'Heart_Rate',
                                                                value:
                                                                'V')
                                                                .toString()) <
                                                                60
                                                                ? Colors.red
                                                                : double.parse(controller.historyReportTableData(index: index, intervalValue: 'Heart_Rate', value: 'V').toString()) >
                                                                100
                                                                ? Colors
                                                                .blue
                                                                : Colors
                                                                .blue
                                                                .shade50),
                                                            cells: [
                                                              DataCell(
                                                                Container(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    controller
                                                                        .changeObsValue(
                                                                        index: index,
                                                                        keyName: 'Heart_Rate',
                                                                        firstValue: 60,
                                                                        secondValue: 100)
                                                                        .toString(),
                                                                    style:
                                                                    TextStyle(
                                                                      color: double.parse(controller.historyReportTableData(index: index, intervalValue: 'Heart_Rate', value: 'V').toString()) <
                                                                          60
                                                                          ? Colors.white
                                                                          : double.parse(controller.historyReportTableData(index: index, intervalValue: 'Heart_Rate', value: 'V').toString()) > 100
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        ),

                                                        DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Text(""),),
                                                              // RR_Rhythm
                                                            ]
                                                        ),
                                                      ],

                                                    ),

                                                  ],
                                                );
                                              }),

                                            ),

                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),

                            // Comparative ECG Graph (Text)
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width > 600 ? MediaQuery
                                    .of(context)
                                    .size
                                    .width : MediaQuery
                                    .of(context)
                                    .size
                                    .width / 1,
                                // color: Colors.yellow.shade200,
                                child: Text("Comparative ECG Graph : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            // Speed and Chest
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width > 600 ? MediaQuery
                                    .of(context)
                                    .size
                                    .width : MediaQuery
                                    .of(context)
                                    .size
                                    .width / 1,
                                // color: Colors.yellow.shade200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Speed : 25 mm/sec",),
                                    SizedBox(width: 50,),
                                    Text("Chest : 10 mm/mV"),
                                  ],
                                ),
                              ),
                            ),

                            // Compare ECG Graph 0 and 1
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Stack(
                                children: [

                                  // Compare ECG Graph 0 Fix
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            1.0),
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width > 600 ? MediaQuery
                                            .of(context)
                                            .size
                                            .width : MediaQuery
                                            .of(context)
                                            .size
                                            .width / 0.8,
                                        height: 250,
                                        child: SfCartesianChart(
                                          plotAreaBorderWidth: 1.0,
                                          plotAreaBorderColor: Colors.red
                                              .shade900,

                                          primaryXAxis: CategoryAxis(
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
                                            minimum: -2,
                                            maximum: 2,
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

                                          // zoomPanBehavior: ZoomPanBehavior(
                                          //   enablePinching: true,
                                          //   enablePanning: true,
                                          //   zoomMode: ZoomMode.x,
                                          //   enableDoubleTapZooming: true,
                                          // ),

                                          series: [

                                            LineSeries<VitalsData, int>(
                                              dataSource: List.generate(
                                                  (controller.getFileDataList
                                                      .isEmpty ? [] : controller
                                                      .graphList(0)
                                                      .length < 720 ? controller
                                                      .graphList(0) : controller
                                                      .graphList(0)
                                                      .getRange((controller
                                                      .graphList(0)
                                                      .length - 720),
                                                      controller
                                                          .graphList(0)
                                                          .length).toList())
                                                      .length, (index) {
                                                var vital = (controller
                                                    .graphList(0)
                                                    .length < 720 ? controller
                                                    .graphList(0) : controller
                                                    .graphList(0)
                                                    .getRange((controller
                                                    .graphList(0)
                                                    .length - 720),
                                                    controller
                                                        .graphList(0)
                                                        .length)
                                                    .toList())[index];

                                                return VitalsData(
                                                    index,
                                                    double.parse(
                                                        vital.toString()));
                                              }),
                                              width: 1.0,
                                              color: Colors.black,
                                              xValueMapper: (VitalsData sales,
                                                  _) => sales.date,
                                              yValueMapper: (VitalsData sales,
                                                  _) => sales.value,
                                            ),

                                            // LineSeries<VitalsData, int>(
                                            //   dataSource: List.generate(
                                            //       (controller.getFileDataList.isEmpty ? [] : controller.graphList(1).length < 720 ? controller.graphList(1) : controller.graphList(1)
                                            //           .getRange((controller.graphList(1).length - 720),
                                            //           controller.graphList(1).length).toList()).length, (index) {
                                            //     var vital = (controller.graphList(1).length < 720 ? controller.graphList(1) : controller.graphList(1)
                                            //         .getRange((controller.graphList(1).length - 720),
                                            //         controller.graphList(1).length).toList())[index];
                                            //
                                            //     return VitalsData(
                                            //         index,
                                            //         double.parse(vital.toString()));
                                            //   }),
                                            //   width: 1.0,
                                            //   color: Colors.blue,
                                            //   xValueMapper: (VitalsData sales, _) => sales.date,
                                            //   yValueMapper: (VitalsData sales, _) => sales.value,
                                            // ),

                                          ],

                                        ),
                                      ),
                                    ),
                                  ),

                                  // Compare ECG Graph 1 Not Fix
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            1.0),
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width > 600 ? MediaQuery
                                            .of(context)
                                            .size
                                            .width : MediaQuery
                                            .of(context)
                                            .size
                                            .width / 0.8,
                                        height: 250,
                                        child: InteractiveViewer(
                                          boundaryMargin: EdgeInsets.zero,
                                          transformationController: zoomTransformationController,
                                          maxScale: 3.0,
                                          minScale: 1,
                                          child: SfCartesianChart(
                                            plotAreaBorderWidth: 1.0,
                                            plotAreaBorderColor: Colors
                                                .transparent,

                                            primaryXAxis: CategoryAxis(
                                              autoScrollingMode: AutoScrollingMode
                                                  .end,
                                              visibleMinimum: 720,
                                              desiredIntervals: 36,
                                              axisLine: AxisLine(
                                                  color: Colors.transparent),
                                              labelStyle: TextStyle(
                                                  fontSize: 0),
                                              tickPosition: TickPosition.inside,
                                              interval: 20,
                                              // Interval * MajorGridLines = ECG Data (20*36=720)
                                              minorTicksPerInterval: 4,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                              minorGridLines: MinorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                            ),

                                            primaryYAxis: NumericAxis(
                                              desiredIntervals: 8,
                                              axisLine: AxisLine(
                                                  color: Colors.transparent),
                                              minimum: -2,
                                              maximum: 2,
                                              labelStyle: TextStyle(
                                                  fontSize: 0),
                                              tickPosition: TickPosition.inside,
                                              minorTicksPerInterval: 4,
                                              majorGridLines: MajorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                              minorGridLines: MinorGridLines(
                                                  width: 1,
                                                  color: Colors.transparent),
                                            ),

                                            zoomPanBehavior: ZoomPanBehavior(
                                              // enablePinching: true,
                                              enablePanning: true,
                                              // zoomMode: ZoomMode.xy,
                                              // enableDoubleTapZooming: true,
                                              // maximumZoomLevel: 0.5,
                                            ),

                                            series: [

                                              // LineSeries<VitalsData, int>(
                                              //   dataSource: List.generate(
                                              //       (controller.getFileDataList.isEmpty ? [] : controller.graphList(0).length < 720 ? controller.graphList(0) : controller.graphList(0)
                                              //           .getRange((controller.graphList(0).length - 720),
                                              //           controller.graphList(0).length).toList()).length, (index) {
                                              //     var vital = (controller.graphList(0).length < 720 ? controller.graphList(0) : controller.graphList(0)
                                              //         .getRange((controller.graphList(0).length - 720),
                                              //         controller.graphList(0).length).toList())[index];
                                              //
                                              //     return VitalsData(
                                              //         index,
                                              //         double.parse(vital.toString()));
                                              //   }),
                                              //   width: 1.0,
                                              //   color: Colors.black,
                                              //   xValueMapper: (VitalsData sales, _) => sales.date,
                                              //   yValueMapper: (VitalsData sales, _) => sales.value,
                                              // ),

                                              LineSeries<VitalsData, int>(
                                                dataSource: List.generate(
                                                    (controller.getFileDataList
                                                        .isEmpty
                                                        ? []
                                                        : controller
                                                        .graphList(1)
                                                        .length < 1440
                                                        ? controller.graphList(
                                                        1)
                                                        : controller.graphList(
                                                        1)
                                                        .getRange((controller
                                                        .graphList(1)
                                                        .length - 1440),
                                                        controller
                                                            .graphList(1)
                                                            .length).toList())
                                                        .length, (index) {
                                                  var vital = (controller
                                                      .graphList(1)
                                                      .length < 1440
                                                      ? controller.graphList(1)
                                                      : controller.graphList(1)
                                                      .getRange((controller
                                                      .graphList(1)
                                                      .length - 1440),
                                                      controller
                                                          .graphList(1)
                                                          .length)
                                                      .toList())[index];

                                                  return VitalsData(
                                                      index,
                                                      double.parse(
                                                          vital.toString()));
                                                }),
                                                width: 1.0,
                                                color: Colors.blue,
                                                xValueMapper: (VitalsData sales,
                                                    _) => sales.date,
                                                yValueMapper: (VitalsData sales,
                                                    _) => sales.value,
                                              ),

                                            ],

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            // Zoom In, Zoom Out and Zoom Reset Button
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width > 600 ? MediaQuery
                                    .of(context)
                                    .size
                                    .width : MediaQuery
                                    .of(context)
                                    .size
                                    .width / 1,
                                // color: Colors.yellow.shade200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
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
                                        child: Icon(
                                          Icons.restart_alt, size: 30,)
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
            ),
          );
        },),
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
    // pdf.addPage(
    //   pw.Page(
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


    // Save the PDF file in the download folder
    // final output = await getTemporaryDirectory();
    final output = await getApplicationDocumentsDirectory();
    final filePath = '${output.path}/${DateFormat('dd MMM yyyy, hh.mm.ss a')
        .format(DateTime.now())}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the share dialog to allow the user to share the PDF file
    await Printing.sharePdf(bytes: await file.readAsBytes(),
        filename: '${DateFormat('dd MMM yyyy, hh.mm.ss a').format(
            DateTime.now())}.pdf');
    // await OpenFile.open(filePath);

  }

}

class VitalsData {
  final int date;
  final double value;

  VitalsData(this.date, this.value);
}
