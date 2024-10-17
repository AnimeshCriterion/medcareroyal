import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

alertToast(context,message){
  FocusScope.of(context).unfocus();
  Fluttertoast.showToast(
    msg: message,
  );
}

class EcgController extends GetxController {

  TextEditingController notesController = TextEditingController();

  Rx<FlutterBlue> flutterBlue = FlutterBlue.instance.obs;

  ScanResult? devicesData;
  set updateDevicesData(ScanResult val) {
    devicesData = val;
    update();
  }

  List<double> ecgData = [];

  set updateECGData(double val) {
    ecgData.add(val);
    print(val);
    update();
  }

  Rx<bool> isDeviceConnected = false.obs;
  bool get getIsDeviceConnected => isDeviceConnected.value;
  set updateIsDeviceConnected(bool val) {
    isDeviceConnected.value = val;
    update();
  }

  clearData(){
    updateIsDeviceConnected=false;
    // updateActiveConnection=false;
    updateIsDeviceFound=false;
    update();
  }

  Timer? timer;

  String HeartRate = '';

  EcgTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      HeartRate = getHr;
      update();
    });
  }

  Rx<String> hr = '00'.obs;
  String get getHr => hr.value;
  set updateHr(String val) {
    hr.value = val;
    update();
  }

  checkDeviceConnection() {
    devicesData!.device.state.listen((event) {
      print(event);
      if (event == BluetoothDeviceState.connected) {
        updateIsDeviceConnected = true;
      } else if (event == BluetoothDeviceState.disconnected) {
        updateIsDeviceConnected = false;
      }
    });
  }

  StreamSubscription? subscription;

  Rx<bool> isDeviceScanning=false.obs;
  bool get getIsDeviceScanning=>isDeviceScanning.value;
  set updateIsDeviceScanning(bool val) {
    isDeviceScanning.value=val;
    update();
  }

  Rx<bool> isDeviceFound=false.obs;
  bool get getIsDeviceFound=>isDeviceFound.value;
  set updateIsDeviceFound(bool val){
    isDeviceFound.value=val;
    update();
  }

  getDevices() {

    updateIsDeviceFound=false;
    updateIsDeviceScanning=true;

    // Start scanning
    flutterBlue.value.startScan(timeout: const Duration(hours: 1));
    updateIsDeviceScanning=false;

// Listen to scan results
    subscription = flutterBlue.value.scanResults.listen((results) {
      // do something with scan results

      for (ScanResult r in results) {
        if (r.device.name.toString() == 'CT_ECG') {
          flutterBlue.value.stopScan();
          updateIsDeviceFound=true;
          updateDevicesData = r;
          Future.delayed(Duration(seconds: 3)).then((value) async {
            await  devicesData!.device.connect(autoConnect: true);
            await  getData();
          });
        }

        print('Device Name : ${r.device.name.toString()}');
      }
    });
    flutterBlue.value.stopScan();
  }

  getData() async {
    checkDeviceConnection();
    flutterBlue.value.state.listen((event) {
      print('nnnnnnnnnn' + event.toString());
    });

    List<BluetoothService> services =
        await devicesData!.device.discoverServices();
    print('Service Length' + services.length.toString());
    services.forEach((service) async {
      if (service.uuid.toString().toUpperCase().substring(4, 8).toString() == 'C201') {
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if (c.uuid.toString().toUpperCase().substring(4, 8).toString() == '483E') {
            c.setNotifyValue(true);
            subscription = c.value.listen((value2) async {
              // print('nnnnnnnnnn'+value2.toString());
              try{
                var data = ascii.decode(value2);
                // print('nvnvnnv'+data.toString());
                // print('nnnnnnnnnn' + (double.parse(data.replaceAll('\n', '').split(',')[0].toString())*0.00166).toString());

                // Ecg graph values
                //     if(!getIsCountDone)   changes...
                {
                  updateECGData = double.parse((double.parse(data
                                  .replaceAll('\n', '')
                                  .split(',')[0]
                                  .toString()) *
                              0.00166)
                          .toString() // (5/3000=0.00166)

                      );

                  // HR value
                  updateHr = data.replaceAll('\n', '').split(',')[1].toString();
                }
              }
              catch(e){

              }
              // do something with new value
            });
          }
        }
      }
    });
    update();
  }

}
