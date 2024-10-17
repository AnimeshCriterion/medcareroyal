import 'package:get/get.dart';
import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/ViewModal/exercise_view_model.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../theme/theme.dart';

class ExerciseTrackingHistoryView extends StatefulWidget {
  const ExerciseTrackingHistoryView({super.key});

  @override
  State<ExerciseTrackingHistoryView> createState() =>
      _ExerciseTrackingViewState();
}

class _ExerciseTrackingViewState extends State<ExerciseTrackingHistoryView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  // https://apishfc.medvantage.tech:7082/api/PatientPhysicalActivityTracker/GetAllPhysicalActivity?uhid=UHID00680
  get() async {
    ExerciseViewModel reportTrackingVM =
        Provider.of<ExerciseViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await reportTrackingVM.getAllPhysicalActivity(
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ExerciseViewModel reportTrackingVM =
        Provider.of<ExerciseViewModel>(context, listen: true);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    var dark = themeChange.darkTheme;

    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
var local = localization.getLocaleData;


    return ColoredSafeArea(
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Exercise History'),
          backgroundColor: dark?AppColor.neoBGGrey1: AppColor.neoBGWhite1,
          foregroundColor: dark?  AppColor.neoBGWhite1:AppColor.neoBGGrey1,
        ),
            body: Container(
              height: Get.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                    dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                    dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                    dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                    dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                    dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                    dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                    dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                    dark?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                    dark?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                  ])
          ),
          child: Column(
            children: [
              Container(
                color:dark?Colors.grey.shade700: Colors.grey.shade400,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Exercise'.toString(),
                              style: MyTextTheme.mediumBCB.copyWith(color: dark?AppColor.white:null),
                            ),
                          )),
                      // Expanded(
                      //     flex: 4,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //
                      //         children: [
                      //           Text('Date',style: MyTextTheme.mediumBCB.copyWith(color: dark?AppColor.white:null),),
                      //           Text('(DD/MM/YY)',style: MyTextTheme.smallBCN.copyWith(color: dark?AppColor.white:null),),
                      //         ],
                      //       ),
                      //     )),
                      Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Time',textAlign: TextAlign.center,style: MyTextTheme.mediumBCB.copyWith(color: dark?AppColor.white:null)),
                          )),
                      Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Duration', style: MyTextTheme.mediumBCB.copyWith(color: dark?AppColor.white:null)),
                                Text('(min)', style: MyTextTheme.smallBCN.copyWith(color: dark?AppColor.white:null)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                    itemCount: reportTrackingVM.getExerciseHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      var urinData = reportTrackingVM.getExerciseHistory[index];
                      var a =   urinData["timeFrom"].toString().split(' ');
                      var date =a[0];
                      var time =a[1];
                      return Container(
                        color:index%2==1?Colors.transparent:(dark?Colors.white12:AppColor.white),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                  flex: 4,
                                  child: Text(
                                    urinData["activityName"].toString(),
                                    style: MyTextTheme.mediumBCB.copyWith(color: AppColor.neoGreen),
                                  )),
                              Expanded(
                                  flex: 4,
                                  child: Text(
                                    date,
                                    style: MyTextTheme.mediumBCN.copyWith(color: dark?AppColor.white:null),
                                  )),
                              Expanded(
                                  flex: 4,
                                  child: Text(
                                    time,
                                    style: MyTextTheme.mediumBCN.copyWith(color: dark?AppColor.white:null),
                                  )),
                              Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      urinData["totalTimeInMinutes"].toString(),
                                      style: MyTextTheme.mediumBCN.copyWith(color: dark?AppColor.white:null),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      )),
    );
  }
}
