import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:medvantage_patient/LiveVital/device_view.dart';
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/View/Pages/vital_history_page.dart';
import 'package:medvantage_patient/ViewModal/addvital_view_modal.dart';
import 'package:medvantage_patient/app_manager/alert_dialogue.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/neomorphic/neomorphic.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/custom_sd.dart';

import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:provider/provider.dart';

import '../../LiveVital/low_ecg/devices_view.dart';
import '../../LiveVital/ptt/ptt_view.dart';
import '../../LiveVital/stetho_bluetooth/pid_page_for_stetho.dart';
import '../../Localization/app_localization.dart';
import '../../app_manager/alert_toast.dart';

import '../../app_manager/imageViewer/imagealaert.dart';
import '../../app_manager/widgets/text_field/primary_date_time_field.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import '../../devices_with_new_ui/add_device_connect.dart';
import '../../devices_with_new_ui/add_device_view.dart';
import '../../voice_assistant.dart';

class AddVitalView extends StatefulWidget {
  const AddVitalView({Key? key}) : super(key: key);

  @override
  State<AddVitalView> createState() => _AddVitalViewState();
}

class _AddVitalViewState extends State<AddVitalView> {
  get() async {
    // aiCommandSheet(context, isFrom: 'add vitals');
    AddVitalViewModal addvitalVM =
        Provider.of<AddVitalViewModal>(context, listen: false);
    addvitalVM.updatesubscriptionIndex = 0;
    addvitalVM.dateC.text = DateTime.now().toString();
    addvitalVM.timeC.text =
        DateFormat("HH:mm a").format(DateTime.now()).toString();
    addvitalVM.clearData();

    setState(() {

      addvitalVM.isIntake = true;
    });
    await addvitalVM.vitalPosition(context,  );
    await addvitalVM.hitVitalHistory(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      get();
    });
  }

  final FormKey = GlobalKey<FormState>() ;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: true);
    AddVitalViewModal addvitalVM =
        Provider.of<AddVitalViewModal>(context, listen: true);

    if(addvitalVM.allData==null){

    }else{
      addvitalVM.systollicC.text=addvitalVM.allData['vmValueBPSys'].toString();
      print(addvitalVM.allData['vmValueBPSys'].toString());
      print(addvitalVM.systollicC.value.text.toString()+'ok');
      // addvitalVM.systollicC.text='90';
      addvitalVM.diatollicC.text=addvitalVM.allData['vmValueBPDias'].toString();
      addvitalVM.respiratoryC.text=addvitalVM.allData['vmValueRespiratoryRate'].toString();
      addvitalVM.spo2C.text=addvitalVM.allData['vmValueSPO2'].toString();
      addvitalVM.temperatureC.text=addvitalVM.allData['vmValueTemperature'].toString();
      addvitalVM.heartrateC.text=addvitalVM.allData['vmValueHeartRate'].toString();
      addvitalVM.weightC.text=addvitalVM.allData['weight'].toString();
      addvitalVM.rbsC.text=addvitalVM.allData['vmValueRbs'].toString();
      addvitalVM.pulserateC.text=addvitalVM.allData['vmValuePulse'].toString();
    }
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    return ColoredSafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: const MyDrawer(),
        // appBar: CustomAppBar(
        //   title: localization.getLocaleData.addVital.toString(),
        //   color: AppColor.primaryColor,
        //   titleColor: AppColor.white,
        //   primaryBackColor: AppColor.white,
        // ),
        backgroundColor: Colors.grey.shade800,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeChange.darkTheme == true
                      ? AppColor.neoBGGrey2
                      : AppColor.neoBGWhite1,
                  themeChange.darkTheme == true
                      ? AppColor.neoBGGrey2
                      : AppColor.neoBGWhite1,
                  themeChange.darkTheme == true
                      ? AppColor.neoBGGrey2
                      : AppColor.neoBGWhite1,
                  themeChange.darkTheme == true
                      ? AppColor.neoBGGrey1
                      : AppColor.neoBGWhite2,
                  themeChange.darkTheme == true
                      ? AppColor.neoBGGrey2
                      : AppColor.neoBGWhite1,
                ]),
            color: Colors.grey.shade800,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
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
                        onTap: () {
                          scaffoldKey.currentState!.openDrawer();
                        },
                        child: Image.asset(
                            themeChange.darkTheme == true
                                ? ImagePaths.menuDark
                                : ImagePaths.menulight,
                            height: 40)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(localization.getLocaleData.vitalManagement.toString(),
                            style: MyTextTheme.largeGCB.copyWith(
                                fontSize: 21,
                                height: 0,
                                color: themeChange.darkTheme == true
                                    ? Colors.white70
                                    : null),
                          ),

                        ],
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        aiCommandSheet(context, isFrom: 'add vitals');
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                        child: Icon(Icons.mic, color: Colors.grey),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        MyNavigator.push(context, const VitalHistoryPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/vital_history.svg',color:  themeChange.darkTheme ?
                        AppColor.white:Colors.black),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Form(
                    key: FormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 22,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: themeChange.darkTheme == false
                                      ? Colors.grey.shade400
                                      : Colors.transparent),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    themeChange.darkTheme == true
                                        ? AppColor.blackLight
                                        : AppColor.white,
                                    themeChange.darkTheme == true
                                        ? AppColor.blackDark
                                        : AppColor.neoBGWhite2,
                                  ]),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          addvitalVM.subscriptionIndex = 0;
                                          addvitalVM.isIntake = true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: !addvitalVM.isIntake
                                                ? Colors.grey
                                                : AppColor.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: !addvitalVM.isIntake
                                                      ? Colors.transparent
                                                      : AppColor.neoGreen,
                                                  blurRadius: 2,
                                                  offset: const Offset(-4, 0)),
                                              BoxShadow(
                                                  color: !addvitalVM.isIntake
                                                      ? Colors.transparent
                                                      : AppColor.neoGreen,
                                                  blurRadius: 2,
                                                  offset: const Offset(4, 0)),
                                            ],
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  !addvitalVM.isIntake
                                                      ? Colors.transparent
                                                      : (themeChange
                                                                  .darkTheme ==
                                                              true
                                                          ? AppColor.blackDark
                                                          : AppColor
                                                              .neoBGWhite2),
                                                  !addvitalVM.isIntake
                                                      ? Colors.transparent
                                                      : (themeChange
                                                                  .darkTheme ==
                                                              true
                                                          ? AppColor.blackLight
                                                          : AppColor
                                                              .neoBGWhite1),
                                                ])),
                                        padding: const EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            localization.getLocaleData.addManually.toString(),

                                            style: !addvitalVM.isIntake
                                                ? MyTextTheme.mediumGCB
                                                : MyTextTheme.mediumWCB
                                                    .copyWith(
                                                        color: addvitalVM
                                                                .isIntake
                                                            ? AppColor.neoGreen
                                                            : Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async{

                                        final prefs = await SharedPreferences.getInstance();
                                        // final box = GetStorage();
                                        //   await box.read('isActive');
                                        // var value= await box.read('isActive');
                                        // print('asdfghjkrtyuiofghj'+value.toString());

                                        var value= await prefs.getString('isActive');

                                          if(value.toString()=='1'){
                                            setState(() {

                                              addvitalVM.subscriptionIndex = 1;
                                              addvitalVM.isIntake = false;

                                            });
                                          }else{
                                           // Get.showSnackbar(MySnackbar.SuccessSnackBar(message: 'Coming Soon!'));
                                            alertToast(context, 'Coming Soon!');
                                          }

                                        // setState(() {
                                        //
                                        //   addvitalVM.subscriptionIndex = 1;
                                        //   addvitalVM.isIntake = false;
                                        // });

                                          // MyNavigator.push(context, const VitalHistoryPage());
                                          //  MyNavigator.navigateTransparent(context, const HistoryPage());

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: addvitalVM.isIntake
                                                ? Colors.grey
                                                : AppColor.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: addvitalVM.isIntake
                                                      ? Colors.transparent
                                                      : AppColor.neoGreen,
                                                  blurRadius: 2,
                                                  offset: const Offset(-4, 0)),
                                              BoxShadow(
                                                  color: addvitalVM.isIntake
                                                      ? Colors.transparent
                                                      : AppColor.neoGreen,
                                                  blurRadius: 2,
                                                  offset: const Offset(4, 0)),
                                            ],
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  addvitalVM.isIntake
                                                      ? Colors.transparent
                                                      : (themeChange
                                                                  .darkTheme ==
                                                              true
                                                          ? AppColor.blackDark
                                                          : AppColor
                                                              .neoBGWhite2),
                                                  addvitalVM.isIntake
                                                      ? Colors.transparent
                                                      : (themeChange
                                                                  .darkTheme ==
                                                              true
                                                          ? AppColor.blackLight
                                                          : AppColor
                                                              .neoBGWhite1),
                                                ])),
                                        padding: const EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            localization.getLocaleData.addByMachine.toString(),
                                            style: addvitalVM.isIntake
                                                ? MyTextTheme.mediumGCB
                                                : MyTextTheme.mediumWCB
                                                    .copyWith(
                                                        color: !addvitalVM
                                                                .isIntake
                                                            ? AppColor.neoGreen
                                                            : Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),

                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: ToggleButtons(
                          //         selectedColor: AppColor.white,
                          //         fillColor: addvitalVM.subscriptionIndex == 1
                          //             ? Colors.orange
                          //             : AppColor.primaryColor,
                          //         isSelected: [
                          //           addvitalVM.subscriptionIndex == 0,
                          //           addvitalVM.subscriptionIndex == 1
                          //         ],
                          //         onPressed: (index) {
                          //           // setState(() {
                          //           addvitalVM.subscriptionIndex = 0;
                          //
                          //           // addvitalVM.subscriptionIndex = index;
                          //           addvitalVM.notifyListeners();
                          //           // });
                          //         },
                          //         children:  [
                          //           Padding(
                          //             padding:
                          //                 const EdgeInsets.symmetric(horizontal: 16.0),
                          //             child: Center(child: Text(localization.getLocaleData.addManually.toString())),
                          //           ),
                          //           Padding(
                          //             padding:
                          //                 const EdgeInsets.symmetric(horizontal: 16.0),
                          //             child:
                          //                 Center(child: Text(localization.getLocaleData.addByMachine.toString())),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     InkWell(
                          //         onTap: () {
                          //           MyNavigator.push(context, const VitalHistoryPage());
                          //         },
                          //         child: Image.asset(
                          //           'assets/history.png',
                          //           width: 40,
                          //           fit: BoxFit.fitWidth,
                          //         )),
                          //   ],
                          // ),
                          SizedBox(
                            height: 15,
                          ),
                          addvitalVM.isIntake
                              ?  Expanded(child: SingleChildScrollView(
                            child: Column(
                                      children: [
                                        // Row(
                                        //  children: [
                                        //    Expanded(child: Text(localization.getLocaleData.addManually.toString(),
                                        //      style: MyTextTheme.largeBCN.copyWith(color: themeChange.darkTheme==true?
                                        //      Colors.white:AppColor.black))),
                                        //    Switch(
                                        //        activeTrackColor:Colors.green,
                                        //        value: addvitalVM.subscriptionIndex==0?true:false,
                                        //        onChanged: (val){
                                        //          if(addvitalVM.subscriptionIndex==0){
                                        //            addvitalVM.subscriptionIndex = 1;
                                        //          }else{
                                        //            addvitalVM.subscriptionIndex = 0;
                                        //          }
                                        //          addvitalVM.notifyListeners();
                                        //    })
                                        //  ],
                                        //                           ),
                                        //                           const SizedBox(
                                        //  height: 10
                                        //                           ),

                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color:
                                                      themeChange.darkTheme == true
                                                          ? Colors.transparent
                                                          : Colors.grey.shade300,
                                                  offset: const Offset(2, 3),
                                                  blurRadius: 7,
                                                  spreadRadius: 2),
                                            ],
                                          ),
                                          child: PrimaryDateTimeField(
                                              style: TextStyle(
                                                  color:
                                                      themeChange.darkTheme == true
                                                          ? Colors.white
                                                          : Colors.grey),
                                              borderColor: Colors.transparent,
                                              backgroundColor:
                                                  themeChange.darkTheme == true
                                                      ? Colors.grey.shade600.withOpacity(0.1)
                                                      : Colors.white,
                                              borderRadius: 10,
                                              lastDate: DateTime.now(),
                                              dateTimePickerType:
                                                  DateTimePickerType.dateTime,
                                              suffixIcon:
                                                  const Icon(Icons.calendar_month),
                                              controller: addvitalVM.dateC,
                                              // hintText: "Select Date",
                                              onChanged: (val) {
                                                addvitalVM.notifyListeners();
                                              },
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return 'Please Select date';
                                                }
                                              }),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                // Image.asset(
                                                //   "assets/dashboard_icons/blood_pressure.png",
                                                //   height: 29,
                                                // ),
                                                // const SizedBox(
                                                //   width: 6,
                                                // ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            localization
                                                                .getLocaleData
                                                                .bloodPressure
                                                                .toString(),
                                                            style: themeChange
                                                                    .darkTheme
                                                                ? MyTextTheme
                                                                    .smallGCB
                                                                    .copyWith(
                                                                        color: AppColor
                                                                            .white
                                                                            .withOpacity(
                                                                                .6))
                                                                : MyTextTheme
                                                                    .mediumBCB
                                                                    .copyWith(
                                                                        color: AppColor
                                                                            .black
                                                                            .withOpacity(
                                                                                0.7))),
                                                        // const SizedBox(
                                                        //   width: 3,
                                                        // ),
                                                        // InkWell(
                                                        //     onTap: () {
                                                        //       Get.to(ImageAlertDialog(
                                                        //         imageUrl: ImagePaths.bpinfo,
                                                        //       ));
                                                        //     },
                                                        //     child: const Icon(
                                                        //       Icons.info,
                                                        //       size: 15,
                                                        //     ))
                                                      ],
                                                    ),
                                                    // Text(
                                                    //   localization.getLocaleData
                                                    //       .entertheValueofBloodPressure
                                                    //       .toString(),
                                                    //   style: MyTextTheme.smallGCN,
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        BoxDecoration(boxShadow: [
                                                      BoxShadow(
                                                        color: themeChange
                                                                    .darkTheme ==
                                                                true
                                                            ? Colors.transparent
                                                            : Colors.grey.shade300,
                                                        offset: const Offset(2, 3),
                                                        blurRadius: 7,
                                                        spreadRadius: 2,
                                                      ),
                                                    ]),
                                                    child: PrimaryTextField(
                                                      prefixIcon: Image.asset(
                                                          ImagePaths.bp2,
                                                          height: 20),
                                                      hintTextColor:
                                                          themeChange.darkTheme ==
                                                                  true
                                                              ? Colors.white60
                                                              : Colors.grey,
                                                      borderColor:
                                                          Colors.transparent,
                                                      backgroundColor:
                                                          themeChange.darkTheme ==
                                                                  true
                                                              ? Colors.grey.shade600.withOpacity(0.1)
                                                              : Colors.white,
                                                      borderRadius: 10,
                                                      maxLength: 3,
                                                      style: TextStyle(
                                                          color: themeChange
                                                                      .darkTheme ==
                                                                  true
                                                              ? Colors.white70
                                                              : AppColor.black),
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                              signed: true),
                                                      controller:
                                                          addvitalVM.systollicC,
                                                      hintText:
                                                          '${localization.getLocaleData.systollic} (mm Hg)',
                                                        validator: (val){
                                                        if(val!.isNotEmpty)  {
                                                          if (double.parse(val
                                                                  .toString()) >
                                                              250) {
                                                            return 'Please enter valid value.';
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        BoxDecoration(boxShadow: [
                                                      BoxShadow(
                                                          color: themeChange
                                                                      .darkTheme ==
                                                                  true
                                                              ? Colors.transparent
                                                              : Colors
                                                                  .grey.shade300,
                                                          offset:
                                                              const Offset(2, 3),
                                                          blurRadius: 7,
                                                          spreadRadius: 2)
                                                    ]),
                                                    child: PrimaryTextField(
                                                      prefixIcon: Image.asset(
                                                          ImagePaths.bp2,
                                                          height: 20),
                                                      hintTextColor:
                                                          themeChange.darkTheme ==
                                                                  true
                                                              ? Colors.white60
                                                              : Colors.grey,
                                                      backgroundColor:
                                                          themeChange.darkTheme ==
                                                                  true
                                                              ? Colors.grey.shade600.withOpacity(0.1)
                                                              : Colors.white,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLength: 3,
                                                      style: TextStyle(
                                                          color: themeChange
                                                                      .darkTheme ==
                                                                  true
                                                              ? Colors.white70
                                                              : AppColor.black),
                                                      controller:
                                                          addvitalVM.diatollicC,
                                                      hintText: localization
                                                              .getLocaleData
                                                              .diastolic
                                                              .toString() +
                                                          " (mm Hg)",
                                                      borderColor:
                                                          Colors.transparent,
                                                      borderRadius: 10,
                                                      validator: (val){
                                                        if(val!.isNotEmpty)  {
                                                          if (double.parse(val
                                                                  .toString()) >
                                                              250) {
                                                            return 'Please enter valid value.';
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                // Image.asset(
                                                //   "assets/dashboard_icons/heart_rate.png",
                                                //   height: 29,
                                                // ),
                                                // const SizedBox(
                                                //   width: 6,
                                                // ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      localization
                                                          .getLocaleData.spo2
                                                          .toString(),
                                                      style: themeChange.darkTheme
                                                          ? MyTextTheme.smallGCB
                                                          .copyWith(
                                                          color: AppColor
                                                              .white
                                                              .withOpacity(
                                                              .6))
                                                          : MyTextTheme.mediumBCB
                                                          .copyWith(
                                                          color: AppColor
                                                              .black
                                                              .withOpacity(
                                                              0.7)),
                                                    ),
                                                    // Text(
                                                    //   localization
                                                    //       .getLocaleData.enterTheValueofSpo2
                                                    //       .toString(),
                                                    //   style: MyTextTheme.smallGCN,
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                    BoxDecoration(boxShadow: [
                                                      BoxShadow(
                                                          color: themeChange
                                                              .darkTheme ==
                                                              true
                                                              ? Colors.transparent
                                                              : Colors
                                                              .grey.shade300,
                                                          offset:
                                                          const Offset(2, 3),
                                                          blurRadius: 7,
                                                          spreadRadius: 2)
                                                    ]),
                                                    child: PrimaryTextField(
                                                      prefixIcon: Image.asset(
                                                          ImagePaths.pulse2,
                                                          height: 20),
                                                      hintTextColor:
                                                      themeChange.darkTheme ==
                                                          true
                                                          ? Colors.white60
                                                          : Colors.grey,
                                                      backgroundColor:
                                                      themeChange.darkTheme ==
                                                          true
                                                          ? Colors.grey.shade600.withOpacity(0.1)
                                                          : Colors.white,
                                                      maxLength: 5,
                                                      keyboardType:
                                                      TextInputType.number,
                                                      controller: addvitalVM.spo2C,
                                                      hintText: localization
                                                          .getLocaleData.spo2
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: themeChange
                                                              .darkTheme ==
                                                              true
                                                              ? Colors.white70
                                                              : AppColor.black),
                                                      borderColor:
                                                      Colors.transparent,
                                                      borderRadius: 10,
                                                      validator: (val){
                                                        if(val!.isNotEmpty)  {
                                                          if (double.parse(val
                                                              .toString()) >
                                                              100) {
                                                            return 'Please enter valid value.';
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                // Image.asset(
                                                //   "assets/dashboard_icons/pulse.png",
                                                //   height: 29,
                                                // ),
                                                // const SizedBox(
                                                //   width: 6,
                                                // ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      localization
                                                          .getLocaleData.heartRate
                                                          .toString(),
                                                      style: themeChange.darkTheme
                                                          ? MyTextTheme.smallGCB
                                                          .copyWith(
                                                          color: AppColor
                                                              .white
                                                              .withOpacity(
                                                              .6))
                                                          : MyTextTheme.mediumBCB
                                                          .copyWith(
                                                          color: AppColor
                                                              .black
                                                              .withOpacity(
                                                              0.7)),
                                                    ),
                                                    // Text(
                                                    // localization.getLocaleData.enterTheHeartRate.toString(),
                                                    //   style: MyTextTheme.smallGCN,
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                    BoxDecoration(boxShadow: [
                                                      BoxShadow(
                                                          color: themeChange
                                                              .darkTheme ==
                                                              true
                                                              ? Colors.transparent
                                                              : Colors
                                                              .grey.shade300,
                                                          offset:
                                                          const Offset(2, 3),
                                                          blurRadius: 7,
                                                          spreadRadius: 2)
                                                    ]),
                                                    child: PrimaryTextField(
                                                      prefixIcon: Image.asset(
                                                          ImagePaths.pr2,
                                                          height: 20),
                                                      hintTextColor:
                                                      themeChange.darkTheme ==
                                                          true
                                                          ? Colors.white60
                                                          : Colors.grey,
                                                      backgroundColor:
                                                      themeChange.darkTheme ==
                                                          true
                                                          ? Colors.grey.shade600.withOpacity(0.1)
                                                          : Colors.white,
                                                      controller:
                                                      addvitalVM.heartrateC,
                                                      keyboardType:
                                                      TextInputType.number,
                                                      maxLength: 5,
                                                      style: TextStyle(
                                                          color: themeChange
                                                              .darkTheme ==
                                                              true
                                                              ? Colors.white70
                                                              : AppColor.black),
                                                      hintText: localization
                                                          .getLocaleData.heartRate
                                                          .toString(),
                                                      borderColor:
                                                      Colors.transparent,
                                                      borderRadius: 10,
                                                      validator: (val){
                                                        if(val!.isNotEmpty)  {
                                                          if (double.parse(val
                                                              .toString()) >
                                                              170) {
                                                            return 'Please enter valid value.';
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                // Image.asset(
                                                //   "assets/dashboard_icons/pulse.png",
                                                //   height: 29,
                                                // ),
                                                // const SizedBox(
                                                //   width: 6,
                                                // ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        localization
                                                            .getLocaleData.pulseRate
                                                            .toString(),
                                                        style: themeChange.darkTheme
                                                            ? MyTextTheme.smallGCB
                                                                .copyWith(
                                                                    color: AppColor
                                                                        .white
                                                                        .withOpacity(
                                                                            .6))
                                                            : MyTextTheme.mediumBCB
                                                                .copyWith(
                                                                    color: AppColor
                                                                        .black
                                                                        .withOpacity(
                                                                            0.7))),
                                                    // Text(
                                                    //   localization
                                                    //       .getLocaleData.enterThePulseRate
                                                    //       .toString(),
                                                    //   style: MyTextTheme.smallGCN,
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        BoxDecoration(boxShadow: [
                                                      BoxShadow(
                                                          color: themeChange
                                                                      .darkTheme ==
                                                                  true
                                                              ? Colors.transparent
                                                              : Colors
                                                                  .grey.shade300,
                                                          offset:
                                                              const Offset(2, 3),
                                                          blurRadius: 7,
                                                          spreadRadius: 2)
                                                    ]),
                                                    child: PrimaryTextField(
                                                      prefixIcon: Image.asset(
                                                          ImagePaths.pulseRate2,
                                                          height: 20,color: AppColor.grey,),
                                                      hintTextColor:
                                                          themeChange.darkTheme ==
                                                                  true
                                                              ? Colors.white60
                                                              : Colors.grey,
                                                      backgroundColor:
                                                          themeChange.darkTheme ==
                                                                  true
                                                              ? Colors.grey.shade600.withOpacity(0.1)
                                                              : Colors.white,
                                                      controller:
                                                          addvitalVM.pulserateC,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLength: 3,
                                                      style: TextStyle(
                                                          color: themeChange
                                                                      .darkTheme ==
                                                                  true
                                                              ? Colors.white70
                                                              : AppColor.black),
                                                      hintText:
                                                          "${localization.getLocaleData.pulseRate} (Beats)",
                                                      borderColor:
                                                          Colors.transparent,
                                                      borderRadius: 10,
                                                      validator: (val){
                                                        if(val!.isNotEmpty)  {
                                                          if (double.parse(val
                                                                  .toString()) >
                                                              170) {
                                                            return 'Please enter valid value.';
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                // Image.asset(
                                                //   "assets/dashboard_icons/temperature.png",
                                                //   height: 29,
                                                // ),
                                                // const SizedBox(
                                                //   width: 6,
                                                // ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        localization.getLocaleData
                                                            .temperature
                                                            .toString(),
                                                        style: themeChange.darkTheme
                                                            ? MyTextTheme.smallGCB
                                                                .copyWith(
                                                                    color: AppColor
                                                                        .white
                                                                        .withOpacity(
                                                                            .6))
                                                            : MyTextTheme.mediumBCB
                                                                .copyWith(
                                                                    color: AppColor
                                                                        .black
                                                                        .withOpacity(
                                                                            0.7))),
                                                    // Text(
                                                    //   localization.getLocaleData
                                                    //       .enterTheTempFahrenheit
                                                    //       .toString(),
                                                    //   style: MyTextTheme.smallGCN,
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        BoxDecoration(boxShadow: [
                                                      BoxShadow(
                                                          color: themeChange
                                                                      .darkTheme ==
                                                                  true
                                                              ? Colors.transparent
                                                              : Colors
                                                                  .grey.shade300,
                                                          offset:
                                                              const Offset(2, 3),
                                                          blurRadius: 7,
                                                          spreadRadius: 2)
                                                    ]),
                                                    child: PrimaryTextField(
                                                      prefixIcon: Image.asset(
                                                          ImagePaths.temp2,
                                                          height: 20),
                                                      hintTextColor:
                                                          themeChange.darkTheme ==
                                                                  true
                                                              ? Colors.white60
                                                              : Colors.grey,
                                                      backgroundColor:
                                                          themeChange.darkTheme ==
                                                                  true
                                                              ? Colors.grey.shade600.withOpacity(0.1)
                                                              : Colors.white,
                                                      controller:
                                                          addvitalVM.temperatureC,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLength: 5,
                                                      style: TextStyle(
                                                          color: themeChange
                                                                      .darkTheme ==
                                                                  true
                                                              ? Colors.white70
                                                              : AppColor.black),
                                                      hintText:
                                                          "${localization.getLocaleData.temperature} (°F)",
                                                      borderColor:
                                                          Colors.transparent,
                                                      borderRadius: 10,
                                                      validator: (val){
                                                        if(val!.isNotEmpty)  {
                                                          if (double.parse(val
                                                                  .toString()) >
                                                              109) {
                                                            return 'Please enter valid value.';
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                // Image.asset(
                                                //   "assets/dashboard_icons/respiratory.png",
                                                //   height: 29,
                                                // ),
                                                // const SizedBox(
                                                //   width: 6,
                                                // ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      localization.getLocaleData
                                                          .repiratoryRate
                                                          .toString(),
                                                      style: themeChange.darkTheme
                                                          ? MyTextTheme.smallGCB
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .white
                                                                      .withOpacity(
                                                                          .6))
                                                          : MyTextTheme.mediumBCB
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .black
                                                                      .withOpacity(
                                                                          0.7)),
                                                    ),
                                                    // Text(
                                                    //   localization.getLocaleData
                                                    //       .enterTheResiratoryRate
                                                    //       .toString(),
                                                    //   style: MyTextTheme.smallGCN,
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: PrimaryTextField(
                                                    prefixIcon: Image.asset(
                                                        ImagePaths.rr2,
                                                        height: 20,color: AppColor.grey,),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    hintTextColor:
                                                        themeChange.darkTheme ==
                                                                true
                                                            ? Colors.white60
                                                            : Colors.grey,
                                                    backgroundColor:
                                                        themeChange.darkTheme ==
                                                                true
                                                            ? Colors.grey.shade600.withOpacity(0.1)
                                                            : Colors.white,
                                                    maxLength: 5,
                                                    controller:
                                                        addvitalVM.respiratoryC,
                                                    hintText: localization
                                                        .getLocaleData
                                                        .repiratoryRate
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            themeChange.darkTheme ==
                                                                    true
                                                                ? Colors.white70
                                                                : AppColor.black),
                                                    borderColor: Colors.transparent,
                                                    borderRadius: 10,
                                                    validator: (val){
                                                      if(val!.isNotEmpty)  {
                                                        if (double.parse(val.toString()) >
                                                            41) {
                                                          return localization.getLocaleData.pleaseEnterValidValue.toString();
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                // Image.asset(
                                                //   "assets/dashboard_icons/respiratory.png",
                                                //   height: 29,
                                                // ),
                                                // const SizedBox(
                                                //   width: 6,
                                                // ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      localization.getLocaleData.rbs.toString().toUpperCase(),
                                                      style: themeChange.darkTheme
                                                          ? MyTextTheme.smallGCB
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .white
                                                                      .withOpacity(
                                                                          .6))
                                                          : MyTextTheme.mediumBCB
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .black
                                                                      .withOpacity(
                                                                          0.7)),
                                                    ),
                                                    // Text('Enter the RBS'
                                                    //       .toString(),
                                                    //   style: MyTextTheme.smallGCN,
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: PrimaryTextField(
                                                    prefixIcon: Image.asset(
                                                        ImagePaths.bp2,
                                                        height: 20),
                                                    hintTextColor:
                                                        themeChange.darkTheme ==
                                                                true
                                                            ? Colors.white60
                                                            : Colors.grey,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    backgroundColor:
                                                        themeChange.darkTheme ==
                                                                true
                                                            ? Colors.grey.shade600.withOpacity(0.1)
                                                            : Colors.white,
                                                    style: TextStyle(
                                                        color:
                                                            themeChange.darkTheme ==
                                                                    true
                                                                ? Colors.white70
                                                                : AppColor.black),
                                                    maxLength: 3,
                                                    controller: addvitalVM.rbsC,
                                                    hintText: localization.getLocaleData.rbs.toString().toUpperCase()+'(mg-dl)',
                                                    borderColor: Colors.transparent,
                                                    borderRadius: 10,
                                                    validator: (val){
                                                      if(val!.isNotEmpty)  {
                                                        if (double.parse(val.toString()) >
                                                            600) {
                                                          return 'Please enter valid value.';
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          // Icon(Icons.monitor_weight),
                                                          Text(
                                                            localization
                                                                .getLocaleData
                                                                .weight
                                                                .toString(),
                                                            style: themeChange
                                                                    .darkTheme
                                                                ? MyTextTheme
                                                                    .smallGCB
                                                                    .copyWith(
                                                                        color: AppColor
                                                                            .white
                                                                            .withOpacity(
                                                                                .6))
                                                                : MyTextTheme
                                                                    .mediumBCB
                                                                    .copyWith(
                                                                        color: AppColor
                                                                            .black
                                                                            .withOpacity(
                                                                                0.7)),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      PrimaryTextField(
                                                        prefixIcon: const Icon(
                                                          Icons.monitor_weight,
                                                          color: Colors.grey,
                                                        ),
                                                        keyboardType:
                                                            TextInputType.number,
                                                        hintTextColor:
                                                            themeChange.darkTheme ==
                                                                    true
                                                                ? Colors.white60
                                                                : Colors.grey,
                                                        backgroundColor: themeChange
                                                                    .darkTheme ==
                                                                true
                                                            ? Colors.grey.shade600.withOpacity(0.1)
                                                            : Colors.white,
                                                        style: TextStyle(
                                                            color: themeChange
                                                                        .darkTheme ==
                                                                    true
                                                                ? Colors.white70
                                                                : AppColor.black),
                                                        maxLength: 3,
                                                        controller:
                                                            addvitalVM.weightC,
                                                        hintText: localization
                                                            .getLocaleData.inKg
                                                            .toString(),
                                                        borderColor:
                                                            Colors.transparent,
                                                        borderRadius: 10,
                                                        validator: (val){
                                                          if(val!.isNotEmpty)  {
                                                            if (double.parse(val
                                                                    .toString()) >
                                                                300) {
                                                              return 'Please enter valid value.';
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                          ],
                                        ),
                                        //  Visibility(
                                        // visible: addvitalVM.subscriptionIndex == 1,
                                        // child: Column(
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     SizedBox(
                                        //       height: 120,
                                        //       width: Get.width,
                                        //       child: ListView.builder(
                                        //         scrollDirection: Axis.horizontal,
                                        //         shrinkWrap: true,
                                        //         itemCount:
                                        //             addvitalVM.addVitalsMachine.length,
                                        //         itemBuilder: (context, index) {
                                        //           return InkWell(
                                        //             onTap: () {
                                        //               setState(() {
                                        //                 addvitalVM.SelectedListIndex =
                                        //                     index;
                                        //               });
                                        //             },
                                        //             child: Padding(
                                        //               padding: const EdgeInsets.all(5.0),
                                        //               child: Column(
                                        //                 children: [
                                        //                   Container(
                                        //                     height: 75,
                                        //                     width: 75,
                                        //                     decoration: BoxDecoration(
                                        //                         borderRadius:
                                        //                             const BorderRadius.all(
                                        //                                 Radius.circular(
                                        //                                     10.0)),
                                        //                         gradient: LinearGradient(
                                        //                             begin: Alignment.topCenter,
                                        //                             end: Alignment.bottomCenter,
                                        //                             colors: [
                                        //                               themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.white,
                                        //                               themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.white,
                                        //                               themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.white,
                                        //                               themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                                        //                             ]
                                        //                         ),
                                        //                         boxShadow: [
                                        //                           BoxShadow(color: themeChange.darkTheme?
                                        //                           Colors.grey.shade900:
                                        //                           Colors.transparent,offset: const Offset(0,5),spreadRadius: 1,blurRadius: 25)
                                        //                         ],
                                        //                         border: addvitalVM
                                        //                                     .SelectedListIndex ==
                                        //                                 index
                                        //                             ? Border.all(
                                        //                                 color: AppColor.neoGreen,
                                        //                                 width: 1)
                                        //                             : Border.all(
                                        //                             color: Colors.grey.shade400,
                                        //                             width: 1)),
                                        //                     child: Column(
                                        //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        //                       children: [
                                        //                         Image.asset(addvitalVM
                                        //                             .addVitalsMachine[index]
                                        //                                 ['image']
                                        //                             .toString(),
                                        //                             height: 32,
                                        //                             width: 32,
                                        //                             color:addvitalVM
                                        //                             .SelectedListIndex ==
                                        //                             index
                                        //                             ?  AppColor.neoGreen:null),
                                        //                         Text(addvitalVM
                                        //                             .addVitalsMachine[index]
                                        //                         ['Name']
                                        //                             .toString(),style: MyTextTheme.mediumGCN.copyWith(color: addvitalVM
                                        //                             .SelectedListIndex ==
                                        //                             index
                                        //                             ? AppColor.neoGreen: Colors.grey),)
                                        //                       ],
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           );
                                        //         },
                                        //       ),
                                        //     ),
                                        //     Container(
                                        //       height: 180,
                                        //       width: Get.width,
                                        //       decoration:
                                        //           BoxDecoration(color: AppColor.bgGreen,borderRadius: BorderRadius.circular(10)),
                                        //       child: Image.asset(
                                        //           addvitalVM.getImage().toString()),
                                        //     ),
                                        //     const SizedBox(
                                        //       height: 10,
                                        //     ),
                                        //     Text(
                                        //       addvitalVM.getHeadings(context).toString(),
                                        //       style: TextStyle(
                                        //           fontSize: 17 ,color: themeChange.darkTheme? Colors.white:Colors.grey),
                                        //     ),
                                        //     Text(
                                        //       addvitalVM.getInstruction(context),
                                        //       style: TextStyle(
                                        //           color: AppColor.greyDark,
                                        //           fontSize: 15,
                                        //           height: 2),
                                        //     ),
                                        //     Visibility(
                                        //       visible: addvitalVM.SelectedListIndex == 5,
                                        //       child: Row(
                                        //         children: [
                                        //           Image.asset(ImagePaths.bp),
                                        //           const SizedBox(
                                        //             width: 10,
                                        //           ),
                                        //           Text(
                                        //             addvitalVM.getLabelsDyanmic(context),
                                        //             style: TextStyle(
                                        //                 color: AppColor.primaryColor,
                                        //                 fontSize: 17,
                                        //                 fontWeight: FontWeight.w600),
                                        //           )
                                        //         ],
                                        //       ),
                                        //     ),
                                        //     const SizedBox(
                                        //       height: 30,
                                        //     ),
                                        //     Visibility(
                                        //       visible: addvitalVM.SelectedListIndex == 5,
                                        //       child: PrimaryTextField(
                                        //         controller: addvitalVM.weightC,
                                        //         hintText: localization.getLocaleData.enterYourWeightInkg.toString(),
                                        //         textAlign: TextAlign.center,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // )),
                                      ],
                                    ),
                                ),
                              )
                              : Expanded(child: AddDeviceConnectView()),
                          // Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           // SizedBox(
                          //           //   height: 120,
                          //           //   width: Get.width,
                          //           //   child: ListView.builder(
                          //           //     scrollDirection: Axis.horizontal,
                          //           //     shrinkWrap: true,
                          //           //     itemCount:
                          //           //         addvitalVM.addVitalsMachine.length,
                          //           //     itemBuilder: (context, index) {
                          //           //       return InkWell(
                          //           //         onTap: () {
                          //           //           setState(() {
                          //           //             addvitalVM.SelectedListIndex =
                          //           //                 index;
                          //           //           });
                          //           //           addvitalVM.updateSelectedDeviceType=addvitalVM
                          //           //               .addVitalsMachine[
                          //           //           index]['type']
                          //           //               .toString();
                          //           //         },
                          //           //         child: Padding(
                          //           //           padding:
                          //           //               const EdgeInsets.all(5.0),
                          //           //           child: Column(
                          //           //             children: [
                          //           //               Container(
                          //           //                 height: 75,
                          //           //                 width: 75,
                          //           //                 decoration: BoxDecoration(
                          //           //                     borderRadius:
                          //           //                         const BorderRadius
                          //           //                             .all(
                          //           //                             Radius.circular(
                          //           //                                 10.0)),
                          //           //                     gradient: LinearGradient(
                          //           //                         begin:
                          //           //                             Alignment
                          //           //                                 .topCenter,
                          //           //                         end: Alignment
                          //           //                             .bottomCenter,
                          //           //                         colors: [
                          //           //                           themeChange.darkTheme ==
                          //           //                                   true
                          //           //                               ? AppColor
                          //           //                                   .neoBGGrey2
                          //           //                               : AppColor
                          //           //                                   .white,
                          //           //                           themeChange.darkTheme ==
                          //           //                                   true
                          //           //                               ? AppColor
                          //           //                                   .neoBGGrey2
                          //           //                               : AppColor
                          //           //                                   .white,
                          //           //                           themeChange.darkTheme ==
                          //           //                                   true
                          //           //                               ? AppColor
                          //           //                                   .neoBGGrey2
                          //           //                               : AppColor
                          //           //                                   .white,
                          //           //                           themeChange.darkTheme ==
                          //           //                                   true
                          //           //                               ? AppColor
                          //           //                                   .neoBGGrey1
                          //           //                               : AppColor
                          //           //                                   .neoBGWhite2,
                          //           //                         ]),
                          //           //                     boxShadow: [
                          //           //                       BoxShadow(
                          //           //                           color: themeChange
                          //           //                                   .darkTheme
                          //           //                               ? Colors.grey
                          //           //                                   .shade900
                          //           //                               : Colors
                          //           //                                   .transparent,
                          //           //                           offset:
                          //           //                               const Offset(
                          //           //                                   0, 5),
                          //           //                           spreadRadius: 1,
                          //           //                           blurRadius: 25)
                          //           //                     ],
                          //           //                     border: addvitalVM
                          //           //                                 .SelectedListIndex ==
                          //           //                             index
                          //           //                         ? Border.all(
                          //           //                             color: AppColor
                          //           //                                 .neoGreen,
                          //           //                             width: 1)
                          //           //                         : Border.all(
                          //           //                             color: Colors
                          //           //                                 .grey
                          //           //                                 .shade400,
                          //           //                             width: 1)),
                          //           //                 child: Column(
                          //           //                   mainAxisAlignment:
                          //           //                       MainAxisAlignment
                          //           //                           .spaceEvenly,
                          //           //                   children: [
                          //           //                     Image.asset(
                          //           //                         addvitalVM
                          //           //                             .addVitalsMachine[
                          //           //                                 index]
                          //           //                                 ['image']
                          //           //                             .toString(),
                          //           //                         height: 32,
                          //           //                         width: 32,
                          //           //                         color: addvitalVM
                          //           //                                     .SelectedListIndex ==
                          //           //                                 index
                          //           //                             ? AppColor
                          //           //                                 .neoGreen
                          //           //                             : null),
                          //           //                     Text(
                          //           //                       addvitalVM
                          //           //                           .addVitalsMachine[
                          //           //                               index]['Name']
                          //           //                           .toString(),
                          //           //                       style: MyTextTheme
                          //           //                           .mediumGCN
                          //           //                           .copyWith(
                          //           //                               color: addvitalVM
                          //           //                                           .SelectedListIndex ==
                          //           //                                       index
                          //           //                                   ? AppColor
                          //           //                                       .neoGreen
                          //           //                                   : Colors
                          //           //                                       .grey),
                          //           //                     )
                          //           //                   ],
                          //           //                 ),
                          //           //               ),
                          //           //             ],
                          //           //           ),
                          //           //         ),
                          //           //       );
                          //           //     },
                          //           //   ),
                          //           // ),
                          //           // Container(
                          //           //   height: 180,
                          //           //   width: Get.width,
                          //           //   decoration: BoxDecoration(
                          //           //       color: AppColor.bgGreen,
                          //           //       borderRadius:
                          //           //           BorderRadius.circular(10)),
                          //           //   child: Image.asset(
                          //           //       addvitalVM.getImage().toString()),
                          //           // ),
                          //           // const SizedBox(
                          //           //   height: 10,
                          //           // ),
                          //           // Text(
                          //           //   addvitalVM
                          //           //       .getHeadings(context)
                          //           //       .toString(),
                          //           //   style: TextStyle(
                          //           //       fontSize: 17,
                          //           //       color: themeChange.darkTheme
                          //           //           ? Colors.white
                          //           //           : Colors.grey),
                          //           // ),
                          //           // Text(
                          //           //   addvitalVM.getInstruction(context),
                          //           //   style: TextStyle(
                          //           //       color: AppColor.greyDark,
                          //           //       fontSize: 15,
                          //           //       height: 2),
                          //           // ),
                          //           // Visibility(
                          //           //   visible:
                          //           //       addvitalVM.SelectedListIndex == 5,
                          //           //   child: Row(
                          //           //     children: [
                          //           //       Image.asset(ImagePaths.bp),
                          //           //       const SizedBox(
                          //           //         width: 10,
                          //           //       ),
                          //           //       Text(
                          //           //         addvitalVM
                          //           //             .getLabelsDyanmic(context),
                          //           //         style: TextStyle(
                          //           //             color: AppColor.primaryColor,
                          //           //             fontSize: 17,
                          //           //             fontWeight: FontWeight.w600),
                          //           //       )
                          //           //     ],
                          //           //   ),
                          //           // ),
                          //           // const SizedBox(
                          //           //   height: 30,
                          //           // ),
                          //           // Visibility(
                          //           //   visible:
                          //           //       addvitalVM.SelectedListIndex == 5,
                          //           //   child: PrimaryTextField(
                          //           //     controller: addvitalVM.weightC,
                          //           //     hintText: localization
                          //           //         .getLocaleData.enterYourWeightInkg
                          //           //         .toString(),
                          //           //     hintTextColor: AppColor.black12,
                          //           //   ),
                          //           // ),
                          //
                          //         ],
                          //       )
                        ]),
                  ),
                ),
                addvitalVM.subscriptionIndex == 0
                    ? NeoButton(
                        func: () async {
                          if(FormKey.currentState!.validate()){
                            print('nnnnnnnnnnnnn');
                            // await addvitalVM.AddVitalRequest(context);

                            if (addvitalVM.systollicC.text != '' &&
                                addvitalVM.diatollicC.text != '') {

                              await  patientPosition();
                              // await addvitalVM.addVitalsData(
                              //     isFromMachine: '0');
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                            } else if (addvitalVM.pulserateC.text != '' ||
                                addvitalVM.temperatureC.text != '' ||
                                addvitalVM.spo2C.text != '' ||
                                addvitalVM.respiratoryC.text != '' ||
                                addvitalVM.heartrateC.text != '' ||
                                addvitalVM.weightC.text != '' ||
                                addvitalVM.rbsC.text != '' ||
                                addvitalVM.heightC.text != '') {
                            await  patientPosition();
                              // await addvitalVM.addVitalsData(
                              //     isFromMachine: '0');
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                            } else {

                              Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Add at least one vital'));
                              // Alert.show('Add at least one vital');

                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                            }
                          }
                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                        },
                        title:localization.getLocaleData.saveVitals.toString(),
                        textStyle: MyTextTheme.mediumGCN.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: themeChange.darkTheme
                              ? AppColor.black
                              : AppColor.white,
                        ),

                        //  color: AppColor.darkYellow,
                      )
                    :
                addvitalVM.SelectedListIndex == 5? PrimaryButton(onPressed: (){
                      addvitalVM.addVitalsDataWeight(context);
                    }, title: "Save"):SizedBox()

                    // NeoButton(
                    //     color: themeChange.darkTheme
                    //         ? AppColor.green
                    //         : AppColor.greyDark,
                    //     func: () async{
                    //       if(addvitalVM.SelectedListIndex==6){
                    //
                    //         Get.to(  MyAllDevicesView(
                    //         ));
                    //
                    //       }
                    //       else   if(addvitalVM.SelectedListIndex==7){
                    //
                    //         Get.to(  PidPageForStethoView(
                    //         ));
                    //
                    //       }else   if(addvitalVM.SelectedListIndex==8){
                    //
                    //         Get.to(  PulseTransitTimeView(
                    //         ));
                    //
                    //       }
                    //       else{
                    //         // Get.to(AddDeviceView(
                    //         //
                    //         // ));
                    //     await    _enableBluetooth(context, );
                    //       }
                    //       //
                    //        // Mynav();
                    //     },
                    //     title: localization.getLocaleData.start.toString(),
                    //   )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Location location = new Location();
  late bool _serviceEnabled;
  _enableBluetooth(context, ) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    if (Platform.isAndroid) {
      bool permissionGiven = false;
      print('nnnnnnnvvvvvvv');
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          debugPrint('Location Denied once');
        }
      }

      var permissionStatus = await Permission.location.request();
      permissionGiven = permissionStatus.isGranted;
      var permissionloc = await Permission.locationWhenInUse.request();
      print('nnnnnnnn'+permissionStatus.isGranted.toString());
      permissionGiven = permissionloc.isGranted;
      var permissionBluC = await Permission.bluetoothConnect.request();
      permissionGiven = permissionBluC.isGranted;
      var permissionBlu = await Permission.bluetooth.request();
      await Permission.nearbyWifiDevices.request();
      permissionGiven = permissionBlu.isGranted;
      var permissionBluScan = await Permission.bluetoothScan.request();
      permissionGiven = permissionBluScan.isGranted;

      // bool locationEnable = await LocationService().enableGPS();

      // await FlutterBluetoothSerial.instance.requestEnable();
      // bool bluetoothEnable =
      //     (await FlutterBluetoothSerial.instance.isEnabled) ?? false;

      if (permissionGiven) {
        // if (locationEnable) {
        // if (bluetoothEnable) {
          if (permissionGiven) {
            Get.to(AddDeviceConnectView(
            ));
          } else {

            Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'some Permissions Are Not Granted'));
            // Alert.show('some Permissions Are Not Granted');
          }
        // } else {
        //   Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Please Enable Bluetooth Use This Feature'));
        //   // Alert.show('Please Enable Bluetooth Use This Feature');
        // }
        // } else {
        //   Alert.show('Please Enable Location Use This Feature');
        // }
      } else {

        Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'some Permissions Are Not Granted'));
        // Alert.show('Some Permission Are NotGranted');
      }
    } else {
      Get.to(AddDeviceView(
      ));
    }
  }



  patientPosition() {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProviderLd>(
            builder:  (BuildContext __context, themeChange,_) {
            return AlertDialog(backgroundColor: themeChange.darkTheme
                ? AppColor.black
                : AppColor.white,
                title: Consumer<AddVitalViewModal>(
                    builder:  (BuildContext _context, addvitalVM,_) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Text(localization.getLocaleData.selectPatientPosition.toString(),textAlign: TextAlign.center,style:
                          themeChange.darkTheme
                              ? MyTextTheme.largeWCB
                              :  MyTextTheme.largeBCB,),
                          SizedBox(height: 15,),
                          ...List.generate(addvitalVM.getPatientPosition.length, (index) => InkWell(
                            onTap: (){
                              addvitalVM.updateSelectedPosition=addvitalVM.getPatientPosition[index]['id'].toString();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  addvitalVM.getSelectedPosition.toString()==addvitalVM.getPatientPosition[index]['id'].toString()?
                                  Icon(Icons.radio_button_checked,color: themeChange.darkTheme
                                      ? AppColor.white
                                      : AppColor.black,):
                                  Icon(Icons.radio_button_off_outlined,color:themeChange.darkTheme
                                      ? AppColor.white
                                      : AppColor.black,),
                                  SizedBox(width: 10,),
                                  Text(addvitalVM.getPatientPosition[index]['remark'],style: themeChange.darkTheme
                                      ?MyTextTheme.mediumWCN:MyTextTheme.mediumBCN,)
                                ],
                              ),
                            ),
                          )),

                          // SizedBox(
                          //   width: 301,
                          //   child: CustomSD(listToSearch: addvitalVM.getPatientPosition,
                          //       label: 'Select position',
                          //       valFrom: 'remark', onChanged: (val){
                          //
                          //   }),
                          // ),
                          SizedBox(height: 15,),
                          PrimaryButton(onPressed: () async {

                            Get.back();
                            await addvitalVM.addVitalsData(
                                isFromMachine: '0');
                            addvitalVM.clearData();
                          },color: themeChange.darkTheme
                              ? AppColor.black
                              : AppColor.white,
                              title:  localization.getLocaleData.saveVitals.toString() )
                        ],
                      );
                    }
                ),
                contentPadding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color:themeChange.darkTheme
                      ? AppColor.green
                      : AppColor.green, ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                );
          }
        );
      },
    );
  }


  Mynav() {
    AddVitalViewModal addvitalVM =
        Provider.of<AddVitalViewModal>(context, listen: false);

    switch (addvitalVM.SelectedListIndex) {
      case 0:
        MyNavigator.push(
            context,
            DeviceView(
              isAppleHealth: true,
              isYonkerBPMachine: true,
              isCTBP: true,
            ));
        break;
      case 1:
        MyNavigator.push(
            context,
            DeviceView(
              isViaOximeter: true,
              isYonkerOximeter: true,
              isHelix: true,
              isWellue: true,
            ));
        break;
      case 2:
        // Alert.show('Coming Soon...');
        MyNavigator.push(
            context,
            DeviceView(
              isAppleHealth: true,
              // isHelix: true,
              isStetho: true,
            ));
        break;
      case 3:
        MyNavigator.push(
            context,
            DeviceView(
              isViaOximeter: true,
              isAppleHealth: true,
              isYonkerOximeter: true,
              isHelix: true,
              isWellue: true,
              isYonkerBPMachine: true,
              isCTBP: true,
            ));
        break;
      case 4:
        // Alert.show('Coming Soon...');
        MyNavigator.push(
            context,
            DeviceView(
              isThermometer: true,
            ));
        break;
    }
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  get() async {
    AddVitalViewModal addvitalVM =
        Provider.of<AddVitalViewModal>(context, listen: false);
    addvitalVM.dateC.text = DateTime.now().toString();
    addvitalVM.timeC.text =
        DateFormat("HH:mm a").format(DateTime.now()).toString();
    addvitalVM.clearData();

    await addvitalVM.hitVitalHistory(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: true);
    AddVitalViewModal addvitalVM =
        Provider.of<AddVitalViewModal>(context, listen: true);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Scaffold(
        key: scaffoldKey,
        drawer: MyDrawer(),
        backgroundColor: Colors.grey.shade800,
        body: SafeArea(
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        themeChange.darkTheme == true
                            ? AppColor.neoBGGrey2
                            : AppColor.neoBGWhite1,
                        themeChange.darkTheme == true
                            ? AppColor.neoBGGrey2
                            : AppColor.neoBGWhite1,
                        themeChange.darkTheme == true
                            ? AppColor.neoBGGrey2
                            : AppColor.neoBGWhite1,
                        themeChange.darkTheme == true
                            ? AppColor.neoBGGrey1
                            : AppColor.neoBGWhite2,
                        themeChange.darkTheme == true
                            ? AppColor.neoBGGrey2
                            : AppColor.neoBGWhite2,
                      ]),
                  color: Colors.grey.shade800,
                ),
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            onTap: () {
                              scaffoldKey.currentState!.openDrawer();
                            },
                            child: Image.asset(
                                themeChange.darkTheme == true
                                    ? ImagePaths.menuDark
                                    : ImagePaths.menulight,
                                height: 40)),

                        Column(
                          children: [
                            Text(
                              localization.getLocaleData.addVital.toString(),
                              style: MyTextTheme.largeGCB.copyWith(
                                  fontSize: 21,
                                  height: 0,
                                  color: themeChange.darkTheme == true
                                      ? Colors.white70
                                      : null),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: themeChange.darkTheme == false
                                    ? Colors.grey.shade400
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  themeChange.darkTheme == true
                                      ? AppColor.blackLight
                                      : AppColor.white,
                                  themeChange.darkTheme == true
                                      ? AppColor.blackDark
                                      : AppColor.neoBGWhite2,
                                ]),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        addvitalVM.isIntake = true;
                                        addvitalVM.notifyListeners();
                                        Get.back();
                                        // MyNavigator.pushReplacement(context, const AddVitalView());
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: !addvitalVM.isIntake
                                              ? Colors.grey
                                              : AppColor.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: !addvitalVM.isIntake
                                                    ? Colors.transparent
                                                    : AppColor.neoGreen,
                                                blurRadius: 2,
                                                offset: const Offset(-4, 0)),
                                            BoxShadow(
                                                color: !addvitalVM.isIntake
                                                    ? Colors.transparent
                                                    : AppColor.neoGreen,
                                                blurRadius: 2,
                                                offset: const Offset(4, 0)),
                                          ],
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                !addvitalVM.isIntake
                                                    ? Colors.transparent
                                                    : (themeChange.darkTheme ==
                                                            true
                                                        ? AppColor.blackDark
                                                        : AppColor.neoBGWhite2),
                                                !addvitalVM.isIntake
                                                    ? Colors.transparent
                                                    : (themeChange.darkTheme ==
                                                            true
                                                        ? AppColor.blackLight
                                                        : AppColor.neoBGWhite1),
                                              ])),
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(
                                          localization.getLocaleData.addVital
                                              .toString(),
                                          style: !addvitalVM.isIntake
                                              ? MyTextTheme.mediumGCB
                                              : MyTextTheme.mediumWCB.copyWith(
                                                  color: addvitalVM.isIntake
                                                      ? AppColor.neoGreen
                                                      : Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        addvitalVM.isIntake = false;
                                        //  MyNavigator.push(context, const VitalHistoryPage());
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: addvitalVM.isIntake
                                              ? Colors.grey
                                              : AppColor.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: addvitalVM.isIntake
                                                    ? Colors.transparent
                                                    : AppColor.neoGreen,
                                                blurRadius: 2,
                                                offset: const Offset(-4, 0)),
                                            BoxShadow(
                                                color: addvitalVM.isIntake
                                                    ? Colors.transparent
                                                    : AppColor.neoGreen,
                                                blurRadius: 2,
                                                offset: const Offset(4, 0)),
                                          ],
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                addvitalVM.isIntake
                                                    ? Colors.transparent
                                                    : (themeChange.darkTheme ==
                                                            true
                                                        ? AppColor.blackDark
                                                        : AppColor.neoBGWhite2),
                                                addvitalVM.isIntake
                                                    ? Colors.transparent
                                                    : (themeChange.darkTheme ==
                                                            true
                                                        ? AppColor.blackLight
                                                        : AppColor.neoBGWhite1),
                                              ])),
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(

                                            localization.getLocaleData
                                                .history
                                                .toString(),
                                          style: addvitalVM.isIntake
                                              ? MyTextTheme.mediumGCB
                                              : MyTextTheme.mediumWCB.copyWith(
                                                  color: !addvitalVM.isIntake
                                                      ? AppColor.neoGreen
                                                      : Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text('Last updated on',style: MyTextTheme.largeGCN.copyWith(color:themeChange.darkTheme==false? Colors.grey.shade800: Colors.white60,fontSize: 16),),
                      //       Text('11:20 AM | 08/04/23',style: MyTextTheme.smallGCB.copyWith(color:themeChange.darkTheme==false? Colors.grey: Colors.white60),),
                      //     ],
                      //   ),
                      // ),
                      // box(themeChange),
                      const SizedBox(height: 10),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      //   child: Row(
                      //     children: [
                      //       Box4(themeChange:themeChange,
                      //           context:context,
                      //           image: ImagePaths.temp2,
                      //           text: 'Temperature',
                      //           value: '97.5',
                      //           unit:'F',
                      //           time: '05 min'),
                      //       const SizedBox(width: 10),
                      //       Box4(themeChange:themeChange,
                      //           context:context,
                      //           image: ImagePaths.temp2,
                      //           text: 'Temperature',
                      //           value: '97.5',
                      //           unit:'F',
                      //           time: '05 min'),
                      //     ],
                      //   ),
                      // ),

                      // const SizedBox(height: 10),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                      //   child: Row(
                      //     children: [
                      //       Box4(themeChange:themeChange,context:context,image: ImagePaths.temp2,text: 'Temperature',value: '97.5',unit:'F',time: '05 min'),
                      //       const SizedBox(width: 10,),
                      //       Box4(themeChange:themeChange,context:context,image: ImagePaths.temp2,text: 'Temperature',value: '97.5',unit:'F',time: '05 min'),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              localization.getLocaleData.lastVitals.toString(),
                              style: MyTextTheme.largeWCN.copyWith(
                                  color: themeChange.darkTheme == true
                                      ? Colors.white70
                                      : Colors.grey.shade900),
                            )),
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
                        child: DataTable(columns: [
                          DataColumn(
                              label: Text(
                                localization.getLocaleData
                                    .vital
                                    .toString(),
                            style: MyTextTheme.mediumWCN,
                          )),
                          ...List.generate(
                              addvitalVM.getVitalHistoryList.isEmpty
                                  ? 0
                                  : addvitalVM.getVitalHistoryList
                                      .map((e) => e['vitalDateTime'])
                                      .toSet()
                                      .length,
                              (index) => DataColumn(
                                      label: Column(
                                    children: [
                                      Text(
                                        addvitalVM.getVitalHistoryList[index]
                                                ['vitalDateTime']
                                            .toString()
                                            .split(' ')[0]
                                            .toString(),
                                        style: MyTextTheme.mediumWCN,
                                      ),
                                      Text(
                                        addvitalVM.getVitalHistoryList[index]
                                                ['vitalDateTime']
                                            .toString()
                                            .split(' ')[1]
                                            .toString(),
                                        style: MyTextTheme.smallWCN,
                                      ),
                                    ],
                                  )))
                        ], rows: [
                          DataRow(
                            cells: [
                              DataCell(Text(
                                localization.getLocaleData.bpDias.toString(),
                                style: MyTextTheme.mediumWCN,
                              )),
                              ...List.generate(
                                  addvitalVM.getVitalHistoryList.isEmpty
                                      ? 0
                                      : addvitalVM.getVitalHistoryList
                                          .map((e) => e['vitalDateTime'])
                                          .toSet()
                                          .toList()
                                          .length, (index3) {
                                var vitalDate = addvitalVM.getVitalHistoryList
                                    .map((e) => e['vitalDateTime'])
                                    .toSet()
                                    .toList();
                                return DataCell(
                                  Text(
                                    addvitalVM
                                        .dateWiseVitalMap(vitalDate[index3], 6)
                                        .toString(),
                                    style: MyTextTheme.mediumWCN,
                                  ),
                                );
                              })
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                'BP_Sys',
                                style: MyTextTheme.mediumWCN,
                              )),
                              ...List.generate(
                                  addvitalVM.getVitalHistoryList.isEmpty
                                      ? 0
                                      : addvitalVM.getVitalHistoryList
                                          .map((e) => e['vitalDateTime'])
                                          .toSet()
                                          .toList()
                                          .length, (index3) {
                                var vitalDate = addvitalVM.getVitalHistoryList
                                    .map((e) => e['vitalDateTime'])
                                    .toSet()
                                    .toList();
                                return DataCell(
                                  Text(
                                    addvitalVM
                                        .dateWiseVitalMap(vitalDate[index3], 4)
                                        .toString(),
                                    style: MyTextTheme.mediumWCN,
                                  ),
                                );
                              })
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                localization.getLocaleData.temp.toString(),
                                style: MyTextTheme.mediumWCN,
                              )),
                              ...List.generate(
                                  addvitalVM.getVitalHistoryList.isEmpty
                                      ? 0
                                      : addvitalVM.getVitalHistoryList
                                          .map((e) => e['vitalDateTime'])
                                          .toSet()
                                          .toList()
                                          .length, (index3) {
                                var vitalDate = addvitalVM.getVitalHistoryList
                                    .map((e) => e['vitalDateTime'])
                                    .toSet()
                                    .toList();
                                return DataCell(
                                  Text(
                                    addvitalVM
                                        .dateWiseVitalMap(vitalDate[index3], 5)
                                        .toString(),
                                    style: MyTextTheme.mediumWCN,
                                  ),
                                );
                              })
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                              localization.getLocaleData.repiratoryRate.toString(),
                                style: MyTextTheme.mediumWCN,
                              )),
                              ...List.generate(
                                  addvitalVM.getVitalHistoryList.isEmpty
                                      ? 0
                                      : addvitalVM.getVitalHistoryList
                                          .map((e) => e['vitalDateTime'])
                                          .toSet()
                                          .toList()
                                          .length, (index3) {
                                var vitalDate = addvitalVM.getVitalHistoryList
                                    .map((e) => e['vitalDateTime'])
                                    .toSet()
                                    .toList();
                                return DataCell(
                                  Text(
                                    addvitalVM
                                        .dateWiseVitalMap(vitalDate[index3], 7)
                                        .toString(),
                                    style: MyTextTheme.mediumWCN,
                                  ),
                                );
                              })
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                localization.getLocaleData.spo2.toString(),
                                style: MyTextTheme.mediumWCN,
                              )),
                              ...List.generate(
                                  addvitalVM.getVitalHistoryList.isEmpty
                                      ? 0
                                      : addvitalVM.getVitalHistoryList
                                          .map((e) => e['vitalDateTime'])
                                          .toSet()
                                          .toList()
                                          .length, (index3) {
                                var vitalDate = addvitalVM.getVitalHistoryList
                                    .map((e) => e['vitalDateTime'])
                                    .toSet()
                                    .toList();
                                return DataCell(
                                  Text(
                                    addvitalVM
                                        .dateWiseVitalMap(vitalDate[index3], 56)
                                        .toString(),
                                    style: MyTextTheme.mediumWCN,
                                  ),
                                );
                              })
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                localization.getLocaleData.hr.toString(),
                                style: MyTextTheme.mediumWCN,
                              )),
                              ...List.generate(
                                  addvitalVM.getVitalHistoryList.isEmpty
                                      ? 0
                                      : addvitalVM.getVitalHistoryList
                                          .map((e) => e['vitalDateTime'])
                                          .toSet()
                                          .toList()
                                          .length, (index3) {
                                var vitalDate = addvitalVM.getVitalHistoryList
                                    .map((e) => e['vitalDateTime'])
                                    .toSet()
                                    .toList();
                                return DataCell(
                                  Text(
                                    addvitalVM
                                        .dateWiseVitalMap(vitalDate[index3], 74)
                                        .toString(),
                                    style: MyTextTheme.mediumWCN,
                                  ),
                                );
                              })
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                localization.getLocaleData.height.toString(),
                                style: MyTextTheme.mediumWCN,
                              )),
                              ...List.generate(
                                  addvitalVM.getVitalHistoryList.isEmpty
                                      ? 0
                                      : addvitalVM.getVitalHistoryList
                                          .map((e) => e['vitalDateTime'])
                                          .toSet()
                                          .toList()
                                          .length, (index3) {
                                var vitalDate = addvitalVM.getVitalHistoryList
                                    .map((e) => e['vitalDateTime'])
                                    .toSet()
                                    .toList();
                                return DataCell(
                                  Text(
                                    addvitalVM
                                        .dateWiseVitalMap(vitalDate[index3], 2)
                                        .toString(),
                                    style: MyTextTheme.mediumWCN,
                                  ),
                                );
                              })
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text(
                                localization.getLocaleData.weight.toString(),
                                style: MyTextTheme.mediumWCN,
                              )),
                              ...List.generate(
                                  addvitalVM.getVitalHistoryList.isEmpty
                                      ? 0
                                      : addvitalVM.getVitalHistoryList
                                          .map((e) => e['vitalDateTime'])
                                          .toSet()
                                          .toList()
                                          .length, (index3) {
                                var vitalDate = addvitalVM.getVitalHistoryList
                                    .map((e) => e['vitalDateTime'])
                                    .toSet()
                                    .toList();
                                return DataCell(
                                  Text(
                                    addvitalVM
                                        .dateWiseVitalMap(vitalDate[index3], 2)
                                        .toString(),
                                    style: MyTextTheme.mediumWCN,
                                  ),
                                );
                              })
                            ],
                          ),
                        ]),
                      ),
                      // Container(
                      //   height:44,
                      //   width: MediaQuery.of(context).size.width,
                      //   color:  themeChange.darkTheme == false ?Colors.transparent:Colors.grey.shade800,
                      //   child:  Row(
                      //     children: [
                      //       Expanded(child: Center(child: Text('Vitals',style: MyTextTheme.mediumWCB.copyWith(color:  themeChange.darkTheme == true?Colors.white:Colors.black87)))),
                      //
                      //       // ListView.builder(
                      //       //   itemCount: addvitalVM.getVitalHistoryList.length,
                      //       //   itemBuilder: (BuildContext context, int index) {
                      //       //     return  Expanded(child: Center(child:
                      //       //     Text(addvitalVM.getVitalHistoryList[index].,style: MyTextTheme.mediumWCB.copyWith(color:  AppColor.neoGreen),)));
                      //       //   },),
                      //       Expanded(
                      //         child: SingleChildScrollView(
                      //           child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                      //             child: DataTable(
                      //                 columns: List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:addvitalVM.getVitalHistoryList.length, (index) =>
                      //                 DataColumn(label: Column(
                      //                   children: [
                      //                     Text(addvitalVM.getVitalHistoryList[index]['vitalDateTime'].toString().split(' ')[0].toString()),
                      //                     Text(addvitalVM.getVitalHistoryList[index]['vitalDateTime'].toString().split(' ')[1].toString()),
                      //                   ],
                      //                 ))),
                      //                 rows: List.generate(addvitalVM.getVitalHistoryList.length, (index) =>
                      //                     DataRow(cells:
                      //                     List.generate(addvitalVM.getVitalHistoryList.isEmpty?0:addvitalVM.getVitalHistoryList.length, (index3) =>
                      //                         DataCell( Text(addvitalVM.getVitalHistoryList[index3]['vitalDateTime'].toString()))),))),
                      //           ),
                      //         ),
                      //       )
                      //
                      //       // SizedBox(height: 44,child: VerticalDivider(indent: 0,endIndent: 0,color: themeChange.darkTheme == true?Colors.transparent:Colors.grey,width: 1,)),
                      //       // Expanded(child: Center(child: Text('08/04/23',style: MyTextTheme.mediumWCB.copyWith(color:  AppColor.neoGreen),))),
                      //       // SizedBox(height: 44,child: VerticalDivider(indent: 0,endIndent: 0,color: themeChange.darkTheme == true?Colors.transparent:Colors.grey,width: 1,)),
                      //       // Expanded(child: Center(child: Text('08/04/23',style: MyTextTheme.mediumWCB.copyWith(color:  themeChange.darkTheme == true?Colors.white:Colors.grey.shade700)))),
                      //       // SizedBox(height: 44,child: VerticalDivider(indent: 0,endIndent: 0,color: themeChange.darkTheme == true?Colors.transparent:Colors.grey,width: 1,)),
                      //       // Expanded(child: Center(child: Text('08/04/23',style: MyTextTheme.mediumWCB.copyWith(color:  themeChange.darkTheme == true?Colors.white:Colors.grey.shade700)))),
                      //       // SizedBox(height: 44,child: VerticalDivider(indent: 0,endIndent: 0,color: themeChange.darkTheme == true?Colors.transparent:Colors.grey,width: 1,)),
                      //       // Expanded(child: Center(child: Text('08/04/23',style: MyTextTheme.mediumWCB.copyWith(color:  themeChange.darkTheme == true?Colors.white:Colors.grey.shade700)))),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   child: ListView.builder(
                      //     shrinkWrap: true,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemCount: 10,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         color:  themeChange.darkTheme == true ?Colors.transparent:Colors.white,
                      //           border: Border(
                      //           bottom: BorderSide(
                      //           color: themeChange.darkTheme == true?Colors.grey.shade800:Colors.grey,
                      //           width: 1.0,
                      //       ),),
                      //
                      //       ),
                      //     height:55,
                      //     width: MediaQuery.of(context).size.width,
                      //
                      //     child:  Row(
                      //       children: [
                      //         Expanded(child: Center(child: Text('Vitals',style: MyTextTheme.mediumWCB.copyWith(color:  themeChange.darkTheme == true?Colors.white:Colors.black87)))),
                      //         Expanded(child: Container(color: themeChange.darkTheme==true?Colors.grey.shade800:AppColor.neoGreen,child: Center(child: Text('08/04/23',style: MyTextTheme.mediumWCB.copyWith(color: themeChange.darkTheme==true? AppColor.neoGreen:Colors.white),)))),
                      //         Expanded(child: Center(child: Text('08/04/23',style: MyTextTheme.mediumWCN.copyWith(color:  themeChange.darkTheme == true?Colors.white:Colors.grey.shade700)))),
                      //         SizedBox(height: 55,child: VerticalDivider(indent: 0,endIndent: 0,color: themeChange.darkTheme == true?Colors.grey.shade800:Colors.grey,width: 1,)),
                      //
                      //         Expanded(child: Center(child: Text('08/04/23',style: MyTextTheme.mediumWCN.copyWith(color:  themeChange.darkTheme == true?Colors.white:Colors.grey.shade700)))),
                      //         SizedBox(height: 55,child: VerticalDivider(indent: 0,endIndent: 0,color: themeChange.darkTheme == true?Colors.grey.shade800:Colors.grey,width: 1,)),
                      //
                      //         Expanded(child: Center(child: Text('08/04/23',style: MyTextTheme.mediumWCN.copyWith(color:  themeChange.darkTheme == true?Colors.white:Colors.grey.shade700)))),
                      //       ],
                      //     ),
                      //     );
                      //   },
                      //   ),
                      // )
                    ],
                  ),
                ]))));
  }
}

aiCommandSheet(context, {String? isFrom}) {
  showModalBottomSheet(
    context: context,
    // color is applied to main screen when modal bottom screen is displayed
    barrierColor: Colors.black54,
    //background color for modal bottom screen
    backgroundColor: Colors.transparent,
    //elevates modal bottom screen
    elevation: 10,
    // gives rounded corner to modal bottom screen
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(height: 350, child: VoiceAssistant(isFrom: isFrom)),
      );
    },
  );
}

box(themeChange) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20.0),
    height: 87,
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
            color: themeChange.darkTheme == false
                ? Colors.grey.shade400
                : Colors.transparent,
            blurRadius: 10,
            offset: Offset(0, 5),
            spreadRadius: 2)
      ],
      border: Border.all(
          color: themeChange.darkTheme == false
              ? Colors.grey.shade400
              : Colors.grey.shade800,
          width: 1),
      gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            themeChange.darkTheme == true
                ? AppColor.neoBGGrey2
                : AppColor.neoBGWhite2,
            themeChange.darkTheme == true
                ? AppColor.neoBGGrey2
                : AppColor.neoBGWhite1,
            themeChange.darkTheme == true
                ? AppColor.neoBGGrey1
                : AppColor.neoBGWhite1,
            themeChange.darkTheme == true
                ? AppColor.neoBGGrey1
                : AppColor.neoBGWhite1,
          ]),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Image.asset(
                ImagePaths.pulse2,
                height: 18,
                width: 18,
                color: AppColor.neoGreen,
              ),
              const SizedBox(width: 10),
              Text('Blood Pressure',
                  style: MyTextTheme.mediumWCN.copyWith(
                      color: themeChange.darkTheme == false
                          ? Colors.grey.shade600
                          : Colors.white70)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('119/87',
                  style: MyTextTheme.veryLargeWCB.copyWith(
                      color: themeChange.darkTheme == false
                          ? Colors.grey.shade800
                          : Colors.white,
                      fontSize: 26)),
              const SizedBox(width: 10),
              Text(
                ' mm/hq',
                style: MyTextTheme.largeWCN.copyWith(
                  color: themeChange.darkTheme == false
                      ? Colors.grey.shade800
                      : Colors.white,
                ),
              ),
              const Expanded(child: SizedBox()),
              Text(
                '05 min',
                style: MyTextTheme.mediumGCN.copyWith(
                    color: themeChange.darkTheme == false
                        ? Colors.grey.shade600
                        : Colors.white60),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Box4({themeChange, context, text, image, value, unit, time}) {
  return Container(
    height: 87,
    width: (MediaQuery.of(context).size.width / 2) - 30,
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
            color: themeChange.darkTheme == false
                ? Colors.grey.shade400
                : Colors.transparent,
            blurRadius: 5,
            offset: Offset(0, 5),
            spreadRadius: 2)
      ],
      border: Border.all(
          color: themeChange.darkTheme == false
              ? Colors.grey.shade400
              : Colors.grey.shade800,
          width: 1),
      gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            themeChange.darkTheme == true
                ? AppColor.neoBGGrey2
                : AppColor.neoBGWhite2,
            themeChange.darkTheme == true
                ? AppColor.neoBGGrey2
                : AppColor.neoBGWhite1,
            themeChange.darkTheme == true
                ? AppColor.neoBGGrey1
                : AppColor.neoBGWhite1,
            themeChange.darkTheme == true
                ? AppColor.neoBGGrey1
                : AppColor.neoBGWhite1,
          ]),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Image.asset(
                image,
                height: 18,
                width: 18,
                color: AppColor.neoGreen,
              ),
              const SizedBox(width: 10),
              Text(text,
                  style: MyTextTheme.mediumWCN.copyWith(
                      color: themeChange.darkTheme == false
                          ? Colors.grey.shade600
                          : Colors.white70)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: MyTextTheme.veryLargeWCB.copyWith(
                      color: themeChange.darkTheme == false
                          ? Colors.grey.shade800
                          : Colors.white,
                      fontSize: 26)),
              const SizedBox(width: 10),
              Text(
                unit,
                style: MyTextTheme.largeWCN.copyWith(
                  color: themeChange.darkTheme == false
                      ? Colors.grey.shade800
                      : Colors.white,
                ),
              ),
              const Expanded(child: SizedBox()),
              Text(
                time,
                style: MyTextTheme.mediumGCN.copyWith(
                    color: themeChange.darkTheme == false
                        ? Colors.grey.shade600
                        : Colors.white60),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
