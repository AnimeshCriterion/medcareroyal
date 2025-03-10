import 'package:flutter/cupertino.dart';
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:flutter/widgets.dart';
import 'package:medvantage_patient/View/Pages/urin_output.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../medcare_utill.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/bottom_sheet.dart';
import 'package:medvantage_patient/app_manager/neomorphic/neomorphic.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import '../../Localization/app_localization.dart';
import '../../Modal/ManualFoodAssignDataModal.dart';
import '../../app_manager/alert_toast.dart';
import '../../assets.dart';
import '../../theme/theme.dart';
import '../../app_manager/neomorphic/hex.dart';
import '../../assets.dart';
import 'add_new_drink.dart';
import 'menu_intake_widget.dart';
import '../../app_manager/bottomSheet/functional_sheet.dart';
import '../../app_manager/navigator.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../common_libs.dart';
import '../../ViewModal/addvital_view_modal.dart';

class SliderVerticalWidget extends StatefulWidget {
  final throughVoice;
  const SliderVerticalWidget({super.key, this.throughVoice});

  @override
  _SliderVerticalWidgetState createState() => _SliderVerticalWidgetState();
}

List fluidIntakeList = [
  {'name': 'water', "foodID": 97694, 'color': Colors.blue[100], 'isBig': true},
  {'name': 'Milk', "foodID": 76, 'color': Colors.white, 'isBig': true},
  // {'name': 'Green tea', "foodID": 112533, 'color': Colors.green.shade200, 'isBig': false},
  {'name': 'Coffee', "foodID": 168, 'color': Colors.brown.shade500, 'isBig': false},
  {'name': 'Fruit Juice', "foodID": 66, 'color': Colors.orangeAccent, 'isBig': true},
];

class _SliderVerticalWidgetState extends State<SliderVerticalWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      get();
    });
  }

  get() async {
    AddVitalViewModal addvitalVM = Provider.of<AddVitalViewModal>(context, listen: false);

    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    addvitalVM.fluidC.text = addvitalVM.getQtyValue.toString();
    await addvitalVM.clearData();

    addvitalVM.updateQtyValue = 100;

    addvitalVM.fluidC.text = '100';
    addvitalVM.urineC.text = '50';
    addvitalVM.notifyListeners();
    await addvitalVM.manualFoodAssign(context);
    await addvitalVM.urinHistory(context);
    if (widget.throughVoice == true) {
      if (addvitalVM.fluidAdded > 100.0) {
        addvitalVM.updateQtyValue = 100;
      } else {
        addvitalVM.updateQtyValue = addvitalVM.fluidAdded;
      }
      addvitalVM.fluidC.text = addvitalVM.fluidAdded.toString();

      dPrint('setp1');

      int index = addvitalVM.getManualFoodList.indexWhere((item) => item.foodName?.toLowerCase() == addvitalVM.valueFromVoice.toLowerCase());
      dPrint('setp3');

      addvitalVM.updateSelectedFoodID = addvitalVM.getManualFoodList[index].foodID.toString();
      dPrint('setp4');
      await CustomBottomSheet.open(context,
          child: FunctionalSheet(
            message: localization.getLocaleData.areYouSureYouWantTo.toString() + ' ${addvitalVM.valueFromVoice} (${addvitalVM.fluidAdded.toString()} ml)?',
            buttonName: localization.getLocaleData.confirm.toString(),
            onPressButton: () async {
              //  Get.back();
              await addvitalVM.fluidIntake(context);
            },
          ));
    }
    // int index=  addvitalVM.getManualFoodList.indexWhere((item) => item.foodName == addvitalVM.valueFromVoice.toLowerCase());
    // addvitalVM.getManualFoodList[index];
    // themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();
    if(addvitalVM.valueFromVoice.toLowerCase()=='water'){
      addvitalVM.updateIndex=0;
    }else if(addvitalVM.valueFromVoice.toLowerCase()=='milk'){
      addvitalVM.updateIndex=1;
    } else if(addvitalVM.valueFromVoice.toLowerCase()=='green tea'){
      addvitalVM.updateIndex=2;
    }else if(addvitalVM.valueFromVoice.toLowerCase()=='coffee'){
      addvitalVM.updateIndex=3;
    }else if(addvitalVM.valueFromVoice.toLowerCase()=='fruit juice'){
      addvitalVM.updateIndex=4;
    }
  }

  bool isIntake = true;
  bool isIntakePage = true;
  bool isOutput = false;
  double value = 75;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _editTitleTextField() {
    ThemeProviderLd themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    AddVitalViewModal addvitalVM = Provider.of<AddVitalViewModal>(context, listen: true);
    if (addvitalVM.isEditingText) {
      return Center(
        child: SizedBox(
          width: 100,
          child: TextField(
              style: MyTextTheme.mediumBCB.copyWith(fontSize: 20, color: themeChange.darkTheme ? Colors.white : null),
              onSubmitted: (newValue) {
                setState(() {
                  addvitalVM.urineC.text = newValue.toString();
                  addvitalVM.isEditingText = false;
                });
              },
              autofocus: true,
              controller: addvitalVM.urineC,
              onTapOutside: (PointerDownEvent) {
                addvitalVM.isEditingText = false;
                addvitalVM.notifyListeners();
              }),
        ),
      );
    }
    return InkWell(
        onTap: () {
          setState(() {
            addvitalVM.isEditingText = true;
          });
        },
        child: Text(
          addvitalVM.urineC.value.text.toString(),
          style: MyTextTheme.mediumBCB.copyWith(fontSize: 50, color: themeChange.darkTheme ? Colors.white : null),
        ));
  }

  @override
  Widget build(BuildContext context) {
    ThemeProviderLd themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: true);
    var local = localization.getLocaleData;
    AddVitalViewModal addvitalVM = Provider.of<AddVitalViewModal>(context, listen: true);
    ManualFoodAssignDataModal data1 = ManualFoodAssignDataModal();

    if (addvitalVM.getInt == 0) {
      data1 = addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[1];
    } else if (addvitalVM.getInt == 1) {
      data1 = addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[0];
    } else if (addvitalVM.getInt == 2) {
      data1 = addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[2];
    } else if (addvitalVM.getInt == 3) {
      data1 = addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[3];
    } else if (addvitalVM.getInt == 4) {
      data1 = addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[4];
    }

    return ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          drawer: MyDrawer(),
          // appBar: CustomAppBar(
          //   titleColor: AppColor.white,
          //   color: AppColor.primaryColor,
          //   primaryBackColor: AppColor.white,
          //   title: localization.getLocaleData.intakeOutput.toString(),
          //   actions: [
          //     InkWell(
          //       onTap: () {
          //         changeQtyAlert();
          //       },
          //       child: Padding(
          //         padding: const EdgeInsets.only(right: 15),
          //         child: Icon(Icons.settings,color: AppColor.white,),
          //       ),
          //     )
          //   ],
          // ),
          body: Container(
            height: Get.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                themeChange.darkTheme == true ? AppColor.bgDark : AppColor.bgWhite,
                themeChange.darkTheme == true ? AppColor.bgDark : AppColor.bgWhite,
                themeChange.darkTheme == true ? AppColor.bgDark : AppColor.bgWhite,
              ]),
              color: AppColor.bgDark,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: Image.asset(themeChange.darkTheme == true ? ImagePaths.menuDark : ImagePaths.menulight, height: 40)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.getLocaleData.fluidManagement.toString(),
                              style: MyTextTheme.largeGCB.copyWith(fontSize: 21, height: 0, color: themeChange.darkTheme == true ? Colors.white70 : null),
                            ),
                          ],
                        ),
                      ),
                      // Switch(
                      //     activeColor: AppColor.neoGreen,
                      //     value: isIntakePage,
                      //     onChanged: (val) async {
                      //       setState(() {});
                      //       isIntakePage = val;
                      //       isIntake = true;
                      //     })
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        themeChange.darkTheme == true ? AppColor.blackLight : AppColor.neoBGWhite1,
                        themeChange.darkTheme == true ? AppColor.blackDark : AppColor.neoBGWhite2,
                      ]),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isIntake = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: !isIntake ? Colors.grey : AppColor.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(color: !isIntake ? Colors.transparent : AppColor.neoGreen, blurRadius: 2, offset: const Offset(-4, 0)),
                                  BoxShadow(color: !isIntake ? Colors.transparent : AppColor.neoGreen, blurRadius: 2, offset: const Offset(4, 0)),
                                ],
                                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                  !isIntake ? Colors.transparent : (themeChange.darkTheme == true ? AppColor.blackDark : AppColor.neoBGWhite2),
                                  !isIntake ? Colors.transparent : (themeChange.darkTheme == true ? AppColor.blackLight : AppColor.neoBGWhite1),
                                ])),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                localization.getLocaleData.flIntake.toString(),
                                style: !isIntake ? MyTextTheme.mediumGCB : MyTextTheme.mediumWCB.copyWith(color: isIntake ? AppColor.neoGreen : Colors.grey),
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
                              isIntake = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: isIntake ? Colors.grey : AppColor.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(color: isIntake ? Colors.transparent : AppColor.neoGreen, blurRadius: 2, offset: const Offset(-4, 0)),
                                  BoxShadow(color: isIntake ? Colors.transparent : AppColor.neoGreen, blurRadius: 2, offset: const Offset(4, 0)),
                                ],
                                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                  isIntake ? Colors.transparent : (themeChange.darkTheme == true ? AppColor.blackDark : AppColor.neoBGWhite2),
                                  isIntake ? Colors.transparent : (themeChange.darkTheme == true ? AppColor.blackLight : AppColor.neoBGWhite1),
                                ])),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                local.urineOutput.toString(),
                                style: isIntake ? MyTextTheme.mediumGCB : MyTextTheme.mediumWCB.copyWith(color: !isIntake ? AppColor.neoGreen : Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
          isIntake?
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 800,
                        thumbShape: SliderComponentShape.noOverlay,
                        overlayShape: SliderComponentShape.noOverlay,
                        valueIndicatorShape: SliderComponentShape.noOverlay,
                        trackShape: const RectangularSliderTrackShape(),
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                      ),
                      child: Column(
                        children: [

                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(localization.getLocaleData.addFluidIntake.toString(),
                                              style: MyTextTheme.mediumBCB.copyWith(color:  themeChange.darkTheme==true?Colors.white:Colors.black87))),
                                      Expanded(
                                        child: NeoButton(
                                          title: localization.getLocaleData.fluidIntakeHistory.toString(),
                                          width: 210,
                                          func: () {
                                            MyNavigator.push(context, const AddNewDrink());
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: RawScrollbar(
                                    trackColor: AppColor.grey,
                                    thumbVisibility: true,
                                    interactive: true,
                                    radius: const Radius.circular(10),
                                    thickness: 5,
                                    trackVisibility: true,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                // SizedBox(
                                                //   height: 400,
                                                //   child: Stack(
                                                //     children: [
                                                //       Center(
                                                //         child:
                                                //         LiquidCustomProgressIndicator(
                                                //           value: double.parse(addvitalVM
                                                //               .getQtyValue
                                                //               .toStringAsFixed(0)) /
                                                //               addvitalVM.maxvalue,
                                                //           valueColor:
                                                //           AlwaysStoppedAnimation(
                                                //               Colors.lightBlue[300]!),
                                                //           backgroundColor:  themeChange.darkTheme==true?  Colors.grey[800]:Colors.grey[400],
                                                //           direction: Axis.vertical,
                                                //           shapePath:
                                                //           _buildBoatPath(), // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
                                                //         ),
                                                //       ),
                                                //       // Center(child: Image.asset('assets/cup.png',width: 500,height: 400,fit: BoxFit.cover,)),
                                                //       // Center(child: Image.asset('assets/coffee trans.png',width: 500,height: 400,fit: BoxFit.cover,)),
                                                //       SizedBox(
                                                //         height: 400,
                                                //         child: RotatedBox(
                                                //           quarterTurns: 3,
                                                //           child: Slider(
                                                //               activeColor:
                                                //               Colors.transparent,
                                                //               inactiveColor:
                                                //               Colors.transparent,
                                                //               value: double.parse(addvitalVM
                                                //                   .getQtyValue
                                                //                   .toStringAsFixed(2)),
                                                //               min: 0,
                                                //               max: double.parse(addvitalVM
                                                //                   .maxvalue
                                                //                   .toStringAsFixed(1)),
                                                //               divisions: 200,
                                                //               label: double.parse(addvitalVM
                                                //                   .getQtyValue
                                                //                   .toStringAsFixed(2))
                                                //                   .round()
                                                //                   .toString(),
                                                //               onChanged: (value) {
                                                //                 addvitalVM.updateQtyValue =
                                                //                     value;
                                                //                 addvitalVM.fluidC.text =
                                                //                     value.toString();
                                                //                 addvitalVM
                                                //                     .notifyListeners();
                                                //               }),
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                                ///
                                                // Visibility(
                                                //   visible:addvitalVM.getManualFoodList.isNotEmpty,
                                                //     child: const PageViewExample()),
                                                Visibility(
                                                  visible: addvitalVM.getManualFoodList.isNotEmpty,
                                                  child: SizedBox(
                                                    height: 660,
                                                    child: IntakeMenusWidget(
                                                      foodId: data1.foodID.toString(),
                                                      title: data1.foodName.toString(),
                                                      color: fluidIntakeList.firstWhere(
                                                        (element) => element['name'].toString().toUpperCase() == data1.foodName.toString().toUpperCase(),
                                                        orElse: () => {"name": "Default Name", "color": Colors.grey, "isBig": false},
                                                      )['color'],
                                                      isBig: fluidIntakeList.firstWhere(
                                                        (element) => element['name'].toString().toUpperCase() == data1.foodName.toString().toUpperCase(),
                                                        orElse: () => {"name": "Default Name", "color": Colors.grey, "isBig": false},
                                                      )['isBig'],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      addvitalVM.fluidC.clear();
                                                      addvitalVM.notifyListeners();
                                                      CustomBottomSheet.open(context,
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                                                  themeChange.darkTheme == true ? AppColor.neoBGGrey2 : AppColor.neoBGWhite1,
                                                                  themeChange.darkTheme == true ? AppColor.neoBGGrey1 : AppColor.neoBGWhite2,
                                                                  themeChange.darkTheme == true ? AppColor.neoBGGrey1 : AppColor.neoBGWhite2,
                                                                ]),
                                                                color: themeChange.darkTheme == true ? AppColor.neoBGGrey1 : AppColor.neoBGWhite2,
                                                              ),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          localization.getLocaleData.customAmount.toString(),
                                                                          style: MyTextTheme.largeBCB,
                                                                        ),
                                                                        Container(
                                                                          width: 45,
                                                                          child: IconButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              icon: const Icon(Icons.clear)),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                                                                    child: PrimaryTextField(
                                                                      style: TextStyle(color: themeChange.darkTheme == true ? AppColor.white : AppColor.grey),
                                                                      hintTextColor: themeChange.darkTheme == true ? AppColor.white : AppColor.grey,
                                                                      borderColor: AppColor.transparent,
                                                                      backgroundColor: themeChange.darkTheme == false ? Colors.white70 : hexToColor('#474747'),
                                                                      controller: addvitalVM.fluidC,
                                                                      keyboardType: TextInputType.number,
                                                                      maxLength: 4,
                                                                      textAlign: TextAlign.center,
                                                                      hintText: localization.getLocaleData.enterValueInml.toString(),
                                                                      onChanged: (val) {
                                                                        if (val <= 1000) {
                                                                          addvitalVM.updateQtyValue = val;
                                                                        }
                                                                        addvitalVM.notifyListeners();
                                                                      },
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                                                                    child: NeoButton(
                                                                      func: () async {
                                                                        await CustomBottomSheet.open(context,
                                                                            child: FunctionalSheet(
                                                                              message: localization.getLocaleData.areYouSureYouWantToAddWaterIntake.toString(),
                                                                              buttonName: localization.getLocaleData.confirm.toString(),
                                                                              onPressButton: () async {
                                                                                addvitalVM.updateSelectedFoodID = '97694';
                                                                                Navigator.pop(context);
                                                                                addvitalVM.fluidIntake(context);

                                                                                // addvitalVM
                                                                                //     .addWaterIntakeData(
                                                                                //         context, value);
                                                                              },
                                                                            ));
                                                                      },
                                                                      title: localization.getLocaleData.save.toString(),
                                                                    ),
                                                                  )
                                                                ],
                                                              )));
                                                    },
                                                    child: const Column(
                                                      children: [
                                                        // Row(
                                                        //   mainAxisAlignment:
                                                        //   MainAxisAlignment.center,
                                                        //   children: [
                                                        //     Text(
                                                        //       "${addvitalVM.getQtyValue.toStringAsFixed(1)} ml",
                                                        //       style:  TextStyle(
                                                        //           fontSize: 30,
                                                        //           fontWeight:
                                                        //           FontWeight.w600,
                                                        //           color:themeChange.darkTheme==true?Colors.white:Colors.black87
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // const SizedBox(
                                                        //   height: 5,
                                                        // ),
                                                        // Text(localization.getLocaleData.addCustom.toString(),style: TextStyle(color:  themeChange.darkTheme==true?Colors.white:Colors.black87),),
                                                        // const SizedBox(
                                                        //   height: 50,
                                                        // ),
                                                        SizedBox(
                                                          height: 50,
                                                        ),
                                                        // Padding(
                                                        //   padding: const EdgeInsets.only(
                                                        //       left: 28.0, right: 28.0),
                                                        //   child: NeoButton(
                                                        //     width: 150,
                                                        //     func: () async {
                                                        //       addvitalVM
                                                        //           .updateSelectedFoodID =
                                                        //       '97694';
                                                        //       await CustomBottomSheet.open(
                                                        //           context,
                                                        //           child: FunctionalSheet(
                                                        //             message:
                                                        //             localization.getLocaleData.areYouSureYouWantToAddFluid.toString(),
                                                        //             buttonName: localization.getLocaleData.confirm.toString(),
                                                        //             onPressButton:
                                                        //                 () async {
                                                        //               await addvitalVM
                                                        //                   .fluidIntake(
                                                        //                   context);
                                                        //               // addvitalVM.addWaterIntakeData(
                                                        //               //     context, value);
                                                        //             },
                                                        //           ));
                                                        //     },
                                                        //     title: localization.getLocaleData.saveWater.toString(),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                            // SizedBox(
                                            //   height: 121,
                                            //   // width: 390,
                                            //   child: ListView.builder(
                                            //       scrollDirection: Axis.horizontal,
                                            //       itemCount: addvitalVM
                                            //           .getManualFoodList.isEmpty
                                            //           ? 0
                                            //           : addvitalVM.getManualFoodList.length,
                                            //       itemBuilder: (context, int index) {
                                            //         ManualFoodAssignDataModal data =
                                            //         addvitalVM.getManualFoodList.isEmpty
                                            //             ? ManualFoodAssignDataModal()
                                            //             : addvitalVM
                                            //             .getManualFoodList[index];
                                            //         return Padding(
                                            //           padding: const EdgeInsets.all(18.0),
                                            //           child: InkWell(
                                            //             onTap: () {
                                            //               addvitalVM.updateSelectedFoodID =
                                            //                   data.foodID.toString();
                                            //
                                            //               MyNavigator.push(
                                            //                   context,
                                            //                   IntakeMenusWidget(
                                            //                     title: data.foodName
                                            //                         .toString(),
                                            //                     color: fluidIntakeList
                                            //                         .firstWhere((element) =>
                                            //                     element['name'] == data.foodName.toString())['color'],
                                            //                     isBig: fluidIntakeList.firstWhere((element) =>
                                            //                     element['name'] == data.foodName.toString())['isBig'],
                                            //                   ));
                                            //             },
                                            //             child: Column(
                                            //               children: [
                                            //                 Image.asset(
                                            //                   'assets/water_intake/${data.foodName.toString().trim()}.png',
                                            //                   fit: BoxFit.fitWidth,
                                            //                   width: 35,
                                            //                 ),
                                            //                 const SizedBox(
                                            //                   height: 5,
                                            //                 ),
                                            //                 Text(data.foodName.toString(),style: TextStyle(color: themeChange.darkTheme==true?Colors.white:Colors.grey.shade800),)
                                            //               ],
                                            //             ),
                                            //           ),
                                            //         );
                                            //       }),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !isIntake,
                            child: const Expanded(child: AddNewDrink()),
                          ),
                        ],
                      ),
                    ),
                  ):

                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 800,
                        thumbShape: SliderComponentShape.noOverlay,
                        overlayShape: SliderComponentShape.noOverlay,
                        valueIndicatorShape: SliderComponentShape.noOverlay,
                        trackShape: const RectangularSliderTrackShape(),
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                      ),
                      child: Column(
                        children: [

                      Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                      Expanded(
                          child: Text(localization.getLocaleData.add.toString()+' '+localization.getLocaleData.urineOutput.toString(),
                              style: MyTextTheme.mediumBCB.copyWith(color:  themeChange.darkTheme==true?Colors.white:Colors.black87))),
                      Expanded(
                        child: NeoButton(
                          title: localization.getLocaleData.urineOutput.toString()+' '+ localization.getLocaleData.history.toString(),
                          width: 210,
                          func: () {
                            MyNavigator.push(context, const UrinOutputView());
                          },
                        ),
                      ),
                        ],
                      ),
                    ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: SizedBox(),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Image.asset(ImagePaths.output),
                                ),
                                const Expanded(
                                  child: SizedBox(),
                                ),
                                Text(localization.getLocaleData.urineOutputQty.toString(), style: MyTextTheme.veryLargeBCB.copyWith(color: themeChange.darkTheme ? Colors.white : null)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (double.parse((addvitalVM.urineC.value.text).toString()) <= 5) {
                                          addvitalVM.urineC.text = '0';
                                          addvitalVM.notifyListeners();
                                        } else if (double.parse((addvitalVM.urineC.value.text).toString()) <= 50) {
                                          addvitalVM.urineC.text = (double.parse((addvitalVM.urineC.value.text).toString()) - 10).toString();
                                          addvitalVM.notifyListeners();
                                        } else {
                                          addvitalVM.urineC.text = (double.parse((addvitalVM.urineC.value.text).toString()) - 50).toString();
                                          addvitalVM.notifyListeners();
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: addvitalVM.urineC.value.text.toString() == '0' ? Colors.grey : AppColor.neoGreen),
                                        child: const Padding(
                                          padding: EdgeInsets.all(14.0),
                                          child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      child: Row(
                                        children: [
                                          _editTitleTextField(),
                                          //    Text(addvitalVM.urineC.value.text.toString(),style: MyTextTheme.mediumBCB.copyWith(fontSize: 70,color: themeChange.darkTheme?Colors.white:null),),
                                          Text(
                                            '  ml',
                                            style: MyTextTheme.mediumBCN.copyWith(fontSize: 30, color: themeChange.darkTheme ? Colors.white : null),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        addvitalVM.urineC.text = (double.parse((addvitalVM.urineC.value.text).toString()) + 50).toString();
                                        addvitalVM.notifyListeners();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.neoGreen),
                                        child: const Padding(
                                          padding: EdgeInsets.all(14.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Expanded(
                                  flex: 2,
                                  child: SizedBox(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: NeoButton(
                                    width: 80,
                                    func: () async {
                                      if (addvitalVM.urineC.text != '') {
                                        await CustomBottomSheet.open(context,
                                            child: FunctionalSheet(
                                              message: localization.getLocaleData.areYouSureYouWantTo.toString() +
                                                  ' ${addvitalVM.isUpdate ? localization.getLocaleData.update.toString() :
                                                  localization.getLocaleData.add.toString().toLowerCase()} ' +
                                                  localization.getLocaleData.urineOutput.toString().toLowerCase() +
                                                  "?",
                                              buttonName: localization.getLocaleData.confirm.toString(),
                                              onPressButton: () async {
                                                if (addvitalVM.isUpdate) {
                                                  await addvitalVM.updatePatientOutput(context);
                                                } else {
                                                  await addvitalVM.addVitalsDataUrine(context);
                                                }
                                              },
                                            ));
                                      } else {
                                        Alert.show('Please enter urine output');
                                      }
                                    },
                                    title: addvitalVM.isUpdate ? localization.getLocaleData.update.toString() : localization.getLocaleData.save.toString(),
                                    textStyle: MyTextTheme.mediumGCB.copyWith(
                                      color: themeChange.darkTheme ? AppColor.black : AppColor.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),

                          // Expanded(
                          //     child: Column(
                          //   children: [
                          //     Container(
                          //       color: themeChange.darkTheme == true ? Colors.grey.shade800 : Colors.grey.withOpacity(.6),
                          //       child: IntrinsicHeight(
                          //         child: Row(
                          //           children: [
                          //             Expanded(
                          //                 flex: 4,
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.all(8.0),
                          //                   child: Text(
                          //                     localization.getLocaleData.output.toString(),
                          //                     style: MyTextTheme.mediumWCN.copyWith(color: themeChange.darkTheme == true ? Colors.white : AppColor.greyDark, fontWeight: FontWeight.w600),
                          //                   ),
                          //                 )),
                          //             Expanded(
                          //                 flex: 4,
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.all(8.0),
                          //                   child: Center(
                          //                       child: Column(
                          //                     children: [
                          //                       Text(
                          //                         localization.getLocaleData.date.toString(),
                          //                         style: MyTextTheme.mediumWCN.copyWith(color: themeChange.darkTheme == true ? Colors.white : AppColor.greyDark, fontWeight: FontWeight.w600),
                          //                       ),
                          //                     ],
                          //                   )),
                          //                 )),
                          //             Expanded(
                          //                 flex: 5,
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.all(8.0),
                          //                   child: Center(
                          //                       child: Column(
                          //                     children: [
                          //                       Text(
                          //                         localization.getLocaleData.time.toString(),
                          //                         style: MyTextTheme.mediumWCN.copyWith(color: themeChange.darkTheme == true ? Colors.white : AppColor.greyDark, fontWeight: FontWeight.w600),
                          //                       ),
                          //                     ],
                          //                   )),
                          //                 )),
                          //             Expanded(
                          //                 flex: 4,
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.all(8.0),
                          //                   child: Center(
                          //                       child: Text(
                          //                     localization.getLocaleData.Action.toString(),
                          //                     style: MyTextTheme.mediumWCN.copyWith(color: themeChange.darkTheme == true ? Colors.white : AppColor.greyDark, fontWeight: FontWeight.w600),
                          //                   )),
                          //                 )),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //         child: CommonWidgets().showNoData(
                          //       title: localization.getLocaleData.noDataFound.toString(),
                          //       show: (addvitalVM.getShowNoData && (addvitalVM.getUrinOutputList.isEmpty)),
                          //       loaderTitle: localization.getLocaleData.Loading.toString(),
                          //       showLoader: (!addvitalVM.getShowNoData && (addvitalVM.getUrinOutputList.isEmpty)),
                          //       child: ListView.builder(
                          //         itemCount: addvitalVM.getUrinOutputList.length,
                          //         itemBuilder: (BuildContext context, int index) {
                          //           var urinData = addvitalVM.getUrinOutputList[index];
                          //           String dateTimeStr = urinData["outputDate"].toString();
                          //           List<String> parts = dateTimeStr.split(' ');
                          //           String datePart = parts[0];
                          //           String datePart2 = parts[1];
                          //           String datePart3 = parts[2];
                          //           return Container(
                          //             decoration: BoxDecoration(
                          //                 border: Border.symmetric(
                          //                     horizontal: BorderSide(
                          //               width: 1,
                          //               color: themeChange.darkTheme == true ? Colors.grey.shade800 : Colors.grey,
                          //             ))),
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(0.0),
                          //               child: Row(
                          //                 children: [
                          //                   Expanded(
                          //                       flex: 4,
                          //                       child: Text(
                          //                         // '${urinData["quantity"]} ${urinData["unitName"]}',
                          //                         (double.parse(urinData["quantity"].toString())).toStringAsFixed(0) + ' ' + urinData["unitName"].toString(),
                          //                         style: MyTextTheme.mediumGCN.copyWith(color: Colors.green.shade600, fontWeight: FontWeight.w600), textAlign: TextAlign.center,
                          //                       )),
                          //                   Expanded(
                          //                       flex: 5,
                          //                       child: Container(
                          //                           decoration: BoxDecoration(
                          //                               border: Border.symmetric(vertical: BorderSide(color: themeChange.darkTheme == true ? Colors.grey.shade800 : Colors.grey, width: 1))),
                          //                           child: Padding(
                          //                             padding: const EdgeInsets.all(8.0),
                          //                             child: Text(
                          //                               DateFormat("dd MMM yyyy").format(DateFormat('dd/MM/yyyy').parse(datePart.toString().toString())),
                          //                               style: TextStyle(color: themeChange.darkTheme == true ? Colors.white : AppColor.black),
                          //                               textAlign: TextAlign.center,
                          //                             ),
                          //                           ))),
                          //                   Expanded(
                          //                       flex: 4,
                          //                       child: Container(
                          //                           decoration: BoxDecoration(
                          //                               border: Border.symmetric(vertical: BorderSide(color: themeChange.darkTheme == true ? Colors.grey.shade800 : Colors.grey, width: 1))),
                          //                           child: Center(
                          //                               child: Padding(
                          //                             padding: const EdgeInsets.all(8.0),
                          //                             child: Text(
                          //                               '$datePart2  $datePart3',
                          //                               style: TextStyle(
                          //                                 color: themeChange.darkTheme == true ? Colors.white : AppColor.black,
                          //                               ),
                          //                               textAlign: TextAlign.center,
                          //                             ),
                          //                           )))),
                          //                   Expanded(
                          //                       flex: 4,
                          //                       child: Row(
                          //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //                         children: [
                          //                           InkWell(
                          //                             onTap: () async {
                          //                               addvitalVM.urineC.text = urinData['quantity'].toString();
                          //                               dPring('nnnnn ${addvitalVM.urineC.text}');
                          //                               addvitalVM.updateSelectedPmID = urinData['pmID'].toString();
                          //                               addvitalVM.updateSelectedID = urinData['id'].toString();
                          //                               addvitalVM.isUpdate = true;
                          //                               setState(() {
                          //                                 isIntake = true;
                          //                               });
                          //                               addvitalVM.notifyListeners();
                          //                             },
                          //                             child: Padding(
                          //                               padding: const EdgeInsets.all(8.0),
                          //                               child: Icon(
                          //                                 Icons.edit,
                          //                                 color: AppColor.blue,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           InkWell(
                          //                             onTap: () async {
                          //                               await CustomBottomSheet.open(context,
                          //                                   child: FunctionalSheet(
                          //                                     message: localization.getLocaleData.areYouSureYouWantToDelete.toString(),
                          //                                     buttonName: localization.getLocaleData.confirm.toString(),
                          //                                     onPressButton: () async {
                          //                                       await addvitalVM.deletePatientOutput(
                          //                                         context,
                          //                                         id: urinData['id'].toString(),
                          //                                         pmID: urinData['pmID'].toString(),
                          //                                       );
                          //                                     },
                          //                                   ));
                          //                             },
                          //                             child: Padding(
                          //                               padding: const EdgeInsets.all(8.0),
                          //                               child: Icon(
                          //                                 Icons.delete_outline,
                          //                                 color: AppColor.red,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ))
                          //                 ],
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     ))
                          //   ],
                          // )),
                        ],
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

  commanWidget() {
    // ThemeProviderLd themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    // ApplicationLocalizations localization =
    // Provider.of<ApplicationLocalizations>(context, listen: true);
    // AddVitalViewModal addvitalVM =
    // Provider.of<AddVitalViewModal>(context, listen: true);

    return Consumer<ThemeProviderLd>(builder: (BuildContext context, themeChange, _) {
      return Consumer<ApplicationLocalizations>(builder: (BuildContext context, localization, _) {
        return Consumer<AddVitalViewModal>(builder: (BuildContext context, addvitalVM, _) {
          return Container(
            height: Get.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                themeChange.darkTheme == true ? AppColor.neoBGGrey2 : AppColor.neoBGWhite1,
                themeChange.darkTheme == true ? AppColor.neoBGGrey1 : AppColor.neoBGWhite2,
                themeChange.darkTheme == true ? AppColor.neoBGGrey1 : AppColor.neoBGWhite2,
              ]),
              color: Colors.grey.shade800,
            ),
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 800,
                thumbShape: SliderComponentShape.noOverlay,
                overlayShape: SliderComponentShape.noOverlay,
                valueIndicatorShape: SliderComponentShape.noOverlay,
                trackShape: const RectangularSliderTrackShape(),
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: Image.asset(themeChange.darkTheme == true ? ImagePaths.menuDark : ImagePaths.menulight, height: 40)),
                        Expanded(
                          child: Text(
                            localization.getLocaleData.intakeOutput.toString(),
                            style: MyTextTheme.largeGCB.copyWith(fontSize: 21, height: 0, color: themeChange.darkTheme == true ? Colors.white70 : null),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            changeQtyAlert2();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Icon(
                              Icons.settings,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                          themeChange.darkTheme == true ? AppColor.blackLight : AppColor.neoBGWhite1,
                          themeChange.darkTheme == true ? AppColor.blackDark : AppColor.neoBGWhite2,
                        ]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isIntake = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: !isIntake ? Colors.grey : AppColor.primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(color: !isIntake ? Colors.transparent : AppColor.neoGreen, blurRadius: 2, offset: const Offset(-4, 0)),
                                        BoxShadow(color: !isIntake ? Colors.transparent : AppColor.neoGreen, blurRadius: 2, offset: const Offset(4, 0)),
                                      ],
                                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                        !isIntake ? Colors.transparent : (themeChange.darkTheme == true ? AppColor.blackDark : AppColor.neoBGWhite2),
                                        !isIntake ? Colors.transparent : (themeChange.darkTheme == true ? AppColor.blackLight : AppColor.neoBGWhite1),
                                      ])),
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      localization.getLocaleData.flIntake.toString(),
                                      style: !isIntake ? MyTextTheme.mediumGCB : MyTextTheme.mediumWCB.copyWith(color: isIntake ? AppColor.neoGreen : Colors.grey),
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
                                    isIntake = false;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: isIntake ? Colors.grey : AppColor.primaryColor,
                                      boxShadow: [
                                        BoxShadow(color: isIntake ? Colors.transparent : AppColor.neoGreen, blurRadius: 2, offset: const Offset(-4, 0)),
                                        BoxShadow(color: isIntake ? Colors.transparent : AppColor.neoGreen, blurRadius: 2, offset: const Offset(4, 0)),
                                      ],
                                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                        isIntake ? Colors.transparent : (themeChange.darkTheme == true ? AppColor.blackDark : AppColor.neoBGWhite2),
                                        isIntake ? Colors.transparent : (themeChange.darkTheme == true ? AppColor.blackLight : AppColor.neoBGWhite1),
                                      ]),
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      localization.getLocaleData.urineOutput.toString(),
                                      style: isIntake ? MyTextTheme.mediumGCB : MyTextTheme.mediumWCB.copyWith(color: !isIntake ? AppColor.neoGreen : Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: !isIntake,
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: PrimaryTextField(
                                                style: TextStyle(color: themeChange.darkTheme == true ? AppColor.white : AppColor.grey),
                                                hintTextColor: themeChange.darkTheme == true ? AppColor.white : AppColor.grey,
                                                borderColor: AppColor.transparent,
                                                backgroundColor: themeChange.darkTheme == false ? Colors.white70 : hexToColor('#474747'),
                                                keyboardType: TextInputType.number,
                                                hintText: localization.getLocaleData.enterValueInml.toString(),
                                                controller: addvitalVM.urineC,
                                                onChanged: (val) {
                                                  setState(() {
                                                    this.value = val;
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: NeoButton(
                                                width: 80,
                                                func: () async {
                                                  if (addvitalVM.urineC.text != '') {
                                                    await CustomBottomSheet.open(context,
                                                        child: FunctionalSheet(
                                                          message: localization.getLocaleData.areYouSureYouWantTo.toString() +
                                                              ' ${addvitalVM.isUpdate ? localization.getLocaleData.update.toString() : localization.getLocaleData.add.toString()}' +
                                                              localization.getLocaleData.urineOutput.toString() +
                                                              "?",
                                                          // 'Are you sure You want to ${addvitalVM.isUpdate? 'update':'add'} urine output',
                                                          buttonName: localization.getLocaleData.confirm.toString(),
                                                          onPressButton: () async {
                                                            if (addvitalVM.isUpdate) {
                                                              await addvitalVM.updatePatientOutput(context);
                                                            } else {
                                                              await addvitalVM.addVitalsDataUrine(context);
                                                            }
                                                          },
                                                        ));
                                                  } else {
                                                    Alert.show('Please enter urine output');
                                                  }
                                                },
                                                title: addvitalVM.isUpdate ? localization.getLocaleData.update.toString() : localization.getLocaleData.save.toString(),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          localization.getLocaleData.history.toString(),
                                          style: MyTextTheme.largeGCB.copyWith(color: themeChange.darkTheme == true ? Colors.white : Colors.grey.shade800),
                                        ),
                                        Container(
                                          color: themeChange.darkTheme == true ? Colors.grey.shade800 : Colors.grey,
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 4,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        localization.getLocaleData.vital.toString(),
                                                        style: MyTextTheme.mediumWCN.copyWith(color: themeChange.darkTheme == true ? Colors.white : Colors.black87),
                                                      ),
                                                    )),
                                                Expanded(
                                                    flex: 4,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Center(
                                                          child: Text(
                                                        localization.getLocaleData.date.toString(),
                                                        style: MyTextTheme.mediumWCN.copyWith(color: themeChange.darkTheme == true ? Colors.white : Colors.black87),
                                                      )),
                                                    )),
                                                Expanded(
                                                    flex: 4,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Center(
                                                          child: Text(
                                                        localization.getLocaleData.time.toString(),
                                                        style: MyTextTheme.mediumWCN.copyWith(color: themeChange.darkTheme == true ? Colors.white : Colors.black87),
                                                      )),
                                                    )),
                                                Expanded(
                                                    flex: 4,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Center(
                                                          child: Text(
                                                        localization.getLocaleData.Action.toString(),
                                                        style: MyTextTheme.mediumWCN.copyWith(color: themeChange.darkTheme == true ? Colors.white : Colors.black87),
                                                      )),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: ListView.builder(
                                          itemCount: addvitalVM.getUrinOutputList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            var urinData = addvitalVM.getUrinOutputList[index];
                                            String dateTimeStr = urinData["outputDate"].toString();
                                            List<String> parts = dateTimeStr.split(' ');
                                            String datePart = parts[0];
                                            String datePart2 = parts[1];
                                            String datePart3 = parts[2];
                                            return Container(
                                              decoration: BoxDecoration(
                                                  border: Border.symmetric(
                                                      horizontal: BorderSide(
                                                width: 1,
                                                color: themeChange.darkTheme == true ? Colors.grey.shade800 : Colors.grey,
                                              ))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          '${urinData["quantity"]} ${urinData["unitName"]}',
                                                          style: TextStyle(color: AppColor.neoGreen),
                                                          textAlign: TextAlign.center,
                                                        )),
                                                    Expanded(
                                                        flex: 4,
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.symmetric(vertical: BorderSide(color: themeChange.darkTheme == true ? Colors.grey.shade800 : Colors.grey, width: 1))),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                datePart,
                                                                style: TextStyle(color: themeChange.darkTheme == true ? Colors.white : AppColor.black),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ))),
                                                    Expanded(
                                                        flex: 4,
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.symmetric(vertical: BorderSide(color: themeChange.darkTheme == true ? Colors.grey.shade800 : Colors.grey, width: 1))),
                                                            child: Center(
                                                                child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                '$datePart2  $datePart3',
                                                                style: TextStyle(
                                                                  color: themeChange.darkTheme == true ? Colors.white : AppColor.black,
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            )))),
                                                    Expanded(
                                                        flex: 4,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                addvitalVM.urineC.text = urinData['quantity'].toString();
                                                                dPrint('nnnnn ${addvitalVM.urineC.text}');
                                                                addvitalVM.updateSelectedPmID = urinData['pmID'].toString();
                                                                addvitalVM.updateSelectedID = urinData['id'].toString();
                                                                addvitalVM.isUpdate = true;
                                                                addvitalVM.notifyListeners();
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Icon(
                                                                  Icons.edit,
                                                                  color: AppColor.grey,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                await CustomBottomSheet.open(context,
                                                                    child: FunctionalSheet(
                                                                      message: localization.getLocaleData.areYouSureYouWantToDelete.toString(),
                                                                      buttonName: localization.getLocaleData.confirm.toString(),
                                                                      onPressButton: () async {
                                                                        await addvitalVM.deletePatientOutput(
                                                                          context,
                                                                          id: urinData['id'].toString(),
                                                                          pmID: urinData['pmID'].toString(),
                                                                        );
                                                                      },
                                                                    ));
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Icon(
                                                                  Icons.delete_outline,
                                                                  color: AppColor.grey,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Visibility(
                    visible: isIntake,
                    child: Expanded(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(localization.getLocaleData.addFluidIntake.toString(),
                                        style: MyTextTheme.mediumBCB.copyWith(color: themeChange.darkTheme == true ? Colors.white : Colors.black87))),
                                Expanded(
                                  child: NeoButton(
                                    title: localization.getLocaleData.fluidIntakeHistory.toString(),
                                    width: 210,
                                    func: () {
                                      MyNavigator.push(context, const AddNewDrink());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: RawScrollbar(
                              trackColor: AppColor.grey,
                              thumbVisibility: true,
                              interactive: true,
                              radius: const Radius.circular(10),
                              thickness: 5,
                              trackVisibility: true,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 400,
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: LiquidCustomProgressIndicator(
                                                    value: double.parse(addvitalVM.getQtyValue.toStringAsFixed(0)) / addvitalVM.maxvalue,
                                                    valueColor: AlwaysStoppedAnimation(Colors.lightBlue[300]!),
                                                    backgroundColor: themeChange.darkTheme == true ? Colors.grey[800] : Colors.grey[400],
                                                    direction: Axis.vertical,
                                                    shapePath:
                                                        _buildBoatPath(), // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
                                                  ),
                                                ),
                                                // Center(child: Image.asset('assets/cup.png',width: 500,height: 400,fit: BoxFit.cover,)),
                                                // Center(child: Image.asset('assets/coffee trans.png',width: 500,height: 400,fit: BoxFit.cover,)),
                                                SizedBox(
                                                  height: 400,
                                                  child: RotatedBox(
                                                    quarterTurns: 3,
                                                    child: Slider(
                                                        activeColor: Colors.transparent,
                                                        inactiveColor: Colors.transparent,
                                                        value: double.parse(addvitalVM.getQtyValue.toStringAsFixed(2)),
                                                        min: 0,
                                                        max: double.parse(addvitalVM.maxvalue.toStringAsFixed(1)),
                                                        divisions: 200,
                                                        label: double.parse(addvitalVM.getQtyValue.toStringAsFixed(2)).round().toString(),
                                                        onChanged: (value) {
                                                          addvitalVM.updateQtyValue = value;
                                                          addvitalVM.fluidC.text = value.toString();
                                                          addvitalVM.notifyListeners();
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                addvitalVM.fluidC.clear();
                                                addvitalVM.notifyListeners();
                                                CustomBottomSheet.open(context,
                                                    child: SizedBox(
                                                        height: 250,
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    localization.getLocaleData.customAmount.toString(),
                                                                    style: MyTextTheme.largeBCB,
                                                                  ),
                                                                  Container(
                                                                    width: 45,
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                        },
                                                                        icon: const Icon(Icons.clear)),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                                                              child: PrimaryTextField(
                                                                style: TextStyle(color: themeChange.darkTheme == true ? AppColor.white : AppColor.grey),
                                                                hintTextColor: themeChange.darkTheme == true ? AppColor.white : AppColor.grey,
                                                                borderColor: AppColor.transparent,
                                                                backgroundColor: themeChange.darkTheme == false ? Colors.white70 : hexToColor('#474747'),
                                                                controller: addvitalVM.fluidC,
                                                                keyboardType: TextInputType.number,
                                                                maxLength: 4,
                                                                textAlign: TextAlign.center,
                                                                hintText: localization.getLocaleData.enterValueInml.toString(),
                                                                onChanged: (val) {
                                                                  if (val <= 1000) {
                                                                    addvitalVM.updateQtyValue = val;
                                                                  }
                                                                  addvitalVM.notifyListeners();
                                                                },
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                                                              child: NeoButton(
                                                                func: () async {
                                                                  await CustomBottomSheet.open(context,
                                                                      child: FunctionalSheet(
                                                                        message: localization.getLocaleData.areYouSureYouWantToAddWaterIntake.toString(),
                                                                        buttonName: localization.getLocaleData.confirm.toString(),
                                                                        onPressButton: () async {
                                                                          addvitalVM.updateSelectedFoodID = '97694';
                                                                          Navigator.pop(context);
                                                                          addvitalVM.fluidIntake(context);

                                                                          // addvitalVM
                                                                          //     .addWaterIntakeData(
                                                                          //         context, value);
                                                                        },
                                                                      ));
                                                                },
                                                                title: localization.getLocaleData.save.toString(),
                                                              ),
                                                            )
                                                          ],
                                                        )));
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${addvitalVM.getQtyValue.toStringAsFixed(1)} ml",
                                                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: themeChange.darkTheme == true ? Colors.white : Colors.black87),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    localization.getLocaleData.addCustom.toString(),
                                                    style: TextStyle(color: themeChange.darkTheme == true ? Colors.white : Colors.black87),
                                                  ),
                                                  const SizedBox(
                                                    height: 50,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                                                    child: NeoButton(
                                                      width: 150,
                                                      func: () async {
                                                        addvitalVM.updateSelectedFoodID = '97694';
                                                        await CustomBottomSheet.open(context,
                                                            child: FunctionalSheet(
                                                              message: localization.getLocaleData.areYouSureYouWantToAddFluid.toString(),
                                                              buttonName: localization.getLocaleData.confirm.toString(),
                                                              onPressButton: () async {
                                                                await addvitalVM.fluidIntake(context);
                                                                // addvitalVM.addWaterIntakeData(
                                                                //     context, value);
                                                              },
                                                            ));
                                                      },
                                                      title: localization.getLocaleData.saveWater.toString(),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 121,
                                        // width: 390,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: addvitalVM.getManualFoodList.isEmpty ? 0 : addvitalVM.getManualFoodList.length,
                                            itemBuilder: (context, int index) {
                                              ManualFoodAssignDataModal data = addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[index];
                                              return Padding(
                                                padding: const EdgeInsets.all(18.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    addvitalVM.updateSelectedFoodID = data.foodID.toString();

                                                    MyNavigator.push(
                                                        context,
                                                        IntakeMenusWidget(
                                                          foodId: data.foodID.toString(),
                                                          title: data.foodName.toString(),
                                                          color: fluidIntakeList.firstWhere((element) => element['name'] == data.foodName.toString())['color'],
                                                          isBig: fluidIntakeList.firstWhere((element) => element['name'] == data.foodName.toString())['isBig'],
                                                        ));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        'assets/water_intake/${data.foodName.toString().trim()}.png',
                                                        fit: BoxFit.fitWidth,
                                                        width: 35,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        data.foodName.toString(),
                                                        style: TextStyle(color: themeChange.darkTheme == true ? Colors.white : Colors.grey.shade800),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      });
    });
  }

  Widget buildSideLabel(double value) => Text(
        value.round().toString(),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      );
  _buildBoatPath() {
    return Path()
      ..lineTo(250 / 2 - 70, 400)
      ..lineTo(250 / 2 + 70, 400)
      ..lineTo(250, 0.0)
      ..lineTo(250, 0.0)
      ..close();
  }

  _buildBoxPath() {
    return Path()
      ..lineTo(0, 400)
      ..lineTo(500, 400)
      ..lineTo(500, 0.0)
      ..lineTo(500, 0.0)
      ..close();
  }

  _buildBoatPath2() {
    return Path()
      ..lineTo(250 / 2 - 70, 400)
      ..lineTo(250 / 2 + 70, 400)
      ..lineTo(250, 0.0)
      ..lineTo(250, 0.0)
      ..close();
  }

  changeQtyAlert() {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    AddVitalViewModal addvitalVM = Provider.of<AddVitalViewModal>(context, listen: false);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(localization.getLocaleData.changeQty.toString()), actions: [
            PrimaryTextField(
              hintText: localization.getLocaleData.enterQty.toString(),
              controller: addvitalVM.fluidC,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                addvitalVM.notifyListeners();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: NeoButton(
                      func: () {
                        if (addvitalVM.fluidC.text != '') {
                          if (double.parse(addvitalVM.fluidC.text) <= 250) {
                            addvitalVM.maxvalue = double.parse(addvitalVM.fluidC.text);
                            addvitalVM.updateQtyValue = double.parse(addvitalVM.fluidC.text);
                            addvitalVM.notifyListeners();
                            Get.back();
                          } else {
                            Alert.show(localization.getLocaleData.youCanEnterMaximumQty.toString());
                            // addvitalVM.changeQtyC.clear();
                            // addvitalVM.notifyListeners();
                            //  Get.back();
                          }
                        } else {
                          Alert.show(localization.getLocaleData.pleaseEnterSomeQty.toString());
                        }
                      },
                      title: localization.getLocaleData.change.toString()),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: NeoButton(
                  func: () {
                    if (addvitalVM.fluidC.text != '') {
                      if (double.parse(addvitalVM.fluidC.text) > 250) {
                        addvitalVM.fluidC.clear();
                        addvitalVM.notifyListeners();
                        Get.back();
                      } else {
                        Get.back();
                      }
                    } else {
                      Get.back();
                    }
                  },
                  title: localization.getLocaleData.cancel.toString(),
                  // color: AppColor.orange,
                ))
              ],
            )
          ]);
        });
  }

  changeQtyAlert2() {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    AddVitalViewModal addvitalVM = Provider.of<AddVitalViewModal>(context, listen: false);
    final themeProvider = Provider.of<ThemeProviderLd>(context, listen: false);

    return CustomBottomSheet.open(context,
        child: Container(
            height: 230,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                  themeProvider.darkTheme == true ? AppColor.neoBGGrey2 : AppColor.neoBGWhite1,
                  themeProvider.darkTheme == true ? AppColor.neoBGGrey1 : AppColor.neoBGWhite2,
                  themeProvider.darkTheme == true ? AppColor.neoBGGrey1 : AppColor.neoBGWhite2,
                ]),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    localization.getLocaleData.changeQty.toString(),
                    style: MyTextTheme.largeWCB,
                  ),
                ),
                PrimaryTextField(
                  style: TextStyle(color: themeProvider.darkTheme == true ? AppColor.white : AppColor.grey),
                  hintTextColor: themeProvider.darkTheme == true ? AppColor.white : AppColor.grey,
                  borderColor: AppColor.transparent,
                  backgroundColor: themeProvider.darkTheme == false ? Colors.white70 : hexToColor('#474747'),
                  hintText: localization.getLocaleData.enterQty.toString(),
                  controller: addvitalVM.fluidC,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    addvitalVM.notifyListeners();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: NeoButton(
                          func: () {
                            if (addvitalVM.fluidC.text != '') {
                              if (double.parse(addvitalVM.fluidC.text) <= 250) {
                                addvitalVM.maxvalue = double.parse(addvitalVM.fluidC.text);
                                addvitalVM.updateQtyValue = double.parse(addvitalVM.fluidC.text);
                                addvitalVM.notifyListeners();
                                Get.back();
                              } else {
                                Alert.show(localization.getLocaleData.youCanEnterMaximumQty.toString());
                                // addvitalVM.changeQtyC.clear();
                                // addvitalVM.notifyListeners();
                                //  Get.back();
                              }
                            } else {
                              Alert.show(localization.getLocaleData.pleaseEnterSomeQty.toString());
                            }
                          },
                          title: localization.getLocaleData.change.toString()),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: NeoButton(
                      func: () {
                        if (addvitalVM.fluidC.text != '') {
                          if (double.parse(addvitalVM.fluidC.text) > 250) {
                            addvitalVM.fluidC.clear();
                            addvitalVM.notifyListeners();
                            Get.back();
                          } else {
                            Get.back();
                          }
                        } else {
                          Get.back();
                        }
                      },
                      title: localization.getLocaleData.cancel.toString(),
                    ))
                  ],
                )
              ]),
            )));
  }
}

// class PageViewExample extends StatefulWidget {
//   const PageViewExample({super.key});
//
//   @override
//   State<PageViewExample> createState() => _PageViewExampleState();
// }
//
// class _PageViewExampleState extends State<PageViewExample>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   int _currentPageIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     AddVitalViewModal addvitalVM =
//     Provider.of<AddVitalViewModal>(context, listen: false);
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//
//     AddVitalViewModal addvitalVM =
//     Provider.of<AddVitalViewModal>(context, listen: false);
//     addvitalVM.pageController.dispose();
//     _tabController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final TextTheme textTheme = Theme.of(context).textTheme;
//     AddVitalViewModal addvitalVM =
//     Provider.of<AddVitalViewModal>(context, listen: true);
//     ManualFoodAssignDataModal data1 = addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[0];
//     ManualFoodAssignDataModal data2 =   addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[1];
//     ManualFoodAssignDataModal data3 =  addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[2];
//     ManualFoodAssignDataModal data4 =  addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[3];
//     ManualFoodAssignDataModal data5 =  addvitalVM.getManualFoodList.isEmpty ? ManualFoodAssignDataModal() : addvitalVM.getManualFoodList[4];
//     return SizedBox(
//       height: 700,
//       child: PageView(
//         physics: const NeverScrollableScrollPhysics(),
//         controller: addvitalVM.pageController,
//         onPageChanged: _handlePageViewChanged,
//         children: <Widget>[
//           IntakeMenusWidget(foodId: data1.foodID.toString(),
//             title: data1.foodName.toString(),
//             color: fluidIntakeList.firstWhere((element) =>
//             element['name'] == data1.foodName.toString())['color'], isBig: fluidIntakeList.firstWhere((element) =>
//             element['name'] == data1.foodName.toString())['isBig'],
//           ),IntakeMenusWidget(foodId: data1.foodID.toString(),
//             title: data2.foodName.toString(),
//             color: fluidIntakeList.firstWhere((element) =>
//             element['name'] == data2.foodName.toString())['color'], isBig: fluidIntakeList.firstWhere((element) =>
//             element['name'] == data2.foodName.toString())['isBig'],
//           ),IntakeMenusWidget(foodId: data1.foodID.toString(),
//             title: data3.foodName.toString(),
//             color: fluidIntakeList.firstWhere((element) =>
//             element['name'] == data3.foodName.toString())['color'], isBig: fluidIntakeList.firstWhere((element) =>
//             element['name'] == data3.foodName.toString())['isBig'],
//           ),IntakeMenusWidget(foodId: data1.foodID.toString(),
//             title: data4.foodName.toString(),
//             color: fluidIntakeList.firstWhere((element) =>
//             element['name'] == data4.foodName.toString())['color'], isBig: fluidIntakeList.firstWhere((element) =>
//             element['name'] == data4.foodName.toString())['isBig'],
//           ),IntakeMenusWidget(foodId: data1.foodID.toString(),
//             title: data5.foodName.toString(),
//             color: fluidIntakeList.firstWhere((element) =>
//             element['name'] == data5.foodName.toString())['color'], isBig: fluidIntakeList.firstWhere((element) =>
//             element['name'] == data5.foodName.toString())['isBig'],
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   void _handlePageViewChanged(int currentPageIndex) {
//     // Ensure currentPageIndex is within valid range
//     if (currentPageIndex >= 0 && currentPageIndex < _tabController.length) {
//       _tabController.index = currentPageIndex;
//       setState(() {
//         _currentPageIndex = currentPageIndex;
//       });
//     }
//   }
//   //
//   // void _updateCurrentPageIndex(int index) {
//   //   _tabController.index = index;
//   //   pageViewController.animateToPage(
//   //     index,
//   //     duration: const Duration(milliseconds: 400),
//   //     curve: Curves.easeInOut,
//   //   );
//   // }
//
//
// }

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 32.0,
            ),
          ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.background,
            selectedColor: colorScheme.primary,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 2) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: const Icon(
              Icons.arrow_right_rounded,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}
