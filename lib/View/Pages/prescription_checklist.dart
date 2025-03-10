import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Modal/medicine_intake_data_model.dart';
import '../../ViewModal/prescription_checklist_viewmodel.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/comman_widget.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../common_libs.dart';
import '../../medcare_utill.dart';
import '../../theme/theme.dart';
import '../../theme/style.dart';

class PrescriptionCheckListView extends StatefulWidget {
  const PrescriptionCheckListView({Key? key}) : super(key: key);

  @override
  State<PrescriptionCheckListView> createState() =>
      _PrescriptionCheckListViewState();
}

class _PrescriptionCheckListViewState extends State<PrescriptionCheckListView> {
  ThemeProviderLd themeChangeProvider = new ThemeProviderLd();

  @override
  void initState() {
    get();
    super.initState();
  }

  get() async {
    MedicineViewCheckListDataMOdel controller =
        Provider.of<MedicineViewCheckListDataMOdel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.clearData();
      await controller.apiCall(context);
    });
    themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChangeProvider.darkTheme, context);
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    MedicineViewCheckListDataMOdel controller =
        Provider.of<MedicineViewCheckListDataMOdel>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(
          // key: scaffoldKey,
          // drawer: MyDrawer(),
          backgroundColor: color.highlightColor,
          body: Container( decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeChange.darkTheme
                    ? AppColor.darkshadowColor1
                    : AppColor.lightshadowColor1,
                themeChange.darkTheme
                    ? AppColor.darkshadowColor1
                    : AppColor.lightshadowColor1,
                themeChange.darkTheme ? AppColor.black : AppColor.lightshadowColor2,
              ],
            ),
          ),
            child: Column(
              children: [


                // Padding(
                //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       InkWell(
                //         onTap: () {
                //            scaffoldKey.currentState!.openDrawer();
                //         },
                //         child: Image.asset(
                //             themeChange.darkTheme
                //                 ? ImagePaths.menuDark
                //                 : ImagePaths.menulight,
                //             height: 40),
                //       ),
                //       Expanded(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               "Supplement",
                //               style: MyTextTheme.veryLargePCB.copyWith(
                //                   color: AppColor.greyDark, fontSize: 21),
                //             ),
                //             Text(
                //               "Checklist",
                //               style: MyTextTheme.veryLargeWCB.copyWith(
                //                   color: color.textTheme.bodyText1!.color,
                //                   fontSize: 26,
                //                   height: 1),
                //             ),
                //           ],
                //         ),
                //       ),
                //       // Switch(
                //       //     value: themeChange.darkTheme,
                //       //     onChanged: (val) async {
                //       //       dPring(DateTime.now());
                //       //       themeChange.darkTheme = val;
                //       //       themeChangeProvider.darkTheme =
                //       //           await themeChangeProvider.getTheme();
                //       //     })
                //     ],
                //   ),
                // ),
            // Padding(
            // padding: const EdgeInsets.all(8.0),
            // child: PrimaryDateTimeField(
            // controller:controller.dateC,
            // hintText: 'Select Date',
            // onChanged: (val) async {
            // controller.notifyListeners();
            // await controller.apiCall(context);
            // },
            // ),
            // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: TextField(
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                  fontSize: 12),
                              controller: controller.dateShowController.value,
            //editing controller of this TextField
                              decoration: InputDecoration(
                                hintText: localization.getLocaleData.selectDate
                                    .toString(),
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                                constraints: const BoxConstraints(maxHeight: 40),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                border:InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500)),
                              ),
                              readOnly: true,
            // when true user cannot edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
            //get today's date
                                    firstDate: DateTime(2000),
            //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime.now());

                                if (pickedDate != null) {
                                  dPrint(pickedDate);
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(pickedDate);
                                  dPrint(formattedDate);
                                  setState(() {
                                    controller.dateController.value.text =
                                        formattedDate;
                                    controller.dateShowController.value.text =
                                        DateFormat("dd MMM yyyy").format( DateFormat('yyyy-MM-dd').parse(formattedDate .toString() )) ;
                                  });
                                } else {
                                  dPrint("Date is not selected");
                                }
                              }))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

            // Visibility(
            // visible: controller.getMedNamesandDates.isNotEmpty,
            // child: Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 10),
            // child: Column(
            // children: [
            // upperContainer(child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // children: [
            // Visibility(
            // visible: controller.missedIcon=='missed',
            // child: Row(
            // children: [
            // Container(
            // height: 20,
            // decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            // ),
            // child: const CircleAvatar(
            // radius: 10,
            // backgroundColor: Colors.red,
            // child: Icon(Icons.error_outline,
            // color: Colors.white,
            // size: 15,),
            // ),
            // ),
            // const SizedBox(width: 10,),
            // Text(localization.getLocaleData.missed.toString(),style: TextStyle(color:themeChange.darkTheme?Colors.grey.shade500:AppColor.darkshadowColor2),)
            // ],
            // ),
            // ),
            // Visibility(
            // visible: controller.upcomingIcon=='upcoming',
            // child: Row(
            // children: [
            // Container(
            // height: 20,
            // decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            // ),
            // child: const CircleAvatar(
            // radius: 10,
            // backgroundColor: Colors.orange,
            // child: Icon(Icons.schedule,
            // color: Colors.white,
            // size: 15,),
            // ),
            // ),
            // const SizedBox(width: 10,),
            // Text(localization.getLocaleData.upcoming.toString(),style: TextStyle(color: themeChange.darkTheme?Colors.grey.shade500:AppColor.darkshadowColor2),)
            // ],
            // ),
            // ),
            // ],
            // ) )
            // ,
            // const SizedBox(height: 5,),
            // Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // children: [
            // Visibility(
            // visible: controller.checkIcon=='check',
            // child: Row(
            // children: [
            // Container(
            // height: 20,
            // decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            // ),
            // child: const CircleAvatar(
            // radius: 10,
            // backgroundColor: Colors.green,
            // child: Icon(Icons.check,
            // color: Colors.white,
            // size: 15,),
            // ),
            // ),
            // const SizedBox(width: 10,),
            // Text(localization.getLocaleData.given.toString())
            // ],
            // ),
            // ),
            // Row(
            // children: [
            // const Text("--"),
            // const SizedBox(width: 10,),
            // Text(localization.getLocaleData.notAvailable.toString())
            // ],
            // )
            // ],
            // ),
            // const SizedBox(height: 5,),
            // Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // children: [
            // Visibility(
            // visible: controller.lateIcon=='late',
            // child: Row(
            // children: [
            // Container(
            // height: 20,
            // decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            // ),
            // child: const CircleAvatar(
            // radius: 10,
            // backgroundColor: Colors.orange,
            // child: Icon(Icons.watch_later,
            // color: Colors.white,
            // size: 15,),
            // ),
            // ),
            // const SizedBox(width: 10,),
            // Text(localization.getLocaleData.lateGiven.toString())
            // ],
            // ),
            // ),
            //
            // ],
            // )
            // ],
            // ),
            // ),
            // ),
                const SizedBox(
                  height: 10,
                ),
                //
                // controller.dateController.value.text == ""
                //     ? Text(localization.getLocaleData.selectDate.toString())
                //     : controller.getMedNamesandDates.isEmpty
                //         ? Expanded(child: Text(localization.getLocaleData.noDataFound.toString()))
                //         :
                Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: CommonWidgets().showNoData(
                                  title:localization.getLocaleData.noDataFound.toString(),
                                  show: (controller.getShowNoData &&
                                      (controller.getMedNamesandDates
                                          .isEmpty)),
                                  loaderTitle: localization.getLocaleData.Loading.toString(),
                                  showLoader: (!controller.getShowNoData  &&
                                      (controller.getMedNamesandDates
                                          .isEmpty)),
                                  child: DataTable(
                                    border: const TableBorder(
                                        bottom: BorderSide.none,
                                        verticalInside: BorderSide.none,
                                        horizontalInside: BorderSide.none,
                                      top: BorderSide.none,
                                    ),
                                    dividerThickness: 2,
                                    headingRowColor:
                                        MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return green, otherwise blue
                                      return themeChange.darkTheme
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade400;
                                    }),
                                    columnSpacing: 35.0,
                                    headingRowHeight: 40,
                                    dataRowMaxHeight: 74,
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
                                              width: 101,
                                              child: Center(
                                                child: Text(
                                                  localization.getLocaleData.medicines
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: themeChange.darkTheme
                                                        ? AppColor.lightshadowColor1
                                                        : AppColor.black,
                                                  ),
                                                ),
                                              ))),
                                      DataColumn(
                                          label: Text(localization
                                              .getLocaleData.morning
                                              .toString()
                                              .toUpperCase())),
                                      DataColumn(
                                          label: Text(localization
                                              .getLocaleData.afternoon
                                              .toString()
                                              .toUpperCase())),
                                      DataColumn(
                                          label: Text(localization
                                              .getLocaleData.evening
                                              .toString()
                                              .toUpperCase())),
                                      DataColumn(
                                          label: Text(
                                              localization
                                                  .getLocaleData.night
                                                  .toString()
                                                  .toUpperCase())),
                                      DataColumn(
                                          label: Text(
                                        localization.getLocaleData.SOS
                                            .toString()
                                            .toUpperCase(),
                                        style: const TextStyle(color: Colors.red),
                                      ))
                                    ],
                                    rows: List<DataRow>.generate(
                                      controller.getMedNamesandDates.length,
                                      (int index) {
                                        MedicationNameAndDate drugName =
                                            controller.getMedNamesandDates[index];
                                        MedicationNameAndDate medNameAndDate =
                                            controller.getMedNamesandDates[index];
                                        controller.durationType.clear();
                                        for (int i = 0;
                                            i < medNameAndDate.jsonTime!.length;
                                            i++) {
                                          controller.durationType
                                              .add(medNameAndDate.jsonTime![i]);
                                        }
                                        return DataRow(

                                          cells: <DataCell>[
                                            DataCell(SizedBox(
                                              width: 101,
                                              child: Text(
                                                drugName.drugName
                                                    .toString()
                                                    .toUpperCase() ,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: themeChange.darkTheme
                                                        ? AppColor.lightshadowColor2
                                                        : AppColor
                                                            .darkshadowColor2),
                                              ),
                                            )),
                                            DataCell(controller.missedOrNot(
                                                context,
                                                "morning",
                                                controller.durationType
                                                    .where((element) =>
                                                        element.durationType
                                                            .toString()
                                                            .removeAllWhitespace
                                                            .trim()
                                                            .toLowerCase() ==
                                                        "morning")
                                                    .toList(),
                                                medNameAndDate)),
                                            DataCell(controller.missedOrNot(
                                                context,
                                                "afternoon",
                                                controller.durationType
                                                    .where((element) =>
                                                        element.durationType
                                                            .toString()
                                                            .removeAllWhitespace
                                                            .trim()
                                                            .toLowerCase() ==
                                                        "afternoon")
                                                    .toList(),
                                                medNameAndDate)),
                                            DataCell(controller.missedOrNot(
                                                context,
                                                "evening",
                                                controller.durationType
                                                    .where((element) =>
                                                        element.durationType
                                                            .toString()
                                                            .removeAllWhitespace
                                                            .trim()
                                                            .toLowerCase() ==
                                                        "evening")
                                                    .toList(),
                                                medNameAndDate)),
                                            DataCell(controller.missedOrNot(
                                                context,
                                                "night",
                                                controller.durationType
                                                    .where((element) =>
                                                element.durationType
                                                    .toString()
                                                    .removeAllWhitespace
                                                    .trim()
                                                    .toLowerCase() ==
                                                    "night")
                                                    .toList(),
                                                medNameAndDate)),
                                            DataCell(controller.missedOrNot(
                                                context,
                                                "sos",
                                                controller.durationType
                                                    .where((element) =>
                                                        element.durationType
                                                            .toString()
                                                            .removeAllWhitespace
                                                            .trim()
                                                            .toLowerCase() ==
                                                        "sos")
                                                    .toList(),
                                                medNameAndDate)),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8),child:   upperContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      Text(
                        localization.getLocaleData.missed.toString(),
                        style: MyTextTheme.mediumWCB.copyWith(
                            color: themeChange.darkTheme
                                ? Colors.grey.shade500
                                : AppColor.darkshadowColor2),
                      ),
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      Text(
                        localization.getLocaleData.given.toString(),
                        style: MyTextTheme.mediumWCB.copyWith(
                            color: themeChange.darkTheme
                                ? Colors.grey.shade500
                                : AppColor.darkshadowColor2),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.access_time_filled,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                      Text(
                        localization.getLocaleData.upcoming.toString(),
                        style: MyTextTheme.mediumWCB.copyWith(
                            color: themeChange.darkTheme
                                ? Colors.grey.shade500
                                : AppColor.darkshadowColor2),
                      ),
                    ],
                  )),),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  upperContainer({required Widget child}) {
    // final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    // final themecolor = style.themeData(themeChangeProvider.darkTheme, context);
    return Consumer<ThemeProviderLd>(
        builder:  (BuildContext context, themeChange,_) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
              decoration: BoxDecoration(
                    color: style.themeData(themeChangeProvider.darkTheme, context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
        // themecolor.hintColor,themecolor.primaryColor, themecolor.focusColor
                      themeChange.darkTheme? AppColor.darkshadowColor1 : AppColor.lightshadowColor1,

                      themeChange.darkTheme? Colors.black87 :AppColor.lightshadowColor2,
                      themeChange.darkTheme? Colors.black87 :AppColor.lightshadowColor2,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: themeChange.darkTheme ? Colors.grey.shade800 : Colors.white70,
                      offset: const Offset(
                        .3,
                        .3,
                      ),
        // blurRadius: 10.0,
                    ),
                  ],
                  border: Border.all(
                      color: themeChange.darkTheme
                          ? AppColor.darkshadowColor2
                          : AppColor.lightshadowColor2),
                  borderRadius: BorderRadius.circular(15)),
              child: child),
        );
      }
    );
  }
}
