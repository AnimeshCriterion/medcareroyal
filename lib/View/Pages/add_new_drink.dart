import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/Modal/ManualFoodAssignDataModal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ViewModal/addvital_view_modal.dart';
import '../../app_manager/comman_widget.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import 'drawer_view.dart';

class AddNewDrink extends StatefulWidget {
  const AddNewDrink({super.key});

  @override
  State<AddNewDrink> createState() => _AddNewDrinkState();
}

class _AddNewDrinkState extends State<AddNewDrink> {
  ThemeProviderLd themeChangeProvider = new ThemeProviderLd();
  @override
  void initState() {
// TODO: implement initState
    super.initState();
    get();
  }
  String toCamelCase(String input) {
    if (input.isEmpty) return input;

    // Split the string by spaces or underscores, and remove any empty strings
  var data=  input.split('')[0].toString().toUpperCase()+ input.substring(1);

    return data;
  }

  get() async {
    AddVitalViewModal addvitalVM =
        Provider.of<AddVitalViewModal>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await addvitalVM.manualFoodAssign(context);
    });
    themeChangeProvider.darkTheme = await themeChangeProvider.getTheme();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    AddVitalViewModal addvitalVM =
    Provider.of<AddVitalViewModal>(context, listen: true);

    final themeProvider = Provider.of<ThemeProviderLd>(context, listen: true);
    return  ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(key: scaffoldKey,drawer: MyDrawer(),
appBar: AppBar(title: Text(localization.getLocaleData.history.toString(),style: MyTextTheme.largeWCN.copyWith(
  color: themeProvider.darkTheme?AppColor.white:AppColor.black,
),),
leading: InkWell(
onTap: (){
Get.back();
},
child: Icon(Icons.arrow_back,color:themeProvider.darkTheme? AppColor.white:AppColor.black,)),
backgroundColor:themeProvider.darkTheme? AppColor.black:Colors.white
),
          body: Container(
           color: themeProvider.darkTheme ?AppColor.bgDark: AppColor.bgWhite,
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //       begin: Alignment.bottomCenter,
            //       end: Alignment.topCenter,
            //       colors: [
            //         themeProvider.darkTheme?
            //              AppColor.neoBGGrey2
            //             : Colors.grey.withOpacity(.3),
            //         themeProvider.darkTheme ?
            //            AppColor.neoBGGrey1
            //             : Colors.grey.withOpacity(.3),
            //         // themeProvider.darkTheme
            //         //     ? AppColor.neoBGGrey1
            //         //     : AppColor.grey.withOpacity(.2),
            //       ]
            //   ),
            // ),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       // InkWell(
                    //       //   onTap: (){
                    //       //      Get.back();
                    //       //   },
                    //       //   child: Padding(
                    //       //     padding: const EdgeInsets.all(8.0),
                    //       //     child: Icon(Icons.arrow_back_ios,color: themeChange.darkTheme? Colors.white:Colors.grey,),
                    //       //   ),
                    //       // ),
                    //       InkWell(
                    //           onTap: (){
                    //              Get.back();
                    //
                    //
                    //           },
                    //           child:Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Icon(Icons.arrow_back_ios,color: themeProvider.darkTheme? Colors.white:Colors.grey,),
                    //           ),),
                    //
                    //       Text(localization.getLocaleData.history.toString(),
                    //         style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 0,color: themeProvider.darkTheme==true?Colors.white70:null),),
                    //
                    //     ],
                    //   ),
                    // ),

// Align(
// alignment: Alignment.centerRight,
// child: InkWell(
// onTap: (){
//  Get.back();
// },
// child: CircleAvatar(
// backgroundColor: Colors.grey,
// child: Center(child: Icon(Icons.close,size: 30,color: Colors.white,))))),
// Text("Add New Drink",style: MyTextTheme.largeBCB,),
// SizedBox(height: 20,),
// Padding(
// padding: EdgeInsets.only(left: 25.0, right: 25.0),
// child: PrimaryButton(
// color: AppColor.blue,
// icon: Icon(Icons.add,color: Colors.white,),
// onPressed: () {
// // MyNavigator.push(context, WaterBodyWidget());
// },
// title: 'Create New Drink ',
// ),
// ),
//
// Padding(
// padding: const EdgeInsets.all(18.0),
// child: Text("Click on the Checkbox to drinks that you want to show up on the sceen",textAlign: TextAlign.center,),
// ),
                    ///
// Container(
// margin: const EdgeInsets.symmetric(horizontal:20),
// color: AppColor.secondaryColor,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(localization.getLocaleData.drink.toString(),style: MyTextTheme.mediumWCB,),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(localization.getLocaleData.consumedQtyml.toString(),style: MyTextTheme.mediumWCB,),
// )
// ],
// ),
// ),
                    Expanded(
                      child: CommonWidgets().showNoData(
                        title:localization.getLocaleData.noDataFound.toString(),
                        show: (addvitalVM.getShowNoData &&
                            (addvitalVM.getManualFoodList
                                .isEmpty)),
                        loaderTitle: localization.getLocaleData.Loading.toString(),
                        showLoader: (!addvitalVM.getShowNoData  &&
                            (addvitalVM.getManualFoodList
                                .isEmpty)),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: addvitalVM.getManualFoodList.length,
                          itemBuilder: (context, int index) {
                            ManualFoodAssignDataModal data =
                                addvitalVM.getManualFoodList[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        themeProvider.darkTheme == true
                                            ? AppColor.blackLight
                                            : AppColor.white,
                                        themeProvider.darkTheme == true
                                            ? AppColor.black
                                            : AppColor.neoBGWhite2,
                                      ]),
                                  border: Border.all(
                                      color: themeProvider.darkTheme == true
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade500)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: themeProvider.darkTheme==true,
                                      replacement: Image.asset(
                                'assets/water_intake_light/${toCamelCase(data.foodName.toString()) }.png',
                                width: 35,
                                height: 35,
                              ),
                                      child: Image.asset(
                                        'assets/water_intake2/${toCamelCase(data.foodName.toString())}.png',
                                        width: 35,
                                        height: 35,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Text(toCamelCase(data.foodName.toString()),
                                            style: MyTextTheme.mediumWCB.copyWith(
                                                 color:
                                                themeProvider.darkTheme == true
                                                        ? Colors.white
                                                        : Colors.black87))),
                                    Text(data.quantity.toString() == ''
                                          ? '0 '
                                          : '${data.quantity} ' ,
                                      style: MyTextTheme.largeGCB
                                          .copyWith(color: AppColor.neoGreen),
                                    ), Text('  ml' ,
                                      style: MyTextTheme.mediumGCN
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, int index) {
                            return const SizedBox();
                          },
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
