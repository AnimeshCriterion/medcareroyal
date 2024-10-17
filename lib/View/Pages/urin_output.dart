import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/ViewModal/addvital_view_modal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/bottom_sheet.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_manager/bottomSheet/functional_sheet.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../assets.dart';
import '../../theme/theme.dart';

class UrinOutputView extends StatefulWidget {
  const UrinOutputView({super.key});

  @override
  State<UrinOutputView> createState() => _UrinOutputViewState();
}

class _UrinOutputViewState extends State<UrinOutputView> {
  double value = 75;

  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }

  get() async {
    AddVitalViewModal addvitalVM =
    Provider.of<AddVitalViewModal>(context, listen: false);

    await   addvitalVM.urinHistory(context);
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    AddVitalViewModal addvitalVM =
    Provider.of<AddVitalViewModal>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(
          child: Scaffold(
              key: scaffoldKey,
              backgroundColor: themeChange.darkTheme? Colors.black:Colors.white,

              drawer: MyDrawer(),
              // appBar: AppBar(
              //   title: Text(localization.getLocaleData.urineOutput.toString()),
              //   backgroundColor: AppColor.primaryColor,
              // ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(localization.getLocaleData.history.toString(),
                          style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 0,color: themeChange.darkTheme==true?Colors.white70:null),),

                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Row(
                              //   children: [
                              //   Expanded(flex: 2,
                              //     child: PrimaryTextField(
                              //       keyboardType: TextInputType.number,
                              //       textAlign: TextAlign.center,
                              //       hintText: localization.getLocaleData.enterValueInml.toString(),
                              //       controller: addvitalVM.urineC,
                              //       onChanged: (val) {
                              //          addvitalVM.notifyListeners();
                              //       },
                              //     ),
                              //   ),SizedBox(width: 10,),
                              //
                              //   Expanded(
                              //     child: PrimaryButton(width: 80,
                              //       onPressed: () async {
                              //         await CustomBottomSheet.open(context,
                              //             child: FunctionalSheet(
                              //               message:
                              //               'Are you sure you want to ${addvitalVM.isUpdate? 'update':'add'} urine output?',
                              //               buttonName: localization.getLocaleData.confirm.toString(),
                              //               onPressButton: () async {
                              //                 if( addvitalVM.isUpdate){
                              //                await     addvitalVM
                              //                         .updatePatientOutput(context);
                              //                   }
                              //                 else{
                              //                   await addvitalVM
                              //                       .addVitalsDataUrine(context);
                              //                 }
                              //                 },
                              //             ));
                              //       },
                              //       title: addvitalVM.isUpdate? localization.getLocaleData.update.toString():localization.getLocaleData.save.toString(),
                              //     ),
                              //   )
                              // ],),
                              SizedBox(height: 10,),
                              // Text(localization.getLocaleData.history.toString(),style: MyTextTheme.largeGCB,),
                              Container(
                                color: themeChange.darkTheme?  AppColor.white:Colors.black ,
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(localization.getLocaleData.urineQty.toString(),style: MyTextTheme.mediumWCB.copyWith(
                                              color: themeChange.darkTheme?  AppColor.black:Colors.white
                                            ),),
                                          )),
                                      Container(
                                        color: themeChange.darkTheme?  AppColor.black:Colors.white,
                                        width: 1,
                                      ),
                    
                                      Expanded(flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(child: Text(localization.getLocaleData.time.toString(),style: MyTextTheme.mediumWCB.copyWith(
                                                color: themeChange.darkTheme?  AppColor.black:Colors.white
                                            ),),),
                                          )),
                                      Container(
                                        color: themeChange.darkTheme?  AppColor.black:Colors.white,
                                        width: 1,
                                      ),
                    
                                      Expanded(flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(child: Text(localization.getLocaleData.Action.toString(),style: MyTextTheme.mediumWCB.copyWith(
                                                color: themeChange.darkTheme?  AppColor.black:Colors.white
                                            ),),),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              ...List.generate(addvitalVM.getUrinOutputList.length, (index) {
                    
                                var urinData=addvitalVM.getUrinOutputList[index];
                                return    Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(children: [
                                        Expanded(flex: 4,
                                            child: Text(urinData["quantity"].toString()+' '+urinData["unitName"].toString(),style: MyTextTheme.mediumWCB.copyWith(
                                                color: themeChange.darkTheme?  AppColor.white:Colors.black
                                            ), )),
                                        Expanded(flex:4,
                                            child: Text(DateFormat('dd MMM yyyy hh:mm a').format(DateFormat('dd/MM/yyyy hh:mm a').parse(urinData["outputDate"])).toString(),style: MyTextTheme.mediumWCB.copyWith(
                                                color: themeChange.darkTheme?  AppColor.white:Colors.black
                                            ),)),
                                        Expanded(flex:3,
                                            child: Row(
                                              children: [
                                                // InkWell(
                                                //   onTap: () async {
                                                //
                                                //     addvitalVM.urineC.text=urinData['quantity'].toString();
                                                //     print('nnnnn '+addvitalVM.urineC.text.toString());
                                                //     addvitalVM.updateSelectedPmID=urinData['pmID'].toString();
                                                //     addvitalVM.updateSelectedID=urinData['id'].toString();
                                                //     addvitalVM.isUpdate=true;
                                                //     addvitalVM.notifyListeners();
                                                //     // await CustomBottomSheet.open(context,
                                                //     //     child: FunctionalSheet(
                                                //     //       message:
                                                //     //       'Are you sure you want to update?',
                                                //     //       buttonName: 'Confirm',
                                                //     //       onPressButton: () async {
                                                //     //         await  addvitalVM.updatePatientOutput(context,
                                                //     //           id: urinData['id'].toString(),
                                                //     //           pmID: urinData['pmID'].toString(),  );
                                                //     //       },
                                                //     //     ));
                                                //
                                                //
                                                //   },
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.all(8.0),
                                                //     child: Icon(Icons.edit,color: AppColor.blue,),
                                                //   ),
                                                // ),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        await CustomBottomSheet.open(context,
                                                            child: FunctionalSheet(
                                                              message:
                                                              localization.getLocaleData.areYouSureYouWantToDelete.toString(),
                                                              buttonName: localization.getLocaleData.confirm.toString(),
                                                              onPressButton: () async {
                                                                await  addvitalVM.deletePatientOutput(context,
                                                                  id: urinData['id'].toString(),
                                                                  pmID: urinData['pmID'].toString(),  );
                                                              },
                                                            ));


                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Icon(Icons.delete,color: AppColor.red,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ))
                                      ],),
                                    )
                                  ],
                                );})
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}