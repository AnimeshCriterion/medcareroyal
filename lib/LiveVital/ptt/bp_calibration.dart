import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../app_manager/alert_toast.dart';
import 'bp_calibration_controller.dart';
class BPCalibration extends StatefulWidget {
  const BPCalibration({super.key});

  @override
  State<BPCalibration> createState() => _BPCalibrationState();
}

class _BPCalibrationState extends State<BPCalibration> {

  BPCalibrationController bpCalibrationController = Get.put(BPCalibrationController());

  final userFormKey = GlobalKey<FormState>();

  connectDevice() async {
    if(!bpCalibrationController.getIsDeviceConnected) {
      await bpCalibrationController.devicesData!.device.connect();
      bpCalibrationController.onPressConnect();
    }
  }

  @override
  void initState() {
    bpCalibrationController.scanDevices();
    connectDevice();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    bpCalibrationController.scanSubscription!.cancel();
    bpCalibrationController.subscription1!.cancel();
    bpCalibrationController.timer.cancel();
    Get.delete<BPCalibrationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder(
        init: BPCalibrationController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text('BP Calibration'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    // Form and button
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.01,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Form(
                            key: userFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                // // Systolic value
                                // TextFormField(
                                //   controller: bpCalibrationController.systolic.value,
                                //   keyboardType: TextInputType.number,
                                //   decoration: InputDecoration(
                                //     border: OutlineInputBorder(),
                                //     labelText: 'Systolic Value',
                                //   ),
                                //   inputFormatters: [
                                //     LengthLimitingTextInputFormatter(3),
                                //     FilteringTextInputFormatter.digitsOnly,
                                //   ],
                                //   validator: (val) {
                                //     if (val!.isEmpty) {
                                //       return 'Please enter systolic value';
                                //     }
                                //   },
                                //   autovalidateMode: AutovalidateMode.always,
                                // ),
                                //
                                // // Diastolic value
                                // Padding(
                                //   padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                //   child: TextFormField(
                                //     controller: bpCalibrationController.diastolic.value,
                                //     keyboardType: TextInputType.number,
                                //     decoration: InputDecoration(
                                //       border: OutlineInputBorder(),
                                //       labelText: 'Diastolic Value',
                                //     ),
                                //     inputFormatters: [
                                //       LengthLimitingTextInputFormatter(3),
                                //       FilteringTextInputFormatter.digitsOnly,
                                //     ],
                                //     //   validator: (val) {
                                //     //     if (val!.isEmpty) {
                                //     //       return 'Please enter your diastolic value';
                                //     //     }
                                //     //   },
                                //     // autovalidateMode: AutovalidateMode.always,
                                //   ),
                                // ),
                                //
                                // // Pulse
                                // TextFormField(
                                //   controller: bpCalibrationController.pulseRate.value,
                                //   keyboardType: TextInputType.number,
                                //   decoration: InputDecoration(
                                //     border: OutlineInputBorder(),
                                //     labelText: 'Pulse Rate Value',
                                //   ),
                                //   inputFormatters: [
                                //     LengthLimitingTextInputFormatter(3),
                                //     FilteringTextInputFormatter.digitsOnly,
                                //   ],
                                //   //   validator: (val) {
                                //   //     if (val!.isEmpty) {
                                //   //       return 'Please enter your pulse rate value';
                                //   //     }
                                //   //   },
                                //   // autovalidateMode: AutovalidateMode.always,
                                // ),





                                // Systolic, Diastolic and Pulse rate headings
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width/3.1,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                      ),
                                      child: Text('Systolic',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),

                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width/3.1,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                      ),
                                      child: Text('Diastolic',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),

                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width/3.1,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                      ),
                                      child: Text('Pulse Rate',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),

                                  ],
                                ),

                                // Values
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Systolic (120)
                                    Container(
                                      width: MediaQuery.of(context).size.width/3.1,
                                      color: Colors.blue.shade50,
                                      child: NumberPicker(
                                        axis: Axis.vertical,
                                        step: 1,
                                        itemHeight: 60,
                                        itemWidth: 120,
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                        selectedTextStyle: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 2,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        minValue: 0,
                                        maxValue: 300,
                                        value: bpCalibrationController.currentSysValue,
                                        onChanged: (value) {
                                          setState(() {
                                            bpCalibrationController.currentSysValue=value;
                                          });
                                        },
                                      ),
                                    ),

                                    // Diastolic (80)
                                    Container(
                                      width: MediaQuery.of(context).size.width/3.1,
                                      color: Colors.blue.shade50,
                                      child: NumberPicker(
                                        axis: Axis.vertical,
                                        step: 1,
                                        itemHeight: 60,
                                        itemWidth: 120,
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                        selectedTextStyle: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 2,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        minValue: 0,
                                        maxValue: 300,
                                        value: bpCalibrationController.currentDiaValue,
                                        onChanged: (value) {
                                          setState(() {
                                            bpCalibrationController.currentDiaValue=value;
                                          });
                                        },
                                      ),
                                    ),

                                    // Pulse rate (60-100)
                                    Container(
                                      width: MediaQuery.of(context).size.width/3.1,
                                      color: Colors.blue.shade50,
                                      child: NumberPicker(
                                        axis: Axis.vertical,
                                        step: 1,
                                        itemHeight: 60,
                                        itemWidth: 120,
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                        selectedTextStyle: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 2,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        minValue: 0,
                                        maxValue: 300,
                                        value: bpCalibrationController.currentPulseValue,
                                        onChanged: (value) {
                                          setState(() {
                                            bpCalibrationController.currentPulseValue=value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                // Calibrate button
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width/2,
                                    height: 60,
                                    child: ElevatedButton(
                                      onPressed: () async {

                                        if(userFormKey.currentState!.validate()) {
                                          await bpCalibrationController.getBPCalibrationData();
                                          // bpCalibrationController.clearBPCalibrationData();

                                          Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: 'BP Calibration completed.'));


                                          bpCalibrationController.timer=Timer.periodic(Duration(seconds: 3), (timer) {
                                            bpCalibrationController.onPressBack();
                                          });

                                        }

                                      },
                                      child: Text("Calibrate",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
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
