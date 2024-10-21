


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/LiveVital/pmd/my_text_theme.dart';
import 'package:medvantage_patient/View/Pages/nnn.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/my_button.dart';

import '../../ViewModal/report_tracking_view_modal.dart';
import '../../app_manager/camera_and images/image_picker.dart';
import '../../app_manager/widgets/text_field/primary_date_time_field.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../authenticaton/user_repository.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';

class AddLabResultsView extends StatefulWidget {
  const AddLabResultsView({super.key});

  @override
  State<AddLabResultsView> createState() => _AddLabResultsViewState();
}

class _AddLabResultsViewState extends State<AddLabResultsView> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    ReportTrackingViewModal reportTrackingVM =
    Provider.of<ReportTrackingViewModal>(context, listen: true);
    return SafeArea(child: Scaffold(
      backgroundColor: AppColor.greyVeryVeryLight,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios,size: 21,color: themeChange.darkTheme? Colors.white:Colors.black,),
                  ),
                ),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text( 'Add Lab Results',
                              style: MyTextTheme().largeBCB.copyWith( height: 0,color:
                              themeChange.darkTheme==true?Colors.white70:Colors.black,),),
                          ),


                        ],
                      ),
                      // Text(localization.getLocaleData.symptomsTracker.toString(),style:MyTextTheme.largeBCB.copyWith(fontSize: 25,height: 1,color: themeChange.darkTheme==true?Colors.white:Colors.black),),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 15,),

            Text('Test Type',style: MyTextTheme().mediumGCB,),
            // SmartSearchableDropdown(items: reportTrackingVM.upperList, keyValue: 'title',
            //     borderWidth: 0,borderColor: Colors.white,borderRadius: 10, onChanged: (val){
            //
            // }),

            SizedBox(height: 15,),
            Text('Date',style: MyTextTheme().mediumGCB,),
            PrimaryDateTimeField(
              dateTimePickerType: DateTimePickerType.date,
              hintText: 'Select Date',
              onChanged: (val){
              },
            ),
            SizedBox(height: 15,),
            Text('Test Type',style: MyTextTheme().mediumGCB,),
            PrimaryTextField(
              backgroundColor: themeChange.darkTheme == true
                  ? AppColor.greyDark.withOpacity(.5)
                  : AppColor.white,
              borderColor: themeChange.darkTheme == true
                  ? AppColor.darkshadowColor2
                  : AppColor.white,
              onChanged: (val) async {
                setState(() {});
              },
              hintText: 'Enter test name',
              hintTextColor: themeChange.darkTheme == true
                  ? Colors.grey
                  : Colors.grey.shade600,
              // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
            ),

            SizedBox(height: 15,),
            Text('Findings',style: MyTextTheme().mediumGCB,),
            PrimaryTextField(
              backgroundColor: themeChange.darkTheme == true
                  ? AppColor.greyDark.withOpacity(.5)
                  : AppColor.white,
              borderColor: themeChange.darkTheme == true
                  ? AppColor.darkshadowColor2
                  : AppColor.white,
              onChanged: (val) async {
                setState(() {});
              },
              hintText: 'Enter Findings',
              hintTextColor: themeChange.darkTheme == true
                  ? Colors.grey
                  : Colors.grey.shade600,
              // backgroundColor: themeChange.darkTheme==true?Colors.grey.shade800:Colors.white,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child:  imgCapture('assets/camera.png', 'Gallery', 'Upload files from gallery',
                  Colors.purple.shade800),),

                  SizedBox(width: 10,),
                  Expanded(child:    imgCapture('assets/gallary.png', 'Camera', 'Capture from camera', Colors.green))

                ],
              ),
            ),
            Expanded(child: SizedBox()),

            MyButton(title: 'Upload & Save',color: VitalioColors.primaryBlue,onPress: () async {



              await reportTrackingVM.insertInvesigation(context);
            },)
          ],
        ),
      )
    ));
  }
  // gallary.png,
  // camera.png


imgCapture(img,title,subTitle,textColor){
  ReportTrackingViewModal reportTrackingVM =
  Provider.of<ReportTrackingViewModal>(context, listen: false);
  UserRepository userRepository =
  Provider.of<UserRepository>(context, listen: false);
    return InkWell(
      onTap: () async {
        var data = await MyImagePicker.pickImageFromCamera();
        print(data.path.toString());
        reportTrackingVM.updateImgPath = data.path.toString();

        await reportTrackingVM
            .insertPatientMediaData(context,admitDoctorId:userRepository.getUser.admitDoctorId,
            uhId: userRepository.getUser.uhID.toString());

      },
      child: Container(
          height: 150,

        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.purpleAccent.withOpacity(0.06),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(img),
                  SizedBox(height: 15,),
                  Text(title,style: MyTextTheme().mediumBCN.copyWith(
                    color: textColor ,
                  ),),
                  Text(subTitle,style: MyTextTheme().smallBCN.copyWith(
                    color: textColor,
                  ),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}
}
