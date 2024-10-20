import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

alertToast(context,message){
  FocusScope.of(context).unfocus();
  Fluttertoast.showToast(
    msg: message,

  );
}

class CareTakerController extends GetxController {


  StreamSubscription? scanSubscription;
  StreamSubscription? subscription1;

  Rx<TextEditingController> systolic = TextEditingController().obs;
  int sys=0;
  handleSystolic(value) {
    sys=int.parse(value.toString());
  }

  Rx<TextEditingController> diastolic = TextEditingController().obs;
  int dia=0;
  handleDiastolic(value) {
    dia=int.parse(value.toString());
  }

  Rx<TextEditingController> pulserate = TextEditingController().obs;
  int pr=0;
  handlePulseRate(value) {
    pr=int.parse(value.toString());
  }

  clearBPOtherData() {
    systolic.value.clear();
    diastolic.value.clear();
    pulserate.value.clear();
  }

  ScanResult? devicesData;
  set updateDevicesData(ScanResult val) {
    devicesData = val;
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
    print('3DeviceScanning'+getIsDeviceScanning.toString());

    // Start scanning
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4)).then((value) {

      updateIsDeviceScanning=false;
    });

    // Listen to scan results
    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print(r.device.name.toString());
        if (r.device.name.toString() == 'CT_PMonitor_1') {
          updateIsDeviceFound=true;
          updateDevicesData = r;
        }
        print('${r.device.name.toString()}');
      }
    });
    update();
    // FlutterBluePlus.stopScan();
  }

  onPressedBack() {
    if(devicesData!=null) {
      devicesData!.device.disconnect();
    }
    Get.back();
  }

  onPressedConnect() async {
    checkDeviceConnection();
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

  checkDeviceConnection() {
    devicesData!.device.state.listen((event) {
      print(event);

      // if(event==BluetoothDeviceState.connected) {
      if(event==BluetoothDeviceState.connected) {
        updateIsDeviceConnected=true;
        updateDeviceStates=true;
      }
      // else if(event==BluetoothDeviceState.disconnected) {
      else if(event==BluetoothDeviceState.disconnected) {
        if(devicesData!=null){
          devicesData!.device.disconnect();
        }

        updateIsDeviceConnected=false;
        updateDeviceStates=false;

      }
    });
  }

  getBPOtherData() async {
    List<BluetoothService> services =  await devicesData!.device.discoverServices();
    // print('Service length' + services.length.toString());

    services.forEach((service) async {
      print(service.uuid.toString().toUpperCase().substring(4, 8).toString());
      // print('Servic UUID' + service.uuid.toString());

      if(service.uuid.toString().toUpperCase().substring(4, 8).toString()=='180A') {  // 180A

        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          print('Characteristics UUID' + c.uuid.toString().toUpperCase().substring(4, 8));

          if(c.uuid.toString().toUpperCase().substring(4, 8).toString()=='2A38') {  // 2A38

          await c.write(utf8.encode(systolic.value.text));

            List<int> value = await c.read();
            // print(value);

            c.setNotifyValue(true);

            subscription1 = c.value.listen((event) {

              var data = ascii.decode(value);
              print(data.toString());

            });

          }
        }
      }
    });
    update();
  }

}
