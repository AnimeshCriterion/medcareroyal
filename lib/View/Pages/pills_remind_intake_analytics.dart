import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../theme/style.dart';
class PillsReminderIntakeAnaytics extends StatefulWidget {
  const PillsReminderIntakeAnaytics({super.key});

  @override
  State<PillsReminderIntakeAnaytics> createState() => _PillsReminderIntakeAnayticsState();
}

class _PillsReminderIntakeAnayticsState extends State<PillsReminderIntakeAnaytics> {
  ThemeProviderLd themeChangeProvider = new ThemeProviderLd();
  double percent = 0.0;
  late Timer timer;
 List DayType=[
   {"day":"Morning"},
   {"day":"Afternoon"},
   {"day":"Night"}

 ];
  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds:1000),(_){
      setState(() {
        percent+=10;
        if(percent >= 100){
          timer.cancel();
          // percent=0;
        }
      });
    });
    get(context);
    super.initState();
  }

  get(context) async {
   
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
    themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();
  }
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChangeProvider.darkTheme, context);
    return ColoredSafeArea(
      child: SafeArea(child: Scaffold(
        backgroundColor: color.scaffoldBackgroundColor,
        body: Container(
         decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,

             colors: [

               themeChange.darkTheme?   AppColor.darkshadowColor1: AppColor.lightshadowColor1,
               themeChange.darkTheme?   AppColor.darkshadowColor1: AppColor.lightshadowColor1,
               themeChange.darkTheme?   AppColor.black: AppColor.lightshadowColor2,




             ],
           ),
         ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 8),
                    child: InkWell(
                        onTap: () {
                           Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios_rounded)),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pills",
                          style: MyTextTheme.veryLargePCB
                              .copyWith(color: AppColor.greyDark),
                        ),
                        Text(
                          "Reminder",
                          style: MyTextTheme.veryLargeWCB.copyWith(
                              color: themeChange.darkTheme ?  Colors.black87 :AppColor.lightshadowColor2, fontSize: 32, height: .9),
                        ),
                        Text(
                          "Intake Analytics",
                          style: MyTextTheme.mediumWCB.copyWith(
                              color: AppColor.green12,
                              fontSize: 16,
                              height: 1),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                      value:themeChange.darkTheme, onChanged: (val)async{
                    dPrint(DateTime.now());
                    themeChange.darkTheme=val;
                    themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();
                  })

                ],
              ),
             Padding(padding: EdgeInsets.all(10),
             child:  percentageContainer(),
             ),
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                child: Row(children: [
                  Expanded(child: Text("Intake Accuracy Report",style: MyTextTheme.mediumWCB.copyWith(color:   themeChange.darkTheme?AppColor.lightshadowColor2:AppColor.greyDark,fontSize:17),)),
                  Text("Last 30 days",style: MyTextTheme.mediumWCB.copyWith(color:   themeChange.darkTheme?AppColor.lightshadowColor1:Colors.grey.shade400),),
                ],),
              ),
              IntakeAccutacyReport(),
              doasageContainer(child:  Row(children: [
                Image.asset(themeChange.darkTheme?"assets/darkm_patient/skip_dosage.png":"assets/lightm_patient/skip_dosage.png",height: 20,
                ),SizedBox(width: 10,),
                Expanded(child: Text("Skipped Dosage",style: MyTextTheme.mediumWCN.copyWith(color: themeChange.darkTheme?AppColor.lightshadowColor1:AppColor.greyDark,fontSize: 16,fontWeight: FontWeight.w600),)),
                Text("5",style: MyTextTheme.mediumWCB.copyWith(color:AppColor.green12,fontSize: 20 ),),
                SizedBox(width: 3,),
                Text("Times",style: MyTextTheme.mediumWCB.copyWith(color:AppColor.green12, ),)
              ]),),

              doasageContainer(child:  Row(children: [
                Image.asset(themeChange.darkTheme?"assets/darkm_patient/pills_medicine.png":"assets/lightm_patient/pills_medicine.png",height: 20,),
                SizedBox(width: 10,),
                Expanded(child: Text("SOS",style: MyTextTheme.mediumWCN.copyWith(color: themeChange.darkTheme?AppColor.lightshadowColor1:AppColor.greyDark,fontSize: 16,fontWeight: FontWeight.w600),)),
                Text("1",style: MyTextTheme.mediumWCB.copyWith(color:AppColor.green12,fontSize: 20 ),),SizedBox(width: 3,),
                Text("Times",style: MyTextTheme.mediumWCB.copyWith(color:AppColor.green12, ),)
              ]),)
            ]),
          ),
        ),
      )),
    );
  }
  percentageContainer(){

    // final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    // final themecolor = style.themeData(themeChangeProvider.darkTheme, context);
    return  Consumer<ThemeProviderLd>(
        builder:  (BuildContext context, themeChange,_) {
        return Container(

          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          decoration: BoxDecoration(
            border: Border.all(color: themeChange.darkTheme ? Colors.grey.shade800 : Colors.white70,
            ) ,
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [
                AppColor.lightgreen13,
                AppColor.lightgreen13,
                AppColor.lightgreen13,
                AppColor.darkgreen,
                AppColor.darkgreen,
              ],
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: style.themeData(themeChangeProvider.darkTheme, context).scaffoldBackgroundColor,
                offset: const Offset(
                  .5,
                  .5,
                ),
                // blurRadius: 10.0,
                spreadRadius:2,
              ),
            ],
          ),
          child: Row(children: [
            Expanded(flex: 6,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Here's your Overall",style: MyTextTheme.largeWCN.copyWith(color:style.themeData(themeChangeProvider.darkTheme, context).primaryColor,fontWeight: FontWeight.w600,fontSize: 20),),
                  Text("Medicine Intake Accuracy Status !",style: MyTextTheme.largeWCB.copyWith(color:style.themeData(themeChangeProvider.darkTheme, context).primaryColor,fontSize: 20,height: 1),),
                ],
              ),
            ),
            Expanded(flex: 2,
                child: circularPercentageIndicatorWidget(backgroundColor: AppColor.white,progressColor: AppColor.lightshadowColor2, textColor: AppColor.lightshadowColor1))

        ]),);
      }
    );
  }
  circularPercentageIndicatorWidget({ required Color backgroundColor,required Color progressColor,required Color textColor}){
    return CircularPercentIndicator(
      radius: 48,
      lineWidth: 10.0,
      animation: true,
      percent: percent/100,
      center: Text(
        percent.toString().split(".")[0].toString() + "%",
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: textColor
        ),
      ),
      backgroundColor:backgroundColor,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: progressColor,
    );
  }
  IntakeAccutacyReport(){
    // final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    // final themecolor = style.themeData(themeChangeProvider.darkTheme, context);
    return
      Consumer<ThemeProviderLd>(
          builder:  (BuildContext context, themeChange,_) {
          return Row(children: [
          ...List.generate(DayType.length, (index){
            var data=DayType[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // themecolor.hintColor,themecolor.primaryColor, themecolor.focusColor
                        style.themeData(themeChangeProvider.darkTheme, context).highlightColor,
                        style.themeData(themeChangeProvider.darkTheme, context).highlightColor,style.themeData(themeChangeProvider.darkTheme, context).focusColor,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1,
                        color: themeChange.darkTheme ? Colors.grey.shade800 : Colors.white70,
                        offset: const Offset(
                          .5,
                          .5,
                        ),
                        // blurRadius: 10.0,
                        spreadRadius:1,
                      ),
                    ],
                  border: Border.all(color: themeChange.darkTheme?AppColor.darkshadowColor2:AppColor.lightshadowColor2),
               borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                children: [
                  circularPercentageIndicatorWidget(backgroundColor: AppColor.green12,progressColor: AppColor.lightshadowColor2, textColor: AppColor.green12),
                  SizedBox(height: 5,),
                  Text(data["day"].toString(),style: MyTextTheme.mediumWCB.copyWith(color: themeChange.darkTheme?AppColor.lightshadowColor2:AppColor.greyDark,),)
                ],
              ),),
            );
          })
          ]);
        }
      );
  }
  doasageContainer({required Widget child}) {
    // final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    // final themecolor = style.themeData(themeChangeProvider.darkTheme, context);
    return  Consumer<ThemeProviderLd>(
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
                    style.themeData(themeChangeProvider.darkTheme, context).highlightColor,


                    style.themeData(themeChangeProvider.darkTheme, context).focusColor,
                    style.themeData(themeChangeProvider.darkTheme, context).focusColor,
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
                border: Border.all(color: themeChange.darkTheme?AppColor.darkshadowColor2:AppColor.lightshadowColor2),
                borderRadius: BorderRadius.circular(15)
            ),
            child:child
          ),
        );
      }
    );
  }
}
