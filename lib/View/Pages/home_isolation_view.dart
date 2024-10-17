import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/custom_sd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Localization/app_localization.dart';
import '../../ViewModal/homeisolation_view_modal.dart';
import '../../app_manager/appBar/custom_app_bar.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/text_field/primary_date_time_field.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../authenticaton/user_repository.dart';

class HomeIsolation extends StatefulWidget {
  const HomeIsolation({Key? key}) : super(key: key);
  @override
  State<HomeIsolation> createState() => _HomeIsolationState();
}

class _HomeIsolationState extends State<HomeIsolation> {
  int _value = 0;
  int _homeValue = 0;
  int _covidvalue=0;

  get() async {
    HomeIsolationViewModal homeIsolationVM =
        Provider.of<HomeIsolationViewModal>(context, listen: false);
    await homeIsolationVM.HospitalListForHomeIsolation(context);

    UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
 homeIsolationVM.nameC.text=userRepository.getUser.patientName.toString();
    homeIsolationVM.contactC.text=userRepository.getUser.mobileNo.toString();
  }

  @override
  void initState() {
    get();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    HomeIsolationViewModal homeIsolationVM =
    Provider.of<HomeIsolationViewModal>(context, listen: true);
    // HomeIsolationViewModal homeIsolationVM =
    return ColoredSafeArea(
      child: SafeArea(
          child: Scaffold(backgroundColor: AppColor.white,
            appBar:   CustomAppBar(primaryBackColor: AppColor.greyDark,
              title: localization.getLocaleData.homeIsolation.toString(),
              actions: [
              InkWell(
              onTap: () {},
              child: Icon(
                Icons.notifications_none,
                color: AppColor.greyDark,
              ),
            ),SizedBox(width: 5,),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColor.greyDark,
                ),
              ),SizedBox(width: 10,)
            ],),
        body: Column(
          children: [
            // HomeIsolationAppBar(),
            Expanded(
              child: ListView(children: [
                // SizedBox(
                //   height: 15,
                // ),
                CovidCareTip(),
                SizedBox(
                  height: 5,
                ),
                HomeIsolationRequestText(),
              ]),
            ),
            Divider(
              thickness: 2,
              color: AppColor.greyVeryLight,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      homeIsolationVM.getPackageName.toString(),

                      style: MyTextTheme.mediumBCB
                          .copyWith(color: AppColor.greyDark),
                    ),
                  ),
                  InkWell(onTap: () async {
                  await  homeIsolationVM.onPressedContinue(context);
                  },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(22, 10, 22, 10),
                      color: AppColor.primaryColor,
                      child: Center(
                          child: Text(
                        localization.getLocaleData.continueText.toString(),
                        style: MyTextTheme.largeWCB,
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  // Header portion
  HomeIsolationAppBar() {

    HomeIsolationViewModal homeIsolationVM =
        Provider.of<HomeIsolationViewModal>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                   Get.back();
                },
                child: Icon(
                  Icons.arrow_back_outlined,
                  color: AppColor.greyVeryLight,
                  size: 25,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Expanded(child: SizedBox()),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.notifications_none,
                  color: AppColor.greyVeryLight,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColor.greyVeryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//know more
  CovidCareTip() {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(
          children: [
            Image.asset('assets/dashboard_image/covid_care_girl.png'),
            Positioned(
                top: 10,
                left: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     localization.getLocaleData.covidCareText.toString(),
                      style: MyTextTheme.veryLargeWCB.copyWith(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(localization.getLocaleData.covidCareTipDiscription.toString(),

                      style: MyTextTheme.smallWCN.copyWith(height: 1.4),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      color: AppColor.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(
                         localization.getLocaleData.knowMore.toString(),
                          style: MyTextTheme.smallBCB
                              .copyWith(color: AppColor.blue),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        )
      ]),
    );
  }

  //home isolation Request
  HomeIsolationRequestText() {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    HomeIsolationViewModal homeIsolationVM =
        Provider.of<HomeIsolationViewModal>(context, listen: true);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.getLocaleData.homeIsoRequest.toString(),
                style: MyTextTheme.mediumBCB
                    .copyWith(color: AppColor.greyDark),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                localization.getLocaleData.homeIsoDescription.toString(),
                style: MyTextTheme.smallGCN
                    .copyWith(color: AppColor.greyDark),
              )
            ],
          ),
        ),
        Divider(
          thickness: 6,

          color: AppColor.greyVeryLight,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:
            [
                PrimaryTextField(enabled: false,
            controller:homeIsolationVM.nameC ,
            hintText: localization.getLocaleData.enterName.toString(),
            hintTextColor: AppColor.greyDark,
            backgroundColor: AppColor.greyVeryLight,
                ),
                SizedBox(
            height: 8,
                ),
                PrimaryTextField(enabled: false,
            controller: homeIsolationVM.contactC,

            hintText: localization.getLocaleData.enterNo.toString(),
            hintTextColor: AppColor.greyDark,
            backgroundColor: AppColor.white,
                ),
                SizedBox(height: 8),
                CustomSD(
            label: localization.getLocaleData.selectHospital.toString(),
            listToSearch: homeIsolationVM.getHospitalList,
            valFrom: 'name',
            onChanged: (value) {
              print(value.toString());
              if(value!=null){
                homeIsolationVM.updateHospitalId=int.parse(value['id'].toString());
              }


            },
                ),
                SizedBox(
            height: 8,
                ),
                PrimaryTextField(
            controller: homeIsolationVM.comorbidC,
            hintText: localization.getLocaleData.enterComorbid.toString(),
            hintTextColor: AppColor.greyDark,
                ),
                Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(localization.getLocaleData.douHaveAnySymptoms.toString(),
                        style: MyTextTheme.mediumBCB
                            .copyWith(color: AppColor.greyDark))),
                Radio(
                    value: 1,
                    groupValue: _value,
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        _value = value as int;
                      });
                    }),
                Text(
                localization.getLocaleData.yes.toString(),
                  style: MyTextTheme.mediumBCB
                      .copyWith(color: AppColor.greyDark),
                ),
                Radio(
                    value: 2,
                    groupValue: _value,
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        _value = value as int;
                      });
                    }),
                Text(localization.getLocaleData.no.toString(),
                    style: MyTextTheme.mediumBCB
                        .copyWith(color: AppColor.greyDark))
              ],
            ),
                ),

                Visibility(visible: _value==1,
            child: Column(
              children: [
                PrimaryTextField(
                  controller: homeIsolationVM.symptomsC,
                  hintText: localization.getLocaleData.enterSymptoms.toString(),
                  hintTextColor: AppColor.greyDark,
                ),SizedBox(height: 8,),

                PrimaryTextField(
                  controller: homeIsolationVM.symptomsdateC,
                  hintText:localization.getLocaleData.dateOnSymptoms.toString(),
                  hintTextColor: AppColor.greyDark,
                ),
              ],
            ),
                ),
              ]),
          ),
        ),
        Divider(
          thickness: 6,
          height: 1,
          color: AppColor.white,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: homeIsolationVM.homeCarePackageList.length,
          itemBuilder: (BuildContext context, int index) {


          return Container(
            height: 40,
            color: AppColor.white,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  Radio(
                      value: int.parse(homeIsolationVM.homeCarePackageList[index]['id'].toString()),
                      groupValue: _homeValue,
                      onChanged: (value) {
                        print(value);
                        homeIsolationVM.updatePackageId=int.parse(value.toString());
                        homeIsolationVM.updatePackageName=homeIsolationVM.homeCarePackageList[index]["packageName"].toString()+'  \u{20B9}'+
                            homeIsolationVM.homeCarePackageList[index]["packagePrice"];

                        setState(() {
                          _homeValue = value as int;
                        });
                      }),
                  Expanded(
                    child: Text(
                     homeIsolationVM.homeCarePackageList[index]['packageName'].toString(),
                      style: MyTextTheme.mediumBCB
                          .copyWith(color: AppColor.black12),
                    ),
                  ),
                  Text(
                    '\u{20B9}',
                    style: MyTextTheme.mediumGCN
                        .copyWith(color: AppColor.greyDark, fontSize: 20),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                   homeIsolationVM.homeCarePackageList[index]['packagePrice'],
                    style: MyTextTheme.mediumBCB
                        .copyWith(color: AppColor.black12),
                  )
                ],
              ),
            ),
          );
        },),

        Divider(
          color: AppColor.white,
          thickness: 6,
        ),
        Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(localization.getLocaleData.undergoCovidTest.toString(),
                          style: MyTextTheme.mediumBCB
                              .copyWith(color: AppColor.greyDark))),
                  Radio(
                      value: 1,
                      groupValue: _covidvalue,
                      onChanged: (value) {
                        setState(() {

                          _covidvalue = value as int;
                        });
                      }),
                  Text(localization.getLocaleData.yes.toString(),
                      style: MyTextTheme.mediumBCB
                          .copyWith(color: AppColor.greyDark)),
                  Radio(
                      value: 2,
                      groupValue: _covidvalue,
                      onChanged: (value) {
                        setState(() {
                          _covidvalue = value as int;
                        });
                      }),
                  Text(localization.getLocaleData.no.toString(),
                      style: MyTextTheme.mediumBCB
                          .copyWith(color: AppColor.greyDark))
                ],
              ),
            ),
            Visibility(visible: _covidvalue==1,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSD(
                      label: localization.getLocaleData.selTestType.toString(),
                      listToSearch: homeIsolationVM.getTestType(context),
                      valFrom: 'test',
                      onChanged: (value) {
                        homeIsolationVM.updateTestTypeId=int.parse(value['id'].toString());
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // DateTimePicker(
                    //   controller: homeIsolationVM.covidtestdateC,
                    //   firstDate:   DateTime((DateTime.now().year-10)) ,
                    //   lastDate:    DateTime.now(),
                    //   dateLabelText: "Date",
                    //   onChanged: (val)=>print(val),
                    //   validator: (val){
                    //     print(val);
                    //     return null;
                    //   },
                    //   onSaved: (val)=>print(val),
                    // ),
                    PrimaryDateTimeField( controller: homeIsolationVM.covidtestdateC ,
                      hintText: "Select Covid TestDate",
                      hintTextColor: AppColor.greyDark,
                    ),

                    // CustomSD(label:localization.getLocaleData.covidTestDate.toString() ,
                    //     listToSearch: ,
                    //     valFrom: valFrom,
                    //     onChanged: onChanged),
                    // PrimaryTextField(
                    //   controller: homeIsolationVM.covidtestdateC,
                    //   hintText:localization.getLocaleData.covidTestDate.toString(),
                    //   hintTextColor: AppColor.greyDark,
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    PrimaryTextField(
                      controller: homeIsolationVM.allergiesC,
                      hintText: localization.getLocaleData.enterAllergies.toString(),
                      hintTextColor: AppColor.greyDark,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomSD(
                      label: localization.getLocaleData.selectLifeSupport.toString(),
                      listToSearch: homeIsolationVM.lifeSupportList,
                      valFrom: 'life',
                      onChanged: (value) {
                        homeIsolationVM.updateLifeSupportId=int.parse(value['id'].toString());


                      },
                    ),
                    SizedBox(height: 10,),
                    Visibility(visible: homeIsolationVM.getLifeSupportId==2,
                      child: PrimaryTextField(
                        hintText: "Type o2 value here",
                        hintTextColor: AppColor.greyDark,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
