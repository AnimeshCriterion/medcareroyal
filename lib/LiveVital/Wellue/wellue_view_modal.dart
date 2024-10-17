

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:medvantage_patient/LiveVital/Wellue/wellue_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';

import '../../View/widget/common_method/show_progress_dialog.dart';
import '../../authenticaton/user_repository.dart';
import '../../common_libs.dart';
import '../devices_api.dart';


import 'package:get/get.dart';

class WellueViewModal extends ChangeNotifier {







  FlutterBlue flutterBlue = FlutterBlue.instance;


  BluetoothDevice? deviceData;
  BluetoothDevice get getDeviceData=>deviceData!;

  set updateDeviceData(BluetoothDevice val){
    deviceData=val;
    notifyListeners();
  }



  bool isScanning=false;
  get getIsScanning=>isScanning;
  set updateIsScanning(bool val){
    isScanning=val;
    notifyListeners();
  }


  bool isDeviceFound=false;
  bool get getIsDeviceFound=>isDeviceFound;
  set updateIsDeviceFound(bool val){
    isDeviceFound=val;
    notifyListeners();
  }

  bool isDeviceConnected=false;
  bool get getIsDeviceConnected=>isDeviceConnected;
  set updateIsDeviceConnected(bool val){
    isDeviceConnected=val;
    notifyListeners();
  }


  getDevices() {

    updateIsScanning=true;
    updateIsDeviceFound=false;

    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

// Listen to scan results
      flutterBlue.scanResults.listen((results) {
      // do something with scan results


      for (ScanResult r in results) {
        if (r.device.name.toString().split(' ')[0].toString() == 'OxySmart') {


          updateDeviceData = r.device;

          updateIsDeviceFound=true;

        }
        print('${r.device.name} ');
      }
    });
Timer(const Duration(seconds: 4), () {

  updateIsScanning=false;
      });
// Stop scanning
    flutterBlue.stopScan();

  }



  ckeckDeviceConnection(){
    getDeviceData.state.listen((event) async {
      print('nnnnnnnnnnnnnnnn'+event.toString());

      if(event==BluetoothDeviceState.connected){
        updateIsDeviceConnected=true;
      }
      else if(event==BluetoothDeviceState.disconnected){
        updateIsDeviceConnected=false;
        // await   disConnected();
      }
      // if(flutterBlue.connectedDevices[0]=='') {
    });
  }


  disConnected()  async {
     await getDeviceData.disconnect();

  }


  onPressedConnect(context) async {
    ProgressDialogue().show(context, loadingText:    !getIsDeviceConnected?   'Connecting'
        : 'Disconnecting', );
    if(deviceData!=null){
      await deviceData!.connect(autoConnect: true);
    }

    List<BluetoothService> services = await deviceData!.discoverServices();

    print('service length : ${services.length}');
    services.forEach((service) async {

      print('service uuid : ${service.uuid.toString().toUpperCase().substring(4, 8)}');

          if(service.uuid.toString().toUpperCase().substring(4, 8).toString()=='0001'){
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if(c.uuid.toString().toUpperCase().substring(4, 8).toString()=='0003'){
            await c.setNotifyValue(true);
            //
            c.value.listen((values)  async {

              // start check internet is on
              //  CheckUserConnection();
              // end check internet is on



               oximeterValue(values);
              // print('value ' + values.toString());
            });

          }
        }
      }
      // do something with service
    });
    ProgressDialogue().hide();
  }

  WellueModal oximeterData=WellueModal();
  WellueModal get getOximeterData=>oximeterData;
  set updateOximeterData(Map val){
    oximeterData=WellueModal(
      spo2:val['spo2'],
      pr:val['pr'],
    );
    notifyListeners();
  }

  oximeterValue(List oxiList){
    
    List hexData=[];
    
    for(int i=0;i<oxiList.length;i++){
      hexData.add(oxiList[i].toRadixString(16));
    }


    if(hexData[0].toString().toUpperCase()=='AA'){
    if(hexData[1].toString()=='55'){
    if(hexData[2].toString().toUpperCase()=='F'){
    if(hexData[3].toString()=='8'){
      print('nnnnnn'+hexData.toString());

      updateOximeterData={"spo2":oxiList[5].toString() ,
        "pr":oxiList[6].toString()};

    }
    }
    }
    }
  }



  bool ActiveConnection=false;
  bool get getActiveConnection=>ActiveConnection;
  set updateActiveConnection(bool val){
    ActiveConnection=val;
    notifyListeners();

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
    print('Turn On the data and repress again$ActiveConnection');
  }




  saveVital(context,{ spo2,pr}) async {
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);

    try {
      List dtDataTable = [];
      if (getOximeterData.spo2 != null ) {
        dtDataTable.add({
          'vitalId': 56.toString(),
          'vitalValue': getOximeterData.spo2.toString(),
        });
      }  if (getOximeterData.spo2 != null ) {
        dtDataTable.add({
          'vitalId': 3.toString(),
          'vitalValue': getOximeterData.pr.toString(),
        });
      }


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

      if (data['responseCode'] == 1) {
      }
    }
    catch(e){

    }

  }


  onPressedBack(context){
    try{
      getDeviceData.disconnect();
    }catch(e){

    }
     Get.back();
  }

  clearData(){
    updateIsDeviceFound=false;
    updateIsScanning=false;
    oximeterData=WellueModal();
    notifyListeners();
  }

}



