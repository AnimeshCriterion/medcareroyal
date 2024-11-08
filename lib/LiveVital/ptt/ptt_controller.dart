import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class PulseTransitTimeController extends GetxController {

  FlutterBluePlus flutterBluePlus = FlutterBluePlus();

  StreamSubscription? scanSubscription;
  StreamSubscription? liveSubscription;
  StreamSubscription? hrSubscription;
  StreamSubscription? spO2PrSubscription;
  StreamSubscription? bpSubscription;
  StreamSubscription? tempSubscription;

  bool permGranted = true;

  BluetoothDevice? devicesData;
  set updateDevicesData(BluetoothDevice val) {
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

    bool isAlreadyConnected=false;
    updateIsDeviceScanning=true;
    updateIsDeviceFound=false;
    devicesData=null;
    updateDeviceStates=true;
    updateIsDeviceConnected=false;
    var status = await Permission.location.status;
    if(status.isDenied) {
      permGranted=false;
    }
    if(await Permission.location.request().isGranted) {
      permGranted=true;
    }


    print('Device scanning : $getIsDeviceScanning');

    // Start scanning
    FlutterBluePlus.startScan(timeout: const Duration(hours: 1)).then((value) {


    });
    Future.delayed((Duration(hours: 1))).then((value) {
      updateIsDeviceScanning=false;
    });
    List<BluetoothDevice> data= await FlutterBluePlus.connectedDevices;
    print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnvnnnnnnnnnnnnn  : ${data}');
    for(int i=0;i<data.length;i++){
      if(data[i].platformName.toString().contains('CT_PTT_Device')) {
        isAlreadyConnected=true;
        updateIsDeviceFound=true;
        updateIsDeviceScanning=false;
        updateDevicesData=data[i];
        Future.delayed((Duration(seconds: 1))).then((value) async {
          await   devicesData!.connect();
          await onPressConnect();
        });
      }
      }

    // Listen to scan results
        if(!isAlreadyConnected){
      scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        // do something with scan results
        for (ScanResult r in results) {
          print('Device name : ${r.device.platformName}');
          if (r.device.platformName.toString() == 'CT_PTT_Device') {
            FlutterBluePlus.stopScan();
            // if (r.device.platformName.toString()=='CT_PMonitor_1') {
            updateIsDeviceFound = true;
            updateIsDeviceScanning = false;
            updateDevicesData = r.device;
            Future.delayed((Duration(seconds: 1))).then((value) async {
              await devicesData!.connect();
              await onPressConnect();
            });
          }
          print('Device name : ${r.device.platformName}');
        }
      });
      update();
    }
    // FlutterBluePlus.stopScan();
  }

  onPressBack() async {
    try{

        await devicesData!.disconnect();
        FlutterBluePlus.stopScan();
    }
    catch(e){

    }
    Get.back();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Get.delete<PulseTransitTimeController>();
  }

  onPressConnect() async {
    checkDeviceConnection();
    await getLiveData();
    await getHrData();
    await getPrData();
    await getBPData();
    await getTempData();
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
    devicesData!.connectionState.listen((event) {
      if(event==BluetoothConnectionState.connected) {
        updateIsDeviceConnected=true;
        updateDeviceStates=true;
      }
      else if(event==BluetoothConnectionState.disconnected) {
        if(devicesData!=null){
          devicesData!.connect();
        }
        updateIsDeviceConnected=false;
        updateDeviceStates=false;
      }
    });
  }










  // Heart rate list for live ecg graph
  List<double> hrList=[];
  List get getHrList=>hrList;
  set updateHrList(double val) {
    hrList.add(val);
    update();
  }

  // heart rate graph list for log file
  List hrGraphDataList=["Date,       Time,        Value" "\n"];
  String hrGraphDataListGraphT='0';
  List get getHrGraphDataList=>hrGraphDataList;
  set updateHrGraphDataList(String val) {
    // hrGraphDataList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    hrGraphDataListGraphT=val.toString();
    update();
  }
  ecgLiveGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
          hrGraphDataList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), hrGraphDataListGraphT});
        }
    );

    update();

  }


  // SpO2 list for live SpO2 graph
  List<double> spO2List=[];
  List get getSpO2List=>spO2List;
  set updateSpO2List(double val) {
    spO2List.add(val);
    update();
  }

  // SpO2 graph list for log file
  List spO2GraphDataList = ["Date,       Time,        Value" "\n"];
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
          spO2GraphDataList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), spO2GraphDataListGraphT});
        }
    );

    update();

  }


  getLiveData() async {
    ecgLiveGraphT();
    spO2LiveGraphT();

    List<BluetoothService> services = await devicesData!.discoverServices();
    services.forEach((service) async {
      if (service.uuid.toString()=='181c') {
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if (c.uuid.toString()=='0040') {
            await c.setNotifyValue(true);
            liveSubscription=c.lastValueStream.listen((value2) async {
              try{
                var data = ascii.decode(value2);
                print('ECG and SpO2 received from device : $data');

                // For ECG Graph
                updateHrList = double.parse(data.split(',')[0].toString());

                // For SpO2 Graph
                updateSpO2List = double.parse(data.split(',')[1].toString());

                updateHrGraphDataList =
                    double.parse(data.split(',')[0].toString()).toString();

                updateSpO2GraphDataList =
                    double.parse(data.split(',')[1].toString()).toString();
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





  /// Heart rate description : -
  // Heart rate value stepper
  String ecgPercentage='00';
  String get getEcgPercentage=>ecgPercentage;
  int get getEcgStepper=>getEcgPercentage==''? 0:(int.parse(getEcgPercentage.toString())/10).round();
  set updateEcgPercentage(String val) {
    ecgPercentage=val;
    update();
  }

  // Heart rate value
  String hrValue='';
  String get getHrValue=>hrValue;
  set updateHrValue(String val) {
    hrValue=val;
    update();
  }

  // Heart rate value list for log file
  List hrValueList=["Date,       Time,        Value" "\n"];
  List hrValueListGraph=[];
  String hrValueListGraphT='0';
  List get getHrValueList=>hrValueList;
  set updateHrValueList(String val) {
    // hrValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    hrValueListGraphT=val.toString();
    update();
  }
  hrGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
          if(hrValue.toString()!='0') {
            hrValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), hrValueListGraphT});
          }
        }
    );

    Timer.periodic(
        Duration(seconds: 30), (timer) {
          if(hrValueListGraphT.toString()!='0') {
            hrValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), 'value':hrValueListGraphT.toString()==''? '0':hrValueListGraphT});
          }
        }
    );

    update();

  }

 String averageHr() {
   double avg=0.0;
    try{
      print("heart rate value list graph length :  ${hrValueListGraph.length}");

      int sum=0;


      for(int i=0; i<hrValueListGraph.map((e)=>e['value']).toList().length; i++) {
        sum += int.parse(hrValueListGraph.map((e)=>e['value']).toList()[i]);
        print("sum : "+sum.toString());
      }

      avg = sum/(hrValueListGraph.map((e)=>e['value']).length);
      print('average : '+avg.toString());


    } catch (e) {
      print("Error about sum and average related : $e");
    }
   return hrValueListGraph.isEmpty?'0':avg.toStringAsFixed(2).toString();
  }

  getHrData() async {
    hrGraphT();

    List<BluetoothService> services =  await devicesData!.discoverServices();
    services.forEach((service) async {
      if(service.uuid.toString()=='180d') {
        var characteristics=service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if(c.uuid.toString()=='2a37'){
            await c.setNotifyValue(true);
            hrSubscription=c.lastValueStream.listen((value2) async {
              var data=ascii.decode(value2);
              print('Heart rate received from device : $data');

              try{
                updateHrValue=data.toString();
                print('Heart rate 1 : $data');

                updateHrValueList=data.toString().split(',')[0];

                updateEcgPercentage=data.toString();
              }
              catch(e){
                print('Error heart rate 1 : $e');
              }

            });
          }
        }
      }
    });
    update();
  }





  /// SpO2 and Pulse rate description : -
  // SpO2 value stepper
  String spO2Percentage='00';
  String get getSpO2Percentage=>spO2Percentage;
  int get getSpO2Stepper=>getSpO2Percentage==''? 0:(int.parse(getSpO2Percentage.toString())/10).round();
  set updateSpO2Percentage(String val) {
    spO2Percentage=val;
    update();
  }

  // SpO2 Value
  String spO2Value='';
  String get getSpO2Value=>spO2Value;
  set updateSpO2Value(String val) {
    spO2Value=val;
    update();
  }

  // SpO2 value list for log file
  List spO2ValueList=["Date,       Time,        Value" "\n"];
  List spO2ValueListGraph=[];
  String spO2ValueListGraphT='0';
  List get getSpO2ValueList=>spO2ValueList;
  set updateSpO2ValueList(String val) {
    // spO2ValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    spO2ValueListGraphT=val.toString();
    update();
  }
  spO2GraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
            if(spO2Value.toString() != '0'){
              spO2ValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), spO2ValueListGraphT});
            }
        }
    );

    Timer.periodic(
        Duration(seconds: 30), (timer) {
            if(spO2ValueListGraphT.toString() != ' 0') {
              spO2ValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':spO2ValueListGraphT.toString()==''? '0':spO2ValueListGraphT});
            }
        }
    );

    update();

  }

  averageSpO2() {

    double avg=0.0;
    try {
      print("SpO2 value list graph length : ${spO2ValueListGraph.length}");

      int sum=0;

      for(int i=0; i<spO2ValueListGraph.map((e)=>e['value']).toList().length; i++) {
        sum += int.parse(spO2ValueListGraph.map((e)=>e['value']).toList()[i]);
        print("sum : "+sum.toString());
      }

      avg = sum/(spO2ValueListGraph.map((e)=>e['value']).length);
      print('average : '+avg.toString());
    } catch (e) {
      print("Error about sum and average related : $e");
    }

    return spO2ValueListGraph.isEmpty?'0':avg.toStringAsFixed(2).toString();
  }

  // Pulse Rate Value
  String prValue='';
  String get getPrValue=>prValue;
  set updatePrValue(String val) {
    prValue=val;
    update();
  }

  // Pulse rate value list for log file
  List prValueList=["Date,       Time,        Value" "\n"];
  List prValueListGraph=[];
  String prValueListGraphT='0';
  List get getPrValueList=>prValueList;
  set updatePrValueList(String val) {
    // prValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    prValueListGraphT=val.toString();
    update();
  }
  prGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
          if(prValue.toString()!='0'){
            prValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), prValueListGraphT});
          }
        }
    );

    Timer.periodic(
        Duration(seconds: 30), (timer) {
          if(prValueListGraphT.toString()!='0'){
            prValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':prValueListGraphT.toString()==''? '0':prValueListGraphT});
          }
        }
    );

    update();

  }

  averagePr() {

    double avg=0.0;
    try{
      print("Pulse rate value list graph length : ${prValueListGraph.length}");

      int sum=0;

      for(int i=0; i<prValueListGraph.map((e)=>e['value']).toList().length; i++) {
        sum += int.parse(prValueListGraph.map((e)=>e['value']).toList()[i]);
        print("sum : "+sum.toString());
      }

      avg = sum/(prValueListGraph.map((e)=>e['value']).length);
      print('average : '+avg.toString());

    } catch (e) {
      print("Error about sum and average related : $e");
    }
    return prValueListGraph.isEmpty?'0':avg.toStringAsFixed(2).toString();

  }

  getPrData() async {
    spO2GraphT();
    prGraphT();

    List<BluetoothService> services =  await devicesData!.discoverServices();
    services.forEach((service) async {
      if(service.uuid.toString()=='1822') {
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if(c.uuid.toString()=='1004') {
            await c.setNotifyValue(true);
            spO2PrSubscription=c.lastValueStream.listen((value2) async {
              var data=ascii.decode(value2);
              print('SpO2 and pulse rate received from device : $data');

              try{
                updateSpO2Value=data.toString().split(',')[0];
                print('SpO2 2 : ${data.toString().split(',')[0]}');

                updatePrValue=data.toString().split(',')[1];
                print('Pulse rate 3 : ${data.toString().split(',')[1]}');

                updateSpO2ValueList=data.toString().split(',')[0];

                updatePrValueList=data.toString().split(',')[1];

                updateSpO2Percentage=data.toString().split(',')[0];
              } catch (e) {
                print('Error SpO2 and pulse rate : $e');
              }

            });
          }
        }
      }
    });
    update();
  }





  /// Blood pressure description : -
  // BP Value
  Map bpData={'mode':'e', 'systolic':'00', 'diastolic':'00'};
  Map get getBpData=>bpData;
  set updateBpData(Map val) {
    bpData=val;
    update();
  }

  // BP Value List
  List bpValueList=["Date,            Time,       Value" "\n"];
  List bpValueListGraph=[];
  String bpValueListGraphT='0';
  List get getBpValueList=>bpValueList;
  set updateBpValueList(String val) {
    // bpValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    bpValueListGraphT=val.toString();
    update();
  }
  bpGraphT(){

    Timer.periodic(
        Duration(seconds: 30), (timer) {
      // bpValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), bpValueListGraphT});
      if(bpValueListGraphT[0]=='i'){  // change f to i
        bpValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), bpValueListGraphT});
      }
        }
        );


    Timer.periodic(
        Duration(seconds: 60), (timer) {
      // bpValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':bpValueListGraphT.toString()==''? '0':bpValueListGraphT});
      if(bpValueListGraphT[0]=='i'){  // change f to i
        bpValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':bpValueListGraphT});
      }
    }
    );

    update();

  }

  averageBpSys() {

    double avg=0.0;
    try {
      print("Blood pressure systolic value list graph length : ${bpValueListGraph.length}");

      var sum=0.0;

      for(var i=0; i<bpValueListGraph.map((e)=>e['value'].split(',')[1]).toList().length; i++) {
        sum += double.parse(bpValueListGraph.map((e)=>e['value'].split(',')[1]).toList()[i]);
        print("sum : "+sum.toString());
      }

      avg = sum/(bpValueListGraph.map((e)=>e['value'].split(',')[1]).length);
      print('average : '+avg.toString());
      // return avg.toStringAsFixed(2);

    } catch (e) {
      print("Error about sum and average related : $e");
    }

    return bpValueListGraph.isEmpty?'0':avg.toStringAsFixed(2).toString();
  }

  averageBpDia() {

    double avg=0.0;
    try {
      print("Blood pressure diastolic value list graph length : ${bpValueListGraph.length}");

      var sum=0.0;

      for(var i=0; i<bpValueListGraph.map((e)=>e['value'].split(',')[2]).toList().length; i++) {
        sum += double.parse(bpValueListGraph.map((e)=>e['value'].split(',')[2]).toList()[i]);
        print("sum : "+sum.toString());
      }

      avg = sum/(bpValueListGraph.map((e)=>e['value'].split(',')[2]).length);
      print('average : '+avg.toString());
    } catch (e) {
      print("Error about sum and average related : $e");
    }

    return bpValueListGraph.isEmpty?'0':avg.toStringAsFixed(2).toString();
  }

  getBPData() async {
    bpGraphT();

    List<BluetoothService> services =  await devicesData!.discoverServices();
    services.forEach((service) async {
      if(service.uuid.toString()=='1810') {
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if(c.uuid.toString()=='2a49'){
            await c.setNotifyValue(true);
            bpSubscription=c.lastValueStream.listen((value2) async {
              try{
                var data = ascii.decode(value2);
                if (data.toString().split(',')[0].toString() == 'f' ||
                    data.toString().split(',')[0].toString() == 'i' ||
                    data.toString().split(',')[0].toString() == 'e') {
                  updateBpData = {
                    'mode': data.toString().split(',')[0],
                    'systolic': data.toString().split(',')[1],
                    'diastolic': data.toString().split(',')[2]
                  };
                  updateBpValueList = data.toString().split('-')[0];
                  updateBpValueList = data.toString().split('-')[1];
                  updateBpValueList = data.toString().split(',')[2];
                }
                print('Blood pressure 4 : $data');
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





  /// Temperature, battery and pulse transit time description : -
  // Temperature Value
  String tempValue='';
  String get getTempValue=>tempValue;
  set updateTempValue(String val) {
    tempValue=val;
    update();
  }

  // Temperature value list for log file
  List tempValueList=["Date,       Time,        Value" "\n"];
  List tempValueListGraph=[];
  String tempValueListGraphT='0';
  List get getTempValueList=>tempValueList;
  set updateTempValueList(String val) {
    // tempValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    tempValueListGraphT=val.toString();
    update();
  }
  tempGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
          if(tempValue.toString()!='0'){
            tempValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), tempValueListGraphT});
          }
        }
    );

    Timer.periodic(
        Duration(seconds: 30), (timer) {
          if(tempValueListGraphT.toString()!='0'){
            tempValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':tempValueListGraphT.toString()==''? '0':tempValueListGraphT});
          }
        }
    );

    update();

  }

  String averageTemp() {
    double avg=0.0;
    try {
      print("Temperature value list graph length : ${tempValueListGraph.length}");

      var sum=0.0;
      double avg=0.0;

      for(var i=0; i<tempValueListGraph.map((e)=>e['value']).toList().length; i++) {
        sum += double.parse(tempValueListGraph.map((e)=>e['value']).toList()[i]);
        print("sum : "+sum.toString());
      }

      avg = sum/(tempValueListGraph.map((e)=>e['value']).length);
      print('average : '+avg.toString());

    } catch (e) {
      print("Error about sum and average related : $e");
    }
    return tempValueListGraph.isEmpty?'0':avg.toStringAsFixed(2).toString();
  }

  // Battery Icon
  double batteryText=0.0;
  double get getBatteryText=>batteryText;
  set updateBatteryText(double val) {
    batteryText=val;
    update();
  }

  // Battery percentage
  String batteryValue='';
  String get getBatteryValue=>batteryValue;
  set updateBatteryValue(String val) {
    batteryValue=val;
    update();
  }

  // Battery value list for log file
  List batteryValueList=["Date,       Time,        Value" "\n"];
  List batteryValueListGraph=[];
  String batteryValueListGraphT='0';
  List get getBatteryValueList=>batteryValueList;
  set updateBatteryValueList(String val) {
    // prValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    batteryValueListGraphT=val.toString();
    update();
  }
  batteryGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
      batteryValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), batteryValueListGraphT});
    }
    );

    Timer.periodic(
        Duration(seconds: 30), (timer) {
      batteryValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':batteryValueListGraphT.toString()==''? '0':batteryValueListGraphT});
    }
    );

    update();

  }

  averageBattery() {

    try{
      print("Battery value list graph length : ${batteryValueListGraph.length}");

      int sum=0;
      double avg=0.0;

      for(int i=0; i<batteryValueListGraph.map((e)=>e['value']).toList().length; i++) {
        sum += int.parse(batteryValueListGraph.map((e)=>e['value']).toList()[i]);
        print("sum : "+sum.toString());
      }

      avg = sum/(batteryValueListGraph.map((e)=>e['value']).length);
      print('average : '+avg.toString());
      return batteryValueListGraph.isEmpty?'0':avg.toStringAsFixed(2);

    } catch (e) {
      print("Error about sum and average related : $e");
    }

  }

  // Pulse transit time value
  String pttValue='';
  String get getPttValue=>pttValue;
  set updatePttValue(String val) {
    pttValue=val;
    update();
  }

  // Pulse transit time value list for log file
  List pttValueList=["Date,       Time,        Value" "\n"];
  List pttValueListGraph=[];
  String pttValueListGraphT='0';
  List get getPttValueList=>pttValueList;
  set updatePttValueList(String val) {
    // prValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss").format(DateTime.now()).toString(), val});
    pttValueListGraphT=val.toString();
    update();
  }
  pttGraphT(){

    Timer.periodic(
        Duration(seconds: 5), (timer) {
          if(pttValue.toString()!='0'){
            pttValueList.add({DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(), pttValueListGraphT});
          }
        }
    );

    Timer.periodic(
        Duration(seconds: 30), (timer) {
          if(pttValueListGraphT.toString()!='0'){
            pttValueListGraph.add({'date':DateFormat("yyyy-MM-dd, hh:mm:ss a").format(DateTime.now()).toString(),'value':pttValueListGraphT.toString()==''? '0':pttValueListGraphT});
          }
        }
    );

    update();

  }

  averagePtt() {

    double avg=0.0;
    try{
      print("Pulse transit time value list graph length : ${pttValueListGraph.length}");

      int sum=0;
      for(int i=0; i<pttValueListGraph.map((e)=>e['value']).toList().length; i++) {
        sum += int.parse(pttValueListGraph.map((e)=>e['value']).toList()[i]);
        print("sum : "+sum.toString());
      }

      avg = sum/(pttValueListGraph.map((e)=>e['value']).length);
      print('average : '+avg.toString());

    } catch (e) {
      print("Error about sum and average related : $e");
    }

    return pttValueListGraph.isEmpty?'0':avg.toStringAsFixed(2).toString();
  }

  getTempData() async {
    tempGraphT();
    batteryGraphT();
    pttGraphT();

    List<BluetoothService> services =  await devicesData!.discoverServices();
    services.forEach((service) async {
      if(service.uuid.toString()=='1809'){
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if(c.uuid.toString()=='2a6e'){
            await c.setNotifyValue(true);
            tempSubscription=c.lastValueStream.listen((value2) async {
              var data=ascii.decode(value2);
              print('Temperature, battery and PTT received from device : $data');

              try {
                updateTempValue=data.toString().split(',')[0];
                print('Temperature 5 : ${data.split(',')[0]}');

                updateBatteryValue=data.toString().split(',')[2];
                print('Battery 6 : ${data.split(',')[2]}');

                updatePttValue=data.toString().split(',')[3];
                print('Pulse Transit Time 7 : ${data.split(',')[3]}');

                updateTempValueList=data.toString().split(',')[0];

                updateBatteryValueList=data.toString().split(',')[2];

                updatePttValueList=data.toString().split(',')[3];

                // For battery icon
                updateBatteryText=double.parse(data.toString().split(',')[2]);

              }
              catch (e) {
                print('Error temperature 5 : $e');
              }

            });
          }
        }
      }
    });
    update();
  }

}
