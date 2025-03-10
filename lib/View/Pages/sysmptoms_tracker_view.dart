

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/ViewModal/symptoms_tracker_view_modal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/neomorphic/neomorphic.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:get/get.dart';
import '../../app_manager/bottomSheet/bottom_sheet.dart';
import '../../app_manager/bottomSheet/functional_sheet.dart';
import '../../app_manager/comman_widget.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../common_libs.dart';

class SymptomTrackerView extends StatefulWidget {
  const SymptomTrackerView({super.key});

  @override
  State<SymptomTrackerView> createState() => _SymptomTrackerViewState();
}

class _SymptomTrackerViewState extends State<SymptomTrackerView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      get();
    });
  }

  get() async {
    SymptomsTrackerViewModal symptomtrackerVM =
        Provider.of<SymptomsTrackerViewModal>(context, listen: false);
    symptomtrackerVM.updateCurrentIndex=0;

      await symptomtrackerVM.getHomeCareSymtoms(context);

  }

  @override
  Widget build(BuildContext context) {


    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    SymptomsTrackerViewModal symptomtrackerVM =
        Provider.of<SymptomsTrackerViewModal>(context, listen: true);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    return ColoredSafeArea(
      child: SafeArea(
          child: Scaffold(
         //   appBar: AppBar(title: Text(localization.getLocaleData.updateSymptoms.toString()),backgroundColor: AppColor.primaryColor,),
    
         body: Container(
           padding: const EdgeInsets.all(20),
           decoration: BoxDecoration(
               gradient: LinearGradient(
                   begin: Alignment.bottomCenter,
                   end: Alignment.topCenter,
                   colors: [
                     themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                     themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                     themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                     themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                     themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                   ]
               )
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Container(
              //   color:AppColor.secondaryColor ,
              //   child: IntrinsicHeight(
              //     child: Row(
              //       children: [
              //         Expanded(flex: 6,
              //             child: Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text('Symptoms'.toString(),style: MyTextTheme.mediumWCB,),
              //             )),
              //         Container(
              //           color: Colors.white,
              //           width: 1,
              //         ),
              //
              //         Expanded(flex: 5,
              //             child: Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Center(child: Text('Entry Time',style: MyTextTheme.mediumWCB,)),
              //             )),
              //       ],
              //     ),
              //   ),
              // ),
              // Expanded(
              //   child: Column(
              //     children: List.generate(symptomtrackerVM.getSymptomHistory.length, (index) => Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Row(
              //         children: [
              //           Expanded(flex: 6,
              //               child: Text(symptomtrackerVM.getSymptomHistory[index]['details'].toString(),style: MyTextTheme.mediumBCN,),),
              //           SizedBox(width: 10,),
              //           Expanded(flex: 5,
              //               child: Text(DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(symptomtrackerVM.getSymptomHistory[index]['detailsDate'])).toString(),style: MyTextTheme.mediumBCN,),),
              //         ],
              //       ),
              //     ))
              //   ),
              // ),


              Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                       Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back_ios,color: themeChange.darkTheme? AppColor.white:Colors.grey,)
                      // Image.asset(themeChange.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40),
                    ),
                  ),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localization.getLocaleData.update.toString()+' '+localization.getLocaleData.symptoms.toString(),
                          style: MyTextTheme.largeGCB.copyWith(
                              height: 0,color: themeChange.darkTheme?AppColor.white:null)),
                      // Text('${localization.getLocaleData.symptoms}',style:MyTextTheme.largeBCB.copyWith(fontSize: 25,
                      //     height: 0,color: themeChange.darkTheme==true?Colors.white:Colors.black),),
                    ],
                  ),),

                  // Icon(Icons.more_vert_sharp,color: themeChange.darkTheme? AppColor.white:Colors.grey,)



                ],),
              const SizedBox(
                height: 10,
              ),
              Image.asset(themeChange.darkTheme?"assets/darkm_patient/update_symptoms.png":
                'assets/lightm_patient/update_symptoms.png',fit:BoxFit.fitHeight,height:210 ,),
               Expanded(child: SizedBox()),

              // if (symptomtrackerVM.getSymptomHistory.isEmpty) Expanded(child:
              // Center(child: Text(localization.getLocaleData.noDataFound.toString()))) else
              CommonWidgets().showNoData(
                title:localization.getLocaleData.noDataFound.toString(),
                show: (symptomtrackerVM.getShowNoData &&
                    symptomtrackerVM.getSymptomHistory
                        .isEmpty),
                loaderTitle: localization.getLocaleData.Loading.toString(),
                showLoader: (!symptomtrackerVM.getShowNoData  &&
                    symptomtrackerVM.getSymptomHistory
                        .isEmpty),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: symptomtrackerVM.getSymptomHistory
                        .isEmpty
                        ? 0
                        : 1,
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      var problem = symptomtrackerVM.getSymptomHistory[symptomtrackerVM.getCurrentIndex];
                      return Container(
                        width: MediaQuery.of(
                            context)
                            .size
                            .width,
                        padding:
                        const EdgeInsets
                            .all(10),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                          // border: Border.all(color: themeChange.darkTheme==true?Colors.grey.shade800:Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:  localization.getLocaleData.doYouStillHave.toString()+' ',
                                        style:  MyTextTheme
                                            .largeBCN
                                            .copyWith(fontSize: 35, color:  themeChange.darkTheme? AppColor.white:Colors.black87.withOpacity(.7)),
                                      ),
                                      TextSpan(
                                        text:  problem['details'].toString()+"?",
                                        style:  MyTextTheme
                                            .largeBCN
                                            .copyWith(fontSize: 35,color: Colors.green,height: .9 ),
                                      ),
                                    ])),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child:
                                    InkWell(
                                      onTap: () async {
                                        symptomtrackerVM.onPressedYesNo('0');
                                        if(symptomtrackerVM.getSymptomHistory
                                            .length !=
                                            (symptomtrackerVM.getCurrentIndex +
                                                1)){
                                          await symptomtrackerVM.onPressedNext();
                                        }
                                        if(symptomtrackerVM.getSymptomHistory
                                            .length ==
                                            (symptomtrackerVM.getCurrentIndex +
                                                1)){
                                          // symptomUpdate(context);
                                        }
                                        // modal.controller
                                        //     .updateSelectedYesOrNo =
                                        //     localization.getLocaleData.no.toString();
                                        // modal.controller.updateSelectedData(
                                        //     modal
                                        //         .controller
                                        //         .getCurrentIndex,
                                        //     true);
                                      },
                                      child:
                                      Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal:
                                            5,
                                            vertical:
                                            10),
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              5),
                                          color: AppColor
                                              .grey,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [

                                            Text(localization.getLocaleData.no.toString(),
                                              textAlign:   TextAlign.center,
                                              style:
                                              MyTextTheme.mediumWCB,
                                            ),
                                            Visibility(
                                              visible:problem['isSymptom'] == '0',
                                              child:
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.check_circle_rounded,
                                                    color: AppColor.primaryColor,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child:
                                    InkWell(
                                      onTap: () async {

                                        symptomtrackerVM.onPressedYesNo('1');
                                        if(symptomtrackerVM.getSymptomHistory
                                            .length !=
                                            (symptomtrackerVM.getCurrentIndex +
                                                1)){
                                          await symptomtrackerVM.onPressedNext();

                                        }
                                        if(symptomtrackerVM.getSymptomHistory
                                            .length ==
                                            (symptomtrackerVM.getCurrentIndex +
                                                1)){
                                          // symptomUpdate(context);
                                        }
                                        // modal.controller
                                        //     .updateSelectedYesOrNo =
                                        //     localization.getLocaleData.yes.toString();
                                        // modal.controller.updateSelectedData(
                                        //     modal
                                        //         .controller
                                        //         .getCurrentIndex,
                                        //     false);
                                      },
                                      child:
                                      Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal:
                                            5,
                                            vertical:
                                            10),
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              5),
                                          color: AppColor
                                              .neoGreen,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Text(localization.getLocaleData.yes.toString(),
                                              textAlign:
                                              TextAlign.center,
                                              style:
                                              MyTextTheme.mediumWCB,
                                            ),
                                            Visibility(
                                              visible: problem['isSymptom'] == '1',
                                              child:
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.check_circle_rounded,
                                                    color: AppColor.primaryColor,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),

                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ),



              Container(
                                  height: 10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(width: 150,
                                        child: ListView.builder(
                                                          scrollDirection: Axis.horizontal,
                                                          itemCount:  symptomtrackerVM.getSymptomHistory.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            int indexs=symptomtrackerVM.getSymptomHistory.length;
                                                            return Column(
                                                              children: [

                                                                Padding(
                                                                  padding: const EdgeInsets.all(3),
                                                                  child: Container(
                                                                    height: 3,width: 15,
                                                                    color: symptomtrackerVM.getCurrentIndex==index?Colors.green:Colors.grey,

                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },),
                                      ),
                                    ],
                                  ),
                                ),


              SizedBox(
                height: 35,
              ),
              Visibility(
                visible: symptomtrackerVM.getSymptomHistory.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      symptomtrackerVM.getCurrentIndex ==
                          0
                          ? const SizedBox()
                          :   Expanded(
                          child: NeoButton(
                            title: localization.getLocaleData.previous.toString(),
                            func: () async {
                              await symptomtrackerVM.onPressedPrevious();
                              },
                          )
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      symptomtrackerVM.getSymptomHistory
                          .length ==
                          (symptomtrackerVM.getCurrentIndex +
                              1)
                          ? Expanded(
                            child: NeoButton(
                                                    title: localization.getLocaleData.submit.toString(),
                                                    func: () async {
                            await CustomBottomSheet.open(context,
                                child: FunctionalSheet(
                                  message: localization.getLocaleData.areYouSureYouWantToSubmit.toString(),
                                  buttonName: localization.getLocaleData.confirm.toString(),
                                  onPressButton: () async {
                                  await  symptomtrackerVM.updateProblem(
                                        context);
                                  },
                                  cancelBtn: localization.getLocaleData.cancel.toString(),
                                ));
                                                    },

                                                  ),
                          )
                          :   SizedBox(
                      )
                          // : Expanded(
                          // child:  NeoButton(
                          //   title: localization.getLocaleData.next.toString(),
                          //   func: () async {
                          //     await symptomtrackerVM.onPressedNext();
                          //   },
                          // ))
                    ],
                  ),
                ),
              ),

            ],
                   ),
         ),
      )),
    );
  }
  symptomUpdate(context) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    SymptomsTrackerViewModal symptomtrackerVM =
    Provider.of<SymptomsTrackerViewModal>(context, listen: false);
    // MasterDashboardViewModal masterDashboardViewModal =
    // Provider.of<MasterDashboardViewModal>(context, listen: false);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    await CustomBottomSheet.open(context,

        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                    themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite2,
                    themeChange.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                    themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                    themeChange.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite1,
                  ]
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Text(""),
                    ),

                    InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.close,size: 30,color: Colors.grey,),
                      ),
                    )
                  ],
                ),
                Image.asset(themeChange.darkTheme?"assets/darkm_patient/symptom_update.png":
                "assets/lightm_patient/symptom_update.png",height: 30,
                ),
                SizedBox(height: 5,),
                Text("Symptoms Updated Successfully!",
                style: MyTextTheme.mediumGCN.copyWith(
                  color: themeChange.darkTheme?AppColor.green12:AppColor.black.withOpacity(0.8),
                  fontWeight: FontWeight.w600
                ),),
                SizedBox(height: 10,),
                Container(
                    height: 1,
                    color: Colors.grey,
                    child: Row()),
                NeoButton(
                  title: "Done",
                  textStyle: TextStyle(color: themeChange.darkTheme?Colors.white:AppColor.black,fontSize: 15),
                  func: () async {  Get.back();
                    await CustomBottomSheet.open(context,
                        child: FunctionalSheet(
                          message: localization.getLocaleData.areYouSureYouWantToSubmit.toString(),
                          buttonName: localization.getLocaleData.confirm.toString(),
                          onPressButton: () async {
                         await   symptomtrackerVM.updateProblem(
                                context);
                          },
                          cancelBtn: localization.getLocaleData.cancel.toString(),
                        ));
                    // await symptomtrackerVM.onPressedPrevious();
                  },
                )
              ],
            ),
          ),
        ));
  }
}
