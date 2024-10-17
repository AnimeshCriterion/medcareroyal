import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medvantage_patient/ViewModal/editprofile_view_modal.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/neomorphic/neomorphic.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/custom_sd.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/my_text_field_2.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_date_time_field.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Localization/app_localization.dart';
import '../../app_manager/neomorphic/hex.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import 'drawer_view.dart';

class EditProfile extends StatefulWidget {
  final bool isaddmember;

  EditProfile({
    Key? key,
    this.isaddmember = false,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  get(context) async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    EditProfileViewModal editProfileVM =
        Provider.of<EditProfileViewModal>(context, listen: false);
    editProfileVM.clearData();

    if (!widget.isaddmember) {
      editProfileVM.nameC.text = userRepository.getUser.patientName.toString();
      editProfileVM.emailC.text = userRepository.getUser.emailID.toString();
      editProfileVM.phoneC.text = userRepository.getUser.mobileNo.toString();
      editProfileVM.aleternamephoneC.text =
          userRepository.getUser.alternateMobileNo.toString();
      editProfileVM.heightC.text = userRepository.getUser.height.toString();
      editProfileVM.addressline2.text =
          userRepository.getUser.addressLine2.toString();
      editProfileVM.addressC.text = userRepository.getUser.address.toString();
      editProfileVM.city.text = userRepository.getUser.address.toString();
      // editProfileVM.pincode.text = userRepository.getUser.p.toString();
      editProfileVM.heightC.text = userRepository.getUser.height.toString();
      editProfileVM.weightC.text = userRepository.getUser.weight.toString();
      editProfileVM.dobC.text = userRepository.getUser.dob.toString() == ''
          ? ''
          : DateFormat('yyyy-MM-dd').format(DateFormat("dd/MM/yyyy")
              .parse(userRepository.getUser.dob.toString()));
      print('nnnnnnnnnnnnnn' + userRepository.getUser.gender.toString());
      editProfileVM.updateSelectedGender =
          userRepository.getUser.gender.toString() == 'Male' ? 1 : 2;
      print('nnnnnnnnnnnnnn' + editProfileVM.getSelectedGender.toString());
      editProfileVM.addressC.text = userRepository.getUser.address.toString();
    }
  }

  int _value = 0;

  @override
  void initState() {
    get(context);
    // TODO: implement initState
    super.initState();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedGender = 0;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: true);
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: true);
    EditProfileViewModal editProfileVM =
        Provider.of<EditProfileViewModal>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          drawer: const MyDrawer(),
          backgroundColor: AppColor.greyVeryLight,
          body: Container(
            height: Get.height,
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         themeChange.darkTheme == true
            //             ? AppColor.neoBGGrey2
            //             : AppColor.neoBGWhite1,
            //         themeChange.darkTheme == true
            //             ? AppColor.neoBGGrey1
            //             : AppColor.neoBGWhite2,
            //         themeChange.darkTheme == true
            //             ? AppColor.neoBGGrey1
            //             : AppColor.neoBGWhite2,
            //       ]),
            // ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  themeChange.darkTheme == true ? AppColor.bgDark : AppColor.bgWhite,
                  themeChange.darkTheme == true ? AppColor.bgDark : AppColor.bgWhite,
                  themeChange.darkTheme == true ? AppColor.bgDark : AppColor.bgWhite,
                  themeChange.darkTheme == true ? AppColor.bgDark : AppColor.bgWhite,
                  themeChange.darkTheme == true ? AppColor.bgDark : AppColor.bgWhite,
                ])),
            child: Form(
              key: editProfileVM.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: RawScrollbar(
                thickness: 3,
                thumbVisibility: true,
                interactive: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
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
                            child: Image.asset(
                                themeChange.darkTheme == true
                                    ? ImagePaths.menuDark
                                    : ImagePaths.menulight,
                                height: 40)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.getLocaleData.user.toString(),
                              style: MyTextTheme.largeGCB.copyWith(
                                  fontSize: 21,
                                  height: 0,
                                  color: themeChange.darkTheme == true
                                      ? Colors.white70
                                      : null),
                            ),
                            Text( localization.getLocaleData.profile.toString(),
                              style: MyTextTheme.largeBCB.copyWith(
                                  fontSize: 25,
                                  height: 1,
                                  color: themeChange.darkTheme == true
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Container(
                    //   height: 110,
                    //   decoration: const BoxDecoration(shape: BoxShape.circle),
                    //   child:   CircleAvatar(
                    //     radius: 110.0,
                    //     // backgroundImage:  NetworkImage(
                    //     //     'https://miro.medium.com/v2/resize:fit:640/format:webp/1*Ld1KM2WSfJ9YQ4oeRf7q4Q.jpeg'),
                    //     backgroundColor: Colors.transparent,
                    //     child: Icon(Icons.person,size: 74,,c),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 53,
                        backgroundColor:
                        themeChange.darkTheme == true
                            ? Colors.grey.shade400
                            : Colors.grey.shade400,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: userRepository
                                .getUser.patientName
                                .toString(),
                            placeholder: (context, url) =>
                            const Center(
                              child: Icon(
                                Icons.person,
                                size: 75,
                                color: Colors.grey,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(
                              Icons.person,
                              size: 75,
                              color: Colors.grey,
                            ),
                            height: 90,
                            width: 80,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8),
                            child: Text(
                              localization.getLocaleData.name.toString(),
                              style: themeChange.darkTheme
                                  ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                  : MyTextTheme.mediumBCB,
                            ),
                          ),
                          PrimaryTextField(
                            // labelText2: "Name",
                            style: themeChange.darkTheme == false
                                ? MyTextTheme.smallGCB
                                : MyTextTheme.smallWCB,
                            backgroundColor:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                            boxDecoration: true,
                            borderColor: Colors.transparent,
                            controller: editProfileVM.nameC,
                            hintText:   localization.getLocaleData.enterName.toString(),
                            prefixIcon: Icon(
                              CupertinoIcons.person_alt,
                              color: AppColor.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    localization.getLocaleData.gender.toString(),
                                    style: themeChange.darkTheme
                                        ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                        : MyTextTheme.mediumBCB,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedGender = 0;
                                          });
                                        },
                                        child: Container(
                                          width: Get.width,
                                          height: 90,
                                          decoration: BoxDecoration(

                                            boxShadow: [
                                              BoxShadow(
                                                  color: themeChange
                                                              .darkTheme ==
                                                          true
                                                      ? Colors.black26
                                                      : Colors.grey.shade500,
                                                  offset: const Offset(2, 2),
                                                  blurRadius: 2)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: selectedGender == 0
                                                ? Colors.greenAccent.shade700
                                                :    themeChange
                                              .darkTheme ==
                                          true
                                          ?   Colors.grey.shade700:Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.man,
                                                size: 50,
                                                color: selectedGender == 0
                                                    ? Colors.white
                                                    : Colors.grey.shade500,
                                              ),
                                              Text(
                                                localization.getLocaleData.male.toString(),
                                                style: selectedGender == 0
                                                    ? MyTextTheme.mediumWCN
                                                    : MyTextTheme.mediumGCN.copyWith(
                                                  color: themeChange
                                                      .darkTheme ==
                                                      true
                                                      ?   Colors.white:Colors.grey.shade500
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedGender = 1;
                                          });
                                        },
                                        child: Container(
                                          width: Get.width,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: themeChange
                                                              .darkTheme ==
                                                          true
                                                      ? Colors.black26
                                                      : Colors.grey.shade500,
                                                  offset: const Offset(2, 2),
                                                  blurRadius: 2)
                                            ],
                                            color: selectedGender == 1
                                                ? Colors.greenAccent.shade700
                                                :  themeChange
                                                .darkTheme ==
                                                true
                                                ?   Colors.grey.shade700:Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.woman,
                                                size: 50,
                                                color: selectedGender == 1
                                                    ? Colors.white
                                                    : Colors.grey.shade500,
                                              ),
                                              Text(
                                                localization.getLocaleData.female.toString(),
                                                style: selectedGender == 1
                                                    ? MyTextTheme.mediumWCN
                                                    : MyTextTheme.mediumGCN.copyWith(
                                                    color: themeChange
                                                        .darkTheme ==
                                                        true
                                                        ?   Colors.white:Colors.grey.shade500
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedGender = 2;
                                          });
                                        },
                                        child: Container(
                                          width: Get.width,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: themeChange
                                                              .darkTheme ==
                                                          true
                                                      ? Colors.black26
                                                      : Colors.grey.shade500,
                                                  offset: const Offset(2, 2),
                                                  blurRadius: 2)
                                            ],
                                            color: selectedGender == 2
                                                ? Colors.greenAccent.shade700
                                                :   themeChange
                                                .darkTheme ==
                                                true
                                                ?   Colors.grey.shade700:Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.pregnant_woman_rounded,
                                                size: 50,
                                                color: selectedGender == 2
                                                    ? Colors.white
                                                    : Colors.grey.shade500,
                                              ),
                                              Text(
                                                localization.getLocaleData.other.toString(),
                                                style: selectedGender == 2
                                                    ? MyTextTheme.mediumWCN
                                                    : MyTextTheme.mediumGCN.copyWith(
                                                    color: themeChange
                                                        .darkTheme ==
                                                        true
                                                        ?   Colors.white:Colors.grey.shade500
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    localization.getLocaleData.bloodGroup.toString(),
                                    style: themeChange.darkTheme
                                        ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                        : MyTextTheme.mediumBCB,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomSD(
                                    prefixIcon: Icons.bloodtype,
                                    iconColor: AppColor.grey,
                                    hideSearch: true,
                                    borderColor: Colors.transparent,
                                     csPadding: const EdgeInsets.all(4),
                                    labelStyle: themeChange.darkTheme
                                        ? MyTextTheme.mediumWCB
                                        : MyTextTheme.mediumGCB,
                                    initialValue: [
                                      {'parameter': 'type',
                                                  'value':userRepository.getUser.bloodGroupId

                                      }
                                    ],
                                    decoration: BoxDecoration(
                                        color:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                                        borderRadius: BorderRadius.circular(10),
                                        ),
                                    label:  localization.getLocaleData.selectBloodgroup.toString(),
                                    listToSearch: const [
                                      {'id': 1, 'type': 'A+'},
                                      {'id': 2, 'type': 'A-'},
                                      {'id': 3, 'type': 'B+'},
                                      {'id': 4, 'type': 'B-'},
                                      {'id': 5, 'type': 'O+'},
                                      {'id': 6, 'type': 'O-'},
                                      {'id': 7, 'type': 'AB+'},
                                      {'id': 8, 'type': 'AB-'}
                                    ],
                                    valFrom: 'type',
                                    onChanged: (val) {
                                      editProfileVM.selectbloodgroupID =
                                          val['id'];
                                    }),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 8),
                                      child: Text(localization.getLocaleData.height.toString() +' (cm)',
                                        style: themeChange.darkTheme
                                            ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                            : MyTextTheme.mediumBCB,
                                      ),
                                    ),
                                    PrimaryTextField(
                                      style: themeChange.darkTheme == false
                                          ? MyTextTheme.mediumGCB
                                          : MyTextTheme.mediumWCB,
                                      backgroundColor:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                                      boxDecoration: true,
                                      borderColor: Colors.transparent,
                                      controller: editProfileVM.heightC,
                                      maxLength: 4,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9.]')),
                                      ],
                                      hintText: localization.getLocaleData.enterHeight.toString(),
                                      prefixIcon: Icon(
                                        Icons.height,
                                        color: AppColor.grey,
                                      ),
                                      // borderRadius: BorderRadius.circular(50)
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 8),
                                      child: Text(
                                        localization.getLocaleData.weight.toString() +' (kg)',
                                        style: themeChange.darkTheme
                                            ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                            : MyTextTheme.mediumBCB,
                                      ),
                                    ),
                                    PrimaryTextField(
                                      style: themeChange.darkTheme == false
                                          ? MyTextTheme.mediumGCB
                                          : MyTextTheme.mediumWCB,
                                      borderColor: Colors.transparent,
                                      backgroundColor:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                                      boxDecoration: true,
                                      controller: editProfileVM.weightC,
                                      maxLength: 4,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9.]'),
                                        ),
                                      ],
                                      hintText:  localization.getLocaleData.enterYourWeightInkg.toString(),
                                      // labelText2: "Weight",
                                      prefixIcon: Icon(
                                        Icons.line_weight,
                                        color: AppColor.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8),
                            child: Text(
                              localization.getLocaleData.contact.toString(),
                              style: themeChange.darkTheme
                                  ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                  : MyTextTheme.mediumBCB,
                            ),
                          ),
                          PrimaryTextField(
                            style: themeChange.darkTheme== false
                                ? MyTextTheme.mediumGCB
                                : MyTextTheme.mediumWCB,

                            backgroundColor:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                            boxDecoration: true,
                            borderColor: Colors.transparent,
                            controller: editProfileVM.phoneC,
                            hintText:   localization.getLocaleData.enterContact.toString(),
                            // labelText2: "Contact No.",
                            prefixIcon: Icon(
                              Icons.phone,
                              color: AppColor.grey,
                            ),
                            // borderRadius: BorderRadius.circular(50)
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8),
                            child: Text( localization.getLocaleData.alternateContact.toString(),
                              style: themeChange.darkTheme
                                  ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                  : MyTextTheme.mediumBCB,
                            ),
                          ),
                          PrimaryTextField(
                         hintTextColor: themeChange.darkTheme?Colors.white:Colors.grey,
                            style: themeChange.darkTheme == false
                                ? MyTextTheme.mediumGCB
                                : MyTextTheme.mediumWCB,
                            backgroundColor:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                            boxDecoration: true,
                            borderColor: Colors.transparent,
                            controller: editProfileVM.aleternamephoneC,
                            hintText: localization.getLocaleData.enterAlternateContact.toString(),
                            // labelText2: 'Alternate Contact No.',
                            prefixIcon: Icon(
                              Icons.phone,
                              color: AppColor.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8),
                            child: Text(localization.getLocaleData.email.toString(),
                              style: themeChange.darkTheme
                                  ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                  : MyTextTheme.mediumBCB,),
                          ),
                          PrimaryTextField(
                            style: themeChange.darkTheme == false
                                ? MyTextTheme.mediumGCB
                                : MyTextTheme.mediumWCB,
                            backgroundColor:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                            boxDecoration: true,
                            borderColor: Colors.transparent,
                            controller: editProfileVM.emailC,
                            hintText: localization.getLocaleData.enterEmail.toString(),
                            // labelText2: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColor.grey,
                            ),
                            // borderRadius: BorderRadius.circular(50)
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8),
                            child: Text(localization.getLocaleData.addressOne.toString(),
                              style: themeChange.darkTheme
                                  ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                  : MyTextTheme.mediumBCB,),
                          ),
                          PrimaryTextField(
                            style: themeChange.darkTheme == false
                                ? MyTextTheme.mediumGCB
                                : MyTextTheme.mediumWCB,
                            backgroundColor:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                            borderColor: Colors.transparent,
                            boxDecoration: true,
                            controller: editProfileVM.addressC,
                            hintText: localization.getLocaleData.enterAddressOne.toString(),
                            // labelText2: 'Address Line 1',
                            prefixIcon: Icon(
                              Icons.location_history,
                              color: AppColor.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8),
                            child: Text(
                              localization.getLocaleData.addressTwo.toString(),
                              style: themeChange.darkTheme
                                  ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                  : MyTextTheme.mediumBCB,
                            ),
                          ),
                          PrimaryTextField(
                            hintTextColor: themeChange.darkTheme?Colors.white:Colors.grey,
                            style: themeChange.darkTheme == false
                                ? MyTextTheme.mediumGCB
                                : MyTextTheme.mediumWCB,
                            borderColor: Colors.transparent,
                            backgroundColor:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                            boxDecoration: true,
                            controller: editProfileVM.addressline2,
                            hintText:   localization.getLocaleData.enterAddressTwo.toString(),
                            // labelText2: 'Address Line 2',
                            prefixIcon: Icon(
                              Icons.location_history,
                              color: AppColor.grey,
                            ),
                            // borderRadius: BorderRadius.circular(50)
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8),
                            child: Text( localization.getLocaleData.treatmentModality.toString(),
                              style: themeChange.darkTheme
                                  ? MyTextTheme.mediumGCN.copyWith(color: AppColor.white.withOpacity(0.7),fontWeight: FontWeight.w600)
                                  : MyTextTheme.mediumBCB,),
                          ),
                          PrimaryTextField(
                            hintTextColor: themeChange.darkTheme?Colors.white:Colors.grey,
                            style: themeChange.darkTheme == false
                                ? MyTextTheme.mediumGCB
                                : MyTextTheme.mediumWCB,
                            borderColor: Colors.transparent,
                            backgroundColor:themeChange.darkTheme==false?Colors.white70: hexToColor('#24252B'),
                            boxDecoration: true,
                            controller: editProfileVM.modalityC,
                            hintText: localization.getLocaleData.enterTreatmentModality.toString(),
                            // labelText2: 'Treatment modality',
                            prefixIcon: Icon(
                              Icons.location_history,
                              color: AppColor.grey,
                            ),
                            //borderRadius: BorderRadius.circular(50)
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, bottom: 15, right: 10),
                      child: NeoButton(
                        func: () async {
                          await editProfileVM.updateUserData(context);
                        },
                        title: localization.getLocaleData.updateProfile.toString(),
                        height: 50
                          ,textStyle: MyTextTheme.mediumGCB.copyWith(color:themeChange.darkTheme?AppColor.black:AppColor.white,fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
