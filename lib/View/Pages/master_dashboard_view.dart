


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/View/Pages/drawer_view.dart';
import 'package:medvantage_patient/ViewModal/MasterDashoboardViewModal.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/bottom_sheet.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:provider/provider.dart';

import '../../app_manager/theme/text_theme.dart';

class MasterDashboardView extends StatefulWidget {
  const MasterDashboardView({super.key});

  @override 
  State<MasterDashboardView> createState() => _MasterDashboardViewState();
}

class _MasterDashboardViewState extends State<MasterDashboardView> { 
  @override



  Widget build(BuildContext context) {
    MasterDashboardViewModal drawerMenuListVM =
    Provider.of<MasterDashboardViewModal>(context, listen: true);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    return Container(color: themeChange.darkTheme? AppColor.black:Colors.white,
      child: SafeArea(
        child: Scaffold(
          key: drawerMenuListVM.scaffoldKey,
          drawer: MyDrawer(),
          body: WillPopScope(
            onWillPop: (){


              // print('nnnnvnnnnnvn '+drawerMenuListVM.getIsSelectedDrawer.toString());
              // if(drawerMenuListVM.getIsSelectedDrawer){
              //   drawerMenuListVM.updateIsSelectedDrawer=false;
              //   //  Get.back();
              // }
              if(drawerMenuListVM.getSelectedPage!=''){
                drawerMenuListVM.updateSelectedPage='';
              }
              else{
                changeQtyAlert2();
              }
              print('nnnnvnnnnnvn '+drawerMenuListVM.getSelectedPage.toString());
              return Future(() => false);
            },
            child: Column(
              children: [
                Expanded(child: drawerMenuListVM.onSelectPage())
              ],
            ),
          ),
        ),
      ),
    );
  }


  changeQtyAlert2() {
    final themeProvider = Provider.of<ThemeProviderLd>(context, listen: false);

    return  CustomBottomSheet.open(context,
        child:  Container(
            decoration:  BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      themeProvider.darkTheme==true?AppColor.neoBGGrey2:AppColor.neoBGWhite1,
                      themeProvider.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                      themeProvider.darkTheme==true?AppColor.neoBGGrey1:AppColor.neoBGWhite2,
                    ]
                ),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column (children:[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Are you sure you want to close the app? ',style: MyTextTheme.largeWCB.copyWith(color:   themeProvider.darkTheme==true? Colors.white:Colors.black),),
                ),
                const SizedBox(height: 40,),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        color: Colors.grey,
                          onPressed: () {
                            exit(0);
                          },
                          title: 'Yes'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: PrimaryButton(
                          color: AppColor.neoGreen,
                          onPressed: () {
                             Get.back();
                          },
                          title: 'Cancel',

                        ))
                  ],
                ),
                const SizedBox(height: 20,),]),
            ))
    );

  }


}
