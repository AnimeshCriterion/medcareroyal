


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/common_libs.dart';

import '../../LiveVital/pmd/my_text_theme.dart';
import '../../ViewModal/plan_of_care_view_modal.dart';
import '../../app_manager/app_color.dart';
import '../../assets.dart';
import '../../theme/theme.dart';

class PlanOfCareView extends StatefulWidget {
  const PlanOfCareView({super.key});

  @override
  State<PlanOfCareView> createState() => _PlanOfCareViewState();
}

class _PlanOfCareViewState extends State<PlanOfCareView> {




  get() async {
    PlanOfCareViewModal  planOfCareViewModal = Provider.of<PlanOfCareViewModal>(context, listen: false);
    await planOfCareViewModal.getNotesTittle(context);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    PlanOfCareViewModal  planOfCareViewModal = Provider.of<PlanOfCareViewModal>(context, listen: false);
    return SafeArea(child:
    Scaffold(
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                      Text('Plan of Care',
                        style: MyTextTheme().largeBCB.copyWith(
                            fontSize: 21,
                            height: 0,
                            color: themeChange.darkTheme == true
                                ? Colors.white70
                                : null),
                      ),

                    ],
                  ),
                ),


              ],
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(flex: 4,child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Plan of Care',style: MyTextTheme().mediumWCB,),
                    )),
                    Container(
                      color: Colors.white,
                        width: 1,
                    ),
                
                    Expanded(flex: 4,child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Time',style: MyTextTheme().mediumWCB,),
                    )),

                    Container(
                      color: Colors.white,
                      width: 1,
                    ),
                    Expanded(flex: 4,child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Written By',style: MyTextTheme().mediumWCB,),
                    )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: planOfCareViewModal.getPlanList.length ,
                itemBuilder: (BuildContext context, int index) {
                  var data=planOfCareViewModal.getPlanList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(flex: 4,child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Html(data: data['details'].toString(), ),
                        )),
                        Container(
                          color: Colors.white,
                          width: 1,
                        ),

                        Expanded(flex: 4,child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd").parse(data['detailsDate'].toString()))  + ' '+DateFormat("hh:mm a").format(DateFormat("HH:mm").parse(data['detailsTime'].toString())),style: MyTextTheme().smallBCN,),
                        )),

                        Container(
                          color: Colors.white,
                          width: 1,
                        ),
                        Expanded(flex: 4,child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text( data['consultantName'].toString(),style: MyTextTheme().smallBCN,),
                        )),
                      ],
                    ),
                  );
                },),
            )
          ],
        ),
      ),
    ));
  }
}
