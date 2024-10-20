import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:medvantage_patient/app_manager/theme/theme_provider.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/my_text_field_2.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../Localization/app_localization.dart';
import '../../ViewModal/addvital_view_modal.dart';
import '../../app_manager/alert_toast.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/bottomSheet/bottom_sheet.dart';
import '../../app_manager/bottomSheet/functional_sheet.dart';
import '../../app_manager/my_button.dart';
import '../../app_manager/neomorphic/neomorphic.dart';
import '../../app_manager/widgets/buttons/primary_button.dart';
import '../../app_manager/widgets/tab_responsive.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../app_manager/widgets/text_field/secondary_text_field.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import 'add_new_drink.dart';
import '../../theme/style.dart';

class IntakeMenusWidget extends StatefulWidget {
  final String title;
  final Color? color;
  final bool isBig;
  final String foodId;

  const IntakeMenusWidget(
      {super.key,
      required this.title,
      this.color,
      required this.isBig,
      required this.foodId});

  @override
  State<IntakeMenusWidget> createState() => _IntakeMenusWidgetState();
}

class _IntakeMenusWidgetState extends State<IntakeMenusWidget> {
  String? imgageName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    if (widget.title == 'water') {
      imgageName = '';
    } else if (widget.title == 'Green tea') {
      imgageName = 'assets/cup.png';
    } else if (widget.title == 'Coffee') {
      imgageName = 'assets/coffee trans.png';
    } else if (widget.title == 'Fruit Juice') {
      imgageName = '';
    } else if (widget.title == 'Milk') {
      imgageName = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == 'water') {
      imgageName = '';
    } else if (widget.title == 'Green tea') {
      imgageName = 'assets/cup.png';
    } else if (widget.title == 'Coffee') {
      imgageName = 'assets/coffee trans.png';
    } else if (widget.title == 'Fruit Juice') {
      imgageName = '';
    } else if (widget.title == 'Milk') {
      imgageName = '';
    }
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: true);
    AddVitalViewModal addvitalVM =
        Provider.of<AddVitalViewModal>(context, listen: true);

    ThemeProviderLd themeChange =
        Provider.of<ThemeProviderLd>(context, listen: true);
    final color1 = style.themeData(themeChange.darkTheme, context);
    return Container(
      color: themeChange.darkTheme ? AppColor.neoBGGrey1.withOpacity(.1) : Colors.grey.shade300 ,
      width: MediaQuery.of(context).size.width,
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: 600,
          thumbShape: SliderComponentShape.noOverlay,
          overlayShape: SliderComponentShape.noOverlay,
          valueIndicatorShape: SliderComponentShape.noOverlay,
          trackShape: const RectangularSliderTrackShape(),
          activeTickMarkColor: Colors.transparent,
          inactiveTickMarkColor: Colors.transparent,
        ),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Align(
            //       alignment: Alignment.centerRight,
            //       child: InkWell(
            //           onTap: (){
            //              Get.back();
            //           },
            //           child: const CircleAvatar(
            //               backgroundColor: Colors.grey,
            //               child: Center(child: Icon(Icons.close,size: 30,color: Colors.white,))))),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 0, 9),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //**
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Center(
                                  child: LiquidCustomProgressIndicator(
                                    value: double.parse(addvitalVM.getQtyValue
                                            .toStringAsFixed(0)) /
                                        addvitalVM.maxvalue,
                                    valueColor:
                                        AlwaysStoppedAnimation(widget.color!),
                                    backgroundColor: Colors.grey[200],
                                    direction: Axis.vertical,
                                    shapePath: buildDesign(widget.title
                                        .toString()), // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
                                  ),
                                ),
                                Visibility(
                                    visible: imgageName != '',
                                    child: Center(
                                        child: Image.asset(
                                      imgageName!,
                                      width: 500,
                                      height: 400,
                                      fit: BoxFit.fill,
                                      color: themeChange.darkTheme
                                          ? AppColor.blackLight2  : Colors.grey.shade300,
                                    ))),
                                SizedBox(
                                  height: 400,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Slider(
                                        activeColor: Colors.transparent,
                                        inactiveColor: Colors.transparent,
                                        value: double.parse(addvitalVM.getQtyValue
                                            .toStringAsFixed(2)),
                                        min: 0,
                                        max: double.parse(addvitalVM.maxvalue
                                            .toStringAsFixed(1)),
                                        divisions: 200,
                                        label: double.parse(addvitalVM.getQtyValue
                                                .toStringAsFixed(2))
                                            .round()
                                            .toString(),
                                        onChanged: (value) {
                                          addvitalVM.updateQtyValue = value;
                                          addvitalVM.fluidC.text =
                                              value.toString();
                                          addvitalVM.notifyListeners();
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                CustomBottomSheet.open(
                                  context,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: themeChange.darkTheme == true
                                          ? AppColor.neoBGGrey1
                                          : AppColor.neoBGWhite2,
                                    ),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Custom amount",
                                                style: MyTextTheme.largeBCB,
                                              ),
                                              Container(
                                                width: 45,
                                                child: IconButton(
                                                    onPressed: () {
                                                       Get.back();
                                                    },
                                                    icon: Icon(Icons.clear)),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 15),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: PrimaryTextField(
                                                      controller:
                                                          addvitalVM.fluidC,
                                                      hintText: 'ml',
                                                      textAlign: TextAlign.center,
                                                      maxLength:
                                                          !widget.isBig ? 3 : 4,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (val) {
                                                        if (widget.isBig &&
                                                            val <= 1000) {
                                                          addvitalVM
                                                                  .updateQtyValue =
                                                              val;
                                                        } else if (!widget
                                                                .isBig &&
                                                            val <= 250) {
                                                          addvitalVM
                                                                  .updateQtyValue =
                                                              val;
                                                        }
                                                        addvitalVM
                                                            .notifyListeners();
                                                      },
                                                    ),
                                                  ),
                                                  //Icon(Icons.close)
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              PrimaryButton(
                                                  width: 250,
                                                  color: Colors.orange,
                                                  onPressed: () async {
                                                    if (widget.isBig &&
                                                        int.parse(addvitalVM
                                                                .fluidC.text
                                                                .toString()) <=
                                                            1000) {
                                                      await addvitalVM
                                                          .fluidIntake(context);
                                                       Get.back();
                                                       Get.back();
                                                    } else if (!widget.isBig &&
                                                        int.parse(addvitalVM
                                                                .fluidC.text
                                                                .toString()) <=
                                                            250) {
                                                      await addvitalVM
                                                          .fluidIntake(context);
                                                       Get.back();
                                                       Get.back();
                                                    } else {
                                                      if (widget.isBig &&
                                                          int.parse(addvitalVM
                                                                  .fluidC.text
                                                                  .toString()) >
                                                              1000) {
                                                        Alert.show(
                                                            'Please Add Maximum 1000 ml Qty');
                                                      } else if (!widget.isBig &&
                                                          int.parse(addvitalVM
                                                                  .fluidC.text
                                                                  .toString()) >
                                                              250) {
                                                        Alert.show(
                                                            'Please Add Maximum 250 ml Qty');
                                                      }
                                                    }
                                                  },
                                                  title: widget.title)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    addvitalVM.getQtyValue.toStringAsFixed(1),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        color: themeChange.darkTheme
                                            ? Colors.white
                                            : AppColor.black.withOpacity(.8)),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ml",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.green.shade400),
                                        ),
                                        Text(
                                          "Total Intake",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: themeChange.darkTheme
                                                  ? Colors.white
                                                  : Colors.grey.shade800),
                                        ),
                                      ])
                                ],
                              ),
                            )
                          ],
                        ),

                        // Image.asset('assets/green_tea_cup.png'),
                        // SizedBox(height: 200,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      addvitalVM.updateIndex = addvitalVM.intakeIndex - 1;
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration:   BoxDecoration(
                            shape: BoxShape.circle, color:
    ( addvitalVM.intakeIndex - 1 >= 0 &&  addvitalVM.intakeIndex - 1 < addvitalVM.getManualFoodList.length)  ? Colors.green:Colors.grey),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 15,
                        )),
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  SizedBox(
                      width: 100,
                      child: Center(
                          child: Text(
                              addvitalVM.getManualFoodList.isEmpty
                                  ? ''
                                  : addvitalVM
                                      .getManualFoodList[
                                          addvitalVM.intakeIndex == 0
                                              ? 1
                                              : addvitalVM.intakeIndex == 1
                                                  ? 0
                                                  : addvitalVM.intakeIndex]
                                      .foodName
                                      .toString(),
                              style: MyTextTheme.mediumGCN.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w700)))),
                  SizedBox(
                    width: 35,
                  ),
                  InkWell(
                    onTap: () {
                      addvitalVM.updateIndex = addvitalVM.intakeIndex + 1;
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration:   BoxDecoration(
                            shape: BoxShape.circle, color:
     ( addvitalVM.intakeIndex + 1 >= 0 &&  addvitalVM.intakeIndex + 1 < addvitalVM.getManualFoodList.length)   ? Colors.green:Colors.grey),
                        child: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                          size: 15,
                        )),
                  ),
                ],
              ),
            ),


            Text((double.parse(addvitalVM.fluidC.text) ).toStringAsFixed(2).toString()+' '+"ml",style: MyTextTheme.largeBCN.copyWith(color:themeChange.darkTheme?Colors.white:AppColor.greyDark ),),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
              child: Row(
                children: [
                  Image.asset(themeChange.darkTheme
                      ? "assets/water_intake/add_water_qty_dark.png"
                      : "assets/water_intake/add_water_qty_light.png"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        addvitalVM.intakeQTYC.clear();
                        AlertDialogue().show(
                          context,
                          newWidget: [addWaterQuanitiyBottomsheet(localization)],
                        );
                      },
                      child: Text(
                        localization.getLocaleData.addEditQty.toString(),
                        style: themeChange.darkTheme
                            ? MyTextTheme.mediumWCN.copyWith(fontSize: 13,fontWeight: FontWeight.w600)
                            : MyTextTheme.mediumGCN.copyWith(fontSize: 13,color: AppColor.greyDark,fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  // Text("Repetition",
                  //     style: MyTextTheme.smallGCN.copyWith(
                  //         color: themeChange.darkTheme
                  //             ? AppColor.white
                  //             : AppColor.greyDark)),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // quantityaddingContainer(
                  //     child: Padding(
                  //   padding: const EdgeInsets.all(3.0),
                  //   child: Row(
                  //     children: [
                  //       InkWell(
                  //         onTap: (){
                  //           if(addvitalVM.itemCount>1){
                  //             addvitalVM.itemCount--;
                  //             addvitalVM.notifyListeners();
                  //           }
                  //         },
                  //         child: CircleAvatar(
                  //
                  //           maxRadius: 13,
                  //           backgroundColor: addvitalVM.itemCount<2?Colors.white:AppColor.green,
                  //
                  //           child: Icon(
                  //             Icons.arrow_back_ios_rounded,
                  //             color:  addvitalVM.itemCount<2?AppColor.greyDark:Colors.white,
                  //             size: 13,
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Expanded(
                  //         child: Text(
                  //           "0"+addvitalVM.itemCount.toString(),
                  //           style: MyTextTheme.mediumWCB.copyWith(
                  //               color:
                  //               themeChange.darkTheme ? Colors.grey.shade400 : AppColor.greyDark),
                  //         ),
                  //       ),
                  //       InkWell(
                  //         onTap: (){
                  //          if(addvitalVM.itemCount<5){
                  //            addvitalVM.itemCount++;
                  //            addvitalVM.notifyListeners();
                  //          }
                  //          else {
                  //
                  //          }
                  //         },
                  //         child: CircleAvatar(
                  //           maxRadius: 13,
                  //           backgroundColor: addvitalVM.itemCount>4?Colors.white:AppColor.green,
                  //           child: Icon(
                  //             Icons.arrow_forward_ios_sharp,
                  //             color: addvitalVM.itemCount>4?AppColor.greyDark:Colors.white,
                  //             size: 13,
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // )),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Wrap(
                crossAxisAlignment:WrapCrossAlignment.start ,
                alignment:WrapAlignment.start ,

                children: List.generate(
                    addvitalVM.getConfirmAddVital.length, (index) {

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: (){
                        if(double.parse(addvitalVM.getConfirmAddVital[index].toString())>=100){
                          addvitalVM.maxvalue=double.parse(addvitalVM.getConfirmAddVital[index]);

                        }
                        addvitalVM.updateQtyValue=double.parse(addvitalVM.getConfirmAddVital[index]);
                        addvitalVM.fluidC.text= addvitalVM.getConfirmAddVital[index].toString() ;
                        addvitalVM.notifyListeners();
                        addvitalVM.updateSelectedIndex =index;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: addvitalVM.getSelectedIndex==index?AppColor.darkgreen:AppColor.grey),
                            color:  themeChange.darkTheme
                                            ? AppColor.black.withOpacity(.4)
                                                       : Colors.white54,
                          // border: Border.all(color:Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              themeChange.darkTheme
                                  ? AppColor.darkshadowColor2
                                  : Colors.white,
                              themeChange.darkTheme
                                  ? AppColor.darkshadowColor2
                                  : Colors.white,

                              themeChange.darkTheme
                                  ? AppColor.darkshadowColor1
                                  : Colors.grey.shade300,
                              themeChange.darkTheme
                                  ? AppColor.darkshadowColor1
                                  : Colors.grey.shade400,

                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeChange.darkTheme
                                  ? AppColor.darkshadowColor2
                                  : AppColor.grey,
                              offset: const Offset(
                                .5,
                                1,
                              ),
                              blurRadius: 5,
                              spreadRadius: .5,
                            ),
                          ]),

                        padding: EdgeInsets.all(5),
                        child: Wrap(children: [
                          Text(addvitalVM.getConfirmAddVital[index].toString(),
                              style: themeChange.darkTheme
                                  ? MyTextTheme.mediumWCN.copyWith(
                                  fontSize: 13,color: addvitalVM.getSelectedIndex==index?AppColor.darkgreen:AppColor.grey,
                                  fontWeight: FontWeight.w800)
                                  : MyTextTheme.mediumGCN.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                              color: addvitalVM.getSelectedIndex==index?AppColor.darkgreen:AppColor.greyDark)),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "ml",
                            style: MyTextTheme.smallGCN.copyWith(color:  addvitalVM.getSelectedIndex==index?AppColor.darkgreen:AppColor.greyDark),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     addvitalVM.confirmAddVital.removeAt(index);
                          //     addvitalVM.notifyListeners();
                          //   },
                          //   child: Icon(
                          //     Icons.close,
                          //     color: themeChange.darkTheme
                          //         ? AppColor.white
                          //         : AppColor.greyDark,
                          //     size: 15,
                          //   ),
                          // )
                        ]),
                      ),
                    ),
                  );
                })),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NeoButton(
                      func: () async {
                        addvitalVM.updateSelectedFoodID =
                            widget.foodId.toString();
                        await CustomBottomSheet.open(context,
                            child: FunctionalSheet(
                              message:
                                 localization.getLocaleData.areYouSureYouWantTo.toString()+' ${widget.title}?',
                              buttonName:
                                  localization.getLocaleData.confirm.toString(),
                              onPressButton: () async {
                                //  Get.back();
                                await addvitalVM.fluidIntake(context);
                              },
                            ));
                        //  Get.back();
                      },
                      title: localization.getLocaleData.addFluidIntake.toString(),
                      textStyle: MyTextTheme.mediumGCB.copyWith(color:  themeChange.darkTheme? AppColor.black:AppColor.white,),
                    ),
                  ),
                ),
                // const SizedBox(width: 100,),
                ///
                //         InkWell(
                //             onTap: (){
                //               CustomBottomSheet.open(context,
                //                 child: Column(
                //                   // mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     Padding(
                //                       padding: const EdgeInsets.all(8.0),
                //                       child: Row(
                //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                         children: [
                //                           Text("Custom amount",style: MyTextTheme.largeBCB,),
                //                           Container(
                //                             width: 45,
                //                             child: IconButton(onPressed: (){
                //                                Get.back();
                //                             }, icon: Icon(Icons.clear)),
                //                           )
                //                         ],
                //                       ),
                //                     ),
                //
                //                     Padding(
                //                       padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 25),
                //                       child: Column(
                //                         children: [
                //                           Row(
                //                             children: [
                //                               Expanded(
                //                                 child: PrimaryTextField(
                //                                   controller: addvitalVM.fluidC,
                //                                   hintText: 'ml',
                //                                   textAlign: TextAlign.center,
                //                                   maxLength: !widget.isBig? 3:4,
                //                                   keyboardType: TextInputType.number,
                //                                   onChanged: (val){
                //                                     if(widget.isBig && val<=1000){
                //                                       addvitalVM.updateQtyValue = val;
                //                                     }
                //                                     else  if(!widget.isBig && val<=250){
                //                                       addvitalVM.updateQtyValue = val;
                //                                     }addvitalVM.notifyListeners();
                //
                //                                   },
                //                                 ),
                //                               ),
                //                               //Icon(Icons.close)
                //
                //                             ],
                //                           ),
                //
                //
                //                           const SizedBox(height: 15,),
                //                           PrimaryButton(width: 250,
                //                             color: Colors.orange,
                //                               onPressed: () async {
                //
                //                             if(widget.isBig && int.parse(addvitalVM.fluidC.text.toString())<=1000){
                //                               await  addvitalVM.fluidIntake(context);
                //                                Get.back();
                //                                Get.back();
                //                             }
                //                             else if(!widget.isBig && int.parse(addvitalVM.fluidC.text.toString())<=250){
                //                               await  addvitalVM.fluidIntake(context);
                //                                Get.back();
                //                                Get.back();
                //                             }
                //                             else{
                //                               if(widget.isBig && int.parse(addvitalVM.fluidC.text.toString())>1000){
                //                                 Alert.show('Please Add Maximum 1000 ml Qty');
                //                               }
                //                               else if(!widget.isBig && int.parse(addvitalVM.fluidC.text.toString())>250){
                //                                 Alert.show('Please Add Maximum 250 ml Qty');
                //                               }
                //                             }
                //
                //
                //
                //                           }, title: widget.title)
                //
                //                         ],
                //                       ),
                //                     ),
                //
                //
                //
                //                   ],
                //                 ),
                //               );
                //             },
                //             child: Image.asset('assets/water_intake/menus.png'))
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  quantityaddingContainer({child}) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    final themecolor = style.themeData(themeChange.darkTheme, context);
    return Container(
      width: 98,
      decoration: BoxDecoration(
          color: themecolor.hintColor,
          // border: Border.all(color:Colors.grey),
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeChange.darkTheme
                  ? AppColor.darkshadowColor2
                  : Colors.grey.shade300,
              themeChange.darkTheme
                  ? AppColor.darkshadowColor1
                  : Colors.grey.shade300,
              themeChange.darkTheme
                  ? AppColor.darkshadowColor1
                  : Colors.grey.shade400,
              themeChange.darkTheme
                  ? AppColor.black.withOpacity(.6)
                  : Colors.grey.shade400,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: themeChange.darkTheme
                  ? AppColor.darkshadowColor2
                  : AppColor.grey,
              offset: const Offset(
                .5,
                1,
              ),
              blurRadius: 5,
              spreadRadius: .5,
            ),
          ]),
      child: child,
    );
  }

  addWaterQuanitiyBottomsheet(ApplicationLocalizations localization) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    return Consumer<ThemeProviderLd>(builder: (__context, themeChange, _) {
      return Consumer<AddVitalViewModal>(
          builder: (BuildContext _context, addvitalVM, _) {
        return Form(
          key: addvitalVM.formKey1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: themeChange.darkTheme
                  ? AppColor.darkshadowColor2
                  : Colors.grey.shade300,
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(localization.getLocaleData.addEditGlassSize.toString(),
                        style: themeChange.darkTheme
                            ? MyTextTheme.mediumWCN
                                .copyWith(fontWeight: FontWeight.w700)
                            : MyTextTheme.mediumGCN
                                .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                         Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: themeChange.darkTheme
                            ? Colors.white
                            : AppColor.greyDark,
                      ),
                    )
                  ],
                ),
                Divider(
                  color:
                      themeChange.darkTheme ? Colors.grey : Colors.grey.shade400,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: PrimaryTextField(
                          style: themeChange.darkTheme?MyTextTheme.mediumWCN.copyWith(fontSize: 13,fontWeight:FontWeight.w600):MyTextTheme.mediumGCN.copyWith(fontSize: 13,fontWeight:FontWeight.w600),
                          prefixIcon: Image.asset("assets/water_intake/jug.png"),
                          keyboardType:TextInputType.number ,
                          validator: (value) {
                            if(value!.isEmpty){

                              return " Please Enter Quantity";
;                          }
                         else  if ((int.parse(value) < 30)||(int.parse(value)> 250)) {
                              return " enter value less between 30-250 ml";
                            }
                          },
                          onChanged: (val) {},
                          controller: addvitalVM.intakeQTYC,
                          hintTextColor: themeChange.darkTheme
                              ? AppColor.white
                              : AppColor.grey,
                          hintText: localization.getLocaleData.enterQty.toString(),
                          borderColor: Colors.transparent,
                          backgroundColor: themeChange.darkTheme
                              ? AppColor.greyDark.withOpacity(.6)
                              : Colors.white,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      localization.getLocaleData.ml.toString(),
                      style: MyTextTheme.mediumGCB,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: PrimaryButton(
                        icon: Icon(
                          Icons.add,
                          color: AppColor.white,
                        ),
                        onPressed: () {
                          if(addvitalVM.formKey1.currentState!.validate()
                          ){addvitalVM.updateaddintakeQty =
                                addvitalVM.intakeQTYC.text.toString();

                            addvitalVM.intakeQTYC.clear();
                          }
                        },
                        title:  localization.getLocaleData.add.toString(),
                        color: Colors.green.shade400,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeChange.darkTheme
                        ? AppColor.greyDark.withOpacity(.4)
                        : AppColor.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                            children: List.generate(
                                addvitalVM.getaddintakeQty.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:  themeChange.darkTheme
                                      ? AppColor.black.withOpacity(.4)
                                      : Colors.white54,
                                  // border: Border.all(color:Colors.grey),
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      themeChange.darkTheme
                                          ? AppColor.darkshadowColor2
                                          : Colors.white,
                                      themeChange.darkTheme
                                          ? AppColor.darkshadowColor2
                                          : Colors.white,

                                      themeChange.darkTheme
                                          ? AppColor.darkshadowColor1
                                          : Colors.grey.shade300,
                                      themeChange.darkTheme
                                          ? AppColor.darkshadowColor1
                                          : Colors.grey.shade400,

                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeChange.darkTheme
                                          ? AppColor.darkshadowColor2
                                          : AppColor.grey,
                                      offset: const Offset(
                                        .5,
                                        1,
                                      ),
                                      blurRadius: 5,
                                      spreadRadius: .5,
                                    ),
                                  ]),
                              padding: EdgeInsets.all(5),
                              child: Wrap(children: [
                                Text(addvitalVM.getaddintakeQty[index].toString(),
                                    style: themeChange.darkTheme
                                        ? MyTextTheme.mediumWCN.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800)
                                        : MyTextTheme.mediumGCN.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  localization.getLocaleData.ml.toString(),
                                  style: MyTextTheme.smallGCN,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {addvitalVM.notifyListeners();
                                    addvitalVM.confirmAddVital.removeWhere((element) =>
                                    element.toString()==addvitalVM.getaddintakeQty[index].toString());
                                    addvitalVM.addintakeQty.removeAt(index);
                                    print("nnnnnnnnnnnnnn ${ addvitalVM.getaddintakeQty.length}");

                                    addvitalVM.notifyListeners();
                                    print("nnnnnnnnnnnnnn ${ addvitalVM.confirmAddVital}");

                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: themeChange.darkTheme
                                        ? AppColor.white
                                        : AppColor.greyDark,
                                    size: 15,
                                  ),
                                )
                              ]),
                            ),
                          );
                        })),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () {
                          Get.back();
                        },
                        title:  localization.getLocaleData.cancel.toString(),
                        color: AppColor.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () {
                          // print("jjjjjjjj"+actChronicleVM.addVital.where((element) =>
                          // element["value"]==true).toList().toString());
                          if(addvitalVM.getaddintakeQty.isEmpty){

                            Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: localization.getLocaleData.enterQty.toString()));
                            // Alert.show( localization.getLocaleData.enterQty.toString());
                          }
                     else{
                            addvitalVM.updateConfirmAddVital=  addvitalVM.getaddintakeQty;
                             Get.back();
                          }
                        },
                        title:  localization.getLocaleData.confirm.toString(),
                        color: Colors.green.shade400,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
    });
  }

  buildDesign(val) {
    switch (val) {
      case 'water':
        return _buildGlassPath();
      case 'Green tea':
        return _buildBoxPath();
      case 'Coffee':
        return _buildBoxPath();
      case 'Milk':
        return _buildGlassPath();
      default:
        return _buildGlassPath();
    }
  }

  _buildBoxPath() {
    return Path()
      ..lineTo(0, 400)
      ..lineTo(500, 400)
      ..lineTo(500, 0.0)
      ..lineTo(500, 0.0)
      ..close();
  }

  _buildGlassPath() {
    return Path()
      ..lineTo(250 / 2 - 70, 400)
      ..lineTo(250 / 2 + 70, 400)
      ..lineTo(250, 0.0)
      ..lineTo(250, 0.0)
      ..close();
  }

  _buildBottle() {
    return Path()
      ..lineTo(30, 0)
      ..lineTo(30, 20)
      ..lineTo(35, 20)
      ..lineTo(0, 50)
      ..lineTo(0, 400)
      ..lineTo(150, 400)
      ..lineTo(150, 50)
      ..lineTo(115, 20)
      ..lineTo(120, 20)
      ..lineTo(120, 0)
      ..close();
  }
}

class AlertDialogue {
  show(
    context, {
    String? msg,
    String? firstButtonName,
    Color? firstButtonColor,
    Function? firstButtonPressEvent,
    String? secondButtonName,
    Function? secondButtonPressEvent,
    bool? showCancelButton,
    bool? showOkButton,
    bool? disableDuration,
    bool? checkIcon,
    List<Widget>? newWidget,
    String? title,
    String? subTitle,
  }) {

    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    var canPressOk = true;

    showCupertinoModalBottomSheet(
      shadow: BoxShadow(
          blurRadius: 0,
          color: newWidget == null ? Colors.transparent : Colors.black12,
          spreadRadius: 0),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: TabResponsive(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: newWidget != null
                  ? ListView(
                      shrinkWrap: true,
                      //  physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Center(
                          child: Container(
                            width: 200,
                            height: 5,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                color: Colors.black26,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              border: Border.all(color: AppColor.greyLight)),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: title != null,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title.toString(),
                                              style: MyTextTheme.largeBCB,
                                            ),
                                            Visibility(
                                                visible: subTitle != null,
                                                child: Text(
                                                  subTitle.toString(),
                                                  style: MyTextTheme.mediumGCB,
                                                )),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            if (canPressOk) {
                                              canPressOk = false;
                                               Get.back();
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.clear,
                                            color: Colors.black,
                                          ))
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: newWidget,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                border: Border.all(color: AppColor.greyLight)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Container(
                                //     decoration: BoxDecoration(
                                //         color: AppColor().primaryColorDark,
                                //         borderRadius: BorderRadius.only(
                                //           topLeft: Radius.circular(10),
                                //           topRight: Radius.circular(10),
                                //         )
                                //     ),
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Row(
                                //         children: [
                                //           Icon(
                                //             checkIcon?? false? Icons.check:Icons.info_outline,
                                //             color: Colors.white,
                                //           ),
                                //           SizedBox(width: 5,),
                                //           Expanded(
                                //             child: Text(alert.toString(),
                                //               style: MyTextTheme().mediumWCB),
                                //           ),
                                //         ],
                                //       ),
                                //     )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 20, 20, 20),
                                          child: Text(msg.toString(),
                                              textAlign: TextAlign.center,
                                              style: MyTextTheme.mediumGCB)),
                                      Visibility(
                                        visible: showCancelButton ?? false,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 8, 20, 8),
                                          child: MyButton(
                                            color: AppColor.greyLight,
                                            title: localization.getLocaleData.cancel.toString(),
                                            onPress: () {
                                              if (canPressOk) {
                                                canPressOk = false;
                                                 Get.back();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: showOkButton ?? false,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 8, 20, 8),
                                          child: MyButton(
                                            color: AppColor.primaryColor,
                                            title: localization.getLocaleData.ok.toString(),
                                            onPress: () {
                                              if (canPressOk) {
                                                canPressOk = false;
                                                 Get.back();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: firstButtonName != null,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 8, 20, 8),
                                          child: MyButton(
                                            color: firstButtonColor ??
                                                AppColor.primaryColor,
                                            title: firstButtonName.toString(),
                                            onPress: () {
                                              if (canPressOk) {
                                                canPressOk = false;
                                                firstButtonPressEvent!();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: secondButtonName != null,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 8, 20, 8),
                                          child: MyButton(
                                            color: AppColor.primaryColor,
                                            title: secondButtonName.toString(),
                                            onPress: () {
                                              if (canPressOk) {
                                                canPressOk = false;
                                                secondButtonPressEvent!();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );

    // return WidgetsBinding.instance.addPostFrameCallback((_){
    //
    //
    //
    // });
  }
}
