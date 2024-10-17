
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_date_time_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app_manager/app_color.dart';
import '../../../app_manager/my_button.dart';
import '../../../app_manager/theme/text_theme.dart';
import '../../../app_manager/widgets/text_field/custom_sd.dart';
import '../../../app_manager/widgets/text_field/my_text_field_2.dart';
import '../stetho_recording/module/viewAllPID_module.dart';
import '../stethoscope_controller.dart';

class ListenAudioView extends StatefulWidget {
  final bool isScanPage;
  const ListenAudioView({super.key, required this.isScanPage});

  @override
  State<ListenAudioView> createState() => _ListenAudioViewState();
}

class _ListenAudioViewState extends State<ListenAudioView> {
  StethoscopeController stethoController = Get.put(StethoscopeController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      stethoController.clearData();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primaryColor,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColor.primaryColor,
            appBar: AppBar(title: const Text('')),
            body: GetBuilder(
                init: StethoscopeController(),
                builder: (_) {
                  return Column(
                    children: [
                      Image.asset(
                        'assets/stethoImg/listenImage.png',

                        fit: BoxFit.contain,
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Are you want to listen \nStethoScope audio?',
                                textAlign: TextAlign.center,
                                style: MyTextTheme.largeBCB,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [


                                  Expanded(
                                    child: RadioMenuButton(
                                        value: true, groupValue: stethoController
                                        .getIsSelectedMemberList,onChanged: (val) {
                                      stethoController.clearData();
                                      stethoController
                                          .updateIsSelectedMemberList = !stethoController
                                          .getIsSelectedMemberList;
                                    }, child: Text('Member List',style: MyTextTheme.mediumBCB,)),
                                  ),

                                  Expanded(
                                    child: RadioMenuButton(
                                        value: false, groupValue: stethoController
                                        .getIsSelectedMemberList,onChanged: (val) {
                                      stethoController.clearData();
                                      stethoController
                                          .updateIsSelectedMemberList = !stethoController
                                          .getIsSelectedMemberList;
                                    }, child: Text('PID',style: MyTextTheme.mediumBCB,)),
                                  ),


                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Visibility(
                                visible:stethoController
                                    .getIsSelectedMemberList ,
                                child: CustomSD(
                                  listToSearch: stethoController.getMemberList,
                                  valFrom: 'name',
                                  hideSearch: true,
                                  borderColor: AppColor.greyDark,
                                  label: 'Select Member',
                                  onChanged: (val) {
                                    print('nnvnnvnnv'+val.toString());
                                    if (val != null) {
                                      // stethoController.updateSelectedMemberId = val;
                                    }
                                  },
                                ),
                              ),

                              Visibility(
                                visible:!stethoController
                                    .getIsSelectedMemberList ,
                                child: Form(
                                  key: stethoController.addPatientFormKey.value,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: [
                                      MyTextField2(
                                          controller:
                                          stethoController.pidTextC.value,

                                          hintText: 'Enter PID',
                                          maxLength: 7,
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return 'Please Enter PID';
                                            }
                                          }
                                      ),
                                      Visibility(
                                        visible: !widget.isScanPage,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10,),

                                            MyTextField2(
                                                controller:
                                                stethoController.nameC.value,

                                                hintText: 'Enter Name',
                                                validator: (val) {
                                                  if (val!.isEmpty) {
                                                    return 'Please Enter Name';
                                                  }
                                                }
                                            ),
                                            SizedBox(height: 10,)  ,
                                            PrimaryDateTimeField(
                                                controller: stethoController.ageC.value,
                                                hintText: "Select DOB",
                                                validator: (val) {
                                                  if (val!.isEmpty) {
                                                    return 'Please Select DOB';
                                                  }
                                                }
                                            ),

                                            SizedBox(height: 10,)  ,

                                            Row(
                                              children: [
                                                const Text('Gender',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    )),
                                                SizedBox(
                                                  width: 150,
                                                  child: RadioListTile(
                                                    title: const Text("Male"),
                                                    value: 1,
                                                    groupValue: stethoController.getGender,
                                                    onChanged: (value) {
                                                      stethoController.updateGender =
                                                          int.parse(value.toString());
                                                      stethoController.clearMemberListData();
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                  child: RadioListTile(
                                                    title: const Text("Female"),
                                                    value: 2,
                                                    groupValue: stethoController.getGender,
                                                    onChanged: (value) {
                                                      stethoController.updateGender =
                                                          int.parse(value.toString());
                                                      stethoController.clearMemberListData();
                                                    },
                                                  ),
                                                )
                                                // addRadioButton(0, 'Male'),
                                                // addRadioButton(1, 'Female'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              SizedBox(
                                width: 250,
                                child: MyButton(
                                  title: 'Listen',
                                  onPress: () async {
                                    print('nnvnnvnnvnnvnn');
                                    if(!stethoController.getIsSelectedMemberList){
                                      if (stethoController.addPatientFormKey.value.currentState!.validate()) {
                                        if(!widget.isScanPage){
                                          // try {
                                            await stethoController
                                                .onPressedAddInfo(context);
                                          // } catch (e) {}


                                        }
                                        await stethoController
                                            .listenData(context);
                                      }
                                    }
                                    else{
                                      if(!widget.isScanPage){
                                        // try {
                                          await stethoController
                                              .onPressedAddInfo(context);
                                        // } catch (e) {
                                        //
                                        // }
                                      }
                                      await stethoController
                                          .listenData(context);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
          )),
    );
  }
}

// listenModule(context){
//
//   StethoscopeController stethoController = Get.put(StethoscopeController());
//   stethoController.clearData();
//   AlertDialogue().show(context,msg: '',title:'Listen',
//       newWidget: [
//         GetBuilder(
//             init: StethoscopeController(),
//             builder: (_) {
//               return Form(
//                 key: stethoController.listenFormKey.value,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 child: Column(
//                   children: [
//
//
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: MyTextField2(
//                               controller: stethoController.pidTextC.value,
//                               maxLength: 8,
//                               keyboardType: TextInputType.number,
//                               label: Text('PID'),
//                               hintText: 'Enter PID',
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//
//                         MyButton(
//                             title: 'Listen',
//                             color: AppColor.primaryColor,
//                             textStyle: MyTextTheme().mediumWCB,
//                             width: 115,
//                             onPress: () async {
//                               if (stethoController.pidTextC.value.text.isNotEmpty) {
//                                 if (stethoController.pidTextC.value.text.length > 5) {
//                                   await stethoController.listenData(context);
//                                 } else {
//                                   alertToast(context, 'Please enter valid pid');
//                                 }
//                               } else {
//                                 alertToast(context, 'Please enter PID');
//                               }
//                             }),
//
//                         const SizedBox(
//                           width: 5,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 15,),
//
//                     MyButton(title: 'Member List',onPress: (){
//
//                       viewAllPIDModule(context);
//                     },),
//
//
//                     // Row(
//                     //   crossAxisAlignment: CrossAxisAlignment.start,
//                     //   children: [
//                     //     Expanded(
//                     //       child: MyCustomSD(
//                     //         listToSearch: stethoController.getMemberList,
//                     //         valFrom: 'name',
//                     //         hideSearch: true,
//                     //         borderColor: AppColor.greyDark,
//                     //         label: 'Select Member',
//                     //         onChanged: (val){
//                     //           if(val!=null){
//                     //             stethoController.updateSelectedMemberId=val['memberId'].toString();
//                     //           }
//                     //         },),
//                     //     ),
//                     //     const SizedBox(width: 5,),
//                     //
//                     //     MyButton(title: 'Listen',
//                     //         width: 115,
//                     //         onPress: () async {
//                     //           await stethoController.listenData(context);
//                     //         }),
//                     //   ],
//                     // )
//
//                     // TextFormField(
//                     //     controller: stethoController.pidC.value,
//                     //     decoration:
//                     //     const InputDecoration(
//                     //       prefixIcon: Icon(Icons.perm_identity),
//                     //       border: OutlineInputBorder(),
//                     //       labelText:
//                     //       'PID',
//                     //       hintText: 'Enter PID',
//                     //     ),
//                     //     validator: (val){
//                     //       if(val!.isEmpty){
//                     //         return 'Please Enter PID';
//                     //       }
//                     //     }
//                     // ),
//                     // const SizedBox(height: 25,),
//                     //
//                     // MyButton(title: 'Connect',onPress: () async {
//                     //   if(stethoController.listenFormKey.value.currentState!.validate()){
//                     //      Get.back();
//                     //     await stethoController.listenData(context);
//                     //   }
//                     // },)
//
//
//
//                   ],
//                 ),
//               );
//             }
//         ),
//       ]);
// }