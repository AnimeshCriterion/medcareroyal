// /*
//
// import 'package:medvantage_patient/app_manager/widgets/text_field/custom_sd.dart';
// import 'package:medvantage_patient/app_manager/widgets/text_field/primary_date_time_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../app_manager/alert_dialogue.dart';
// import '../../../app_manager/app_color.dart';
// import '../../../app_manager/my_button.dart';
// import '../../../app_manager/theme/text_theme.dart';
// import '../stethoscope_controller.dart';
//
// addPatientModule(context) {
//   StethoscopeController stethoController = Get.put(StethoscopeController());
//   stethoController.clearAddPatientData();
//   AlertDialogue().show(context, msg: '', title: 'Add Patient', newWidget: [
//     GetBuilder(
//         init: StethoscopeController(),
//         builder: (_) {
//           return Form(
//             key: stethoController.addPatientFormKey.value,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 children: [
//                   //
//                   Container(
//                     padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: AppColor.greyVeryLight)),
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                               border: Border.all(color: AppColor.greyDark)),
//                           child: Column(
//                             children: [
//                               TextFormField(
//                                 controller: stethoController.nameC.value,
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: 'Enter Name',
//                                 ),
//                                 onChanged: (val) {
//                                   stethoController.clearMemberListData();
//                                 },
//                               ),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               PrimaryDateTimeField(
//                                 prefixIcon: const Icon(Icons.calendar_month),
//                                 controller: stethoController.ageC.value,
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: 'select DOB',
//                                 ),
//                                 onChanged: (val) {
//                                   stethoController.clearMemberListData();
//                                 },
//                               ),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               TextFormField(
//                                 controller: stethoController.pidC.value,
//                                 keyboardType: TextInputType.number,
//                                 maxLength: 7,
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: 'Enter PID',
//                                 ),
//                                 onChanged: (val) {
//                                   stethoController.clearMemberListData();
//                                 },
//                               ),
//                               Row(
//                                 children: [
//                                   const Text('Gender',
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                       )),
//                                   Expanded(
//                                     child: RadioListTile(
//                                       title: const Text("Male"),
//                                       value: 1,
//                                       groupValue: stethoController.getGender,
//                                       onChanged: (value) {
//                                         stethoController.updateGender =
//                                             int.parse(value.toString());
//                                         stethoController.clearMemberListData();
//                                       },
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: RadioListTile(
//                                       title: const Text("Female"),
//                                       value: 2,
//                                       groupValue: stethoController.getGender,
//                                       onChanged: (value) {
//                                         stethoController.updateGender =
//                                             int.parse(value.toString());
//                                         stethoController.clearMemberListData();
//                                       },
//                                     ),
//                                   )
//                                   // addRadioButton(0, 'Male'),
//                                   // addRadioButton(1, 'Female'),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         Text(
//                           'OR',
//                           style: MyTextTheme.mediumBCB,
//                         ),
//                         const SizedBox(
//                           height: 15,
//                         ),
//
//                         // TextFormField(
//                         //   controller: stethoController.pidC.value,
//                         //   decoration: const InputDecoration(
//                         //     border: OutlineInputBorder(),
//                         //     labelText: 'Enter PID',
//                         //   ),
//                         //   validator: (val){
//                         //     if(val!.isEmpty){
//                         //       return 'Please Enter your PID';
//                         //     }
//                         //   },
//                         // ),
//                         CustomSD(
//                           listToSearch: stethoController.getMemberList,
//                           valFrom: 'name',
//                           hideSearch: true,
//                           borderColor: AppColor.greyDark,
//                           label: 'Select Member',
//                           onChanged: (val) {
//                             if (val != null) {
//                               stethoController.updateSelectedMemberId = val;
//
//                               stethoController.nameC.value.clear();
//                               stethoController.ageC.value.clear();
//                               stethoController.pidC.value.clear();
//                               stethoController.updateGender=0;
//                               stethoController.update();
//
//                               print('nnnnnnnnnnnnnnnnnnnnnnnnn' + val.toString());
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(
//                     height: 15,
//                   ),
//
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   TextFormField(
//                     controller: stethoController.hotspotName.value,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter Hotspot Name',
//                     ),
//                     // validator: (val) {
//                     //   if (val!.isEmpty) {
//                     //     return 'Please Enter your Hotspot Name';
//                     //   }
//                     // },
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   TextFormField(
//                     controller: stethoController.hotspotPass.value,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter Password',
//                     ),
//                     // validator: (val) {
//                     //   if (val!.isEmpty) {
//                     //     return 'Please Enter your Hotspot Password';
//                     //   }
//                     // },
//                   ),
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   MyButton(
//                     title: 'Add ',
//                     onPress: () async {
//                       print('nnnnnnnnnnnnnnnnnn' +stethoController.pidC.value.text.length
//                               .toString());
//                       if (
//                       stethoController.getSelectedMemberId.memberId != 0 ||
//                           (stethoController.pidC.value.text != '' &&
//                               stethoController.nameC.value.text != '' &&
//                               stethoController.ageC.value.text != '' &&
//                               stethoController.nameC.value.text != '')) {
//
//                         if (stethoController.getSelectedMemberId.memberId !=
//                             0) {
//                             await stethoController.onPressedAddInfo(context);
//                         }
//                         else{
//                           if (
//                           stethoController.getSelectedMemberId.memberId == 0 &&
//                               stethoController.pidC.value.text.length > 6) {
//                             await stethoController.onPressedAddInfo(context);
//                           } else {
//                             alertToast(context, 'Please enter Valid PID');
//                           }
//                         }
//                       }else {
//                         alertToast(context,
//                             'Please Select Member or Fill Patient Details');
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//   ]);
// }
// */
