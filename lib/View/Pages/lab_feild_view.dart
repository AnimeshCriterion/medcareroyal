


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/my_button.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/my_text_field_2.dart';
import 'package:medvantage_patient/common_libs.dart';

import '../../ViewModal/report_tracking_view_modal.dart';
import '../../theme/theme.dart';

class LabFeildView extends StatefulWidget {
  const LabFeildView({super.key});

  @override
  State<LabFeildView> createState() => _LabFeildViewState();
}

class _LabFeildViewState extends State<LabFeildView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get(){

    ReportTrackingViewModal reportTrackingVM =
    Provider.of<ReportTrackingViewModal>(context, listen: false);


  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    ReportTrackingViewModal reportTrackingVM =
    Provider.of<ReportTrackingViewModal>(context, listen: true);
    return SafeArea(child: Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              InkWell(
                onTap: (){

                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back_ios),
                ),
              ) ,
              Text('Report Data',style: MyTextTheme.largeBCB,)
              
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(reportTrackingVM.getPatientReportExtraction['patient_name'].toString()+
                '( '+
                reportTrackingVM.getPatientReportExtraction['age'].toString()+'/'+
                reportTrackingVM.getPatientReportExtraction['sex'].toString()+
                ' )',
              style: MyTextTheme.mediumBCB,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: StaggeredGrid.extent(
                  maxCrossAxisExtent: 350,
                  crossAxisSpacing: 2, 
                  children: [
                    ...List.generate(reportTrackingVM.getReportExtraction.length, (index) {
                      var data=reportTrackingVM.getReportExtraction[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Text(data['test_name'].toString(),style: MyTextTheme.mediumBCB,),
                                Text( ' ('+data['normal_values'].toString()+' '+data['unit'].toString()+')' ),
                              ],
                            ),

              
                            MyTextField2(
                              controller: data['val'],
                              style: MyTextTheme.mediumBCN,
                              // suffixIcon: Padding(
                              //   padding: const EdgeInsets.all(3),
                              //   child: Text(data['unit'].toString()),
                              // ),

                            )
              
                          ],
                        ),
                      );
                    }),
                  ]),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyButton(title: 'Save',onPress: () async {
              await reportTrackingVM.insertInvesigation(context);
              Get.back();
            },),
          )



        ],
      ),
    ));
  }
}
