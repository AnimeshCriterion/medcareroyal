import 'dart:developer';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Localization/app_localization.dart';
import '../../Modal/vital_chart_data_modal.dart';
import '../../ViewModal/vitals_trend_view_modal.dart';
import '../../app_manager/widgets/buttons/custom_ink_well.dart';

class VitalTrendView extends StatefulWidget {
  const VitalTrendView({Key? key}) : super(key: key);

  @override
  State<VitalTrendView> createState() => _VitalTrendViewState();
}

class _VitalTrendViewState extends State<VitalTrendView> {
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    VitalsTrendsViewModal vitalsTrendsVM =
        Provider.of<VitalsTrendsViewModal>(context, listen: true);
    return ColoredSafeArea(
        child: SafeArea(
            child: Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(
        title: localization.getLocaleData.vitalTrend.toString(),
        color: AppColor.primaryColor,
        titleColor: AppColor.white,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      List.generate(vitalsTrendsVM.VitalTrends.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 60,
                        child: Column(
                          children: [
                            CustomInkWell(
                              onTap: () async {
                                vitalsTrendsVM.updateSelectVitals = vitalsTrendsVM.VitalTrends[index];
                                await vitalsTrendsVM.patientVitalList(context);
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                    color: vitalsTrendsVM.VitalTrends[index]['color'],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Image.asset(
                                  vitalsTrendsVM.VitalTrends[index]["icons"],
                                  height: 40,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: Text(
                                vitalsTrendsVM.VitalTrends[index]['title'],
                                textAlign: TextAlign.center,
                                style: MyTextTheme.smallGCB,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                  // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColor.grey,
                      )),
                  // child: VitalCHartView2()),
                  child:  SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat('dd/MMM/yyyy\nhh:mm'),
                        desiredIntervals: 10,
                        autoScrollingDelta: 200),
                    enableAxisAnimation: true,
                    title: ChartTitle(
                          text: vitalsTrendsVM.getSelectVitals['title'].toString(),
                        backgroundColor: vitalsTrendsVM.getSelectVitals['color'],alignment:ChartAlignment.center,
                        textStyle: MyTextTheme.smallWCB,borderWidth:5

                    ),
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,),
                    tooltipBehavior: TooltipBehavior(enable: true,color: AppColor.white,textStyle: const TextStyle(
                      color: Colors.black,
                    )),
                    series: vitalsTrendsVM.getSelectVitals['id']==-1?
                    [
                      LineSeries<VitalsData,DateTime>(dataSource: List.generate(vitalsTrendsVM.getSystolic.length, (index)
                      {VitalChartData vital=vitalsTrendsVM.getSystolic[index];
                        return VitalsData(DateTime.parse(
                            DateFormat('dd MMM yyyy, hh:mma').parse( vital.vitalDate.toString()).toString()
                        ),  double.parse(vital.vitalValue.toString()));



                      }),
                          markerSettings:  MarkerSettings(
                              isVisible: true,
                              color: Colors.deepPurpleAccent,
                              borderColor:vitalsTrendsVM.getSelectVitals['color']
                          ),
                          enableTooltip: true,
                          color: Colors.deepPurpleAccent,
                          //dataLabelSettings:const DataLabelSettings(isVisible: true),
                          name: localization.getLocaleData.systollic.toString(),
                          xValueMapper: (VitalsData vi, _) => vi.date,
                          yValueMapper: (VitalsData sales, _) => sales.value),
                      //Second graph line Diastoic
                      LineSeries<VitalsData,DateTime>(dataSource:
                      List.generate(vitalsTrendsVM.getDiastolic.length, (index){

                        VitalChartData vital=vitalsTrendsVM.getDiastolic[index];
                        return VitalsData(DateTime.parse(
                            DateFormat('dd MMM yyyy, hh:mma').parse( vital.vitalDate.toString()).toString()
                        ),  double.parse(vital.vitalValue.toString()));


                      }),
                          markerSettings:  MarkerSettings(
                              isVisible: true,
                              color: Colors.orangeAccent,
                              borderColor:vitalsTrendsVM.getSelectVitals['color']
                          ),
                          enableTooltip: true,
                          color: Colors.orangeAccent,
                          //dataLabelSettings:const DataLabelSettings(isVisible: true),
                          name: 'diastolic',
                          xValueMapper: (VitalsData sales, _) => sales.date,
                          yValueMapper: (VitalsData sales, _) => sales.value),
                    ] : [
                      LineSeries<VitalsData,DateTime>(dataSource: List.generate(vitalsTrendsVM.getChartData.length, (index){

                        VitalChartData vital=vitalsTrendsVM.getChartData[index];
                        return
                          VitalsData(
                            DateTime.parse(DateFormat('dd MMM yyyy, hh:mma').parse( vital.vitalDate.toString()).toString()),
                            double.parse(vital.vitalValue.toString())
                        );



                      }),
                          markerSettings:  MarkerSettings(
                              isVisible: true,
                              color:vitalsTrendsVM.getSelectVitals['iconColor'],
                              borderColor:vitalsTrendsVM.getSelectVitals['color']
                          ),
                          enableTooltip: true,
                          color:vitalsTrendsVM.getSelectVitals['iconColor'],
                          dataLabelSettings:const DataLabelSettings(isVisible: true),
                          name:vitalsTrendsVM.getSelectVitals['tittle'].toString(),
                          xValueMapper: (VitalsData sales, _) => sales.date,
                          yValueMapper: (VitalsData sales, _) => sales.value),
                    ],
                  ),),
            )
          ],
        ),
      ),
    )));
  }
}
class VitalsData{
  final DateTime date;
  final double value;

  VitalsData(this.date,this.value);
}