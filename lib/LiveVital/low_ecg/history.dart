import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app_manager/alert_toast.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../authenticaton/user_repository.dart';
import '../../common_libs.dart';
import 'history_controller.dart';
import 'history_report.dart';

class ReportHistory extends StatefulWidget {
  const ReportHistory({Key? key}) : super(key: key);

  @override
  State<ReportHistory> createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {

  HistoryController controller = Get.put(HistoryController());

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
    await controller.getHistory(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  Back() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Navigator.of(context).pop();
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
                title: Text('History',
                ),
              ),
              body: WillPopScope(
                onWillPop: () {
                  return Back();
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Patient Name and ID
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Patient Name
                            Padding(
                              padding:  EdgeInsets.fromLTRB(8, 10, 0, 0),
                              child: Container(
                                height: 40,
                                color: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Patient Name : ",
                                        style:  MyTextTheme.mediumWCB,
                                      ),
                                      Text(
                                        controller.getPreviousDataList.isNotEmpty
                                            ? controller.getPreviousDataList[0]
                                        ['PName']
                                            .toString()
                                            : '',
                                        style: MyTextTheme.mediumWCB,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Patient ID
                            Padding(
                              padding:  EdgeInsets.fromLTRB(8, 10, 8, 0),
                              child: Container(
                                height: 40,
                                color: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Patient UHID : ",
                                        style:  MyTextTheme.mediumWCB,
                                      ),
                                      Text(userRepository.getUser.uhID.toString(),
                                        style: MyTextTheme.mediumWCB,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // History Data
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// Parameters and Units
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/5.5 : MediaQuery.of(context).size.width/2.5,
                                  child: DataTable(
                                    dataRowHeight : 30,
                                    headingRowColor: MaterialStatePropertyAll(Colors.green.shade600),
                                    horizontalMargin: 8,
                                    columnSpacing: 15,
                                    headingTextStyle: TextStyle(fontSize: MediaQuery.of(context).size.width > 600 ? 11 : 7.5, fontWeight: FontWeight.w600, color: Colors.white,),
                                    border: TableBorder.symmetric(outside: BorderSide(color: Colors.black, width: 1), inside: BorderSide(color: Colors.black, width: 1.5)),

                                    columns: [
                                      DataColumn(label: Text('Parameters'),),
                                      DataColumn(label: Text('Units'),),
                                    ],

                                    rows: [
                                      DataRow(cells: [
                                        DataCell(Text('PP Interval'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('RR Interval'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('PR Interval'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('ST Interval'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('QT Interval'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('QTc Interval'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('QRS Duration'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('P Duration'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('Q Duration'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('R Duration'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('S Duration'),),
                                        DataCell(Text('ms'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('P Amplitude'),),
                                        DataCell(Text('mV'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('Q Amplitude'),),
                                        DataCell(Text('mV'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('R Amplitude'),),
                                        DataCell(Text('mV'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('S Amplitude'),),
                                        DataCell(Text('mV'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('T Amplitude'),),
                                        DataCell(Text('mV'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('Heart Rate'),),
                                        DataCell(Text('bpm'),),
                                      ]),

                                      DataRow(cells: [
                                        DataCell(Text('RR Rhythm'),),
                                        DataCell(Text(''),),
                                      ]),
                                    ],

                                  ),
                                ),
                              ),

                              /// Data coming from API
                              Row(
                                children: List.generate(controller.getPreviousDataList.length, (index) => Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ...List.generate(jsonDecode(controller.getPreviousDataList[index]['responce'] == "NA" ? "[]" : controller.getPreviousDataList[index]['responce'])['perlead'].length, (index2) {controller.selectedData.length;

                                          print('vvvvvvvvvvvv' + jsonDecode(controller.getPreviousDataList[index]['responce'])['perlead'][index2].toString());

                                          var data = jsonDecode(controller.getPreviousDataList[index]['responce'] == "NA" ? "[]" : controller.getPreviousDataList[index]['responce'])['perlead'][index2];

                                          return InkWell(
                                            onTap: () {
                                              controller.updateSelectedData(context,
                                                  jsonFile: controller.getPreviousDataList[index]['jsonFile'],
                                                  val: jsonDecode(controller.getPreviousDataList[index]['responce'])['perlead'].isEmpty ? {} : jsonDecode(controller.getPreviousDataList[index]['responce'])['perlead'][0],
                                                  date: controller.getPreviousDataList[index]['rec_date'].toString());
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/6.4 : MediaQuery.of(context).size.width/4.6,

                                                  color: controller.selectedData.map((e) => e['Date'].toString().trim()).toList().contains(controller.getPreviousDataList[index]['rec_date'].toString()).toString().trim() == 'true' ? Colors.blue.shade100 : Colors.white,

                                                  child: DataTable(
                                                    dataRowHeight: 30,
                                                    headingRowColor: MaterialStatePropertyAll(Colors.green.shade600),
                                                    horizontalMargin: MediaQuery.of(context).size.width/60,
                                                    headingTextStyle: TextStyle(fontSize: MediaQuery.of(context).size.width > 600 ? 10 : 7.5, fontWeight: FontWeight.w600, color: Colors.white),
                                                    border: TableBorder.symmetric(outside: BorderSide(color: Colors.black, width: 1), inside: BorderSide(color: Colors.black, width: 1.5)),

                                                    columns: [
                                                      DataColumn(label: Text(controller.getPreviousDataList[index]['rec_date'].split('.').first.toString()),),
                                                    ],

                                                    rows: [
                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(
                                                            controller.historyTablata(
                                                                index1: index,
                                                                index2:index2,
                                                                leadIntervel:
                                                                'pp_Interval',
                                                                leadValue:
                                                                'V')
                                                                .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'RR_Interval',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'PR_Interval',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                          index1: index,
                                                          index2:index2,
                                                          leadIntervel:
                                                          'ST_Interval',
                                                          leadValue:
                                                          'V')
                                                          .toString()) ),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                          index1: index,
                                                          index2:index2,
                                                          leadIntervel:
                                                          'QT_Interval',
                                                          leadValue:
                                                          'V')
                                                          .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'QTc_Interval',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'QRS_Duration',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child:  Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'P_duration',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'Q_Duration',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child:  Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'R_Duration',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child:Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'S_Duration',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'P_Amplitude',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'Q_Amplitude',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'R_Amplitude',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'S_Amplitude',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'T_Amplitude',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child: Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'Heart_Rate',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),

                                                      DataRow(cells: [
                                                        DataCell(Container(alignment: Alignment.center, child:Text(controller.historyTablata(
                                                            index1: index,
                                                            index2:index2,
                                                            leadIntervel:
                                                            'RR_Rhythm',
                                                            leadValue:
                                                            'V')
                                                            .toString())),),
                                                      ]),
                                                    ],

                                                  ),

                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // View compare report button
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/1.04 : MediaQuery.of(context).size.width/1.04,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if(controller.selectedData.length==2){
                                  Get.to(HistoryReport());}
                                else{

                                  Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Please Select two column'));
                                  // alertToast(context, 'Please Select two column');
                                }

                              },
                              child: Text("View Comparative Report",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
