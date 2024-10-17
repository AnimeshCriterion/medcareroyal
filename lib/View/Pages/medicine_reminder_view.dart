import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/ViewModal/medicine_reminder_view_moda.dart';

import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/bottom_sheet.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:medvantage_patient/services/local_notification_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Modal/medicine_reminder_data_modal.dart';
import '../../app_manager/app_color.dart';

class MedicineReminderView extends StatefulWidget {
  final String title;
  const MedicineReminderView({Key? key, required this.title}) : super(key: key);

  @override
  State<MedicineReminderView> createState() => _MedicineReminderViewState();
}

class _MedicineReminderViewState extends State<MedicineReminderView> {
  get() async {
    MedicineReminderViewModal medicinereminderVM =
        Provider.of<MedicineReminderViewModal>(context, listen: false);
    await medicinereminderVM.getMedicineReminderList(context);
    await medicinereminderVM.getDateTimeData();
  }

  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MedicineReminderViewModal medicinereminderVM =
        Provider.of<MedicineReminderViewModal>(context, listen: true);
    return ColoredSafeArea(
        child: SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: CustomAppBar(
          title: widget.title
        ),
        body: Column(children: [
          Expanded(
            child: ListView.builder(
              itemCount: medicinereminderVM.getMedicineList.length,
              itemBuilder: (BuildContext context, int index) {
                MedicineReminderDataModal medicineData =
                    medicinereminderVM.getMedicineList[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Column(
                    children:  [
                     Container (
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColor.greyVeryLight)),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/dashboard_icons/medicine_icon.png",
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        medicineData.medicineName.toString(),
                                        style: MyTextTheme.mediumBCB,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        medicineData.dosageFormName.toString(),
                                        style: MyTextTheme.smallGCN
                                            .copyWith(color: AppColor.black12),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Frequency:   " +
                                            medicineData.frequencyName
                                                .toString() +
                                            " " +
                                            medicineData.durationInDays
                                                .toString() +
                                            " days",
                                        style: MyTextTheme.smallGCN
                                            .copyWith(color: AppColor.black12),
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: medicinereminderVM.getReminderDateTime.where((element) => element['mid'] == medicineData.medicineId).toList().isNotEmpty,
                                  child: InkWell(
                                      onTap: () {
                                        SetReminderDialog(context, medicineData,);

                                      },
                                      child: Icon(
                                        Icons.add_circle_outlined,
                                        color: AppColor.primaryColor,
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: medicinereminderVM.getReminderDateTime.where((element) => element['mid'] == medicineData.medicineId).toList().isEmpty,
                              child: PrimaryButton(
                                  borderRadius: 1,
                                  textStyle: MyTextTheme.smallWCB,
                                  color: AppColor.darkYellow,
                                  onPressed: () {
                                    print(medicineData.medicineId.toString());
                                    SetReminderDialog(context, medicinereminderVM.getMedicineList[index],
                                    );
                                    },
                                  title: "Set Reminder"),
                            ),
                            Visibility(
                              child: Column(
                                  children: List.generate(
                                medicinereminderVM.getReminderDateTime.where((element) => element['mid'] == medicineData.medicineId).length,
                                (index) => Row(
                                  children: [
                                    // Text(medicinereminderVM.getReminderDateTime.where((element) => element['mid'] == medicineData.medicineId).length.toString()),
                                    Icon(
                                      Icons.access_time_filled_rounded,
                                      color: AppColor.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(medicinereminderVM.getReminderDateTime[index]['time'],
                                      style: MyTextTheme.mediumGCB,
                                    )),
                                    InkWell(
                                        onTap: () {
                                          medicinereminderVM.onPressedRemove(
                                              medicineData.medicineId
                                                  .toString(),
                                              medicinereminderVM
                                                  .getReminderDateTime[index]
                                                      ['time']
                                                  .toString());
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: AppColor.red,
                                        ))
                                  ],
                                ),
                              )),
                            )
                          ],
                        ),
                      ),
                      // Container(padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      //   decoration: BoxDecoration(border: Border.all(color: AppColor.greyVeryLight)),
                      //   child: Column(
                      //     children: [
                      //       Row(crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //        Image.asset("assets/dashboard_icons/medicine_icon.png",height: 20,),
                      //         SizedBox(width: 15,),
                      //         Column(crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //           Text("L-Asparaginas",style: MyTextTheme.mediumBCB,),
                      //             SizedBox(height: 5,),
                      //             Text("Injection",style: MyTextTheme.smallGCN,),
                      //             SizedBox(height: 5,),
                      //             Text("Frequency:"+"QWK 10 days",style: MyTextTheme.smallGCN,),
                      //
                      //         ],),
                      //
                      //           ],
                      //         ),
                      //       SizedBox(height: 15,),
                      //
                      //       PrimaryButton(borderRadius: 1,textStyle:MyTextTheme.smallWCB ,
                      //           color: AppColor.darkYellow,
                      //           onPressed: (){
                      //             SetReminderDialog(context);
                      //           }, title: "Set Reminder"),
                      //
                      //
                      //     ],
                      //   ),
                      //
                      //   ),
                    ],
                  ),
                );
              },
            ),
          )
        ]),
      ),
    ));
  }

  SetReminderDialog(context, MedicineReminderDataModal medicineData,)
  {
    CustomBottomSheet.open(
      context,
      child: Consumer<MedicineReminderViewModal>(
          builder: (context, medicinereminderVM, _) {
        MedicineReminderViewModal medicinereminderVM =
            Provider.of<MedicineReminderViewModal>(context, listen: false);
        // MedicineReminderDataModal medicineData=medicinereminderVM.getMedicineList[index];
        return Container(
          height: 250,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Set Reminder",
              style: MyTextTheme.largeBCB,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              medicineData.medicineName.toString(),
              style: MyTextTheme.veryLargePCB,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              medicineData.dosageFormName.toString(),
              style: MyTextTheme.largeGCN,
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
                child: Text(
              "Frequency: " +
                  medicineData.frequencyName.toString() +
                  " " +
                  medicineData.durationInDays.toString() +
                  " days",
              style: MyTextTheme.largeGCN,
            )),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              controller: medicinereminderVM.dateC,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              style: TextStyle(color: AppColor.primaryColor),
              // controller: editProfileVM.dobC,
              decoration: InputDecoration(
                  label: Container(
                    decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                      child: Center(
                          child: Text(
                        'Please select Date and Time',
                        style: MyTextTheme.mediumWCB,
                      )),
                    ),
                  ),
                  labelStyle: TextStyle(color: AppColor.white),
                  hintStyle: TextStyle(color: AppColor.white)),
              dateLabelText: 'nnn',
              onChanged: (val) {
                medicinereminderVM.storeDateTimeData(mid: medicineData.medicineId, time: val,midName:medicineData.medicineName.toString(),dosageName: medicineData.dosageFormName.toString() );

                 Get.back();

                print(val);
              },
              validator: (val) {
                if (val!.isEmpty) {
                  // return localization.getLocaleData.pleaseEnterDob.toString();
                }
              },
              onSaved: (val) => print(val),
            ),
          ]),
        );
      }),
    );
  }
}
