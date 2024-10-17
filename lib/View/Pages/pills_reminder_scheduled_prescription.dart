import 'package:flutter/material.dart';

import '../../LiveVital/pmd/my_text_theme.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import '../../theme/style.dart';
import 'drawer_view.dart';
class PillsReminderScheduledPrescription extends StatefulWidget {
  const PillsReminderScheduledPrescription({super.key});

  @override
  State<PillsReminderScheduledPrescription> createState() => _PillsReminderScheduledPrescriptionState();
}

class _PillsReminderScheduledPrescriptionState extends State<PillsReminderScheduledPrescription> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    final color = style.themeData(themeChange.darkTheme, context);
    return  ColoredSafeArea(
      child: SafeArea(child: Scaffold(
        key: scaffoldKey,
        drawer: MyDrawer(),
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
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      scaffoldKey.currentState!.openDrawer();
                    },

                    child:Image.asset(themeChange.darkTheme? ImagePaths.menuDark:ImagePaths.menulight,height: 40),),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pills",
                          style: MyTextTheme().veryLargePCB
                              .copyWith(color: AppColor.greyDark,fontSize: 21),
                        ),
                        Text(
                          "Reminder",
                          style: MyTextTheme().veryLargeWCB.copyWith(
                              color: themeChange.darkTheme ?  Colors.black87 :AppColor.lightshadowColor2, fontSize: 25, height: .9),
                        ),
                        Text(
                          "Scheduled Prescription",
                          style: MyTextTheme().mediumWCB.copyWith(
                              color: AppColor.green12,
                              fontSize: 16,
                              height: 1),
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
              prescriptionCard(child: Row())
            ],
          ),
        ),
        ),
      ),

      ),
    );
  }
  prescriptionCard({ required Widget child}){
    // final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    //
    //
    // final themecolor = style.themeData(themeChange.darkTheme, context);
    return Consumer<ThemeProviderLd>(
        builder:  (BuildContext context, themeChange,_) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container( height: 60,
            child: Column(children: [
              child
            ]),
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

          ),
        );
      }
    );
  }
}
