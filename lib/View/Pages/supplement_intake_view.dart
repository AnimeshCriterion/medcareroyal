
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/ViewModal/supplement_intake_view_modal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/assets.dart';
import 'package:provider/provider.dart';
import '../../Localization/app_localization.dart';
import '../../Modal/SupplementIntakeDataModek.dart';
import '../../app_manager/comman_widget.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/text_field/primary_date_time_field.dart';
import '../../authenticaton/user_repository.dart';
import '../../theme/theme.dart';
import '../../theme/style.dart';

class SupplementIntakeView extends StatefulWidget {
  const SupplementIntakeView({Key? key}) : super(key: key);

  @override
  State<SupplementIntakeView> createState() => _SupplementIntakeViewState();
}

class _SupplementIntakeViewState extends State<SupplementIntakeView> {

  get(context) async {
    SupplementIntakeViewModal controller =
        Provider.of<SupplementIntakeViewModal>(context, listen: false);
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    controller.nameC.text = userRepository.getUser.patientName.toString();
    controller.updateIntakeListResponse =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    controller.dateC.text=DateTime.now().toString();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {

      await controller.apiCall(context);
    });
  }
  List temp=[
    'Mid Morning',
    'Lunch',
    'Evening Time',
    'Early Morning',
    'Dinner',
    'Breakfast',
    'Bed Time',
    'All day meals',
  ];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {

      get(context);
    });
    super.initState();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: true);
    SupplementIntakeViewModal controller =
        Provider.of<SupplementIntakeViewModal>(context, listen: true);


    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    return ColoredSafeArea(
      child: SafeArea(
        child:  Scaffold(key: scaffoldKey,
          drawer: MyDrawer(),
          // appBar: CustomAppBar(
          //   title: localization.getLocaleData.supplementChecklist.toString(),
          //     color: AppColor.primaryColor,
          //     titleColor: AppColor.white,
          //     primaryBackColor: AppColor.white
          // ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeChange.darkTheme ? AppColor.bgDark : AppColor.bgWhite,
                  themeChange.darkTheme ? AppColor.bgDark : AppColor.lightshadowColor1,
                  themeChange.darkTheme ? AppColor.bgDark : AppColor.lightshadowColor2,
                ],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // InkWell(
                    //   onTap: (){
                    //      Get.back();
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Icon(Icons.arrow_back_ios,color: themeChange.darkTheme? Colors.white:Colors.grey,),
                    //   ),
                    // ),
                    InkWell(
                        onTap: (){
                          scaffoldKey.currentState!.openDrawer();
                        },
                        child: Image.asset(themeChange.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40)),

                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localization.getLocaleData.supplement.toString(),
                          style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 0,color: themeChange.darkTheme==true?Colors.white70:null),),
                        Text(localization.getLocaleData.checklist.toString(),
                          style: MyTextTheme.largeGCB.copyWith(fontSize: 26,height: 1,
                              color: themeChange.darkTheme ? AppColor.lightshadowColor1 : AppColor.black,)),
                      ],
                    ),

                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      SizedBox(
                        width: 130,
                        child: PrimaryDateTimeField(lastDate: DateTime.now(),
                        suffixIcon:  Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Image.asset(themeChange.darkTheme?'assets/calandericondark.png':'assets/calandericon.png'),
                        ),
                          style:themeChange.darkTheme==true?MyTextTheme.smallWCN: MyTextTheme.smallBCN,
                          backgroundColor: Colors.transparent,
                          border: InputBorder.none,
                          controller:controller.dateC,
                          hintText: localization.getLocaleData.selectDate.toString(),
                          onChanged: (val) async {
                            controller.notifyListeners();
                            await controller.apiCall(context);
                          },
                        ),
                      ),

                    ],
                  ),
                ),


                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Visibility(
                //   visible:  controller.getDataList.isNotEmpty,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 10),
                //     child: Row(
                //       children: [
                //         Expanded(
                //             child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Container(
                //               height: 20,
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //               child: const CircleAvatar(
                //                 radius: 10,
                //                 backgroundColor: Colors.red,
                //                 child: Icon(
                //                   Icons.close,
                //                   color: Colors.white,
                //                   size: 15,
                //                 ),
                //               ),
                //             ),
                //             const SizedBox(
                //               width: 10,
                //             ),
                //              Text(localization.getLocaleData.missed.toString())
                //           ],
                //         )),
                //         const SizedBox(
                //           width: 10,
                //         ),
                //         Expanded(
                //             child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Container(
                //               height: 20,
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //               child: const CircleAvatar(
                //                 radius: 10,
                //                 backgroundColor: Colors.green,
                //                 child: Icon(
                //                   Icons.check,
                //                   color: Colors.white,
                //                   size: 15,
                //                 ),
                //               ),
                //             ),
                //             const SizedBox(
                //               width: 10,
                //             ),
                //              Text(localization.getLocaleData.given.toString())
                //           ],
                //         )),
                //         Expanded(
                //             child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Container(
                //               height: 20,
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //               child: const CircleAvatar(
                //                 radius: 10,
                //                 backgroundColor: Colors.orange,
                //                 child: Icon(
                //                   Icons.schedule,
                //                   color: Colors.white,
                //                   size: 15,
                //                 ),
                //               ),
                //             ),
                //             const SizedBox(
                //               width: 10,
                //             ),
                //              Text(localization.getLocaleData.pending.toString())
                //           ],
                //         ))
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
               // controller.getDataList.isEmpty
               //          ?  Expanded(child: Center(child: Text(localization.getLocaleData.supplementNotAssigned.toString(),
               //   style: TextStyle(color: AppColor.green),)))
               //
               //          :
               Expanded(
                          child: SingleChildScrollView(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                              child: CommonWidgets().showNoData(
                                title:localization.getLocaleData.noDataFound.toString(),
                                show: (controller.getShowNoData &&
                                    (controller.getDataList
                                        .isEmpty)),
                                loaderTitle: localization.getLocaleData.Loading.toString(),
                                showLoader: (!controller.getShowNoData  &&
                                    (controller.getDataList
                                        .isEmpty)),
                                child: DataTable(
                                  border: const TableBorder(
                                      bottom: BorderSide.none,
                                      verticalInside: BorderSide.none,
                                      horizontalInside: BorderSide.none,),
                                  dividerThickness:0,
                                  headingRowColor:
                                  MaterialStateProperty.resolveWith((states) {
                                    return themeChange.darkTheme? Colors.transparent:AppColor.lightshadowColor2;
                                  }),
                                  columnSpacing: 35.0,
                                  headingRowHeight: 35,
                                  //
                                  headingTextStyle: MyTextTheme.mediumWCB
                                      .copyWith(
                                      color: themeChange.darkTheme
                                          ? AppColor.lightshadowColor2
                                          : AppColor.darkshadowColor2,
                                      fontSize: 12),
                                  // Adjust the spacing between columns
                                  columns: [
                                    DataColumn(
                                        label: SizedBox(
                                            width: 100,
                                            child: Text(
                                              localization.getLocaleData.medicines
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: themeChange.darkTheme
                                                    ? AppColor.lightshadowColor1
                                                    : AppColor.black,
                                              ),
                                            ))),


                                    ...List.generate(temp.length, (index) => DataColumn(
                                        label: Text(temp[index].toString()
                                            .toString()
                                            .toUpperCase())),)
                                    // DataColumn(
                                    //     label: Text(localization
                                    //         .getLocaleData.morning
                                    //         .toString()
                                    //         .toUpperCase())),
                                    // DataColumn(
                                    //     label: Text(localization
                                    //         .getLocaleData.afternoon
                                    //         .toString()
                                    //         .toUpperCase())),
                                    // DataColumn(
                                    //     label: Text(localization
                                    //         .getLocaleData.evening
                                    //         .toString()
                                    //         .toUpperCase())),
                                    // DataColumn(
                                    //     label: Text('Night'
                                    //           .toString()
                                    //           .toUpperCase(),
                                    //     ))
                                  ],
                                  rows: List<DataRow>.generate(controller.getDataList.length,
                                        (int index) {


                                          SupplementIntakeDataModel drugName =
                                      controller.getDataList[index];

                                      return DataRow(
                                        color: MaterialStateProperty.resolveWith((states) {

                                          return  index%2!=0?Colors.transparent:(themeChange.darkTheme?AppColor.darkshadowColor1:AppColor.white);
                                        }),
                                        cells: <DataCell>[


                                          DataCell(SizedBox(
                                            width: 100,
                                            child:  Text(drugName.supplimentName .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: themeChange.darkTheme
                                                      ? AppColor.lightshadowColor2
                                                      : AppColor
                                                      .darkshadowColor2),
                                            ),
                                          )),
                                          ...List.generate(temp.length,
                                          (int index3) {

                                          return DataCell( drugName.foodGivenAt.toString()==temp[index3].toString()?
                                              controller.iconAccordingToGivenStatus(context,
                                                  drugName.isGiven.toString(),drugName):
                                          const Center(
                                            child: Text(  "----",style: TextStyle(
                                              letterSpacing: -2,color: Colors.grey,
                                            ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                          );
                                          })

                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                                // child: DataTable(
                                //   border: TableBorder(
                                //     bottom: BorderSide(
                                //         width: 3,
                                //         color: themeChange.darkTheme
                                //             ? Colors.grey.shade800
                                //             : Colors.grey.shade300),
                                //     verticalInside: BorderSide(
                                //         width: 1,
                                //         color: themeChange.darkTheme
                                //             ? Colors.grey.shade800
                                //             : Colors.grey.shade300),
                                //     horizontalInside: BorderSide(
                                //         width: 1,
                                //         color: themeChange.darkTheme
                                //             ? Colors.grey.shade800
                                //             : Colors.grey.shade300)),
                                //   headingRowColor:
                                //   MaterialStateProperty.resolveWith((states) {
                                //     // If the button is pressed, return green, otherwise blue
                                //     return themeChange.darkTheme
                                //         ? Colors.black54
                                //         : Colors.grey.shade400;
                                //   }),
                                //   columnSpacing: 10,
                                //   dataRowMinHeight: 40,
                                //   dataRowMaxHeight: 60,
                                //   // Adjust the spacing between columns
                                //   columns: List<DataColumn>.generate(
                                //       controller.getDataList
                                //               .map((e) => e.medicationEntryTime)
                                //               .toList()
                                //               .length +
                                //           1, (int index1) {
                                //     var data = controller.getDataList
                                //         .map((e) => e.medicationEntryTime)
                                //         .toList();
                                //     var timeSlot = controller.getDataList
                                //         .map((e) => e.timeSlot??'')
                                //         .toList();
                                //     data.insert(0, "Supplement");
                                //     timeSlot.insert(0, "");
                                //     return DataColumn(
                                //         label: SizedBox(
                                //             width: index1 == 0 ? 120 : 70,
                                //             child: Column(
                                //               children: [
                                //
                                //                 Text(timeSlot[index1].toString(),
                                //                     style: TextStyle(color:   themeChange.darkTheme
                                //                         ? AppColor.lightshadowColor2
                                //                         : AppColor
                                //                         .darkshadowColor2)),
                                //                 Text(data[index1].toString(),
                                //                     style: TextStyle(color:   themeChange.darkTheme
                                //                         ? AppColor.lightshadowColor2
                                //                         : AppColor
                                //                         .darkshadowColor2)),
                                //               ],
                                //             ),));
                                //   }),
                                //   // columns: const [
                                //   //   DataColumn(label: SizedBox(width:100,child: Text('Medicine'))),
                                //   //   DataColumn(label: Text('Morning')),
                                //   //   DataColumn(label: Text('Afternoon')),
                                //   //   DataColumn(label: Text('Evening')),
                                //   //   DataColumn(label: Text('Night')),
                                //   // ],
                                //   rows: List<DataRow>.generate(
                                //     controller.getDataList.length,
                                //     (int index2) {
                                //       SupplementIntakeDataModel data =
                                //           controller.getDataList[index2];
                                //
                                //       return DataRow(
                                //           color:themeChange.darkTheme?
                                //           MaterialStateProperty.all(index2/2==0? Colors.grey.shade800:Colors.grey.shade700):
                                //           MaterialStateProperty.all(index2/2==0? Colors.white:AppColor.greyVeryLight),
                                //           cells: List.generate(
                                //               controller.getDataList
                                //                       .map((e) => e.medicationEntryTime)
                                //                       .toList()
                                //                       .length +
                                //                   1, (index3) {
                                //         return DataCell(index3 == 0
                                //             ? Padding(
                                //               padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                                //               child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                //                 children: [
                                //                   Text(data.supplimentName.toString(),
                                //                     style: TextStyle(fontWeight: FontWeight.w700,
                                //                         color:   themeChange.darkTheme
                                //                             ? AppColor.lightshadowColor1
                                //                             : AppColor
                                //                             .darkshadowColor2),),
                                //                   Text(data.doseStrength!.toStringAsFixed(0).toString()+" "+data.unitName.toString(),
                                //                     style: TextStyle(fontWeight: FontWeight.w700,
                                //                         color:   themeChange.darkTheme
                                //                             ? AppColor.lightshadowColor2
                                //                             : AppColor
                                //                             .greyDark.withOpacity(.8)),),
                                //                 ],
                                //
                                //               ),
                                //             )
                                //             : controller.getDataList.indexWhere(
                                //                         (element) =>
                                //                             element.medicationEntryTime ==
                                //                             data.medicationEntryTime) ==
                                //                     index3 - 1
                                //                 ? controller.iconAccordingToGivenStatus(context,
                                //                     data.isGiven.toString(),data)
                                //                 : const Center(
                                //                     child: Text(
                                //                     "--",
                                //                     textAlign: TextAlign.center,
                                //                   )));
                                //       }));
                                //     },
                                //   ),
                                // ),
                              ),
                          ),
                        ),
                upperContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error,
                              size: 25,color: Colors.orange
                            ),
                            SizedBox(width: 5,),
                            Text(
                              localization.getLocaleData.missed.toString(),
                              style: MyTextTheme.mediumWCB.copyWith(
                                  color: themeChange.darkTheme
                                      ? Colors.grey.shade500
                                      : AppColor.darkshadowColor2),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              localization.getLocaleData.given.toString(),
                              style: MyTextTheme.mediumWCB.copyWith(
                                  color: themeChange.darkTheme
                                      ? Colors.grey.shade500
                                      : AppColor.darkshadowColor2),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.access_time_filled,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              localization.getLocaleData.upcoming.toString(),
                              style: MyTextTheme.mediumWCB.copyWith(
                                  color: themeChange.darkTheme
                                      ? Colors.grey.shade500
                                      : AppColor.darkshadowColor2),
                            ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    );
  }



  upperContainer({required Widget child}) {
    return   Consumer<ThemeProviderLd>(
        builder:  (BuildContext context, themeChange,_) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  color: style.themeData(themeChange.darkTheme, context).primaryColor,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        themeChange.darkTheme?AppColor.neoBGGrey1:AppColor.white,
                        themeChange.darkTheme?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                      ]
                  ),
        //               boxShadow: [
        //                 BoxShadow(
        //                   blurRadius: 35,spreadRadius: 0.1,
        //                   color: themeChange.darkTheme? AppColor.grey:Colors.grey,
        //                   offset: const Offset(
        //                     0,
        //                     0,
        //                   ),
        // // blurRadius: 10.0,
        //                 ),
        //               ],
                  border: Border.all(
                      color: themeChange.darkTheme
                          ? AppColor.darkshadowColor2
                          : AppColor.lightshadowColor2),
                  borderRadius: BorderRadius.circular(25)),
              child: child),
        );
      }
    );
  }
}
