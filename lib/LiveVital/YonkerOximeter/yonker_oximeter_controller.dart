

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../View/widget/common_method/show_progress_dialog.dart';
import '../../authenticaton/user_repository.dart';
import '../devices_api.dart';


class YonkerOximeterController extends GetxController{



  BluetoothDevice? devicesData;

  set updateDevicesData(BluetoothDevice val) {
    devicesData = val;
    update();
  }

  bool isDeviceFound=false;
  bool get getIsDeviceFound=>isDeviceFound;
  set updateIsDeviceFound(bool val){
    isDeviceFound=val;
    update();
  }
  bool isScanning=false;
  get getIsScanning=>isScanning;
  set updateIsScanning(bool val){
    isScanning=val;
    update();
  }


  getDevices(context) async {
    // Start scanning
    bool isAlreadyConnected=false;
     List<BluetoothDevice> data=await FlutterBluePlus.connectedDevices;
    print('nnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnn : ' + data.toString());
     if(data.isNotEmpty){

       updateIsDeviceFound = false;
       updateIsScanning = true;

       print('nnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnn : ' + data.toString());
       // String tempName='';
       for(int i=0;i<data.length;i++){
         if(data[i].name.toString().contains('BleModuleA')){
           updateIsScanning = false;
           // tempName=data[i].name.toString();
           isAlreadyConnected=true;
           print('nnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnn : ' + data.toString());
           updateDevicesData =data[i];
           Future.delayed(Duration(seconds: 3)).then((value) async {
             getData(context);
           });   updateIsDeviceFound = true;
         }
       }

     }
    if(!isAlreadyConnected){
      updateIsDeviceFound = false;
      updateIsScanning = true;
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 4)).then((value) {
        updateIsScanning = false;
      });
// Listen to scan results
      FlutterBluePlus.scanResults.listen((results) {
        // do something with scan results

        for (ScanResult r in results) {
          print(r.device.id.toString());
          if (r.device.name.toString() == 'BleModuleA') {
            updateDevicesData = r.device;
            updateIsDeviceFound = true;
            Future.delayed(Duration(seconds: 3)).then((value) async {
              FlutterBluePlus.stopScan();
              await getData(context);
            });
          }

          print('${r.device.name.toString()}');
        }
      });
    }
    FlutterBluePlus.stopScan();
  }

  bool isConnected=false;
  bool get getIsConnected=>isConnected;
  set updateIsConnected(bool val){
    isConnected=val;
    update();
  }

  checkConnection(context){
    devicesData!.state.listen((event) {
      print('nnnnnnnnnnnnnnnnnvnnvnnnnn' + getIsConnected.toString());
      if(event==BluetoothDeviceState.connected){
        updateIsConnected=true;

      }
      else if(event==BluetoothDeviceState.disconnected){
        updateIsConnected=false;
        devicesData!.connect();
      }
    });
  }



  String spo2='0.0';
  String get getSpo2=>spo2;
  set updateSpo2(String val){
    spo2=val;
    update();
  }

  String pr='0.0';
  String get getPR=>pr;
  set updatePr(String val){
    pr=val;
    update();
  }


  StreamSubscription? subscription;

  getData(context) async{
    if(!getIsConnected && devicesData!=null){
      if(devicesData!=null){
        if(getIsConnected){
          await devicesData!.disconnect();
        }
      }

      print('nnnnnnnnnnnnnnnnnvnnvnnnnn' + getIsConnected.toString());
      print('nnnnnnnnnnnnnnnnnvnnvnnnnn' + devicesData.toString());
      Future.delayed(Duration(seconds: 3)).then((value) async {
        await devicesData!.connect();
        checkConnection(context);
      });
    }

    List<BluetoothService> services =  await devicesData!.discoverServices();

    services.forEach((service) async {
      print('Service Length' + service.uuid.toString());
      if(service.uuid.toString()=='cdeacd80-5235-4c07-8846-93a37ee6b86d'){
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          print('nnnnnvnvnnvn' + c.uuid.toString());

          if(c.uuid.toString()=='cdeacd81-5235-4c07-8846-93a37ee6b86d'){
            c.setNotifyValue(true);
            subscription=  c.value.listen((value) async {

             if(value.isNotEmpty){
               if(value[0]==129){
                 updateSpo2=value[1].toString();
                 updatePr=value[2].toString();
               }
             }
            });
            }
        }
      }
    });
  }

  Timer? timer;

  bool ActiveConnection=false;
  bool get getActiveConnection=>ActiveConnection;
  set updateActiveConnection(bool val){
    ActiveConnection=val;
    update();

  }

  Future CheckUserConnection() async {
    try {

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        updateActiveConnection = true;


      }
    }
    on SocketException catch (_) {

      updateActiveConnection = false;

    }
    print('Turn On the data and repress again'+ActiveConnection.toString());
  }




  saveVital(context,{ spo2,pr}) async {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);

    try {
      List dtDataTable = [];
      if (spo2 != null && spo2 != '' ) {
        dtDataTable.add({
          'vitalId': 56.toString(),
          'vitalValue': spo2.toString(),
        });
      }  if (pr != null && pr != '' ) {
        dtDataTable.add({
          'vitalId': 3.toString(),
          'vitalValue': pr.toString(),
        });
      }


      if(dtDataTable.isNotEmpty){
        var body = {
          "memberId": userRepository.getUser.uhID.toString(),
          'dtDataTable': jsonEncode(dtDataTable),
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()).toString(),
        };

        var data = await RawData().api(
          "Patient/addVital",
          body,
          context,
        );

        if (data['responseCode'] == 1) {}
      }
    }
    catch(e){

    }

  }

}