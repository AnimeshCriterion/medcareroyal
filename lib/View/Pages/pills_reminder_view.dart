import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medvantage_patient/LiveVital/pmd/app_color.dart';
import 'package:medvantage_patient/LiveVital/stetho_bluetooth/pid_page_for_stetho.dart';
import 'package:medvantage_patient/View/Pages/prescription_checklist.dart';
import 'package:medvantage_patient/View/Pages/storage_data.dart';
import 'package:medvantage_patient/ViewModal/MasterDashoboardViewModal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';

import '../../LiveVital/pmd/my_text_theme.dart';
import '../../Localization/app_localization.dart';
import '../../Modal/medicine_intake_data_model.dart';
import '../../ViewModal/pills_reminder_view_modal.dart';
import '../../app_manager/alert_toast.dart';
import '../../app_manager/bottomSheet/bottom_sheet.dart';
import '../../app_manager/bottomSheet/functional_sheet.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import '../../theme/style.dart';
import 'drawer_view.dart';
class PillsReminderView extends StatefulWidget {
  const PillsReminderView({super.key});

  @override
  State<PillsReminderView> createState() => _PillsReminderViewState();
}

class _PillsReminderViewState extends State<PillsReminderView> {
  // ThemeProviderLd themeChangeProvider = new ThemeProviderLd();
  @override
  void initState() {
    // TODO: implement initState
    get(context);

    super.initState();
  }

  get(context) async {

    // await InternalStorage().insertStoredData(setState);

    PillsReminderViewModal pillsRemindVM =
    Provider.of<PillsReminderViewModal>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      pillsRemindVM.typeIndex=[];
      pillsRemindVM.notifyListeners();

      int currentTime=int.parse(DateFormat('HH').format(DateTime.now()).toString());
      print('nnnvnnvnn '+currentTime.toString());
      var type='';


      if (currentTime >= 0 && currentTime < 12) {
        pillsRemindVM.updateFirstValue(1);
      }
      else if (currentTime >= 12 && currentTime < 17) {
        pillsRemindVM.updateFirstValue(2);
      }
      else if (currentTime >= 17 && currentTime < 24) {
        pillsRemindVM.updateFirstValue(3);
      }

      await pillsRemindVM.pillsReminderApi(context);
    });
  }

  int typeIndex=0;




  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    MasterDashboardViewModal masterDashboardViewModal =
    Provider.of<MasterDashboardViewModal>(context, listen: true);

    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);


    final color = style.themeData(themeChange.darkTheme, context);
    PillsReminderViewModal pillsRemindVM =
    Provider.of<PillsReminderViewModal>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(
          child: Scaffold(key: scaffoldKey,
            drawer: MyDrawer(),
            backgroundColor: color.highlightColor,
            body: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child:    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6, right: 8),
                          child: InkWell(
                              onTap: () {
                               scaffoldKey.currentState!.openDrawer();
                              },

                            child:Image.asset(themeChange.darkTheme? ImagePaths.menuDark:ImagePaths.menulight,height: 40),),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.getLocaleData.prescriptionChecklist.toString(),
                                style: MyTextTheme().veryLargePCB
                                    .copyWith(color: themeChange.darkTheme ?AppColor.grey:AppColor.greyDark,fontSize: 21),
                              ),

                              Text(
                               localization.getLocaleData.intakeTimeline.toString(),
                                style: MyTextTheme().mediumWCB.copyWith(
                                    color: AppColor.green12,
                                    fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        // Switch(
                        //     value:themeChange.darkTheme, onChanged: (val)async{
                        //   print(DateTime.now());
                        //   themeChange.darkTheme=val;
                        //   themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();
                        // })
                      ],
                    ),
                  ),

                  Expanded(
                    child:
                  PrescriptionCheckListView() ,
                  )
                  // medicineCard(context)
                ],
              ),
            ),
          )),
    );
  }
  medicineCard(context){

    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    // PillsReminderViewModal pillsRemindVM = Provider.of<PillsReminderViewModal>(context, listen: false);
    // ThemeProviderLd themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    // final themecolor = style.themeData(themeChange.darkTheme, context);


    return  Consumer<PillsReminderViewModal>(
        builder:  (BuildContext context, pillsRemindVM,_) {
        return Consumer<ThemeProviderLd>(
            builder:  (BuildContext context, themeChange,_) {
            return Expanded(
              child: SingleChildScrollView(
                child: Visibility(visible:  pillsRemindVM.getMedNamesAndDates.isNotEmpty,
                  child: Column(children:
                  List.generate(pillsRemindVM.Daylist.length, (index) {

                    int currentTime=int.parse(DateFormat('HH').format(DateTime.now()).toString());
                    print('nnnvnnvnn '+currentTime.toString());
                    var type='';


                      if (currentTime >= 0 && currentTime < 12) {
                        type = 'Morning';
                      }
                      else if (currentTime >= 12 && currentTime < 17) {
                        type = 'Afternoon';
                      }
                      else if (currentTime >= 17 && currentTime < 24) {
                        type = 'Evening';
                      }


                    List <MedicationNameAndDate> medicineList=[];
                    if(index==0){
                      medicineList=  pillsRemindVM.getMedNamesAndDates.where((element) =>
                      element.frequency=='0-0-0').toList();
                    }
                    else{
                      medicineList=  pillsRemindVM.getMedNamesAndDates.where((element) =>
                      element.frequency!.split("-")[index-1]==pillsRemindVM.Daylist[index]["frequency"].toString().split("-")[index-1]).toList();
                    }


                    int totalTaken=0;

                    bool isShowGrey=false;


                    for(int i=0;i<medicineList.length;i++){
                      for(int j=0;j<medicineList[i].jsonTime!.length;j++){
                        if(medicineList[i].jsonTime![j].icon.toString().toLowerCase()=='check' &&
                            medicineList[i].jsonTime![j].durationType.toString().toLowerCase()==pillsRemindVM.Daylist[index]['day'].toLowerCase()){
                          totalTaken++;
                        }
                      }
                    }



                    return Column(
                      children: [
                        InkWell(
                          onTap: (){
                            // MyNavigator.push(context, MyHomePage());


                            pillsRemindVM.updateTypeIndex(index,);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: pillsRemindVM.Daylist[index]["day"]!=type? AppColor.grey:AppColor.green12,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [


                                  Expanded(
                                      child: Text(
                                        pillsRemindVM.Daylist[index]["day"],
                                        style: MyTextTheme().mediumBCB.copyWith(
                                            color: pillsRemindVM.Daylist[index]["day"]!=type?AppColor.greyVeryVeryLight:AppColor.greyDark,
                                      ))),
                                  Text( totalTaken.toString()+'/'+medicineList.length.toString(),
                                    style: MyTextTheme().mediumBCN
                                        .copyWith( color:
                                    pillsRemindVM.Daylist[index]["day"]!=type?AppColor.greyVeryVeryLight:AppColor.greyDark,fontSize: 16,fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),

                                  Icon(
                                      pillsRemindVM.typeIndex.contains(index)?
                                      Icons.keyboard_arrow_up_outlined: Icons.keyboard_arrow_down_outlined,
                                      color: pillsRemindVM.Daylist[index]["day"]!=type?AppColor.greyVeryVeryLight:AppColor.greyDark)
                                  // Text(
                                  //   "${'(' '0-SOS' ')'}",
                                  //   style: MyTextTheme().mediumWCB
                                  //       .copyWith(color: AppColor.red, fontSize: 15),
                                  // ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        // Divider(color: themecolor.primaryTextTheme.headline1!.color,
                        //   thickness: 1,
                        // ),




                        ...List.generate(

                            medicineList.length, (index2) {
                          MedicationNameAndDate data=medicineList[index2];

                         List medicineIsTaken=data.jsonTime!.where((element) => element.icon.toString().toLowerCase()=='check' &&
                              element.durationType.toString().toLowerCase()== pillsRemindVM.Daylist[index]['day'].toLowerCase()).toList();

                          return   pillsRemindVM.typeIndex.contains(index)?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: style.themeData(themeChange.darkTheme, context).primaryColor,
                                // border: Border.all(color: themecolor.backgroundColor
                                // ),
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,

                                  colors: [
                                    // themecolor.hintColor,themecolor.primaryColor, themecolor.focusColor
                                    style.themeData(themeChange.darkTheme, context).highlightColor, style.themeData(themeChange.darkTheme, context).highlightColor,style.themeData(themeChange.darkTheme, context).focusColor,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: style.themeData(themeChange.darkTheme, context).shadowColor,
                                    offset: const Offset(
                                      .5,
                                      .5,
                                    ),
                                    // blurRadius: 10.0,
                                    spreadRadius:2,
                                  ),
                                ],

                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(

                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                              data.drugName.toString().toUpperCase().replaceAll("CAPSULES", "CAPSULE").split("CAPSULE")[0],
                                              style: MyTextTheme().smallBCB.copyWith(color: themeChange.darkTheme ?  Colors.black87 :AppColor.lightshadowColor2,))),
                                        ...List.generate(
                                            data.jsonTime!.length, (index3) {

                                          JsonTime medicineIntakeType= data.jsonTime![index3];
                                          return


                                            medicineIntakeType.durationType!.toLowerCase()==
                                                pillsRemindVM.Daylist[index]['day'].toLowerCase()?  Icon(Icons.circle,color:
                                            medicineIntakeType.icon.toString() == "check"  ?Colors.green :
                                            medicineIntakeType.icon.toString() == "exclamation"?Colors.orange:
                                            medicineIntakeType.durationType.toString() == "SOS"?Colors.orange:
                                            medicineIntakeType.icon.toString() == "late"?Colors.red:Colors.orange,
                                              size: 15,):SizedBox()

                                          ;
                                        })

                                      ],

                                    ),
                                    SizedBox(height: 3,),
                                    IntrinsicHeight(
                                      child: Row(

                                        children: [
                                          Icon(Icons.mode_fan_off,size: 15,color: themeChange==true? Colors.white:Colors.grey,),
                                          SizedBox(width: 5,),
                                          Text(data.frequency.toString(),style: MyTextTheme().smallPCB.copyWith(color:     themeChange.darkTheme ? Colors.grey.shade400 : AppColor.greyDark,)),
                                          SizedBox(width: 10,),
                                          VerticalDivider(
                                            color:Colors.grey,
                                            thickness: 1,
                                            width: 2,
                                          ),
                                          // SizedBox(width: 10,),
                                          // Icon(Icons.adjust_outlined,size: 12,color: AppColor.green12,),
                                          // SizedBox(width: 3,),
                                          //
                                          // Text("Before food",style:MyTextTheme().smallPCB.copyWith(color:AppColor.green12 ),),



                                        ],),
                                    ),
                                    Row(children: [
                                      Expanded(flex: 3,
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${localization.getLocaleData.remark} : ",style: MyTextTheme().smallPCB.copyWith(fontSize: 10,color:     themeChange.darkTheme ? Colors.grey.shade400 : AppColor.greyDark)),
                                            Expanded(child: Text(data.remark.toString(),style:MyTextTheme().smallPCB.
                                            copyWith(fontSize: 10,color: AppColor.green) ,))
                                          ],
                                        ),
                                      ),
                                      // Expanded(
                                      //   child:button(text:"Skip" ,onPressed: (){
                                      //     print(data.drugName);
                                      //   },color: Colors.grey.shade200 ,textColor: Colors.grey.shade700
                                      //   ),
                                      // ),
                                      // SizedBox(width: 5,),
                                      // Text(data.jsonTime![0].time.toString()),
                                      Expanded(
                                          child: button(text:localization

                                              ,onPressed: () async {
                                                if(medicineIsTaken.isEmpty){
                                                    ApplicationLocalizations
                                                        localization = Provider.of<
                                                                ApplicationLocalizations>(
                                                            context,
                                                            listen: false);
                                                    await CustomBottomSheet.open(context,
                                                        child: FunctionalSheet(
                                                          message: localization
                                                              .getLocaleData
                                                              .areYouSureYouHaveTakenThisMedicine
                                                              .toString(),
                                                          buttonName: localization
                                                              .getLocaleData.yes
                                                              .toString(),
                                                          cancelBtn: localization
                                                              .getLocaleData.cancel
                                                              .toString(),
                                                          onPressButton: () async {
                                                            var jsonData = data.jsonTime!
                                                                .where((element) =>
                                                                    element.durationType
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    pillsRemindVM
                                                                        .Daylist[index]
                                                                            ['day']
                                                                        .toString()
                                                                        .toLowerCase())
                                                                .toList();
                                                            // print('nnnnnnnnnnnnn '+jsonTimeData[0].time.toString());

                                                            await pillsRemindVM.insertMedicine(
                                                                context,
                                                                pmID: int.parse(
                                                                    data.pmId.toString()),
                                                                prescriptionID: int.parse(
                                                                    data.prescriptionRowID
                                                                        .toString()),
                                                                time: DateFormat('HH:mm')
                                                                    .format(DateFormat(
                                                                            'hh:mm a')
                                                                        .parse(jsonData[0]
                                                                            .time
                                                                            .toString()))
                                                                    .toString());
                                                            // }
                                                            // await userRepository.updateUserData(User());
                                                            // await userRepository.logOutUser(context);
                                                            // print('nnnnnnnvvvv');
                                                            // vitalDialog(context);
                                                          },
                                                        ));
                                                  }
                                                else{

                                                  Get.showSnackbar( MySnackbar.SuccessSnackBar(  message:localization.getLocaleData.medicineAlreadyTaken.toString()));
                                                  // Alert.show(localization.getLocaleData.medicineAlreadyTaken.toString());
                                                }
                                                }
                                              ,color:
                                              medicineIsTaken.isEmpty?
                                              AppColor.green12
                                               :AppColor.greyLight
                                              ,
                                              textColor:  themeChange.darkTheme? AppColor.greyVeryVeryLight:AppColor.greyDark)

                                      )
                                    ],)
                                  ],
                                ),
                              ),
                            ),
                          ): SizedBox();
                        }
                        ),
                      ],
                    );
                  })

                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
  button({text,Color? color,Color? textColor, required Function onPressed}){
    return SizedBox(
      child: InkWell(
        onTap: () async {

            await onPressed();
        },
        child: Container(
            padding:EdgeInsets.fromLTRB(0,5,0,5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5)
          ),alignment: Alignment.center,
          child: Text(  text,textAlign: TextAlign.center,
              style:   TextStyle(
                  color: textColor,
                  fontSize: 15
              ))
        ),
      ),
      
      // TextButton(
      //     style: TextButton.styleFrom(
      //
      //       shape:  RoundedRectangleBorder(
      //         borderRadius:  const BorderRadius.all(Radius.circular(10.0)),
      //
      //       ),
      //       padding:  const EdgeInsets.all(6),
      //       backgroundColor:color,
      //       // shadowColor: AppColor.grey,
      //
      //     ),onPressed: () async {
      //   await onPressed();
      //
      // },child: Wrap(
      //   crossAxisAlignment: WrapCrossAlignment.center,
      //   alignment: WrapAlignment.center,
      //   children: [
      //
      //     Text(text,
      //         style:   TextStyle(
      //             color: textColor,
      //             fontSize: 15
      //         )),
      //   ],
      // )),
    );
  }
}
