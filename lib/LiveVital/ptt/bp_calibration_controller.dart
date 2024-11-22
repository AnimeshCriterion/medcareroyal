import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../medcare_utill.dart';

alertToast(context,message){
  Fluttertoast.showToast(
    msg: message,
    fontSize: 16,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    timeInSecForIosWeb: 3,
  );
}

class BPCalibrationController extends GetxController {

  FlutterBluePlus flutterBluePlus = FlutterBluePlus();

  StreamSubscription? scanSubscription;
  StreamSubscription? subscription1;

  // Rx<TextEditingController> systolic = TextEditingController().obs;
  // Rx<TextEditingController> diastolic = TextEditingController().obs;
  // Rx<TextEditingController> pulseRate = TextEditingController().obs;
  //
  // clearBPCalibrationData() {
  //   systolic.value.clear();
  //   diastolic.value.clear();
  //   pulseRate.value.clear();
  // }

  late Timer timer;
  int currentSysValue=120;
  int currentDiaValue=80;
  int currentPulseValue=72;

  ScanResult? devicesData;
  set updateDevicesData(ScanResult val) {
    devicesData=val;
    update();
  }

  Rx<bool> isDeviceScanning=false.obs;
  bool get getIsDeviceScanning=>isDeviceScanning.value;
  set updateIsDeviceScanning(bool val) {
    isDeviceScanning.value=val;
    update();
  }

  Rx<bool> isDeviceFound=false.obs;
  bool get getIsDeviceFound=>isDeviceFound.value;
  set updateIsDeviceFound(bool val) {
    isDeviceFound.value=val;
    update();
  }

  scanDevices() {
    devicesData=null;
    updateDeviceStates=true;
    updateIsDeviceConnected=false;
    updateIsDeviceFound=false;
    updateIsDeviceScanning=true;

    dPrint('Device scanning : $getIsDeviceScanning');

    // Start scanning
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4)).then((value) {
      updateIsDeviceScanning=false;
    });

    // Listen to scan results
    scanSubscription = FlutterBluePlus.scanResults.listen((results) {

      // do something with scan results
      for (ScanResult r in results) {
        dPrint('Device name : ${r.device.platformName}');
        if (r.device.platformName.toString()=='CT_PTT_Device') {
          updateIsDeviceFound=true;
          updateDevicesData=r;
        }
        dPrint('Device name : ${r.device.platformName}');
      }
    });
    update();
    // FlutterBluePlus.stopScan();
  }

  onPressBack() async {
    // if(devicesData!=null) {
    //   devicesData!.device.disconnect();
    // }
    Get.back();
    // Get.delete<BPCalibrationController>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  onPressConnect() async {
    checkDeviceConnection();
    await getBPCalibrationData();
  }

  Rx<bool> isDeviceConnected=false.obs;
  bool get getIsDeviceConnected=>isDeviceConnected.value;
  set updateIsDeviceConnected(bool val) {
    isDeviceConnected.value=val;
    update();
  }

  bool deviceStates=true;
  bool get getDeviceStates=>deviceStates;
  set updateDeviceStates(bool val) {
    deviceStates=val;
    update();
  }

  checkDeviceConnection() async {
    devicesData!.device.connectionState.listen((event) {
      if(event==BluetoothConnectionState.connected) {
        updateIsDeviceConnected=true;
        updateDeviceStates=true;
      }
      else if(event==BluetoothConnectionState.disconnected) {
        if(devicesData!=null){
          devicesData!.device.disconnect();
        }
        updateIsDeviceConnected=false;
        updateDeviceStates=false;
      }
    });
  }

  getBPCalibrationData() async {
    List<BluetoothService> services=await devicesData!.device.discoverServices();
    services.forEach((service) async {
      if(service.uuid.toString()=='180a') {
        var characteristics=service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if(c.uuid.toString()=='2a38') {
            // await c.write(utf8.encode(systolic.value.text));
            await c.write(utf8.encode(currentSysValue.toString()));
            List<int> value=await c.read();
            c.setNotifyValue(true);
            subscription1=c.value.listen((event) {
              var data=ascii.decode(value);
              dPrint('Systolic Value $data');
            });
          }
        }

      }
    });
    update();
  }

}
