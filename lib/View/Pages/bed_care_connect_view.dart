import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/app_manager/widgets/tab_responsive.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/custom_sd.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/my_text_field_2.dart';
import 'package:timezone/timezone.dart';

import '../../LiveVital/pmd/my_text_theme.dart';
import '../../Localization/app_localization.dart';
import '../../ViewModal/bed_care_view_modal.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';

class BedCareConnectView extends StatefulWidget {
  const BedCareConnectView({super.key});

  @override
  State<BedCareConnectView> createState() => _BedCareConnectViewState();
}

class _BedCareConnectViewState extends State<BedCareConnectView> {
  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }

  get() {
    BedCareConnectViewModal bedCareVM =
        Provider.of<BedCareConnectViewModal>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    List widgetList = [
      ottWidget(localization),
      gamesWidget(localization),
      foodWidget(localization),
      ebookWidget(localization),
      videoChatWidget(localization),
    ];

    BedCareConnectViewModal bedCareVM =
        Provider.of<BedCareConnectViewModal>(context, listen: true);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return SafeArea(
        child: Scaffold(
            body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeChange.darkTheme == true
                  ? AppColor.neoBGGrey1
                  : AppColor.neoBGWhite2,
              themeChange.darkTheme == true
                  ? AppColor.neoBGGrey1
                  : AppColor.neoBGWhite2,
              themeChange.darkTheme == true
                  ? AppColor.neoBGGrey1
                  : AppColor.neoBGWhite2,
              themeChange.darkTheme == true
                  ? AppColor.neoBGGrey1
                  : AppColor.neoBGWhite2,
              themeChange.darkTheme == true
                  ? AppColor.neoBGGrey1
                  : AppColor.neoBGWhite2,
              themeChange.darkTheme == true
                  ? AppColor.neoBGGrey2
                  : AppColor.neoBGWhite1,
              themeChange.darkTheme == true
                  ? AppColor.neoBGGrey2
                  : AppColor.neoBGWhite1,
            ]),
        color: Colors.grey.shade800,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                Text(
                  localization.getLocaleData.bedCareConnect.toString(),
                  style: MyTextTheme().veryLargeBCN.copyWith(
                      fontWeight: FontWeight.w600,
                      color: themeChange.darkTheme ? Colors.white : Colors.grey,
                      fontSize: 24),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                     '',
                    style: MyTextTheme()
                        .veryLargeBCN
                        .copyWith(fontSize: 24, color: Colors.green),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    themeChange.darkTheme = !themeChange.darkTheme;
                    themeChange.darkTheme = await themeChange.getTheme();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      themeChange.darkTheme
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: themeChange.darkTheme
                          ? Colors.white
                          : Colors.orangeAccent,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: widgetList[bedCareVM.selectedBottomIndex]),
          Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: bottomNavigationBar(context))
        ]),
      ),
    )));
  }

  ottWidget(ApplicationLocalizations localization) {

    return Consumer<BedCareConnectViewModal>(
        builder: (BuildContext context, bedCareVM, _) {
      return Consumer<ThemeProviderLd>(
          builder: (BuildContext context, themeChange, _) {
        return  TabResponsiveUtil.isTab(context)?
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      localization.getLocaleData.ttApps.toString(),
                      style: MyTextTheme().mediumBCN.copyWith(
                          fontSize: 22,
                          color: themeChange.darkTheme
                              ? AppColor.white
                              : AppColor.grey,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: PrimaryTextField(
                      backgroundColor: themeChange.darkTheme
                          ? AppColor.black12.withOpacity(.9)
                          : Colors.white,
                      // controller:feedbackVm.emailC ,
                      borderColor: themeChange.darkTheme
                          ? AppColor.black12.withOpacity(.9)
                          : Colors.white,
                      onChanged: (val) async {
                        setState(() {});
                      },
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColor.grey,
                        size: 25,
                      ),
                      hintText: localization.getLocaleData.search,
                      hintTextColor: themeChange.darkTheme == true
                          ? Colors.grey.shade400
                          : Colors.grey,

                      // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              StaggeredGrid.extent(
                maxCrossAxisExtent: 350,
                crossAxisSpacing: 2,
                children: [
                  ...List.generate(bedCareVM.OttList.length, (index) {
                    var data = bedCareVM.OttList[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  themeChange.darkTheme == true
                                      ? AppColor.black12.withOpacity(.4)
                                      : AppColor.neoBGWhite2,
                                  themeChange.darkTheme == true
                                      ? AppColor.black12.withOpacity(.4)
                                      : AppColor.neoBGWhite2,
                                  themeChange.darkTheme == true
                                      ? AppColor.neoBGGrey2
                                      : AppColor.neoBGWhite1,
                                  themeChange.darkTheme == true
                                      ? AppColor.neoBGGrey2
                                      : AppColor.neoBGWhite1,
                                ]),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Container(
                            child: Image.asset(data["image"]),
                          ),
                        )
                      ]),
                    );
                  })
                ],
              )
            ],
          ),
        ):
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex:1,
                  child: Text(
                    localization.getLocaleData.ttApps.toString(),
                    style: MyTextTheme().mediumBCN.copyWith(
                        fontSize: 16,
                        color: themeChange.darkTheme
                            ? AppColor.white
                            : AppColor.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: PrimaryTextField(
                    backgroundColor: themeChange.darkTheme
                        ? AppColor.black12.withOpacity(.9)
                        : Colors.white,
                    // controller:feedbackVm.emailC ,
                    borderColor: themeChange.darkTheme
                        ? AppColor.black12.withOpacity(.9)
                        : Colors.white,
                    onChanged: (val) async {
                      setState(() {});
                    },
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColor.grey,
                      size: 25,
                    ),
                    hintText: localization.getLocaleData.search.toString(),
                    hintTextColor: themeChange.darkTheme == true
                        ? Colors.grey.shade400
                        : Colors.grey,

                    // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: StaggeredGrid.extent(
                  maxCrossAxisExtent: 350,
                  crossAxisSpacing: 2,
                  children: [
                    ...List.generate(bedCareVM.OttList.length, (index) {
                      var data = bedCareVM.OttList[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    themeChange.darkTheme == true
                                        ? AppColor.black12.withOpacity(.4)
                                        : AppColor.neoBGWhite2,
                                    themeChange.darkTheme == true
                                        ? AppColor.black12.withOpacity(.4)
                                        : AppColor.neoBGWhite2,
                                    themeChange.darkTheme == true
                                        ? AppColor.neoBGGrey2
                                        : AppColor.neoBGWhite1,
                                    themeChange.darkTheme == true
                                        ? AppColor.neoBGGrey2
                                        : AppColor.neoBGWhite1,
                                  ]),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Container(
                              child: Image.asset(data["image"]),
                            ),
                          )
                        ]),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        );
      });
    });
  }

  gamesWidget(ApplicationLocalizations localization) {
    return Consumer<BedCareConnectViewModal>(
        builder: (BuildContext context, bedCareVM, _) {
      return Consumer<ThemeProviderLd>(
          builder: (BuildContext context, themeChange, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: TabResponsiveUtil.isTab(context)?Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      localization.getLocaleData.games.toString(),
                      style: MyTextTheme().mediumBCN.copyWith(
                          fontSize: 22,
                          color: themeChange.darkTheme
                              ? AppColor.white
                              : AppColor.grey,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: PrimaryTextField(
                      backgroundColor: themeChange.darkTheme
                          ? AppColor.black12.withOpacity(.9)
                          : Colors.white,
                      // controller:feedbackVm.emailC ,
                      borderColor: themeChange.darkTheme
                          ? AppColor.black12.withOpacity(.9)
                          : Colors.white,
                      onChanged: (val) async {
                        setState(() {});
                      },
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColor.grey,
                        size: 25,
                      ),
                      hintText: localization.getLocaleData.search.toString(),
                      hintTextColor: themeChange.darkTheme == true
                          ? Colors.grey.shade400
                          : Colors.grey,

                      // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              StaggeredGrid.extent(
                maxCrossAxisExtent: 350,
                crossAxisSpacing: 2,
                children: [
                  ...List.generate(7, (index) {
                    // var data=bedCareVM.OttList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  themeChange.darkTheme == true
                                      ? AppColor.black12.withOpacity(.3)
                                      : AppColor.neoBGWhite2,
                                  themeChange.darkTheme == true
                                      ? AppColor.black12.withOpacity(.3)
                                      : AppColor.neoBGWhite2,
                                  themeChange.darkTheme == true
                                      ? AppColor.neoBGGrey2
                                      : AppColor.neoBGWhite1,
                                  themeChange.darkTheme == true
                                      ? AppColor.neoBGGrey2
                                      : AppColor.neoBGWhite1,
                                ]),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Container(
                            child:
                                Image.asset("assets/BedCareConnect/game.png"),
                          ),
                        )
                      ]),
                    );
                  })
                ],
              )
            ],
          ):
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Games",
                      style: MyTextTheme().mediumBCN.copyWith(
                        fontSize: 16,
                          color: themeChange.darkTheme
                              ? AppColor.white
                              : AppColor.grey,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: PrimaryTextField(
                      backgroundColor: themeChange.darkTheme
                          ? AppColor.black12.withOpacity(.9)
                          : Colors.white,
                      // controller:feedbackVm.emailC ,
                      borderColor: themeChange.darkTheme
                          ? AppColor.black12.withOpacity(.9)
                          : Colors.white,
                      onChanged: (val) async {
                        setState(() {});
                      },
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColor.grey,
                        size: 25,
                      ),
                      hintText: "Search",
                      hintTextColor: themeChange.darkTheme == true
                          ? Colors.grey.shade400
                          : Colors.grey,

                      // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: StaggeredGrid.extent(
                    maxCrossAxisExtent: 350,
                    crossAxisSpacing: 2,
                    children: [
                      ...List.generate(7, (index) {
                        // var data=bedCareVM.OttList[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      themeChange.darkTheme == true
                                          ? AppColor.black12.withOpacity(.3)
                                          : AppColor.neoBGWhite2,
                                      themeChange.darkTheme == true
                                          ? AppColor.black12.withOpacity(.3)
                                          : AppColor.neoBGWhite2,
                                      themeChange.darkTheme == true
                                          ? AppColor.neoBGGrey2
                                          : AppColor.neoBGWhite1,
                                      themeChange.darkTheme == true
                                          ? AppColor.neoBGGrey2
                                          : AppColor.neoBGWhite1,
                                    ]),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Container(
                                child:
                                Image.asset("assets/BedCareConnect/game.png"),
                              ),
                            )
                          ]),
                        );
                      })
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      });
    });
  }

  foodWidget(ApplicationLocalizations localization) {
    return Consumer<BedCareConnectViewModal>(
        builder: (BuildContext context, bedCareVM, _) {
      return Consumer<ThemeProviderLd>(
          builder: (BuildContext context, themeChange, _) {
        return TabResponsiveUtil.isTab(context)?
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    "E-book",
                    style: MyTextTheme().mediumBCN.copyWith(
                        fontSize: 22,
                        color: themeChange.darkTheme
                            ? AppColor.white
                            : AppColor.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: PrimaryTextField(
                    backgroundColor: themeChange.darkTheme
                        ? AppColor.black12.withOpacity(.9)
                        : Colors.white,
                    // controller:feedbackVm.emailC ,
                    borderColor: themeChange.darkTheme
                        ? AppColor.black12.withOpacity(.9)
                        : Colors.white,
                    onChanged: (val) async {
                      setState(() {});
                    },
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColor.grey,
                      size: 25,
                    ),
                    hintText: localization.getLocaleData.search.toString(),
                    hintTextColor: themeChange.darkTheme == true
                        ? Colors.grey.shade400
                        : Colors.grey,

                    // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(child: SizedBox()),
                Text(
                  localization.getLocaleData.filter.toString(),
                  style: MyTextTheme().mediumBCB.copyWith(
                      color: themeChange.darkTheme
                          ? AppColor.grey
                          : AppColor.black),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 200,
                  child: CustomSD(
                      decoration: BoxDecoration(
                          color: themeChange.darkTheme
                              ? Colors.black12.withOpacity(0.3)
                              : AppColor.white),
                      listToSearch: [],
                      valFrom: "",
                      onChanged: (val) {}),
                ),

              ],
            ),
            SizedBox(height: 10,),
            Expanded(
              child: SingleChildScrollView(
                child: StaggeredGrid.extent(maxCrossAxisExtent: 350,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: [
                    ... List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  themeChange.darkTheme
                                      ? AppColor.darkshadowColor2
                                      : Colors.grey.shade400,
                                  themeChange.darkTheme
                                      ? AppColor.black
                                      : Colors.grey.shade100,
                                ],
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: themeChange.darkTheme
                              //         ? Colors.black12.withOpacity(.2)
                              //         : Colors.grey.shade400,
                              //     offset: const Offset(
                              //       1.0,
                              //       1.0,
                              //     ),
                              //     spreadRadius: 12,
                              //   ),
                              // ]
                            ),

                            child: IntrinsicHeight(
                              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: AppColor.grey,
                                        borderRadius:
                                        BorderRadius.circular(8)),

                                    child:Image.asset("assets/BedCareConnect/atomic_habbit.png"),),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(localization.getLocaleData.atomic.toString(),style: MyTextTheme().mediumGCB.copyWith(color: themeChange.darkTheme?AppColor.white:AppColor.grey),),
                                          SizedBox(height: 5,),
                                          Text(localization.getLocaleData.atomic.toString(),style: MyTextTheme().mediumGCB.copyWith(color: themeChange.darkTheme?AppColor.grey:AppColor.grey),),
                                        ],
                                      ),

                                      PrimaryButton(width: 100,
                                          color: AppColor.darkgreen,
                                          onPressed: (){},
                                          title: localization.getLocaleData.read.toString())
                                    ],),


                                ],),
                            )

                        ),
                      );
                    })
                  ],
                ),
              ),
            )

          ],

        )
          :Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        localization.getLocaleData.food.toString(),
                        style: MyTextTheme().mediumBCN.copyWith(
fontSize: 16,
                            color: themeChange.darkTheme
                                ? AppColor.white
                                : AppColor.grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: PrimaryTextField(
                        backgroundColor: themeChange.darkTheme
                            ? AppColor.black12.withOpacity(.9)
                            : Colors.white,
                        // controller:feedbackVm.emailC ,
                        borderColor: themeChange.darkTheme
                            ? AppColor.black12.withOpacity(.9)
                            : Colors.white,
                        onChanged: (val) async {
                          setState(() {});
                        },
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColor.grey,
                          size: 25,
                        ),
                        hintText: localization.getLocaleData.search.toString(),
                        hintTextColor: themeChange.darkTheme == true
                            ? Colors.grey.shade400
                            : Colors.grey,

                        // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                Row(children: [
                  Text(
                    localization.getLocaleData.dishType.toString(),
                    style: MyTextTheme().mediumBCB.copyWith(
                        color: themeChange.darkTheme
                            ? AppColor.grey
                            : AppColor.black),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomSD(


                        listToSearch: [], valFrom: "", onChanged: (val) {}),
                  ),
                ],),
                SizedBox(height: 5,),



                Row(
                  children: [
                    Expanded(
                      flex:6,
                      child: Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      bedCareVM.subscriptionIndex = 0;
                                      bedCareVM.isIntake = true;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: !bedCareVM.isIntake
                                            ? Colors.grey
                                            : AppColor.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: !bedCareVM.isIntake
                                                  ? Colors.transparent
                                                  : AppColor.neoGreen,
                                              blurRadius: 2,
                                              offset: const Offset(-4, 0)),
                                          BoxShadow(
                                              color: !bedCareVM.isIntake
                                                  ? Colors.transparent
                                                  : AppColor.neoGreen,
                                              blurRadius: 2,
                                              offset: const Offset(4, 0)),
                                        ],
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              !bedCareVM.isIntake
                                                  ? Colors.transparent
                                                  : (themeChange.darkTheme ==
                                                          true
                                                      ? AppColor.blackDark
                                                      : AppColor.neoBGWhite2),
                                              !bedCareVM.isIntake
                                                  ? Colors.transparent
                                                  : (themeChange.darkTheme ==
                                                          true
                                                      ? AppColor.blackLight
                                                      : AppColor.neoBGWhite1),
                                            ])),
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(
                                        localization.getLocaleData.veg.toString(),
                                        style: !bedCareVM.isIntake
                                            ? MyTextTheme().mediumGCB
                                            : MyTextTheme()
                                                .mediumWCB
                                                .copyWith(
                                                    color: bedCareVM.isIntake
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
                                      bedCareVM.subscriptionIndex = 1;
                                      bedCareVM.isIntake = false;
                                      // MyNavigator.push(context, const VitalHistoryPage());
                                      //  MyNavigator.navigateTransparent(context, const HistoryPage());
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: bedCareVM.isIntake
                                            ? Colors.grey
                                            : AppColor.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: bedCareVM.isIntake
                                                  ? Colors.transparent
                                                  : AppColor.neoGreen,
                                              blurRadius: 2,
                                              offset: const Offset(-4, 0)),
                                          BoxShadow(
                                              color: bedCareVM.isIntake
                                                  ? Colors.transparent
                                                  : AppColor.neoGreen,
                                              blurRadius: 2,
                                              offset: const Offset(4, 0)),
                                        ],
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              bedCareVM.isIntake
                                                  ? Colors.transparent
                                                  : (themeChange.darkTheme ==
                                                          true
                                                      ? AppColor.blackDark
                                                      : AppColor.neoBGWhite2),
                                              bedCareVM.isIntake
                                                  ? Colors.transparent
                                                  : (themeChange.darkTheme ==
                                                          true
                                                      ? AppColor.blackLight
                                                      : AppColor.neoBGWhite1),
                                            ])),
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(
                                        localization.getLocaleData.nonVeg.toString(),
                                        style: bedCareVM.isIntake
                                            ? MyTextTheme().mediumGCB
                                            : MyTextTheme()
                                                .mediumWCB
                                                .copyWith(
                                                    color: !bedCareVM.isIntake
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

                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: StaggeredGrid.extent(
                  maxCrossAxisExtent: 250,
                crossAxisSpacing: 2,
                mainAxisSpacing:2,
                  children: List.generate(4, (index) {
                    return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.grey.withOpacity(.4)),
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.black.withOpacity(.3),
                    ),
                      padding: EdgeInsets.all(4),
                      child: Column(children: [
                        Image.asset("assets/BedCareConnect/foodImage.png"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                    localization.getLocaleData.moongDalKhichdi.toString(),
                                style: MyTextTheme().smallBCB.copyWith(

                                    color: themeChange.darkTheme
                                        ? AppColor.white
                                        : AppColor.grey),
                              )),
                              PrimaryButton(
                                width: 80,
                                icon: Icon(
                                  Icons.add,
                                  color: AppColor.black,
                                ),
                                color: AppColor.darkgreen,
                                onPressed: () {},
                                title:localization.getLocaleData.add.toString(),
                                textStyle: MyTextTheme().mediumBCB,
                              )],),)])
                      ,);}),),),)],);});});}

  ebookWidget(ApplicationLocalizations localization) {
              return Consumer<BedCareConnectViewModal>(
               builder: (BuildContext context, bedCareVM, _) {
                 return Consumer<ThemeProviderLd>(
                 builder: (BuildContext context, themeChange, _) {
                  return TabResponsiveUtil.isTab(context)?
                    Padding(
                   padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                   child:
                      Column(
                   children: [
                       Row(
                  children: [
                   Expanded(
                     flex: 8,
                    child: Text(
                      localization.getLocaleData.ebook.toString(),
                      style: MyTextTheme().mediumBCN.copyWith(
                          fontSize: 22,
                          color: themeChange.darkTheme
                              ? AppColor.white
                              : AppColor.grey,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: PrimaryTextField(
                      backgroundColor: themeChange.darkTheme
                          ? AppColor.black12.withOpacity(.9)
                          : Colors.white,
                      // controller:feedbackVm.emailC ,
                      borderColor: themeChange.darkTheme
                          ? AppColor.black12.withOpacity(.9)
                          : Colors.white,
                      onChanged: (val) async {
                        setState(() {});
                      },
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColor.grey,
                        size: 25,
                      ),
                      hintText: localization.getLocaleData.search.toString(),
                      hintTextColor: themeChange.darkTheme == true
                          ? Colors.grey.shade400
                          : Colors.grey,
                      // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,

                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  Text(
                    localization.getLocaleData.filter.toString(),
                    style: MyTextTheme().mediumBCB.copyWith(
                        color: themeChange.darkTheme
                            ? AppColor.grey
                            : AppColor.black),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: CustomSD(
                        decoration: BoxDecoration(
                            color: themeChange.darkTheme
                                ? Colors.black12.withOpacity(0.3)
                                : AppColor.white),
                        listToSearch: [],
                        valFrom: "",
                        onChanged: (val) {}),
                  ),

                ],
              ),
              SizedBox(height: 10,),
              Expanded(
                child: SingleChildScrollView(
                  child: StaggeredGrid.extent(maxCrossAxisExtent: 350,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: [
                      ... List.generate(5, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      themeChange.darkTheme
                                          ? AppColor.darkshadowColor2
                                          : Colors.grey.shade400,
                                      themeChange.darkTheme
                                          ? AppColor.black
                                          : Colors.grey.shade100,
                                    ],
                                  ),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: themeChange.darkTheme
                                  //         ? Colors.black12.withOpacity(.2)
                                  //         : Colors.grey.shade400,
                                  //     offset: const Offset(
                                  //       1.0,
                                  //       1.0,
                                  //     ),
                                  //     spreadRadius: 12,
                                  //   ),
                                  // ]
                              ),

                              child: IntrinsicHeight(
                                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: AppColor.grey,
                                        borderRadius:
                                    BorderRadius.circular(8)),

                                    child:Image.asset("assets/BedCareConnect/atomic_habbit.png"),),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                    Column(
                                      children: [
                                        Text(localization.getLocaleData.atomic.toString(),style: MyTextTheme().mediumGCB.copyWith(color: themeChange.darkTheme?AppColor.white:AppColor.grey),),
                                        SizedBox(height: 5,),
                                        Text(localization.getLocaleData.atomic.toString(),style: MyTextTheme().mediumGCB.copyWith(color: themeChange.darkTheme?AppColor.grey:AppColor.grey),),
                                      ],
                                    ),

                                      PrimaryButton(width: 100,
                                          color: AppColor.darkgreen,
                                          onPressed: (){},
                                          title: localization.getLocaleData.read.toString())
                                    ],),


                                ],),
                              )

                          ),
                        );
                      })
                    ],
                  ),
                ),
              )

            ],

          ),
        ):
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              localization.getLocaleData.ebook.toString(),
                              style: MyTextTheme().mediumBCN.copyWith(
                                  fontSize: 16,
                                  color: themeChange.darkTheme
                                      ? AppColor.white
                                      : AppColor.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: PrimaryTextField(
                              backgroundColor: themeChange.darkTheme
                                  ? AppColor.black12.withOpacity(.9)
                                  : Colors.white,
                              // controller:feedbackVm.emailC ,
                              borderColor: themeChange.darkTheme
                                  ? AppColor.black12.withOpacity(.9)
                                  : Colors.white,
                              onChanged: (val) async {
                                setState(() {});
                              },
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: AppColor.grey,
                                size: 25,
                              ),
                              hintText:  localization.getLocaleData.search.toString(),
                              hintTextColor: themeChange.darkTheme == true
                                  ? Colors.grey.shade400
                                  : Colors.grey,
                              // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,

                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            localization.getLocaleData.filter.toString(),
                            style: MyTextTheme().mediumBCB.copyWith(
                                color: themeChange.darkTheme
                                    ? AppColor.grey
                                    : AppColor.black),
                          ),
                          SizedBox(),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            

                            child: CustomSD(

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                    color: themeChange.darkTheme
                                        ? Colors.black12.withOpacity(0.3)
                                        : AppColor.white),
                                listToSearch: [],
                                valFrom: "",
                                onChanged: (val) {}),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: StaggeredGrid.extent(maxCrossAxisExtent:150,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            children: [
                              ... List.generate(5, (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(

                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            themeChange.darkTheme
                                                ? AppColor.darkshadowColor2
                                                : Colors.grey.shade400,
                                            themeChange.darkTheme
                                                ? AppColor.black
                                                : Colors.grey.shade100,
                                          ],
                                        ),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: themeChange.darkTheme
                                        //         ? Colors.black12.withOpacity(.2)
                                        //         : Colors.grey.shade400,
                                        //     offset: const Offset(
                                        //       1.0,
                                        //       1.0,
                                        //     ),
                                        //     spreadRadius: 12,
                                        //   ),
                                        // ]
                                      ),

                                      child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: AppColor.grey,
                                                borderRadius:
                                                BorderRadius.circular(8)),

                                            child:Image.asset("assets/BedCareConnect/atomic_habbit.png"),
                                          ),
                                          SizedBox(width: 5,),
                                          SizedBox(height: 10,),
                                          Text( localization.getLocaleData.atomic.toString(),style: MyTextTheme().smallBCB.copyWith(color: themeChange.darkTheme?AppColor.white:AppColor.grey),),
                                          SizedBox(height: 5,),
                                          Text(localization.getLocaleData.atomic.toString(),style: MyTextTheme().smallBCB.copyWith(color: themeChange.darkTheme?AppColor.grey:AppColor.grey),),
                                          SizedBox(height: 5,),
                                          PrimaryButton(
                                            width: 100,
                                              color: AppColor.darkgreen,
                                              onPressed: (){},
                                              title: localization.getLocaleData.read.toString()),


                                        ],)

                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                      )

                    ],

                  );
      });
    });
  }

  videoChatWidget(ApplicationLocalizations localization) {
    return Consumer<BedCareConnectViewModal>(
        builder: (BuildContext context, bedCareVM, _) {
      return Consumer<ThemeProviderLd>(
          builder: (BuildContext context, themeChange, _) {
        return TabResponsiveUtil.isTab(context)?
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      localization.getLocaleData.videoCalling.toString(),
                      style: MyTextTheme().mediumBCN.copyWith(
                          fontSize: 22,
                          color: themeChange.darkTheme
                              ? AppColor.white
                              : AppColor.grey,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: PrimaryTextField(
                      backgroundColor: themeChange.darkTheme
                          ? AppColor.black12.withOpacity(.9)
                          : Colors.white,
                      // controller:feedbackVm.emailC ,
                      borderColor: themeChange.darkTheme
                          ? AppColor.black12.withOpacity(.9)
                          : Colors.white,
                      onChanged: (val) async {
                        setState(() {});
                      },
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColor.grey,
                        size: 25,
                      ),
                      hintText: localization.getLocaleData.search.toString(),
                      hintTextColor: themeChange.darkTheme == true
                          ? Colors.grey.shade400
                          : Colors.grey,

                      // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              StaggeredGrid.extent(
                maxCrossAxisExtent: 350,
                crossAxisSpacing: 2,
                children: [
                  ...List.generate(2, (index) {
                    // var data=bedCareVM.OttList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  themeChange.darkTheme == true
                                      ? AppColor.black12.withOpacity(.3)
                                      : AppColor.neoBGWhite2,
                                  themeChange.darkTheme == true
                                      ? AppColor.black12.withOpacity(.3)
                                      : AppColor.neoBGWhite2,
                                  themeChange.darkTheme == true
                                      ? AppColor.neoBGGrey2
                                      : AppColor.neoBGWhite1,
                                  themeChange.darkTheme == true
                                      ? AppColor.neoBGGrey2
                                      : AppColor.neoBGWhite1,
                                ]),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Container(
                            child:
                            Image.asset("assets/BedCareConnect/skype.png"),
                          ),
                        )
                      ]),
                    );
                  })
                ],
              )
            ],
          ),
        ):
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex:2,
                  child: Text(
                    localization.getLocaleData.videoCalling.toString(),
                    style: MyTextTheme().mediumBCN.copyWith(
                        fontSize: 16,
                        color: themeChange.darkTheme
                            ? AppColor.white
                            : AppColor.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: PrimaryTextField(
                    backgroundColor: themeChange.darkTheme
                        ? AppColor.black12.withOpacity(.9)
                        : Colors.white,
                    // controller:feedbackVm.emailC ,
                    borderColor: themeChange.darkTheme
                        ? AppColor.black12.withOpacity(.9)
                        : Colors.white,
                    onChanged: (val) async {
                      setState(() {});
                    },
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColor.grey,
                      size: 25,
                    ),
                    hintText: localization.getLocaleData.services.toString(),
                    hintTextColor: themeChange.darkTheme == true
                        ? Colors.grey.shade400
                        : Colors.grey,

                    // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
              Expanded(
              child: SingleChildScrollView(
                child: StaggeredGrid.extent(
                  maxCrossAxisExtent: 350,
                  crossAxisSpacing: 2,
                  children: [
                    ...List.generate(2, (index) {
                      // var data=bedCareVM.OttList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Container(

                            decoration: BoxDecoration(

                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    themeChange.darkTheme == true
                                        ? AppColor.black12.withOpacity(.3)
                                        : AppColor.neoBGWhite2,
                                    themeChange.darkTheme == true
                                        ? AppColor.black12.withOpacity(.3)
                                        : AppColor.neoBGWhite2,
                                    themeChange.darkTheme == true
                                        ? AppColor.neoBGGrey2
                                        : AppColor.neoBGWhite1,
                                    themeChange.darkTheme == true
                                        ? AppColor.neoBGGrey2
                                        : AppColor.neoBGWhite1,
                                  ]),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Container(
                              child:
                              Image.asset("assets/BedCareConnect/skype.png"),
                            ),
                          )
                        ]),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        );
      });
    });
  }

  bottomNavigationBar(context) {
    BedCareConnectViewModal bedCareVM =
        Provider.of<BedCareConnectViewModal>(context, listen: false);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    return TabResponsiveUtil.isTab(context)? isTabView():
    isEmulatorView();



  }

  isEmulatorView(){
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    return Consumer<BedCareConnectViewModal>(
      builder: (BuildContext context, bedCareVM, _){
        return Consumer<ThemeProviderLd>(
          builder: (BuildContext context, themeChange, _){
            return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StaggeredGrid.extent(maxCrossAxisExtent: 150,
                  children: [
                    ...List.generate(bedCareVM.bottomList.length, (index) {
                      var data = bedCareVM.bottomList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  InkWell(
                          onTap: () {
                            bedCareVM.updateSelectedIndex = index;
                          },
                          child:
                          bedCareVM.selectedBottomIndex==index?
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(

                              themeChange.darkTheme?Colors.grey:AppColor.white,
                              BlendMode.modulate,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(6.0),

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      themeChange.darkTheme
                                          ? AppColor.darkshadowColor2
                                          : Colors.grey.shade800,
                                      themeChange.darkTheme
                                          ? AppColor.black
                                          : Colors.grey.shade300,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeChange.darkTheme
                                          ? Colors.black12.withOpacity(.3)
                                          : Colors.grey.shade400,
                                      offset: const Offset(
                                        1.0,
                                        1.0,
                                      ),
                                      spreadRadius: 8,
                                    ),
                                  ]
                              ),
                              child:
                              ClipRRect(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        data["image"],
                                        height: 20,

                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        data["title"].toString(),
                                        style: MyTextTheme().smallBCB.copyWith(
                                            color: themeChange.darkTheme
                                                ? AppColor.grey
                                                : AppColor.black),
                                      )
                                    ],
                                  )),
                            ) ,
                          ):

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              padding: const EdgeInsets.all(6.0),


                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      themeChange.darkTheme
                                          ? AppColor.darkshadowColor2
                                          : Colors.grey.shade400,
                                      themeChange.darkTheme
                                          ? AppColor.black
                                          : Colors.grey.shade100,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeChange.darkTheme
                                          ? Colors.black12.withOpacity(.2)
                                          : Colors.grey.shade400,
                                      offset: const Offset(
                                        1.0,
                                        1.0,
                                      ),
                                      spreadRadius: 8,
                                    ),
                                  ]),
                              child:
                              ClipRRect(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        data["image"],
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        data["title"].toString(),
                                        style: MyTextTheme().smallBCB.copyWith(
                                            color: themeChange.darkTheme
                                                ? AppColor.grey
                                                : AppColor.black),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(width: 10,),


                  ],

                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child:




                  Row(children: [
                    Text(localization.getLocaleData.copyright.toString(),style: MyTextTheme().smallGCN.copyWith(fontWeight: FontWeight.w600),),
                    SizedBox(width: 5,),
                    Text(localization.getLocaleData.and.toString(),style: MyTextTheme().smallGCN.copyWith(color: AppColor.grey,fontWeight: FontWeight.w600
                    ),),
                    SizedBox(width: 5,),
                    Expanded(child: Text(localization.getLocaleData.privacyPolicy.toString(),style: MyTextTheme().smallGCN.copyWith(fontWeight: FontWeight.w600),)),
                    Text(localization.getLocaleData.criterionTech.toString(),style: MyTextTheme().smallGCN.copyWith(fontWeight: FontWeight.w600),),

                  ],),
                )
              ],
            );
          });


    }

    );
  }
  isTabView(){
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    return  Consumer<BedCareConnectViewModal>(
      builder: (BuildContext context, bedCareVM, _){
        return Consumer<ThemeProviderLd>(
            builder: (BuildContext context, themeChange, _){
              return   Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    ...List.generate(bedCareVM.bottomList.length, (index) {
                      var data = bedCareVM.bottomList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            bedCareVM.updateSelectedIndex = index;
                          },
                          child:
                          bedCareVM.selectedBottomIndex==index?
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(

                              themeChange.darkTheme?Colors.grey:AppColor.white,
                              BlendMode.modulate
                              ,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(6.0),

                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(60),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      themeChange.darkTheme
                                          ? AppColor.darkshadowColor2
                                          : Colors.grey.shade800,
                                      themeChange.darkTheme
                                          ? AppColor.black
                                          : Colors.grey.shade300,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeChange.darkTheme
                                          ? Colors.black12.withOpacity(.3)
                                          : Colors.grey.shade400,
                                      offset: const Offset(
                                        1.0,
                                        1.0,
                                      ),
                                      spreadRadius: 12,
                                    ),
                                  ]
                              ),
                              child:
                              ClipRRect(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        data["image"],
                                        height: 40,

                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        data["title"].toString(),
                                        style: MyTextTheme().smallBCB.copyWith(
                                            color: themeChange.darkTheme
                                                ? AppColor.grey
                                                : AppColor.black),
                                      )
                                    ],
                                  )),
                            ) ,
                          ):

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      themeChange.darkTheme
                                          ? AppColor.darkshadowColor2
                                          : Colors.grey.shade400,
                                      themeChange.darkTheme
                                          ? AppColor.black
                                          : Colors.grey.shade100,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeChange.darkTheme
                                          ? Colors.black12.withOpacity(.2)
                                          : Colors.grey.shade400,
                                      offset: const Offset(
                                        1.0,
                                        1.0,
                                      ),
                                      spreadRadius: 12,
                                    ),
                                  ]),
                              child:
                              ClipRRect(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        data["image"],
                                        height: 40,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        data["title"].toString(),
                                        style: MyTextTheme().smallBCB.copyWith(
                                            color: themeChange.darkTheme
                                                ? AppColor.grey
                                                : AppColor.black),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      );
                    }),
                    Expanded(child: SizedBox()),
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              themeChange.darkTheme
                                  ? AppColor.darkshadowColor2
                                  : Colors.grey.shade400,
                              themeChange.darkTheme ? AppColor.black : Colors.grey.shade100,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeChange.darkTheme
                                  ? Colors.black12.withOpacity(.2)
                                  : Colors.grey.shade400,
                              offset: const Offset(
                                1.0,
                                1.0,
                              ),
                              spreadRadius: 12,
                            ),
                          ]),
                      padding: EdgeInsets.all(12),
                      child: ClipRRect(
                          child: Column(
                            children: [
                              Image.asset(
                                ImagePaths.bperson,
                                height: 40,
                              )
                            ],
                          )),
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(children: [
                      Text(localization.getLocaleData.copyright.toString(),style: MyTextTheme().mediumGCB,),
                      SizedBox(width: 5,),
                      Text(localization.getLocaleData.and.toString(),style: MyTextTheme().mediumGCB.copyWith(color: AppColor.grey),),
                      SizedBox(width: 5,),
                      Expanded(child: Text(localization.getLocaleData.privacyPolicy.toString(),style: MyTextTheme().mediumGCB,)),
                      Text(localization.getLocaleData.criterionTech.toString(),style: MyTextTheme().mediumGCB,),

                    ],),
                  )
                ],
              );
            });
      });


  }



}
