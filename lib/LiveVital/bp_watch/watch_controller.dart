import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../medcare_utill.dart';
import '../live_vital_controller.dart';

class WatchController extends GetxController {

  FlutterBluePlus flutterBluePlus = FlutterBluePlus();

  StreamSubscription? scanSubscription;
  StreamSubscription? bpSubscription;

  bool permGranted = true;

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

  scanDevices() async {

    Permission.bluetooth;
    Permission.location;

    var status = await Permission.location.status;
    if(status.isDenied) {
      permGranted=false;
    }
    if(await Permission.location.request().isGranted) {
      permGranted=true;
    }

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
        if (r.device.platformName.toString()=='BPW1') {
          // if (r.device.platformName.toString()=='CT_PMonitor_1') {
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
    if(devicesData!=null) {
      devicesData!.device.disconnect();
    }
    Get.back();
    Get.delete<WatchController>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  onPressConnect(context) async {
    checkDeviceConnection();
    await getBPData(context);
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
          devicesData!.device.connect();
        }
        updateIsDeviceConnected=false;
        updateDeviceStates=false;
      }
    });
  }

  /// Blood pressure description : -

  String  bpSysData = '';
  String get getBpSysData=>bpSysData;
  set updateBpSysData(String val) {
    bpSysData=val;
    update();
  }

  String bpDiaData = '';
  String get getBpDiaData=>bpDiaData;
  set updateBpDiaData(String val) {
    bpDiaData=val;
    update();
  }

  String bpPulData = '';
  String get getBpPulData=>bpPulData;
  set updateBpPulData(String val) {
    bpPulData=val;
    update();
  }

  getBPData(context) async {

    List<BluetoothService> services =  await devicesData!.device.discoverServices();
    services.forEach((service) async {
      if(service.uuid.toString()=='cc00') {
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if(c.uuid.toString()=='cc03'){
            await c.setNotifyValue(true);
            bpSubscription=c.lastValueStream.listen((value2) async {

              dPrint('values list : $value2');

              List data = value2.toList() ;
              if(data.isNotEmpty){
                var systolic =
                    data[7];
                var diastolic =
                    data[8];
                var pulse =
                    data[6];

                updateBpSysData = systolic.toString();
                updateBpDiaData = diastolic.toString();
                updateBpPulData = pulse.toString();
                update();
                await  LiveVitalModal(). addVitals(context,
                    BPSys: getBpSysData.toString(),
              BPDias:getBpDiaData.toString(),
              pr: getBpPulData.toString()
              );

              dPrint('Systolic value : $systolic');
              dPrint('Diastolic value : $diastolic');
              dPrint('Pulse value : $pulse');
            }
            });
          }
        }
      }
    });
    update();
  }

}
