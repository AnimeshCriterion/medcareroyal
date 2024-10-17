
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app_manager/alert_dialogue.dart';
import '../../../app_manager/alert_toast.dart';
import '../../../app_manager/app_color.dart';
import '../../../app_manager/my_button.dart';
import '../../../app_manager/theme/text_theme.dart';
import '../../../app_manager/widgets/text_field/my_text_field_2.dart';
import '../stethoscope_controller.dart';

class UpdateWifiView extends StatefulWidget {
  const UpdateWifiView({super.key});

  @override
  State<UpdateWifiView> createState() => _UpdateWifiViewState();
}

class _UpdateWifiViewState extends State<UpdateWifiView> {
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
        appBar: AppBar(title: Text('')),
        body: GetBuilder(
         init:StethoscopeController() ,
          builder: (_) {
            return Form(  key: stethoController.wifiFormKey.value,
      autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    'assets/stethoImg/updateWifi.svg',
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Update Your Wifi \nConnection',
                                textAlign: TextAlign.center,
                                style: MyTextTheme.largeBCB,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              MyTextField2(controller: stethoController.hotspotName.value,
                                prefixIcon: Icon(
                                  Icons.wifi,
                                  color: Colors.grey,
                                ),
                                hintText: 'Wifi Name',
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please Enter Wifi name';
                                    }
                                  }
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              MyTextField2( controller: stethoController.hotspotPass.value,
                                isPasswordField: true,
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: Colors.grey,
                                ),
                                hintText: 'Wifi Password',
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please Enter Wifi Password';
                                    }
                                  }
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              MyButton(
                                title: 'Update Wifi',
                                onPress: () {
                                  if (stethoController.wifiFormKey.value.currentState!
                                      .validate()) {
                                    if (stethoController.getIsDeviceConnected) {
                                       Get.back();
                                      stethoController.readStethoData(
                                          context, 'update_wifi_name');
                                      Future.delayed(const Duration(seconds: 2), () {
                                        stethoController.readStethoData(
                                            context, 'update_wifi_pass');
                                      });
                                    } else {

                                      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Connect your device'));
                                      // alertToast(context, 'Connect your Device');
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            );
          }
        ),
      )),
    );
  }
}

// updateWifiModule(context) {
//   StethoscopeController stethoController = Get.put(StethoscopeController());
//   stethoController.clearData();
//   AlertDialogue().show(context, msg: '', title: 'Update Wifi', newWidget: [
//     GetBuilder(
//         init: StethoscopeController(),
//         builder: (_) {
//           return Form(
//             key: stethoController.wifiFormKey.value,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   TextFormField(
//                       controller: stethoController.hotspotName.value,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.wifi),
//                         labelText: 'Hotspot Name',
//                         hintText: 'Enter Hotspot name',
//                       ),
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return 'Please Enter Hotspot name';
//                         }
//                       }),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   MyTextField2(
//                       controller: stethoController.hotspotPass.value,
//                       isPasswordField: true,
//                       decoration: InputDecoration(
//                         border: const OutlineInputBorder(),
//                         hintText: 'Enter Password',
//                         prefixIcon: const Icon(Icons.password),
//                         labelText: 'Hotspot Password',
//                       ),
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return 'Please Enter Hotspot Password';
//                         }
//                       }),
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   MyButton(
//                     title: 'Update Wifi',
//                     onPress: () {
//                       if (stethoController.wifiFormKey.value.currentState!
//                           .validate()) {
//                         if (stethoController.getIsDeviceConnected) {
//                            Get.back();
//                           stethoController.readStethoData(
//                               context, 'update_wifi_name');
//                           Future.delayed(const Duration(seconds: 2), () {
//                             stethoController.readStethoData(
//                                 context, 'update_wifi_pass');
//                           });
//                         } else {
//                           alertToast(context, 'Connect your Device');
//                         }
//                       }
//                     },
//                   )
//                 ],
//               ),
//             ),
//           );
//         }),
//   ]);
// }
