import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../app_manager/alert_toast.dart';
import '../../authenticaton/user_repository.dart';
import '../live_vital_controller.dart';


class MyPatientMonitorController extends GetxController{


  FlutterBlue flutterBluePlus =  FlutterBlue.instance;

  StreamSubscription? scanSubscription;
  StreamSubscription? subscription1;
  StreamSubscription? subscription2;
  StreamSubscription? subscription3;
  StreamSubscription? subscription4;
  StreamSubscription? subscription5;


  String ECGPercentage='00';
  String get getECGPercentage=>ECGPercentage;
  int get getEcgStepper=>getECGPercentage==''? 0:(int.parse(getECGPercentage.toString())/10).round();
  set updateECGPercentage(String val) {
    ECGPercentage=val;
    update();
  }


  String spo2Percentage='00';
  String get getSpo2Percentage=>spo2Percentage;
  int get getSpo2Stepper=>getSpo2Percentage==''? 00:(int.parse(getSpo2Percentage.toString())/10).round();
  set updateSpo2Percentage(String val) {
    spo2Percentage=val;
    update();
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
    flutterBluePlus.startScan(timeout: const Duration(seconds: 4)).then((value) {

      updateIsDeviceScanning=false;
    });

    // Listen to scan results
    scanSubscription = flutterBluePlus.scanResults.listen((results) {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }



  List<double> hrList=[];
  List get getHrList=>hrList;
  set updateHrList(double val) {
    if(hrList.length<=1500){
      hrList.add(val);
    }else{
      hrList.removeAt(0);
      hrList.add(val);
    }
    update();
  }


  // ECG live graph data
  List hrGraphDataList = ["Date,             Time,         Value" "\n"];
  String hrGraphDataListGraphT='0';
  List get getHrGraphDataList=>hrGraphDataList;
  set updateHrGraphDataList(String val) {
    hrGraphDataListGraphT=val.toString();
    update();
  }
  ecgLiveGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
      if(hrGraphDataList.length<=1500){
        hrGraphDataList.add({
          DateFormat("yyyy-MM-dd, hh:mm:ss a")
              .format(DateTime.now())
              .toString(),
          hrGraphDataListGraphT
        });
      }
      else{
        hrGraphDataList.removeAt(0);
        hrGraphDataList.add({
          DateFormat("yyyy-MM-dd, hh:mm:ss a")
              .format(DateTime.now())
              .toString(),
          hrGraphDataListGraphT
        });
      }
    } 
    );

    update();

  }



  List<double> spo2List=[];
  List get getSpo2List=>spo2List;
  set updateSpo2List(double val) {
    if(spo2List.length<=1500){
      spo2List.add(val);
    }else{

      spo2List.removeAt(0);
      spo2List.add(val);
    }
    update();
  }


  // SpO2 live graph data
  List spO2GraphDataList = ["Date,             Time,         Value" "\n"];
  String spO2GraphDataListGraphT='0';
  List get getSpO2GraphDataList=>spO2GraphDataList;
  set updateSpO2GraphDataList(String val) {
    // spO2GraphDataList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    spO2GraphDataListGraphT=val.toString();
    update();
  }
  spO2LiveGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
      if(spO2GraphDataList.length<=1500){
        spO2GraphDataList.add({
          DateFormat("yyyy-MM-dd, hh:mm:ss a")
              .format(DateTime.now())
              .toString(),
          spO2GraphDataListGraphT
        });
      } 
      else{spO2GraphDataList.removeAt(0);
        spO2GraphDataList.add({
          DateFormat("yyyy-MM-dd, hh:mm:ss a")
              .format(DateTime.now())
              .toString(),
          spO2GraphDataListGraphT
        });
      }
    }
    );

    update();

  }


  onPressedConnect() async {
    checkDeviceConnection();
    await getLiveData();
    await getBPData();
    await getHrData();
    await getTempData();
    await getPrData();
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


  getLiveData() async {
    ecgLiveGraphT();
    spO2LiveGraphT();
    List<BluetoothService> services = await devicesData!.device.discoverServices();
    services.forEach((service) async {
      print(service.uuid.toString().toUpperCase().substring(4, 8).toString());
      print(service.uuid.toString());

      if (service.uuid.toString().toUpperCase().substring(4, 8).toString() ==
          '181C') {

        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {

          print('characteristics'+c.uuid.toString());

          if (c.uuid.toString().toUpperCase().substring(4, 8).toString() ==
              '0040') {
            c.setNotifyValue(true);
            subscription5 = c.value.listen((value2) async {


              var data = ascii.decode(value2);

              print('nnnnnnnnnn'+data.toString());

              updateHrList=double.parse(data.split(',')[0].toString());

              // updateHrGraphDataList=double.parse(data.split(',')[0].toString());  ///ECG graph live data
              updateHrGraphDataList=double.parse(data.split(',')[0].toString()).toString();

              // updateSpO2GraphDataList=double.parse(data.split(',')[0].toString());  /// SpO2 graph live data
              updateSpO2GraphDataList=double.parse(data.split(',')[0].toString()).toString();

              updateSpo2List=double.parse(data.split(',')[1].toString());


            });
          }
        }

      }

    });
    update();
  }


  // BP Value
  Map bpData={'mode':'e',
    'systolic':'00',
    'diastolic':'00'};
  Map get getBpData=>bpData;
  set updateBpData(Map val) {
    bpData=val;
    update();
  }

  // BP Value List
  List bpValueList = ["Date,             Time,       Value" "\n"];
  List bpValueListGraph=[];
  String bpValueListGraphT = '0';
  List get getBpValueList=>bpValueList;
  set updateBpValueList(String val) {
    // bpValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    bpValueListGraphT=val.toString();
    update();
  }
  bpGraphT(){

    Timer.periodic(
        Duration(seconds: 20), (timer) {
      // bpValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), bpValueListGraphT});
      if(bpValueListGraphT[0]=='f'){
        bpValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), bpValueListGraphT});
      }
    }
    );


    Timer.periodic(
        Duration(seconds: 60), (timer) {
      // bpValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':bpValueListGraphT.toString()==''? '0':bpValueListGraphT});
      if(bpValueListGraphT[0]=='f'){
        bpValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':bpValueListGraphT});
      }
    }
    );

    update();

  }

  averagebpsys() {

    try{
      print("hhhhhhhh"+bpValueListGraph.length.toString());

      var sum=0.0;
      double avg=0.0;

      for(var i=0; i<bpValueListGraph.map((e)=>e['value'].split(',')[1]).toList().length; i++) {
        sum += double.parse(bpValueListGraph.map((e)=>e['value'].split(',')[1]).toList()[i]);
        print("sssss"+sum.toString());
      }

      avg = sum/(bpValueListGraph.map((e)=>e['value'].split(',')[1]).length);
      print('ddddddddddd'+avg.toString());
      // return avg.toStringAsFixed(2);
      return bpValueListGraph.isEmpty?'0':avg.toStringAsFixed(2);

    } catch (e) {
      print("eeeeee"+e.toString());
    }

  }

  averagebpdia() {

    try{
      print("hhhhhhhh"+bpValueListGraph.length.toString());

      var sum=0.0;
      double avg=0.0;

      for(var i=0; i<bpValueListGraph.map((e)=>e['value'].split(',')[2]).toList().length; i++) {
        sum += double.parse(bpValueListGraph.map((e)=>e['value'].split(',')[2]).toList()[i]);
        print("sssss"+sum.toString());
      }

      avg = sum/(bpValueListGraph.map((e)=>e['value'].split(',')[2]).length);
      print('ddddddddddd'+avg.toString());
      // return avg.toStringAsFixed(2);
      return bpValueListGraph.isEmpty?'0':avg.toStringAsFixed(2);

    } catch (e) {
      print("eeeeee"+e.toString());
    }

  }

  getBPData() async {
    bpGraphT();
    List<BluetoothService> services =  await devicesData!.device.discoverServices();
    services.forEach((service) async {
      print(service.uuid.toString().toUpperCase().substring(4, 8).toString());
      // print(service.uuid.toString());

      if(service.uuid.toString().toUpperCase().substring(4, 8).toString()=='1810') {
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          print('nnnnnnnnnnnnnnnnnn' + c.uuid.toString().toUpperCase().substring(4, 8));
          if(c.uuid.toString().toUpperCase().substring(4, 8).toString()=='2A49'){
            c.setNotifyValue(true);
            subscription1 = c.value.listen((value2) async {
              // print('nnnnnnnnnn'+value2.toString());

              var data = ascii.decode(value2);
              try{
                if (data.toString().split(',')[0].toString() ==
                        'f' || // Final result
                    data.toString().split(',')[0].toString() ==
                        'i' // Air inflation
                    ||
                    data.toString().split(',')[0].toString() == 'e') {
                  //  Error
                  updateBpData = {
                    'mode': data.toString().split(',')[0],
                    'systolic': data.toString().split(',')[1],
                    'diastolic': data.toString().split(',')[2]
                  };
                  updateBpValueList = data.toString().split('-')[0];
                  updateBpValueList = data.toString().split('-')[1];
                  updateBpValueList = data.toString().split(',')[2];
                }
              }
              catch(e){

              }
              print('nnnnnnnnnn' + data.toString());
            });
          }
        }
      }
    });
    update();
  }


  // Heart Rate Value
  String hrValue='00';
  String get getHrValue=>hrValue;
  set updateHrValue(String val) {
    hrValue=val;
    update();
  }

  // Heart Rate List
  List hrValueList= ["Date,             Time,       Value" "\n"];
  List hrValueListGraph=[];
  String hrValueListGraphT = '0';
  List get getHrValueList=>hrValueList;
  set updateHrValueList(String val) {
    // hrValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    hrValueListGraphT=val.toString();
    update();
  }
  hrGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
      hrValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), hrValueListGraphT});
    }
    );

    Timer.periodic(
      Duration(seconds: 30), (timer) {
        hrValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), 'value':hrValueListGraphT.toString()==''? '0':hrValueListGraphT});
    }
    );

  update();

}

  averagehr() {

  try{
    print("hhhhhhhh"+hrValueListGraph.length.toString());

    int sum=0;
    double avg=0.0;

    for(int i=0; i<hrValueListGraph.map((e)=>e['value']).toList().length; i++) {
      sum += int.parse(hrValueListGraph.map((e)=>e['value']).toList()[i]);
      print("sssss"+sum.toString());
    }

    avg = sum/(hrValueListGraph.map((e)=>e['value']).length);
    print('ddddddddddd'+avg.toString());
    // return avg.toStringAsFixed(2);
    return hrValueListGraph.isEmpty?'0':avg.toStringAsFixed(2);

  } catch (e) {
    print("eeeeee"+e.toString());
  }

  }

  getHrData() async {
    hrGraphT();
    List<BluetoothService> services =  await devicesData!.device.discoverServices();
    services.forEach((service) async {
      print(service.uuid.toString().toUpperCase().substring(4, 8).toString());
      // print(service.uuid.toString());

      if(service.uuid.toString().toUpperCase().substring(4, 8).toString()=='180D') {
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          print('nnnnnnnnnnnnnnnnnn' + c.uuid.toString().toUpperCase().substring(4, 8));
          if(c.uuid.toString().toUpperCase().substring(4, 8).toString()=='2A37'){
            c.setNotifyValue(true);
            subscription2 = c.value.listen((value2) async {

              var data = ascii.decode(value2);
              print('hrrhrhrhrhrhrhrhrh' + data.toString());
              try{
                updateHrValue = data.toString();
                updateHrValueList = data.toString().split(',')[0];
                updateECGPercentage = data.toString();
              }
              catch(e){

              }
            });
          }
        }
      }
    });
    update();
  }



  // Temperature Value
  String tempValue='00.0';
  String get getTempValue=>tempValue;
  set updateTempValue(String val) {
    tempValue=val;
    update();
  }

  // Temperature List
  List tempValueList=["Date,             Time,       Value" "\n"];
  List tempValueListGraph=[];
  String tempValueListGraphT = '0';
  List get getTempValueList=>tempValueList;
  set updateTempValueList(String val) {
    // tempValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    tempValueListGraphT=val.toString();
    update();
  }
  tempGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
      tempValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), tempValueListGraphT});
    }
    );

    Timer.periodic(
        Duration(seconds: 30), (timer) {
      tempValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':tempValueListGraphT.toString()==''? '0':tempValueListGraphT});
    }
    );

    update();

  }

  averagetemp() {

    try{
      print("hhhhhhhh"+tempValueListGraph.length.toString());

      var sum=0.0;
      double avg=0.0;

      for(var i=0; i<tempValueListGraph.map((e)=>e['value']).toList().length; i++) {
        sum += double.parse(tempValueListGraph.map((e)=>e['value']).toList()[i]);
        print("sssss"+sum.toString());
      }

      avg = sum/(tempValueListGraph.map((e)=>e['value']).length);
      print('ddddddddddd'+avg.toString());
      // return avg.toStringAsFixed(2);
      return tempValueListGraph.isEmpty?'0':avg.toStringAsFixed(2);

    } catch (e) {
      print("eeeeee"+e.toString());
    }

  }

  getTempData() async {
    tempGraphT();
    List<BluetoothService> services =  await devicesData!.device.discoverServices();
    services.forEach((service) async {
      print(service.uuid.toString().toUpperCase().substring(4, 8).toString());
      // print(service.uuid.toString());

      if(service.uuid.toString().toUpperCase().substring(4, 8).toString()=='1809'){
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {

          if(c.uuid.toString().toUpperCase().substring(4, 8).toString()=='2A6E'){
            c.setNotifyValue(true);
            subscription3 = c.value.listen((value2) async {

              var data = ascii.decode(value2);

              updateTempValue=data.toString();
              updateTempValueList=data.toString();
            });
          }
        }
      }
    });
    update();
  }


  // SpO2 Value
  String spo2Value='00';
  String get getSpo2Value=>spo2Value;
  set updateSpo2Value(String val) {
    spo2Value=val;
    update();
  }

  // SpO2 Value List
  List spO2ValueList=["Date,             Time,       Value" "\n"];
  List spO2ValueListGraph=[];
  String spO2ValueListGraphT = '0';
  List get getSpO2ValueList=>spO2ValueList;
  set updateSpO2ValueList(String val) {
    // spO2ValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    spO2ValueListGraphT=val.toString();
    update();
  }
  spO2GraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
      spO2ValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), spO2ValueListGraphT});
    }
    );

    Timer.periodic(
        Duration(seconds: 30), (timer) {
      spO2ValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':spO2ValueListGraphT.toString()==''? '0':spO2ValueListGraphT});
    }
    );

    update();

  }

  averagespO2() {

    try{
      print("hhhhhhhh"+spO2ValueListGraph.length.toString());

      int sum=0;
      double avg=0.0;

      for(int i=0; i<spO2ValueListGraph.map((e)=>e['value']).toList().length; i++) {
        sum += int.parse(spO2ValueListGraph.map((e)=>e['value']).toList()[i]);
        print("sssss"+sum.toString());
      }

      avg = sum/(spO2ValueListGraph.map((e)=>e['value']).length);
      print('ddddddddddd'+avg.toString());
      // return avg.toStringAsFixed(2);
      return spO2ValueListGraph.isEmpty?'0':avg.toStringAsFixed(2);

    } catch (e) {
      print("eeeeee"+e.toString());
    }

  }


  // Pulse Rate Value
  String prValue='00';
  String get getPrValue=>prValue;
  set updatePrValue(String val) {
    prValue=val;
    update();
  }

  // Pulse Rate List
  List prValueList=["Date,             Time,       Value" "\n"];
  List prValueListGraph=[];
  String prValueListGraphT = '0';
  List get getPrValueList=>prValueList;
  set updatePrValueList(String val) {
    // prValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    prValueListGraphT=val.toString();
    update();
  }
  prGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
      prValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), prValueListGraphT});
    }
    );

    Timer.periodic(
        Duration(seconds: 30), (timer) {
      prValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':prValueListGraphT.toString()==''? '0':prValueListGraphT});
    }
    );

    update();

  }

  averagepr() {

    try{
      print("hhhhhhhh"+prValueListGraph.length.toString());

      int sum=0;
      double avg=0.0;

      for(int i=0; i<prValueListGraph.map((e)=>e['value']).toList().length; i++) {
        sum += int.parse(prValueListGraph.map((e)=>e['value']).toList()[i]);
        print("sssss"+sum.toString());
      }

      avg = sum/(prValueListGraph.map((e)=>e['value']).length);
      print('ddddddddddd'+avg.toString());
      // return avg.toStringAsFixed(2);
      return prValueListGraph.isEmpty?'0':avg.toStringAsFixed(2);

    } catch (e) {
      print("eeeeee"+e.toString());
    }

  }

  getPrData() async {
    spO2GraphT();
    prGraphT();
    List<BluetoothService> services =  await devicesData!.device.discoverServices();
    services.forEach((service) async {
      print(service.uuid.toString().toUpperCase().substring(4, 8).toString());
      // print(service.uuid.toString());

      if(service.uuid.toString().toUpperCase().substring(4, 8).toString()=='1822') {
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {

          if(c.uuid.toString().toUpperCase().substring(4, 8).toString()=='1004') {
            c.setNotifyValue(true);
            subscription4 = c.value.listen((value2) async {
              print('nnnnvnnnnvnn'+value2.toString());

              var data = ascii.decode(value2);

              if(data.isNotEmpty){
                updateSpo2Value = data.toString().split(',')[0];
                updateSpO2ValueList = data.toString().split(',')[0];
                updateSpo2Percentage = data.toString().split(',')[0];
                updatePrValue = data.toString().split(',')[1];
                updatePrValueList = data.toString().split(',')[1];
              }
            });
          }
        }
      }
    });
    update();
  }


  Future<BluetoothCharacteristic?> getPatientData({required String myService, required String myCharacteristic,required String name}) async {
    print(name.toString());

    String data='';
    late BluetoothCharacteristic ch;

    List<BluetoothService> services =  await devicesData!.device.discoverServices();
    services.forEach((service) async {
      print(service.uuid.toString().toUpperCase().substring(4, 8).toString());
      // print(service.uuid.toString());

      if(service.uuid.toString().toUpperCase().substring(4, 8).toString()==myService){
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          print('nnnnnnnnnnnnnnnnnn' + c.uuid.toString().toUpperCase().substring(4, 8));

          if(c.uuid.toString().toUpperCase().substring(4, 8).toString()==myCharacteristic.toString()){
            ch=c;
            // c.setNotifyValue(true);
            // subscription = c.value.listen((value2) async{
            //    data = ascii.decode(value2);
            //
            //   print('nnnnnnnnnn' + data.toString());
            // });
          }
        }
      }
    });
    update();
    return ch;
  }


  late Timer timer1;
  late Timer timer2;


  pTimer(context) {
    timer1 = Timer.periodic(const Duration(seconds: 2), (timer) async {

      // if(!getDeviceStates){
      //   // Get.back();
      //   SystemChrome.setPreferredOrientations([
      //     DeviceOrientation.portraitUp,
      //   ]);
      // }
    });

    timer2 = Timer.periodic(const Duration(seconds: 15), (timer) async {
      CheckUserConnection();
      if(getActiveConnection){
        await saveData(context);
      }
    });

  }


  bool ActiveConnection=false;
  bool get getActiveConnection=>ActiveConnection;
  set updateActiveConnection(bool val) {
    ActiveConnection = val;
    update();
  }


  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        updateActiveConnection = true;

      }
    }
    on SocketException catch (_) {

      updateActiveConnection = false;

    }
    print('Turn On the data and repress again'+ActiveConnection.toString());
  }




  // saveDeviceVital(context,) async {
  //
  //   List dtDataTable = [];
  //
  //   if(getSpo2Value.toString()!='0'){
  //     dtDataTable.add({
  //       'vitalId': 56.toString(),
  //       'vitalValue': getSpo2Value.toString(),
  //     });}
  //
  //   if(getSpo2Value!='0'){
  //     dtDataTable.add({
  //       'vitalId': 3.toString(),
  //       'vitalValue':getPrValue.toString(),
  //     });}
  //
  //   if(getBpData['mode']=='f' ){
  //     dtDataTable.add({
  //       'vitalId': 4.toString(),
  //       'vitalValue':getBpData['systolic'].toString(),
  //     });}
  //
  //   if(getBpData['mode']=='f' ){
  //     dtDataTable.add({
  //       'vitalId': 6.toString(),
  //       'vitalValue':getBpData['diastolic'].toString(),
  //     });}
  //
  //   if(getTempValue!='00.0'){
  //     dtDataTable.add({
  //       'vitalId': 5.toString(),
  //       'vitalValue':getTempValue.toString(),
  //     });}
  //
  //   if(getHrValue!='00'){
  //     dtDataTable.add({
  //       'vitalId': 74.toString(),
  //       'vitalValue':getHrValue.toString(),
  //     });}
  //
  //
  //
  //
  //   var body = {
  //     "memberId": UserData().getUserMemberId,
  //     'dtDataTable': jsonEncode(dtDataTable),
  //     "date": DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
  //     "time": DateFormat("HH:mm:ss").format(DateTime.now()).toString(),
  //   };
  //
  //   var data = await RawData().api(
  //     "Patient/addVital",
  //     body,
  //     context,
  //   );
  //
  //
  //
  //
  // }


  LiveVitalModal vitalModal=LiveVitalModal();


  // Press Event


    saveData(context) async{

    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);


      // vitalModal.onPressedClear(context);
      // vitalModal.controller.vitalTextX[2].text=controller.getOximeterData.spo2.toString() ;
      // vitalModal.controller.vitalTextX[0].text=controller.getOximeterData.heartRate.toString();
      // vitalModal.controller.vitalsList[6]['controller'].text=controller.getOximeterData.hrv.toString();
      // vitalModal.controller.vitalsList[6]['controller'].text=controller.getOximeterData.perfusionIndex.toString();


      var data= await vitalModal.addVitals(context,
          spo2: getSpo2Value.toString(),
        pr: getPrValue.toString(),
        BPSys: getBpData['systolic'].toString(),
        BPDias: getBpData['diastolic'].toString(),
        tmp: getTempValue.toString(),
        hr: getHrValue.toString()
      );


      if(data['status']==0){
        Alert.show(data['message'].toString());
      }
      else{
        if(data['responseCode']==1){
          Alert.show('Data Saved Successfully !');
        }
        else{
          Alert.show(data['message'].toString());
        }
      }
  }



}
