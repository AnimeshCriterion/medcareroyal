import 'package:flutter/cupertino.dart';
import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/assets.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/theme/theme.dart';
import '../../../app_manager/widgets/coloured_safe_area.dart';

class LifeStyleInterventions extends StatefulWidget {
  const LifeStyleInterventions({super.key});

  @override
  State<LifeStyleInterventions> createState() => _LifeStyleInterventionsState();
}

class _LifeStyleInterventionsState extends State<LifeStyleInterventions> {

  String cache = "Balanced Diet";


  bool isExercise = false;


  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isExercise = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    List balancedDietP = [
      "${localization.getLocaleData.eatingAHealthy}\n",
    localization.getLocaleData.thisMeansEating.toString(),
    ];

    List eatingPlate = [
      "${localization.getLocaleData.useHealthyOils}\n",
      "${localization.getLocaleData.theMoreVeggies}\n",
      "${localization.getLocaleData.eatPlenty}\n"
    ];

    List childrenAdolescents = [
      "${localization.getLocaleData.shouldDoAtLeast}\n  ",
      "${localization.getLocaleData.shouldIncorporateVigorous}\n  ",
      localization.getLocaleData.shouldLimit.toString()
    ];

    List adultsAged = [
      "${localization.getLocaleData.shouldAlsoDoMuscle}\n  ",
      "${localization.getLocaleData.mayIncreaseModerate}\n  "
    ];


    final themeProvider = Provider.of<ThemeProviderLd>(context, listen: true);
    return ColoredSafeArea(
      child: Scaffold(key: scaffoldKey,
        drawer: MyDrawer(),
        // backgroundColor: Colors.white,
        // appBar:  CustomAppBar(
        //     primaryBackColor: Colors.white,
        //     titleColor: Colors.white,
        //     title: localization.getLocaleData.lifestyleInterventions.toString(),
        //     color: const Color.fromRGBO(0, 23, 103, 1)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container( decoration: BoxDecoration(

              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    themeProvider.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                    themeProvider.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                    themeProvider.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                    themeProvider.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                    themeProvider.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                  ]
              )
          ),
            child: Column(
              children: [

                SizedBox(height: 10,),
                Row(crossAxisAlignment: CrossAxisAlignment.start,
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
                        onTap: (){
                          scaffoldKey.currentState!.openDrawer();
                        },
                        child: Image.asset(themeChange.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40)),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localization.getLocaleData.lifestyleInterventions.toString(),
                          style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 0,color: themeChange.darkTheme==true?Colors.white70:null),),
                       ],
                    ),
                  ],
                ),
                SizedBox(height: 15,),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          themeChange.darkTheme==true?AppColor.blackLight:AppColor.neoBGWhite1,
                          themeChange.darkTheme==true?AppColor.blackDark:AppColor.neoBGWhite2,
                        ]
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isExercise = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                  !isExercise ? Colors.grey : AppColor.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(color:  !isExercise ?Colors.transparent:AppColor.neoGreen,blurRadius: 2,offset: const Offset(-4,0)),
                                    BoxShadow(color:  !isExercise ?Colors.transparent:AppColor.neoGreen,blurRadius: 2,offset: const Offset(4,0)),
                                  ],
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        !isExercise ? Colors.transparent:(themeChange.darkTheme==true?AppColor.blackDark:AppColor.neoBGWhite2),
                                        !isExercise ? Colors.transparent:(themeChange.darkTheme==true?AppColor.blackLight:AppColor.neoBGWhite1),
                                      ]
                                  )),
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(localization.getLocaleData.dietaryAdvice.toString(),
                                  style: !isExercise
                                      ? MyTextTheme.smallGCB
                                      : MyTextTheme.smallWCB.copyWith(color:   isExercise ? AppColor.neoGreen:Colors.grey),
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
                                isExercise = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                  isExercise ? Colors.grey : AppColor.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [

                                    BoxShadow(color:  isExercise ?Colors.transparent:AppColor.neoGreen,blurRadius: 2,offset: const Offset(-4,0)),
                                    BoxShadow(color:  isExercise ?Colors.transparent:AppColor.neoGreen,blurRadius: 2,offset: const Offset(4,0)),

                                  ],
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        isExercise ? Colors.transparent:(themeChange.darkTheme==true?AppColor.blackDark:AppColor.neoBGWhite2),
                                        isExercise ? Colors.transparent:(themeChange.darkTheme==true?AppColor.blackLight:AppColor.neoBGWhite1),

                                      ]
                                  )),
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(localization.getLocaleData.exercisesGuidelines.toString(),
                                  style: isExercise
                                      ? MyTextTheme.smallGCB
                                      : MyTextTheme.smallWCB.copyWith(color:   !isExercise ? AppColor.neoGreen:Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [



                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: InkWell(
                          //         onTap: () {
                          //           setState(() {
                          //             cache = "Balanced Diet";
                          //           });
                          //         },
                          //         child: Container(
                          //           decoration: BoxDecoration(
                          //             color: cache == "Balanced Diet"
                          //                 ? Colors.orange.shade300
                          //                 :themeProvider.darkTheme?  Colors.white:Colors.grey.shade300,
                          //           ),
                          //           child: Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //                 vertical: 12.0, horizontal: 20),
                          //             child: Text(localization.getLocaleData.balancedDiet.toString(),
                          //                 textAlign: TextAlign.center,
                          //                 style: cache == "Balanced Diet"
                          //                     ? MyTextTheme.mediumWCB
                          //                     : MyTextTheme.mediumBCB),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: InkWell(
                          //         onTap: () {
                          //           setState(() {
                          //             cache = "ExerciseGuidelines";
                          //           });
                          //         },
                          //         child: Container(
                          //           decoration: BoxDecoration(
                          //             color: cache == "ExerciseGuidelines"
                          //                 ? const Color.fromRGBO(0, 23, 103, 0.9)
                          //                 : Colors.grey.shade300,
                          //           ),
                          //           child: Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //                 vertical: 12.0, horizontal: 20),
                          //             child: Text(localization.getLocaleData.exercisesGuidelines.toString(),
                          //                 textAlign: TextAlign.center,
                          //                 style: cache == "ExerciseGuidelines"
                          //                     ? MyTextTheme.mediumWCN
                          //                     : MyTextTheme.mediumBCN),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          isExercise ?
                          Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "assets/addVitalsMachine/healthyFoodChart.png",
                                          height: 230,
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      localization.getLocaleData.eatingBalancedDiet.toString(),
                                      style:themeProvider.darkTheme?   MyTextTheme.largeWCB:MyTextTheme.largeBCB,
                                    ),
                                    Text(
                                      balancedDietP[0],
                                      style:themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN,
                                    ),
                                    Text(
                                      balancedDietP[1],
                                      style:themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      localization.getLocaleData.healthyEatingPlate.toString(),
                                      style:themeProvider.darkTheme?   MyTextTheme.largeWCB: MyTextTheme.largeBCB,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: Text(eatingPlate[0].toString(),style:
                                        themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN,),),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Expanded(child: Text(eatingPlate[0].toString(),style:
                                        themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN)),
                                      ],
                                    ),
                                    Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          children: [
                                            Text(eatingPlate[1].toString(),style:
                                            themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN),
                                            Text(eatingPlate[2].toString(),style:
                                            themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN),
                                          ],
                                        )),
                                        Image.asset(
                                            "assets/addVitalsMachine/eating_plate.png",
                                            scale: 3),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(eatingPlate[1].toString(),style: themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN),
                                              Text(eatingPlate[2].toString(),style: themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "assets/addVitalsMachine/exercise_guidelines.png",
                                          height: 230,
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      localization.getLocaleData.childrenAndAdolescentsAged.toString(),
                                      style: themeProvider.darkTheme?   MyTextTheme.largeWCB: MyTextTheme.largeBCB,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 8.0, right: 10),
                                          child: Icon(
                                            Icons.circle,
                                            size: 6,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          childrenAdolescents[0],
                                          style:  themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN,
                                        )),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 8.0, right: 10),
                                          child: Icon(
                                            Icons.circle,
                                            size: 6,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          childrenAdolescents[1],
                                          style: themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN,
                                        )),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 8.0, right: 10),
                                          child: Icon(
                                            Icons.circle,
                                            size: 6,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          childrenAdolescents[2],
                                          style:themeProvider.darkTheme?   MyTextTheme.smallWCN: MyTextTheme.smallBCN,
                                        )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      localization.getLocaleData.AdultsAgedYears.toString(),
                                      style: themeProvider.darkTheme? MyTextTheme.largeWCB: MyTextTheme.largeBCB,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 8.0, right: 10),
                                          child: Icon(
                                            Icons.circle,
                                            size: 6,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          adultsAged[0],
                                          style: themeProvider.darkTheme? MyTextTheme.smallWCN: MyTextTheme.smallBCN,
                                        )),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 8.0, right: 10),
                                          child: Icon(
                                            Icons.circle,
                                            size: 6,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          adultsAged[1],
                                          style: themeProvider.darkTheme? MyTextTheme.smallWCN: MyTextTheme.smallBCN,
                                        )),
                                      ],
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
