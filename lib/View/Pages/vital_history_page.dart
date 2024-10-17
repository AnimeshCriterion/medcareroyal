import 'package:intl/intl.dart';
import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ViewModal/addvital_view_modal.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/comman_widget.dart';
import '../../app_manager/widgets/buttons/primary_button.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';

class VitalHistoryPage extends StatefulWidget {
  const VitalHistoryPage({super.key});

  @override
  State<VitalHistoryPage> createState() => _VitalHistoryPageState();
}

class _VitalHistoryPageState extends State<VitalHistoryPage> {

  @override
  void initState() {
    get();
    super.initState();
  }

  get() async {
    AddVitalViewModal addvitalVM =
    Provider.of<AddVitalViewModal>(context, listen: false);
   await addvitalVM.hitVitalHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    AddVitalViewModal addvitalVM =
    Provider.of<AddVitalViewModal>(context, listen: true);


    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    return ColoredSafeArea(
      child: SafeArea(child: Scaffold(
        appBar: CustomAppBar(title: localization.getLocaleData.vitalHistory.toString(),
color: themeChange.darkTheme==true? AppColor.neoBGGrey2:AppColor.neoBGWhite1,
          titleColor:  themeChange.darkTheme==true? AppColor.white:AppColor.greyDark,
          primaryBackColor: themeChange.darkTheme==true? AppColor.white:AppColor.greyDark,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                  themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                  themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                  themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                  themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                ]
            ),
            color: Colors.grey.shade800,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                child: Row(
                  children: [
                    // Expanded(child: Text('Last vitals',style: MyTextTheme.largeWCN.copyWith(color:  themeChange.darkTheme == true ?Colors.white70:Colors.grey.shade900),)),
                    // Container(
                    //   height: 36,
                    // decoration:  BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),
                    //   border: Border.all(color: themeChange.darkTheme == true ? Colors.grey.shade800:Colors.grey),
                    //   color: themeChange.darkTheme == true ?AppColor.neoBGGrey2:Colors.white
                    // ),
                    //   child: Center(child:
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       children: [
                    //         Text('Weekly',style: MyTextTheme.mediumWCN.copyWith(color:  themeChange.darkTheme == true ?Colors.white:Colors.black),),
                    //          Icon(Icons.keyboard_arrow_down,color: themeChange.darkTheme == true ?Colors.white70:Colors.black87)
                    //       ],
                    //     ),
                    //   )),)
                  ],
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: CommonWidgets().showNoData(
                  title:localization.getLocaleData.noDataFound.toString(),
                  show: (addvitalVM.getShowNoData &&
                      (addvitalVM.getVitalHistoryList
                          .isEmpty)),
                  loaderTitle: localization.getLocaleData.Loading.toString(),
                  showLoader: (!addvitalVM.getShowNoData  &&
                      (addvitalVM.getVitalHistoryList
                          .isEmpty)),
                  child: DataTable(
                      headingRowColor: MaterialStatePropertyAll(
                          themeChange.darkTheme?  Colors.grey.shade800:Colors.grey.shade300),
                      columns: [
                        DataColumn(label:Text('Vital',style:themeChange.darkTheme? MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),
                        ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toList().toSet().length, (index) {
                          var data=addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']) .toSet().toList()[index];
                          return DataColumn(label: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(DateFormat("dd MMM yyyy").format(DateTime.parse(data .toString().split(' ')[0].toString())),
                                  style:   themeChange.darkTheme? MyTextTheme.mediumWCB:MyTextTheme.mediumGCB,),
                                Text(data .toString().split(' ')[1].toString(),
                                  style: themeChange.darkTheme? MyTextTheme.smallWCB:MyTextTheme.smallGCB,),
                              ],
                            ));
                        })],
                      rows:
                      [
                        DataRow(cells:
                        [
                          DataCell(Text('BP_Dias',style: themeChange.darkTheme?
                          MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),

                          ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:
                          addvitalVM.getVitalHistoryList.map((e) =>
                          e['vitalDateTime']).toSet().toList().length, (index3) {
                            var vitalDate= addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toSet().toList();
                            return DataCell( Text(addvitalVM.dateWiseVitalMap(vitalDate[index3],6).toString(),
                              style: themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumGCN,),);
                          })],),


                        DataRow(cells:
                        [
                          DataCell(Text('BP_Sys',textAlign: TextAlign.center,
                            style: themeChange.darkTheme? MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),

                          ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:
                          addvitalVM.getVitalHistoryList.map((e) =>
                          e['vitalDateTime']).toSet().toList().length, (index3) {
                            var vitalDate= addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toSet().toList();
                            return DataCell( Text(addvitalVM.dateWiseVitalMap(vitalDate[index3],4).toString(),
                              textAlign: TextAlign.center,  style: themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumGCN,),);
                          })],),

                        DataRow(cells:
                        [
                          DataCell(Text('Temp',style: themeChange.darkTheme?
                          MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),

                          ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:
                          addvitalVM.getVitalHistoryList.map((e) =>
                          e['vitalDateTime']).toSet().toList().length, (index3) {
                            var vitalDate= addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toSet().toList();
                            return DataCell( Text(addvitalVM.dateWiseVitalMap(vitalDate[index3],5).toString(),
                              style:themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumGCN,),);
                          })],),

                        DataRow(cells:
                        [
                          DataCell(Text('RR',style:themeChange.darkTheme?
                          MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),

                          ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:
                          addvitalVM.getVitalHistoryList.map((e) =>
                          e['vitalDateTime']).toSet().toList().length, (index3) {
                            var vitalDate= addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toSet().toList();
                            return DataCell( Text(addvitalVM.dateWiseVitalMap(vitalDate[index3],7).toString(),
                              style: themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumGCN,),);
                          })],),
                        DataRow(cells:
                        [
                          DataCell(Text('SPO2',style: themeChange.darkTheme?
                          MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),

                          ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:
                          addvitalVM.getVitalHistoryList.map((e) =>
                          e['vitalDateTime']).toSet().toList().length, (index3) {
                            var vitalDate= addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toSet().toList();
                            return DataCell( Text(addvitalVM.dateWiseVitalMap(vitalDate[index3],56).toString(),
                              style: themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumGCN,),);
                          })],),
                        DataRow(cells:
                        [
                          DataCell(Text('HR',style: themeChange.darkTheme?
                          MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),

                          ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:
                          addvitalVM.getVitalHistoryList.map((e) =>
                          e['vitalDateTime']).toSet().toList().length, (index3) {
                            var vitalDate= addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toSet().toList();
                            return DataCell( Text(addvitalVM.dateWiseVitalMap(vitalDate[index3],74).toString(),
                              style:themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumGCN,),);
                          })],),
                        DataRow(cells:
                        [
                          DataCell(Text('PR',style:themeChange.darkTheme? MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),

                          ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:
                          addvitalVM.getVitalHistoryList.map((e) =>
                          e['vitalDateTime']).toSet().toList().length, (index3) {
                            var vitalDate= addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toSet().toList();
                            return DataCell( Text(addvitalVM.dateWiseVitalMap(vitalDate[index3],3).toString(),
                              style:themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumGCN,),);
                          })],),
                        DataRow(cells:
                        [
                          DataCell(Text('RBS',style:themeChange.darkTheme? MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),

                          ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:
                          addvitalVM.getVitalHistoryList.map((e) =>
                          e['vitalDateTime']).toSet().toList().length, (index3) {
                            var vitalDate= addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toSet().toList();
                            return DataCell( Text(addvitalVM.dateWiseVitalMap(vitalDate[index3],10).toString(),
                              style:themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumGCN,),);
                          })],),
                        // DataRow(cells:
                        // [
                        //   DataCell(Text('Height',style:themeChange.darkTheme?
                        //   MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),
                        //
                        //   ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:
                        //   addvitalVM.getVitalHistoryList.map((e) =>
                        //   e['vitalDateTime']).toSet().toList().length, (index3) {
                        //     var vitalDate= addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toSet().toList();
                        //     return DataCell( Text(addvitalVM.dateWiseVitalMap(vitalDate[index3],2).toString(),
                        //       style:themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumGCN,),);
                        //   })],),
                        DataRow(cells:
                        [
                          DataCell(Text('Weight',style: themeChange.darkTheme?
                          MyTextTheme.mediumWCB: MyTextTheme.mediumGCB,)),

                          ...List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:
                          addvitalVM.getVitalHistoryList.map((e) =>
                          e['vitalDateTime']).toSet().toList().length, (index3) {
                            var vitalDate= addvitalVM.getVitalHistoryList.map((e) => e['vitalDateTime']).toSet().toList();
                            return DataCell( Text(addvitalVM.dateWiseVitalMap(vitalDate[index3],2).toString(),
                              style: themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumGCN,),);
                          })],),







                      ]),
                ),
              ),
            ],),
        )
        // Column(
        //   children: [
        //     Container(
        //       color:AppColor.secondaryColor ,
        //       child: IntrinsicHeight(
        //         child: Row(
        //           children: [
        //             Expanded(flex: 4,
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Text(localization.getLocaleData.vital.toString(),style: MyTextTheme.mediumWCB,),
        //                 )),
        //             Container(
        //               color: Colors.white,
        //               width: 1,
        //             ),
        //
        //             Expanded(flex: 4,
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Center(child: Text(localization.getLocaleData.qtyunit.toString(),style: MyTextTheme.mediumWCB,)),
        //                 )),
        //             Container(
        //               color: Colors.white,
        //               width: 1,
        //             ),
        //
        //             Expanded(flex: 4,
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Center(child: Text(localization.getLocaleData.time.toString(),style: MyTextTheme.mediumWCB,)),
        //                 )),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Expanded(child: ListView.builder(
        //       itemCount: addvitalVM.getVitalHistoryList.length,
        //       itemBuilder: (BuildContext context, int index) {
        //         var urinData=addvitalVM.getVitalHistoryList[index];
        //         return    Visibility(
        //           visible:urinData['vitalID'].toString() !='227',
        //           child: Column(
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Row(children: [
        //                   Expanded(flex: 4,
        //                       child: Text(urinData["vitalName"].toString(),style: MyTextTheme.mediumBCN,)),
        //                   const SizedBox(width: 5,),
        //                   Expanded(flex:4,
        //                       child: Text(urinData["vitalValue"].toString()+' '+urinData["unit"].toString(),style: MyTextTheme.mediumBCN,)),
        //                   const SizedBox(width: 5,),
        //                   Expanded(flex:4,
        //                       child: Text(urinData["vitalDateTime"].toString(),style: MyTextTheme.mediumBCN,)),
        //                 ],),
        //               )
        //             ],
        //           ),
        //         ); },))
        //
        //   ],
        // ),





        // ListView(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //
        //       //     Text("Today's Vital",style:MyTextTheme.largeBCB.copyWith(fontSize: 20,fontWeight: FontWeight.w900) ,),
        //       // Card(child: Padding(
        //       //   padding: const EdgeInsets.all(8.0),
        //       //   child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        //       //
        //       //     children: [
        //       //       Row(
        //       //         children: [
        //       //           Expanded(child: Text("Blood Pressure",style: MyTextTheme.largeGCB,)),
        //       //           Text("1hr ago",style: MyTextTheme.mediumGCB,)
        //       //
        //       //         ],
        //       //       ),
        //       //       Row(
        //       //         children: [
        //       //           Text("119/87",style: MyTextTheme.veryLargePCB.copyWith(color: Colors.blue.shade800,fontSize: 35),),
        //       //           SizedBox(width: 5,),
        //       //           Text("mm/Hg",style: MyTextTheme.largePCB.copyWith(color: Colors.blue.shade800),),
        //       //
        //       //
        //       //         ],
        //       //       ),
        //       //
        //       //
        //       //
        //       //     ],
        //       //   ),
        //       // ),),
        //       //
        //       //    Row(
        //       //      children: [
        //       //     Expanded(flex: 4,
        //       //       child:  vitalData(vitalValue: "Temperature",value: "97.5",typeValue: " \u2109",date: "15 min"),),
        //       //   Expanded(flex: 4,
        //       //     child:    vitalData(vitalValue: "Respiratory Rate",value: "17",typeValue: "min",date: "now"),),
        //       //
        //       //
        //       //    ],),
        //       //    Row(children: [
        //       //     Expanded(flex: 4,
        //       //       child:  vitalData(vitalValue: "SPO2",value: "17",typeValue: "%",date: "now"),),
        //       //      Expanded(flex: 4,
        //       //        child:    vitalData(vitalValue: "Heart Rate",value: "78",typeValue: "BPM",date: "now"),),
        //       //
        //       //    ],),
        //       //     SizedBox(height: 5,),
        //       //     Row(
        //       //       children: [
        //       //         Expanded(child: Text("Last Vital's",style:MyTextTheme.largeBCB.copyWith(fontSize: 20,fontWeight: FontWeight.w900) ,)),
        //       //         PrimaryButton(onPressed: (){}, title: 'Week',color: AppColor.darkYellow,width: 70,borderRadius: 5,),
        //       //         SizedBox(width: 5,),
        //       //         PrimaryButton(onPressed: (){}, title: 'Month',color: AppColor.white,width: 80,borderRadius: 5,textStyle: MyTextTheme.mediumGCB.copyWith(color: AppColor.grey),)
        //       //       ],
        //       //     ),
        //       //     SizedBox(height: 10,),
        //           SingleChildScrollView(
        //             scrollDirection: Axis.horizontal,
        //             child: DataTable(
        //               dividerThickness: 2,
        //               border: TableBorder.all(
        //                   width: 2,
        //                   color: AppColor.greyVeryLight,
        //                 ),
        //               columns: [
        //                 DataColumn(label: Text("Vitals",style: MyTextTheme.largeGCB.copyWith(fontSize: 16,),)
        //                 ),
        //                 ...List.generate(length, (index) => DataColumn(label: Text("Vitals",style: MyTextTheme.largeGCB.copyWith(fontSize: 16,),)
        //                 ),)
        //
        //
        //               ],rows: List.generate(addvitalVM.getVitalHistoryList.length, (index) => DataRow(cells:[DataCell(
        //                 Column(
        //                   children: [
        //                     Text(addvitalVM.getVitalHistoryList[index]['name'].toString(),style: MyTextTheme.largeBCB,),
        //                     Text(addvitalVM.getVitalHistoryList[index]['unit'].toString(),style: MyTextTheme.mediumGCN.copyWith(color: AppColor.grey),),
        //
        //                   ],
        //                 )
        //             ),
        //             ...List.generate(addvitalVM.getVitalHistoryList[index]['values'].length, (i) => DataCell(
        //                 Text(addvitalVM.getVitalHistoryList[i].toString())
        //             ))]
        //
        //
        //             ))
        //             ),
        //           )
        //
        //
        //         ],
        //
        //
        //       ),
        //     ),
        //   ],
        // )
      )),
    );
  }

  vitalData({vitalValue,value,typeValue,date,}) {
    return Card(child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(vitalValue.toString(),style: MyTextTheme.largeGCB,),
          Row(
            children: [
              Text(value.toString(),style: MyTextTheme.veryLargePCB.copyWith(color: Colors.blue.shade800,fontSize: 35),),
              const SizedBox(width: 5,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      Text(typeValue.toString(),style: MyTextTheme.largePCB.copyWith(color: Colors.blue.shade800),),
                      const Expanded(child: SizedBox()),
                      Text(date.toString(),style: MyTextTheme.mediumGCB,)
                    ],
                  ),


                ),
              ),

            ],
          )


        ],
      ),
    ),);
  }
}