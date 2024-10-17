import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../app_manager/alert_toast.dart';
import 'caretaker_controller.dart';

class CareTaker extends StatefulWidget {
  const CareTaker({Key? key}) : super(key: key);

  @override
  State<CareTaker> createState() => _CareTakerState();
}

class _CareTakerState extends State<CareTaker> {

  CareTakerController controller = Get.put(CareTakerController());

  final userFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    controller.scanDevices();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.scanSubscription!.cancel();
    controller.subscription1!.cancel();
    Get.delete<CareTakerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder(
        init: CareTakerController(),
        builder: (_) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [

                    // Back and connect button
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          ElevatedButton.icon(
                            onPressed: () {
                              controller.onPressedBack();
                            },
                            label: Text("Back",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            icon: Icon(Icons.arrow_back_ios_new),
                          ),

                          ElevatedButton(
                            child: Text(
                              controller.getIsDeviceConnected
                                  ? 'Connected'
                                  : 'Connect',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if (!controller.getIsDeviceConnected) {
                                await controller.devicesData!.device
                                    .connect(autoConnect: true);
                                controller.onPressedConnect();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ],
                      ),
                    ),

                    // Text
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        // color: Colors.blue,
                        width: MediaQuery.of(context).size.width/2.5,
                        child: Text(
                          "Click on connect button, \nand enter your BP value measured by BP machine",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // Text fields and send button
                    Visibility(
                      visible: controller.getIsDeviceConnected,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                          // color: Colors.blue.shade200,
                          width: MediaQuery.of(context).size.width/2.5,
                          height: MediaQuery.of(context).size.height/2.8,
                          child: Form(
                            key: userFormKey,
                            autovalidateMode: AutovalidateMode.always,
                            child: Column(
                              children: [

                                Padding(
                                  padding:  EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: TextFormField(
                                      controller: controller.systolic.value,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Systolic Value',
                                      ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(3),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) => controller.handleSystolic(value),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please enter systolic value';
                                        }
                                      }),
                                ),

                                Padding(
                                  padding:  EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: TextFormField(
                                      controller: controller.diastolic.value,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Diastolic Value',
                                      ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(3),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) => controller.handleDiastolic(value),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please enter diastolic value';
                                        }
                                      }),
                                ),

                                Padding(
                                  padding:  EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: TextFormField(
                                      controller: controller.pulserate.value,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Pulse Rate Value',
                                      ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(3),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) => controller.handlePulseRate(value),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please enter pulse rate value';
                                        }
                                      }),
                                ),

                                Padding(
                                  padding:  EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width/2.5,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {

                                        if(userFormKey.currentState!.validate()) {
                                          await controller.getBPOtherData();
                                          controller.clearBPOtherData();

                                          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Data has been sent.'));
                                          // alertToast(context, 'Data has been sent.');

                                        }

                                      },
                                      child: Text("SEND",
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),



                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );

        }
      ),
    );
  }
}
