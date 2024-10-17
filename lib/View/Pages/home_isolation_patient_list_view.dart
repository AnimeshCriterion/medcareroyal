import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:flutter/material.dart';

import '../../Modal/home_iso_request_data_modal.dart';
import '../../ViewModal/home_isolation_request_view_modal.dart';
import '../../app_manager/app_color.dart';
import '../../common_libs.dart';
import 'home_isolation_view.dart';

class HomeIsolationPatientListView extends StatefulWidget {
  const HomeIsolationPatientListView({Key? key}) : super(key: key);

  @override
  State<HomeIsolationPatientListView> createState() =>
      _HomeIsolationPatientListViewState();
}

class _HomeIsolationPatientListViewState extends State<HomeIsolationPatientListView> {
  get() async {
    HomeIsolationRequestListViewModal homeRequestVM = Provider.of<HomeIsolationRequestListViewModal>(context, listen: false);
    await homeRequestVM.homeIsolatePatientData(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    HomeIsolationRequestListViewModal homeRequestVM = Provider.of<HomeIsolationRequestListViewModal>(context, listen: true);
    return ColoredSafeArea(
        child: SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: CustomAppBar(
          title: "Home Isolated Patient List",
          actions: [
            IconButton(
                onPressed: () {
                  MyNavigator.push(context, HomeIsolation());
                },
                icon: Icon(
                  Icons.add,
                  color: AppColor.grey,
                ))
          ],
        ),
        body:
        Column(children: [
          // Text(homeRequestVM.getHomeIsoPatientList.length.toString()),

          Expanded(
            child: ListView.builder(
              itemCount:5,
              // homeRequestVM.getHomeIsoPatientList.length,

              itemBuilder: (BuildContext context, int index) {
                // HomeIsolationRequestDataModal patientListData = homeRequestVM.getHomeIsoPatientList[index];
                return

                  Column(
                    children: [

                      Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: AppColor.greyVeryLight,
                        )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             " patientListData.name.toString()",
                              style: MyTextTheme.mediumBCB,
                            ),
                            Text(
                              "ERA MEDICAL COLLEGE",
                              style: MyTextTheme.smallGCB,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "SmartHeart Failure Revival Package For 7 days",
                                    style: MyTextTheme.mediumGCN,
                                  ),
                                ),
                                Text('\u{20B9}'),
                                Text(
                                  "5999",
                                  style: MyTextTheme.mediumBCB
                                      .copyWith(color: AppColor.primaryColor),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "07 June 2023",
                                  style: MyTextTheme.mediumGCN,
                                )),
                                Text(
                                  "Approved",
                                  style: MyTextTheme.mediumBCB
                                      .copyWith(color: AppColor.green),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                ),
                    ],
                  );
              },
            ),
          )
        ]),
      ),
    ));
  }
}
