import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/View/Pages/pills_reminder_view.dart';
import 'package:medvantage_patient/View/Pages/urin_output.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/bottom_sheet.dart';
import 'package:medvantage_patient/app_manager/my_button.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/my_text_field_2.dart';
import 'package:medvantage_patient/assets.dart';

import '../../Localization/app_localization.dart';
import '../../ViewModal/activities_chronicle_view_modal.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../common_libs.dart';
import '../../theme/style.dart';
import '../../theme/theme.dart';
import 'addvital_view.dart';
import 'food_intake.dart';

class ActivitiesChronicleView extends StatefulWidget {
  const ActivitiesChronicleView({super.key});

  @override
  State<ActivitiesChronicleView> createState() =>
      _ActivitiesChronicleViewState();
}

class _ActivitiesChronicleViewState extends State<ActivitiesChronicleView> {
  double _value = 80;
  bool _switchvalue = false;

  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }

  get() async {
    ActivitiesChronicleViewModal actChronicleVM =
        Provider.of<ActivitiesChronicleViewModal>(context, listen: false);
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      await actChronicleVM.getActivityChronicleList(context);
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List widgetList=[
      activityChronicleWidget(),
      FoodIntakeView(),
      PillsReminderView(),
      AddVitalView(),
      UrinOutputView(),
      Text("hhhhhh")
    ];
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChange.darkTheme, context);
    ActivitiesChronicleViewModal actChronicleVM =
        Provider.of<ActivitiesChronicleViewModal>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(
          child:  Scaffold(
            body: Column(
              children: [
                Expanded(child: widgetList[
                  actChronicleVM.selectedBottomIndex]),
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                    child: bottomNavigationBar(context)
                )
              ],
            ),
          ) ),
    );
  }
  activityChronicleWidget(){

    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    return Consumer<ActivitiesChronicleViewModal>(
        builder:  (BuildContext context, actChronicleVM,_) {
          return Consumer<ThemeProviderLd>(
              builder:  (BuildContext context, themeChange,_) {
                return  Scaffold(
                  key: scaffoldKey,
                  drawer: MyDrawer(),
                  backgroundColor: Colors.grey.shade800,
                  body:
                  Container(
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(

                        children: [

                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
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
                                            Text(
                                              localization.getLocaleData.activitiesChronicle.toString(),
                                              style: MyTextTheme.veryLargePCB
                                                  .copyWith(color: AppColor.greyDark, fontSize: 24),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Switch(
                                      //     value: themeChange.darkTheme,
                                      //     onChanged: (val) async {
                                      //       dPring(val);
                                      //       themeChange.darkTheme = val;
                                      //       themeChangeProvider.darkTheme =
                                      //           await themeChangeProvider.getTheme();
                                      //     })
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "Assist Us In Understanding Your Overall Health By Providing Insights into Your Todays Activities.",
                                      style: MyTextTheme.mediumPCB.copyWith(
                                          color: AppColor.grey,
                                          // color.primaryTextTheme.headline1!.color,
                                          fontSize: 13)),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),

//                   selectTimeDisplayWidget(
//                       text: "Wake up time?",
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: CupertinoSlider(
// //                     thumbColor: Colors.white,
// // inactiveColor: Colors.grey.shade300,
//                                   min: 0.0,
//                                   max: 100.0,
//                                   value: _value,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _value = value;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     "Select\nTime",
//                                     style: MyTextTheme.smallBCN.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color,
//                                         fontWeight: FontWeight.w900),
//                                   )),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("6 am",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("7 am",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("8 am",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("9 am",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 2,
//                                   child: Text("After\n10 am",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                             ],
//                           )
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
                                          ...List.generate(
                                              (actChronicleVM.getAllActivityChronicleData.answers ?? [])
                                                  .length, (index) {
                                            var activityChronicledata = (actChronicleVM.getAllActivityChronicleData.answers ??
                                                [])[index];
                                            return selectTimeDisplayWidget(
                                                text: activityChronicledata.questionName,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                     localization.getLocaleData.no.toString(),
                                                      style: MyTextTheme.mediumPCB.copyWith(
                                                          color: Colors.grey.shade400, fontSize: 13),
                                                    ),
                                                    CupertinoSwitch(
                                                        value: activityChronicledata.optionText!
                                                            .toUpperCase() ==
                                                            'YES'
                                                            ? true
                                                            : false,
                                                        onChanged: (val) {
                                                          List temp = jsonDecode(actChronicleVM
                                                              .allActivityChronicleData['answers']);

                                                          temp[index]['optionText'] =
                                                          temp[index]['optionText'].toUpperCase() ==
                                                              'YES'
                                                              ? 'No'
                                                              : 'Yes';
                                                          dPrint(temp[index]);
                                                          actChronicleVM
                                                              .allActivityChronicleData['answers'] =
                                                              jsonEncode(temp);

                                                          actChronicleVM.notifyListeners();
                                                        }),
                                                    Text(
                                                      "Yes",
                                                      style: MyTextTheme.mediumPCB.copyWith(
                                                          color: Colors.grey.shade400, fontSize: 13),
                                                    ),
                                                  ],
                                                ));
                                          }),

                                          SizedBox(
                                            height: 10,
                                          ),
                                          selectTimeDisplayWidget(
                                              text: "Add Morning Vitals Details",
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 10),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                          color: themeChange.darkTheme?Colors.black54:Colors.grey.shade400.withOpacity(.4),
                                                          borderRadius: BorderRadius.circular(12)),
                                                      child: Row(children: [
                                                        Expanded(
                                                            child: Text(
                                                              "Select & add",
                                                              style: MyTextTheme.mediumGCB
                                                                  .copyWith(color: Colors.grey.shade500),
                                                            )),
                                                        InkWell(
                                                          onTap: (){
                                                            setState(() {
                                                              addVitalWidget();
                                                              actChronicleVM.isAddVital=true;
                                                            });
                                                          },
                                                          child: Icon(
                                                            Icons.add_circle_outlined,
                                                            size: 28,
                                                            color: AppColor.darkgreen,
                                                          ),
                                                        )
                                                      ]),
                                                    ),
                                                    SizedBox(height: 10,),

                                                    Column(children:
                                                    List.generate(
                                                        actChronicleVM.addVitalData.length, (index){
                                                      var data= actChronicleVM.addVitalData[index];
                                                      return     Row(
                                                        children: [
                                                          Expanded(flex: 9,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(4.0),
                                                              child: Container(

                                                                decoration: BoxDecoration(
                                                                    color:  themeChange.darkTheme?Colors.black54:AppColor.lightshadowColor1,
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    border: Border.all(color:  themeChange.darkTheme?Colors.grey.shade700: AppColor.grey)

                                                                ),
                                                                padding: EdgeInsets.all(8),
                                                                child:Text(data["vitalName"],  style: MyTextTheme.mediumGCB
                                                                    .copyWith(color: Colors.grey.shade500)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(flex: 5,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(4.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color:  themeChange.darkTheme?Colors.black54:AppColor.lightshadowColor1,
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    border: Border.all(color:  themeChange.darkTheme?Colors.grey.shade700: AppColor.grey)



                                                                ),
                                                                child:Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: MyTextField2(
                                                                          keyboardType: TextInputType.number,
                                                                          borderColor: AppColor.transparent,
                                                                          style: TextStyle(
                                                                            color: themeChange.darkTheme? Colors.white:AppColor.greyDark
                                                                          ),
                                                                          controller:data["controller"] ,
                                                                        )
                                                                      // My,
                                                                      // Text("BP",  style: MyTextTheme.mediumGCB
                                                                      //     .copyWith(color: themeChange.darkTheme?AppColor.lightshadowColor2:Colors.grey.shade700,fontSize: 15) ),
                                                                    ),
                                                                    Text(data["unit"].toString()+'   ',  style: MyTextTheme.smallGCB
                                                                        .copyWith(color: AppColor.green,) ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                              onTap: (){
                                                                actChronicleVM.removeVitalData(index);
                                                              },
                                                              child: Icon(Icons.close,color: themeChange.darkTheme?Colors.grey:AppColor.darkshadowColor2,))
                                                        ],
                                                      );
                                                    })
                                                      ,),
                                                    actChronicleVM.addVitalData.isEmpty? SizedBox():   MyButton(title: localization.getLocaleData.saveVitals.toString(),
                                                    width: 150,
                                                    color: Colors.green,
                                                    onPress: () async {
                                                    await  actChronicleVM.AddVitalRequest(context,
                                                    pulserateC:actChronicleVM.getVitalValue('3'),
                                                    heartrateC: actChronicleVM.getVitalValue('74'),
                                                    spo2C: actChronicleVM.getVitalValue('56'),
                                                    respiratoryC: actChronicleVM.getVitalValue('7'),
                                                    rbsC: actChronicleVM.getVitalValue('10'),
                                                    temperatureC:actChronicleVM.getVitalValue('5'),
                                                    diatollicC:  actChronicleVM.getVitalValue('6'),
                                                    systollicC: actChronicleVM.getVitalValue('4'));
                                                    actChronicleVM.addVitalData=[];
                                                    actChronicleVM.notifyListeners();
                                                    },)

                                                  ],
                                                ),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
//                   selectTimeDisplayWidget(
//                       text: "Have you engaged in any exercise?",
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "No",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                           CupertinoSwitch(
//                               value: _switchvalue,
//                               onChanged: (val) {
//                                 setState(() {
//                                   _switchvalue = val;
//                                 });
//                               }),
//                           Text(
//                             "Yes",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text:
//                           "What level of physical activity have you been involved in?",
//                       child: Row(
//                         children: List.generate(3, (index) {
//                           return Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Icon(
//                                   Icons.check_box_outline_blank,
//                                   color: AppColor.greyLight,
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   "Normal",
//                                   style: MyTextTheme.mediumPCB.copyWith(
//                                       color: color
//                                           .primaryTextTheme.headline1!.color,
//                                       fontSize: 13),
//                                 )
//                               ],
//                             ),
//                           );
//                         }),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "How Frequently do you monitor your vital signs?",
//                       child: Column(
//                         children: List.generate(5, (index) {
//                           return Padding(
//                             padding: const EdgeInsets.all(3.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     "Breakfast",
//                                     style: MyTextTheme.mediumPCB.copyWith(
//                                         color: AppColor.secondaryColorShade2),
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.check_box_outlined,
//                                   color: Colors.grey.shade400,
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Add Morning Vitals Details",
//                       child: Column(
//                         children: [],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Do you observe any health related problems?",
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "No",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                           CupertinoSwitch(
//                               value: _switchvalue,
//                               onChanged: (val) {
//                                 setState(() {
//                                   _switchvalue = val;
//                                 });
//                               }),
//                           Text(
//                             "Yes",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "How often do you prefer to eat in a day?",
//                       child: Column(
//                         children: List.generate(5, (index) {
//                           return Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     "Breakfast",
//                                     style: MyTextTheme.mediumPCB.copyWith(
//                                         color: AppColor.secondaryColorShade2),
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.check_box_outlined,
//                                   color: Colors.grey.shade400,
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Have you Had Your breakfast?",
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "No",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                           CupertinoSwitch(
//                               value: _switchvalue,
//                               onChanged: (val) {
//                                 setState(() {
//                                   _switchvalue = val;
//                                 });
//                               }),
//                           Text(
//                             "Yes",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "What Type of meal you ate in breakfast?",
//                       child: Row(
//                         children: List.generate(3, (index) {
//                           return Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 5),
//                                   child: Icon(
//                                     Icons.check_box_outline_blank,
//                                     color: AppColor.greyLight,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   "Oily/\nFried ",
//                                   style: MyTextTheme.mediumPCB.copyWith(
//                                       color: Colors.grey.shade400,
//                                       fontSize: 13),
//                                 )
//                               ],
//                             ),
//                           );
//                         }),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Specify what dish you had in your Breakfast?",
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
//                         child: Row(
//                           children: [
//                             quantityaddingContainer(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       "00",
//                                       style: MyTextTheme.mediumWCB.copyWith(
//                                       color: color.primaryTextTheme
//                                           .headline1!.color),
//                                     ),
//                                     Icon(
//                                       Icons.expand_less_outlined,
//                                       color: color
//                                           .primaryTextTheme.headline1!.color,
//                                       size: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text("Reps.",
//                                 style: MyTextTheme.mediumWCB.copyWith(
//                                     color:
//                                         color.primaryTextTheme.headline1!.color,
//                                     fontSize: 13)),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             quantityaddingContainer(
//                                 child: Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Row(
//                                 children: [
//                                   CircleAvatar(
//                                     maxRadius: 13,
//                                     backgroundColor: color.focusColor,
//                                     child: Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       color: AppColor.greyLight,
//                                       size: 13,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     "00",
//                                     style: MyTextTheme.mediumWCB.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   CircleAvatar(
//                                     maxRadius: 13,
//                                     backgroundColor: color.focusColor,
//                                     child: Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       color: AppColor.greyLight,
//                                       size: 13,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )),
//                             Expanded(child: SizedBox()),
//                             Icon(
//                               Icons.add_circle_outlined,
//                               size: 28,
//                               color: Colors.greenAccent[400],
//                             )
//                           ],
//                         ),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Have you had your Lunch?",
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "No",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                           CupertinoSwitch(
//                               value: _switchvalue,
//                               onChanged: (val) {
//                                 setState(() {
//                                   _switchvalue = val;
//                                 });
//                               }),
//                           Text(
//                             "Yes",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "What Kind of meal you had in your lunch?",
//                       child: Row(
//                         children: List.generate(3, (index) {
//                           return Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 5),
//                                   child: Icon(
//                                     Icons.check_box_outline_blank,
//                                     color: AppColor.greyLight,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   "Oily/\nFried ",
//                                   style: MyTextTheme.mediumPCB.copyWith(
//                                       color: Colors.grey.shade400,
//                                       fontSize: 13),
//                                 )
//                               ],
//                             ),
//                           );
//                         }),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Specify what dish you had in your Lunch?",
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
//                         child: Row(
//                           children: [
//                             quantityaddingContainer(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                         child: Text(
//                                       "00",
//                                       style: MyTextTheme.mediumWCB.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color),
//                                     )),
//                                     Icon(
//                                       Icons.expand_less_outlined,
//                                       color: color
//                                           .primaryTextTheme.headline1!.color,
//                                       size: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text("Label",
//                                 style: MyTextTheme.mediumWCB.copyWith(
//                                     color:
//                                         color.primaryTextTheme.headline1!.color,
//                                     fontSize: 13)),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             quantityaddingContainer(
//                                 child: Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Row(
//                                 children: [
//                                   CircleAvatar(
//                                     maxRadius: 13,
//                                     backgroundColor: color.focusColor,
//                                     child: Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       color: AppColor.greyLight,
//                                       size: 13,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     "00",
//                                     style: MyTextTheme.mediumWCB.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   CircleAvatar(
//                                     maxRadius: 13,
//                                     backgroundColor: color.focusColor,
//                                     child: Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       color: AppColor.greyLight,
//                                       size: 13,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )),
//                             Expanded(child: SizedBox()),
//                             Icon(
//                               Icons.add_circle_outlined,
//                               size: 28,
//                               color: Colors.greenAccent[400],
//                             )
//                           ],
//                         ),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Did you experience any bioating after lunch?",
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "No",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                           CupertinoSwitch(
//                               value: _switchvalue,
//                               onChanged: (val) {
//                                 setState(() {
//                                   _switchvalue = val;
//                                 });
//                               }),
//                           Text(
//                             "Yes",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "How much time did you spent in your Office?",
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: CupertinoSlider(
// //                     thumbColor: Colors.white,
// // inactiveColor: Colors.grey.shade300,
//                                   min: 0.0,
//                                   max: 100.0,
//                                   value: _value,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _value = value;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     "Select\nHrs",
//                                     style: MyTextTheme.smallBCN.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color,
//                                         fontWeight: FontWeight.w900),
//                                   )),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("<6 am",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("7 am",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("8 am",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("9 am",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 2,
//                                   child: Text(">10\nHrs",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                             ],
//                           )
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Have you had your Dinner?",
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "No",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                           CupertinoSwitch(
//                               value: _switchvalue,
//                               onChanged: (val) {
//                                 setState(() {
//                                   _switchvalue = val;
//                                 });
//                               }),
//                           Text(
//                             "Yes",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                         ],
//                       )),
//                   selectTimeDisplayWidget(
//                       text: "What kind of meal you had in your Dinner?",
//                       child: Row(
//                         children: List.generate(3, (index) {
//                           return Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 5),
//                                   child: Icon(
//                                     Icons.check_box_outline_blank,
//                                     color: AppColor.greyLight,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   "Oily/\nFried ",
//                                   style: MyTextTheme.mediumPCB.copyWith(
//                                       color: Colors.grey.shade400,
//                                       fontSize: 13),
//                                 )
//                               ],
//                             ),
//                           );
//                         }),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Specify what dish you had in your Dinner?",
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
//                         child: Row(
//                           children: [
//                             quantityaddingContainer(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                         child: Text(
//                                       "00",
//                                       style: MyTextTheme.mediumWCB.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color),
//                                     )),
//                                     Icon(
//                                       Icons.expand_less_outlined,
//                                       color: color
//                                           .primaryTextTheme.headline1!.color,
//                                       size: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text("Label",
//                                 style: MyTextTheme.mediumWCB.copyWith(
//                                     color:
//                                         color.primaryTextTheme.headline1!.color,
//                                     fontSize: 13)),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             quantityaddingContainer(
//                                 child: Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Row(
//                                 children: [
//                                   CircleAvatar(
//                                     maxRadius: 13,
//                                     backgroundColor: color.focusColor,
//                                     child: Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       color: AppColor.greyLight,
//                                       size: 13,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     "00",
//                                     style: MyTextTheme.mediumWCB.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   CircleAvatar(
//                                     maxRadius: 13,
//                                     backgroundColor: color.focusColor,
//                                     child: Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       color: AppColor.greyLight,
//                                       size: 13,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )),
//                             Expanded(child: SizedBox()),
//                             Icon(
//                               Icons.add_circle_outlined,
//                               size: 28,
//                               color: Colors.greenAccent[400],
//                             )
//                           ],
//                         ),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Which medication did you forget to take?",
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 5),
//                         child: Column(
//                           children: List.generate(3, (index) {
//                             return Padding(
//                               padding: const EdgeInsets.all(2.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       "Breakfast",
//                                       style: MyTextTheme.mediumPCB.copyWith(
//                                           color: AppColor.secondaryColorShade2),
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.check_box_outlined,
//                                     color: Colors.grey.shade400,
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                         ),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Was dinner a heavy meal for you?",
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "No",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                                 color: Colors.grey.shade400, fontSize: 13),
//                           ),
//                           CupertinoSwitch(
//                               value: _switchvalue,
//                               onChanged: (val) {
//                                 setState(() {
//                                   _switchvalue = val;
//                                 });
//                               }),
//                           Text(
//                             "Yes",
//                             style: MyTextTheme.mediumPCB.copyWith(
//                               color: Colors.grey.shade400,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "How many times did you went for Urination?",
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: CupertinoSlider(
// //                     thumbColor: Colors.white,
// // inactiveColor: Colors.grey.shade300,
//                                   min: 0.0,
//                                   max: 100.0,
//                                   value: _value,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _value = value;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     "Select\nTimes",
//                                     style: MyTextTheme.smallBCN.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color,
//                                         fontWeight: FontWeight.w900),
//                                   )),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("  <4\nTimes ",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("  4-5\nTimes",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("   5-6\nTimes",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("  6-7\nTimes",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 2,
//                                   child: Text("  >7\nTimes",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                             ],
//                           )
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "What Quantity of Urine you passed?",
//                       child: Row(
//                         children: [
//                           Expanded(
//                               child: Text(
//                             " Passed Qty.",
//                             style: MyTextTheme.smallBCB.copyWith(
//                                 color: color.primaryTextTheme.headline1!.color),
//                           )),
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
//                             child: quantityaddingContainer(
//                                 child: Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     "00",
//                                     style: MyTextTheme.mediumWCB.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color),
//                                   ),
//                                   SizedBox(
//                                     width: 20,
//                                   ),
//                                   Text(
//                                     "ml",
//                                     style: MyTextTheme.smallBCN
//                                         .copyWith(color: Colors.greenAccent),
//                                   ),
//                                   Icon(
//                                     Icons.expand_less_outlined,
//                                     color:
//                                         color.primaryTextTheme.headline1!.color,
//                                     size: 20,
//                                   )
//                                 ],
//                               ),
//                             )),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
//                             child: quantityaddingContainer(
//                                 child: Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Row(
//                                 children: [
//                                   CircleAvatar(
//                                     maxRadius: 13,
//                                     backgroundColor: color.focusColor,
//                                     child: Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       color: AppColor.greyLight,
//                                       size: 13,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     "00",
//                                     style: MyTextTheme.mediumWCB.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   CircleAvatar(
//                                     maxRadius: 13,
//                                     backgroundColor: color.focusColor,
//                                     child: Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       color: AppColor.greyLight,
//                                       size: 13,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )),
//                           ),
//                           Icon(
//                             Icons.add_circle_outlined,
//                             size: 28,
//                             color: Colors.greenAccent[400],
//                           )
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Add Vitals Details",
//                       child: Column(
//                         children: [],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Have you used your mobile screen before sleep?",
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 5),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(
//                               "No",
//                               style: MyTextTheme.mediumPCB.copyWith(
//                                   color: Colors.grey.shade400, fontSize: 13),
//                             ),
//                             CupertinoSwitch(
//                                 value: _switchvalue,
//                                 onChanged: (val) {
//                                   setState(() {
//                                     _switchvalue = val;
//                                   });
//                                 }),
//                             Text(
//                               "Yes",
//                               style: MyTextTheme.mediumPCB.copyWith(
//                                   color: Colors.grey.shade400, fontSize: 13),
//                             ),
//                           ],
//                         ),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Time you want to Sleep?",
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: CupertinoSlider(
// //                     thumbColor: Colors.white,
// // inactiveColor: Colors.grey.shade300,
//                                   min: 0.0,
//                                   max: 100.0,
//                                   value: _value,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _value = value;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     "Select\nTimes",
//                                     style: MyTextTheme.smallBCN.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color,
//                                         fontWeight: FontWeight.w900),
//                                   )),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text(" 8 pm",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("9 pm",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("10 pm",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text("11 pm",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                               Expanded(
//                                   flex: 2,
//                                   child: Text("After 12 am",
//                                       style: MyTextTheme.smallBCN.copyWith(
//                                           color: color.primaryTextTheme
//                                               .headline1!.color,
//                                           fontWeight: FontWeight.w900))),
//                             ],
//                           )
//                         ],
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "Lighting conditions when you went to sleep?",
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: Row(
//                           children: List.generate(3, (index) {
//                             return Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.check_box_outline_blank,
//                                     color: AppColor.greyLight,
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     "In Dark",
//                                     style: MyTextTheme.mediumPCB.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color,
//                                         fontSize: 13),
//                                   )
//                                 ],
//                               ),
//                             );
//                           }),
//                         ),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   selectTimeDisplayWidget(
//                       text: "How was the quantity of your sleep?",
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: Row(
//                           children: List.generate(3, (index) {
//                             return Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.check_box_outline_blank,
//                                     color: AppColor.greyLight,
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     "Good",
//                                     style: MyTextTheme.mediumPCB.copyWith(
//                                         color: color
//                                             .primaryTextTheme.headline1!.color,
//                                         fontSize: 13),
//                                   )
//                                 ],
//                               ),
//                             );
//                           }),
//                         ),
//                       )),
                                        ],
                                      ),
                                    ),
                                  ),

                                ]),
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }
    );
  }
  selectTimeDisplayWidget({text, child})  {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final themecolor = style.themeData(themeChange.darkTheme, context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
              color: themecolor.primaryColor,
              border: Border.all(color:
              themeChange.darkTheme?AppColor.darkshadowColor1:Colors.grey.shade400.withOpacity(.7)
              ),
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [themecolor.primaryColor, themecolor.focusColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: themecolor.shadowColor,
                  offset: const Offset(
                    1,
                   1,
                  ),
                  // blurRadius: 10.0,
                  spreadRadius: .5,
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text.toString(),
                        style: MyTextTheme.mediumPCB.copyWith(
                            color:    themeChange.darkTheme ? Colors.grey.shade400 : AppColor.greyDark,
                            fontSize: 13)),
                    child
                  ],
                ),
              ),
            ],
          )),
    );
  }

  bottomNavigationBar(context) {
    ActivitiesChronicleViewModal actChronicleVM =
        Provider.of<ActivitiesChronicleViewModal>(context, listen: false);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final themecolor = style.themeData(themeChange.darkTheme, context);
     
    
    return Container(

      padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
      decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(45),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeChange.darkTheme?AppColor.darkshadowColor1:Colors.grey.shade400,
              themeChange.darkTheme?AppColor.darkshadowColor1:Colors.grey.shade400,
              themeChange.darkTheme?AppColor.darkshadowColor1:Colors.grey.shade100,
              themecolor.primaryColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: themeChange.darkTheme?AppColor.darkshadowColor1:Colors.grey.shade200,
              offset: const Offset(
                1.0,
                1.0,
              ),

              spreadRadius: 5,
            ),
          ]),
      child: Row(children: [
        InkWell(
          onTap: (){
            actChronicleVM.updateSelectedIndex=0;
          },
          child: Container(
            child: ClipRRect(
                child: Center(
                    child: Icon(
              Icons.home,
              size: 30,
              color: Colors.greenAccent.shade400,
            ))),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    themecolor.focusColor,
                    themecolor.primaryColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    color: themecolor.focusColor,
                    offset: const Offset(
                      1.0,
                      7.0,
                    ),
                    // blurRadius: 10.0,
                    spreadRadius: 3,
                  ),
                ]),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(
                      actChronicleVM.bottomNavigationList.length, (index) {
                var data = actChronicleVM.bottomNavigationList[index];
                return InkWell(
                  onTap: (){
                    actChronicleVM.updateSelectedIndex=index;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Wrap(
                      children: [
                        Icon(data["icons"],
                            color:     themeChange.darkTheme ? Colors.grey.shade400 : AppColor.greyDark),
                        SizedBox(
                          width: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            data["title"],
                            style: MyTextTheme.mediumPCB.copyWith(fontSize: 15,
                              color:     themeChange.darkTheme ? Colors.grey.shade400 : AppColor.greyDark,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }))),
        ),
      ]),
    );
  }

  quantityaddingContainer({child})
  {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final themecolor = style.themeData(themeChange.darkTheme, context);
    return Container(
      width: 85,
      decoration: BoxDecoration(
          color: themecolor.hintColor,
          // border: Border.all(color:Colors.grey),
          borderRadius: BorderRadius.circular(40),
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //
          //   colors: [Colors.white,Colors.grey.shade300,Colors.grey.shade300,
          //     Colors.grey.shade300,Colors.white, ],
          // ),
          boxShadow: [
            BoxShadow(
              color: themecolor.focusColor,
              offset: const Offset(
                0.5,
                0.5,
              ),
              // blurRadius: 10.0,
              spreadRadius: 2,
            ),
          ]),
      child: child,
    );}

  addVitalWidget(){


    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    return CustomBottomSheet.open(
        context,child: Consumer<ThemeProviderLd>(
        builder: (__context, themeChange, _){
        return Consumer<ActivitiesChronicleViewModal>(
            builder: (BuildContext _context, actChronicleVM,_) {
            return
              Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        themeChange.darkTheme?AppColor.neoBGGrey1:AppColor.white,
                        themeChange.darkTheme?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                      ]
                  )
              ),
              child: Column(
                children: [
                  Text(localization.getLocaleData.selectAndAddVitals.toString(),style: MyTextTheme.mediumBCB.copyWith(
                   color: themeChange.darkTheme?AppColor.grey:AppColor.grey
                 ),),
                  Divider(
                    thickness: 1,
                    color: Colors.grey.shade400,
                  ),
                  ...List.generate(
                      actChronicleVM.vitalsList.length,

                          (index) {
                    var vital=actChronicleVM.vitalsList[index];
                    return
                      Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          actChronicleVM.vitalsList[index]["isSelected"]=! actChronicleVM.vitalsList[index]["isSelected"];

                          dPrint( vital["id"]);
                          dPrint( vital["vital"].toString());
                          actChronicleVM.notifyListeners();
                          },
                        child: Row(children: [
                          Expanded(child: Text(vital["vitalName"].toString(),style: MyTextTheme.mediumGCB,)),
                          vital["isSelected"]?Icon(Icons.check_box,color: AppColor.darkgreen,)
                              :Icon(Icons.check_box_outline_blank,)
                        ],
                        ),
                      ),
                    );
                  }),
                  Row(children: [
                    Expanded(
                      child: PrimaryButton(onPressed: (){}, title: "Close",
                      color: AppColor.grey,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: PrimaryButton(
                        icon:       Icon(Icons.add,color: AppColor.white,),
                        onPressed: (){

                          // dPring("jjjjjjjj"+actChronicleVM.addVital.where((element) => element["value"]==true).toList().toString());

                          actChronicleVM.updateAddVitalData= actChronicleVM.vitalsList.where((element) =>
                          element["isSelected"]==true).toList();

                          for(int i=0;i<actChronicleVM.getAddVitalData.length;i++){
                            actChronicleVM.addVitalData[i]['controller']=TextEditingController();
                            actChronicleVM.notifyListeners();
                            dPrint("jjjjjjjj"+actChronicleVM.addVitalData.toString());
                          }


                                   Get.back();
                          }, title: localization.getLocaleData.add.toString(),
                        color: AppColor.darkgreen,
                      ),
                    ),
                  ],
                  )
                ],
              ),
            );
          }
        );
      }
    ));
  }}
