import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../medcare_utill.dart';

alertToast(context,message){
  FocusScope.of(context).unfocus();
  Fluttertoast.showToast(
    msg: message,
  );
}

class EcgController extends GetxController {

  TextEditingController notesController = TextEditingController();


  ScanResult? devicesData;
  set updateDevicesData(ScanResult val) {
    devicesData = val;
    update();
  }

  List<double> ecgData = [];

  set updateECGData(double val) {
    ecgData.add(val);
    dPrint(val);
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
    devicesData!.device.connectionState.listen((event) {
      dPrint(event);
      if (event == BluetoothConnectionState.connected) {
        updateIsDeviceConnected = true;
      } else if (event == BluetoothConnectionState.disconnected) {
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

  getDevices() async {

    updateIsDeviceFound=false;
    updateIsDeviceScanning=true;


    List<BluetoothDevice> data= await FlutterBluePlus.connectedDevices;

      // String tempName='';
      for(int i=0;i<data.length;i++){
        try{
        await data[i].disconnect();
        }
        catch(e){

        }
    }
    // Start scanning
    FlutterBluePlus.startScan(timeout: const Duration(minutes: 5));
    updateIsDeviceScanning=false;

// Listen to scan results
    subscription = FlutterBluePlus.scanResults.listen((results) {
      // do something with scan
      dPrint('Device Name :  '+results.length.toString());
      for (ScanResult r in results) {
        dPrint('Device Name : ${r.device.name.toString()}');
        if (r.device.name.toString() == 'CT_ECG') {
        //
        // if (r.device.name.toString().contains('BLEsmart')) {
          FlutterBluePlus.stopScan();
          updateIsDeviceFound=true;
          updateDevicesData = r;
          Future.delayed(Duration(seconds: 3)).then((value) async {
            await  devicesData!.device.connect( );
            await  getData();
          });
        }

      }
      // FlutterBluePlus.stopScan();
    });
  }

  getData() async {
    checkDeviceConnection();

    List<BluetoothService> services =
        await devicesData!.device.discoverServices();
    dPrint('Service Length' + services.length.toString());
    services.forEach((service) async {
      if (service.uuid.toString()  == 'C201' ||
      service.uuid.toString().toUpperCase().substring(4, 8).toString() == 'C201') {
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if (
          c.uuid.toString().toUpperCase() == '483E'||
          c.uuid.toString().toUpperCase().substring(4, 8).toString() == '483E') {
            c.setNotifyValue(true);
            subscription = c.lastValueStream.listen((value2) async {
              // dPring('nnnnnnnnnn'+value2.toString());
              try{
                var data = ascii.decode(value2);
                // dPring('nvnvnnv'+data.toString());
                // dPring('nnnnnnnnnn' + (double.parse(data.replaceAll('\n', '').split(',')[0].toString())*0.00166).toString());

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
