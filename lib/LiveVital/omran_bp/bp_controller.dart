import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../live_vital_controller.dart';

class BPController extends GetxController{


  BluetoothDevice? devicesData;
  set updateDevicesData(BluetoothDevice val) {
    devicesData=val;
    update();
  }

  bool isScanning=false;
  bool get getIsScanning=>isScanning;
set updateIsScanning(bool val){
  isScanning=val;
  update();
}
  bool isFound=false;
  bool get getIsFound=>isFound;
  set updateIsFound(bool val){
    isFound=val;
    update();
  }
  scanDevices() {
    updateIsScanning=true;
    updateIsFound=false;
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4)).then((value) {

      // updateIsDeviceScanning=false;
    });

    Future.delayed(Duration(seconds: 4)).then((value) => updateIsScanning=false);

    // Listen to scan results
     FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      // do something with scan results
      for (ScanResult r in results) {
        if(r.device.id.toString()=='28:FF:B2:F9:B4:14'){
          updateDevicesData=r.device;
          updateIsFound=true;
          print('nnnnnnnnnnnnnn: ' + r.device.id.toString());
          print('nnnnnnnnnnnnnn: ' + r.device.name.toString());
        }
        print('Device MAC Address : ' + r.device.id.toString());

      }
    });
    update();
    // FlutterBluePlus.stopScan();
  }


  String sys='';
  String get getSys=>sys;
  set updateSys(String val){
    sys=val;
    update();
  }

  String dia='';
  String get getDia=>dia;
  set updateDia(String val){
    dia=val;
    update();
  }


  String pr='';
  String get getPr=>pr;
  set updatePr(String val){
    pr=val;
    update();
  }
  StreamSubscription? subscription;

  StreamSubscription? subscription1;

  tempData(context) async {
    subscription1=devicesData!.connectionState.listen((event) async {
      if(BluetoothConnectionState.disconnected==event){
        try{
          await devicesData!.connect();
        }
        catch(e){

        }
      } else if(BluetoothConnectionState.connected==event){

      }
      else{

      }}
    ) ;
    List<BluetoothService> services = await devicesData!.discoverServices();
    // print('Bluetooth services : ' + services.toString());
    services.forEach((service) async {

      print('Service UUID : ' + service.serviceUuid.toString());
      if (service.serviceUuid.toString()  == '1810') {

        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {

          print('Characteristics UUID : ' + c.uuid.toString());
          if (c.uuid.toString() == '2a35') {
            await  c.setNotifyValue(true,forceIndications:true,  );

            subscription=   c.lastValueStream.listen((value2) async {
                print("Data received from device : " + value2.toString());
                try{
                  if (value2.toList()[0].toString() == '22') {
                    updateSys = value2.toList()[1].toString();
                    updateDia = value2.toList()[3].toString();
                    updatePr = value2.toList()[14].toString();

                    await LiveVitalModal().addVitals(context,
                        BPSys: getSys.toString(),
                        BPDias: getDia.toString(),
                        pr: getPr.toString()
                    );
                  }
                }
                catch(e){

                }
                print("Data received from device : " + value2.toString());
            });
          }
        }
      }
    });
    update();
  }

}