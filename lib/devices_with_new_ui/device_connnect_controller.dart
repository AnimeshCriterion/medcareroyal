

import 'dart:async';
// import 'package:flutter_oximeter/flutter_oximeter.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import '../../devices_with_new_ui/bp_data_view.dart';
import '../../devices_with_new_ui/device_list_data_data_modal.dart';

class DeviceConnectController extends GetxController{

  String selectedIndex="";
  String get getSelectedIndex=>selectedIndex;
  set updateSelectedIndex(String val){
    selectedIndex=val;
    update();
  }

  List addDeviceConnect=[
    {
      "id":1,
      "name":"yonker",
      "modal":"YK-81C",
      "deviceType":"Oximeter",
      "image":'assets/yonker_oxi.png',
      // 'device':'YK-81C',
      'device':'BleModuleA',
      // 'suuid':'cd80',
      // 'cuuid':'cd81'
  'suuid':'cdeacd80-5235-4c07-8846-93a37ee6b86d',
  'cuuid':'cdeacd81-5235-4c07-8846-93a37ee6b86d'

    },
    {
      "id":1,
      "name":"Wellue",
      "modal":" ",
      "deviceType":"Oximeter",
      "image":'assets/wellue_oxi.png',
      'device':'OxySmart',
      'suuid':'6e400001-b5a3-f393-e0a9-e50e24dcca9e',
      'cuuid':'6e400003-b5a3-f393-e0a9-e50e24dcca9e'

    },
    {
    // '28:FF:B2:F9:B4:14',
      "id":2,
      "name":"Omron",
      "modal":" ",
      "deviceType":"BP Machine",
      "image":'assets/omron_bp.png',
      'device':'BLESmart_00000' ,
      'suuid':'00001810-0000-1000-8000-00805f9b34fb',
      'cuuid':'00002a35-0000-1000-8000-00805f9b34fb'
    },
    {
      "id":3,
      "name":"CT BP",
      "modal":" ",
      "deviceType":"BP Machine",
      "image":'assets/ct_bp.png',
      'device':'CT033',
      'suuid':'0000FFF0-0000-1000-8000-00805f9b34fb',
      'cuuid':'0000FFF1-0000-1000-8000-00805f9b34fb'
    },
    {
      "id":4,
      "name":"yonker",
      "modal":"YK-BPA1",
      "deviceType":"BP Machine",
      "image":'assets/yonker_bp.png',
      'device':'YK-BPA1',
      // 'device':'BleModuleB',
      'suuid':'cdeacd80-5235-4c07-8846-93a37ee6b86d',
      'cuuid':'cdeacd81-5235-4c07-8846-93a37ee6b86d'
    },
    // {
    //   "id":4,
    //   "name":"CT Oximeter",
    //   "modal":" ",
    //   "deviceType":"Oximeter",
    //   "image":'assets/ct_oxi.png',
    //   'device':'CTP005',
    //   'suuid':'cdeacd80-5235-4c07-8846-93a37ee6b86d',
    //   'cuuid':'cdeacd81-5235-4c07-8846-93a37ee6b86d'
    // },
    {
      "id":4,
      "name":"BPW1 Watch",
      "modal":" ",
      "deviceType":"Watch",
      "image":'assets/bpw_watch.png',
      'device':'BleMod',
      'suuid':'cde 37ee6b86d',
      'cuuid':'cdeacd81-523 37ee6b86d'
    },
    {
      "id":4,
      "name":"Apple",
      "modal":" ",
      "deviceType":"Watch",
      "image":'assets/apple_watch.png',
      'device':'BLEsmart_',
      'suuid':'ecbe3980-c9a2-11e1-b1bd-0002a5d5c51b',
      'cuuid':'0348f9c3-f773-4af8-90dd-25a99ad0518b'
    },
    {
      "id":4,
      "name":"ECG",
      "modal":" ",
      "deviceType":"Pocket ECG",
      "image":'assets/pocket_ecg.png',
      'device':' ',
      'suuid':' ',
      'cuuid':' '
    },
    {
      "id":4,
      "name":"StethoScope",
      "modal":" ",
      "deviceType":"CT Stethoscope",
      "image":'assets/ct_stetho.png',
      'device':' ',
      'suuid':' ',
      'cuuid':' '
    },
    {
      "id":4,
      "name":"PTT",
      "modal":" ",
      "deviceType":"PTT",
      "image":'assets/ct_ptt.png',
      'device':'BLESmart_00000458005FBFD0DFA8',
      'suuid':'1810',
      'cuuid':'2a35'
    },
    // {
    //   'id':2,
    //   "name":"Omron",
    //   "modal":"",
    //   "deviceType":"BP Machine",
    //   "image":'assets/omron_bp.png',
    //   'device':'BLESmart' ,
    //   'suuid':'00001810-0000-1000-8000-00805f9b34fb',
    //   'cuuid':'00002a35-0000-1000-8000-00805f9b34fb'
    // },
    {
      'id':11,
      "name":"Omron",
      "modal":"HEM-7361T",
      "deviceType":"BP Machine",
      "image":'assets/omron_bp.png',
      'device':'BLESmart',
      'suuid':'00001810-0000-1000-8000-00805f9b34fb',
      'cuuid':'00002a35-0000-1000-8000-00805f9b34fb'
    },
    {
      'id':12,
      "name":"Omron",
      "modal":"HEM-7530T",
      "deviceType":"BP Machine",
      "image":'assets/omron_bp.png',
      'device':'BLESmart',
      'suuid':'00001810-0000-1000-8000-00805f9b34fb',
      'cuuid':'00002a35-0000-1000-8000-00805f9b34fb'
    },
    {
      'id':13,
      "name":"Omron",
      "modal":"HEM-7156T",
      "deviceType":"BP Machine",
      "image":'assets/omron_bp.png',
      'device':'BLESmart',
      'suuid':'00001810-0000-1000-8000-00805f9b34fb',
      'cuuid':'00002a35-0000-1000-8000-00805f9b34fb'
    },

    {
      'id':13,
      "name":"Omron",
      "modal":"HBF-222T",
      "deviceType":"BP Machine",
      "image":'assets/omron_bp.png',
      'device':'BLESmart',
      'suuid':'1801',
      'cuuid':'2a05'
    },
    // {
    //   "id":4,
    //   "name":"Omran-736",
    //   "deviceType":"BP Machine",
    //   "image":'assets/ct_ptt.png',
    //   'device':'BLESmart_',
    //   'suuid':'00001810-0000-1000-8000-00805f9b34fb',
    //   'cuuid':'00002a49-0000-1000-8000-00805f9b34fb'
    // },

  ];
  String deviceType='';
  String get getSelecetedDeviceType=>deviceType;
  set updateSelectedDeviceType(String val){
    deviceType=val;
    update();
  }

  DeviceListDataModal selectedDevice=DeviceListDataModal(cuuid: '',device: '',deviceType: '',image: '',name: '',suuid: '',id: 0);
  DeviceListDataModal get getSelectedDevice=>selectedDevice;
  set updateSelectedDevice(Map<String, dynamic> val){
    selectedDevice=DeviceListDataModal.fromJson(val);
    // update();
  }

  String selectedDeviceIndex='';
  String get getSelectedDeviceIndex=>selectedDeviceIndex;
  set updateSelectedDeviceIndex(String val){
    selectedDeviceIndex=val;
    update();

  }

  //
  // Map SelectedDeviceData={};
  // Map get getSelectedDeviceData=>SelectedDeviceData;
  // set UpdateSelectedDeviceData(Map val){
  //   SelectedDeviceData=val;
  //   update();
  // }

  BluetoothDevice? devicesData;
  set updateDevicesData(BluetoothDevice val) {
    devicesData=val;
    update();
  }

  bool isFound=false;
  bool get getIsFound=>isFound;
  set updateIsFound(bool val){
    isFound=val;
    update();
  }

  bool isScanning=false;
  bool get getIsScanning=>isScanning;
  set updateIsScanning(bool val){
    isScanning=val;
    update();
  }



  scanDevices() async {
    updateIsConnected=false;
    int tempint=0;
    bool isAlreadyConnected=false;

    List<BluetoothDevice> data= await FlutterBluePlus.connectedDevices;

    print('nnvnnvnvnvnnnnnvnnnnnnnnvnnvnnnvnnvnnnn : ' + data.length.toString());

    print('nnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnn : ' + getSelectedDevice.device.toString());
  if(data.isNotEmpty){

    print('nnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnn : ' + data.toString());
      // String tempName='';
      for(int i=0;i<data.length;i++){
        if(data[i].platformName.toString().toUpperCase().contains(getSelectedDevice.device.toString().toUpperCase())  ){
          // tempName=data[i].name.toString();
          print('nnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnn : ' + data.toString());

          Future.delayed(Duration(seconds: 1)).then((value) async {
            updateDevicesData =data[i];
            isAlreadyConnected = true;
            await  connectionState();

            print('nnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnnnnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnnnnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnnnnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnn : ' + isConnected.toString());
            // if (!isConnected) {
            //   await devicesData!.connect();
            // }
            try{
              await devicesData!.connect();
            }catch(e){

            }
            tempint=tempint+1;

            if(tempint==1){
              Get.to(() => BpDeviceDataView());
            }
          });
        }
      }

    }
  if(isAlreadyConnected){
    FlutterBluePlus.stopScan();

    }
    else {
      print('nnvnnvnvnvnnnvnnvnnnnnnnnvnnvn : ' + data.toString());
      FlutterBluePlus
          .startScan(timeout: const Duration(minutes: 15),  )
          .then((value) {
        // updateIsDeviceScanning=false;
      });


        Future.delayed(Duration(minutes: 15))
          .then((value) => updateIsScanning = false);

      // Listen to scan results
      FlutterBluePlus.scanResults.listen((List<ScanResult> results) async {
        // do something with scan results
        for (ScanResult r in results) {   print('nnvnnvnvnvnnnvnnvnnnnnnn : ' + r.device.platformName.toString());
          if (r.device.platformName.toString().toUpperCase().contains(getSelectedDevice.device.toString().toUpperCase())) {

            print('nnvnnvnvnvnnnvnnvnnnnnnn nnvnnvnvnvnnnvnnvnnnnnnnnnvnnvnvnvnnnvnnvnnnnnnn : ' + r.device.name.toString().toString());
            updateDevicesData = r.device;
            await   connectionState();
            Future.delayed(Duration(seconds: 1)).then((value) async {
              FlutterBluePlus.stopScan();
              try{
                await r.device.connect();
              }catch(e){

              }

              tempint=tempint+1;

              if(tempint==1){
                Get.to(() => BpDeviceDataView());
              }
            });
          }
        }
      });
      update();

    }

  }

  StreamSubscription? subscription;

  StreamSubscription? subscription1;
  bool isConnected=false;
  set updateIsConnected(bool val){
    isConnected=val;
    update();
  }

  connectionState(){
    subscription1=devicesData!.connectionState.listen((event) async {
      print('nnvnnvnvnvnnnvnnv nnvnnnnnnvnnvnvnvnnnvnnvnnnnnnnnvnnvnnnvnnvnnnn : ' + event.toString());

    if(BluetoothConnectionState.disconnected==event){
        try{
          updateIsMeasring=false;

          updateMesasringbpValue='0.0';
          updateIsConnected=false;
          await devicesData!.connect();
          await deviceData();

        }
        catch(e){

        }
      } else if(BluetoothConnectionState.connected==event){


        updateIsConnected=true;
      }
      else{

        updateIsConnected=false;
      }}
    );
  }

  deviceData( ) async {

    List<BluetoothService> services = await devicesData!.discoverServices();
    // print('Bluetooth services : ' + services.toString());
    services.forEach((service) async {

      print('Service UUID : ' + service.uuid.toString()  == getSelectedDevice.suuid.toString().toString());
      print('nnnnnnnnnnnnnnnnnnnnnnnnnnnvnnnvnnnvnnnnnn : ' + service.uuid.toString());
      print('Service UUID : ' + getSelectedDevice.suuid.toString());
      if (service.uuid.toString().toUpperCase()  == getSelectedDevice.suuid.toString().toUpperCase()) {

        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {

          print('Characteristics UUID : ' + c.uuid.toString());
          if (c.uuid.toString().toUpperCase() == getSelectedDevice.cuuid.toString().toUpperCase()) {
            try{
              await c.setNotifyValue(true);
            }
            catch(e){
              c.setNotifyValue(true);
            }

            subscription=   c.lastValueStream.listen((value) async {
              try{
                print("nnnnnnnnnnnnnnnnnnnnnnnnvnnvnnn : " + value.toString());
                if(value.toList().isNotEmpty){
                  selectedDeviceData(
                      getSelectedDevice.device.toString() +
                          getSelectedDevice.modal.toString(),
                      value);
                }
              }
              catch(e){
                print('nnnnnnnnnnnnvnn '+e.toString());
              }

            });
            update();
          }
        }
      }
    });
    update();
  }


  String pr='00';
  String get getPr=>pr;
  set updatePr(String val){
    pr=val;
    update();
  }


  String spo2='00';
  String get getSpo2=>spo2;
  set updateSpo2(String val){
    spo2=val;
    update();
  }
  String bpSys='00';
  String get getBpSys=>bpSys;
  set updateBpSys(String val){
    bpSys=val;
    update();
  }
  String bpDia='00';
  String get getBpDia=>bpDia;
  set updateBpDia(String val){
    bpDia=val;
    update();
  }
  String mesuringbpValue='0.0';
  String get getMeasringbpValue=>mesuringbpValue;
  set updateMesasringbpValue(String val){
    mesuringbpValue=val;
    update();
  }



  bool ismeasing=false;
  bool get getIsMeasring=>ismeasing;
  set updateIsMeasring(bool val){
    ismeasing=val;
    update();
  }

  selectedDeviceData(val,value) async {

    switch (val){
        case 'CT033':
          await ctBp(value);
        case 'YK-BPA1YK-BPA1':
          await yonkerBpMachine(value);
      // case 'YK-BPA1':
      //   await yonkerBpMachine(value);
      case 'BleModuleAYK-81C':
          await yonkerOximeterData(value);
    case 'YK-81CYK-81C':
        await yonkerOximeterData(value);
      case 'OxySmart':
        await oximeterValue(value);
      case 'BLESmart':
        await omranData(value);
      case 'BLESmartHEM-7361T':
        await OmronHEMCS24(value);
      case 'BLESmartHEM-7530T':
        await  OmronHEMCS24(value);
      case 'BLESmartHEM-7156T':
        await  OmronHEMCS24(value);
        // default:
        //   return yonkerOximeterData(value);
      }
  }

  OmronHEMCS24(List value){
    // [30, 112, 0, 55, 0, 74, 0, 232, 7, 9, 26, 11, 15, 37, 92, 0, 1, 0, 0]

    if(value.toList().isNotEmpty){
      if (value.toList()[0].toString() == '30') {

        updateBpSys = value.toList()[1].toString();
        updateBpDia = value.toList()[3].toString();
        updatePr = value.toList()[14].toString();
      }
    }

  }

  ctBp( List value) {
    int val =value.isEmpty? value[0]:value[2];
    if(val==252){
      updateBpSys=value[3].toString();
      updateBpDia= value[4].toString();
      updatePr=value[5].toString();
      updateMesasringbpValue='0.0';
      updateIsMeasring=false;
    }
    else if(val==251){
      updateMesasringbpValue=value[4].toString();
      updateIsMeasring=true;
    }

  }

  yonkerOximeterData( List value){
    if(value.isNotEmpty){
      if (value[0] == 129) {
        if (value[1].toString() != '0') {
          updateSpo2 = value[1].toString();
        }
        if (value[2].toString() != '0') {
          updatePr = value[2].toString();
        }
        updateIsMeasring=false;
      }else{
        updateIsMeasring=false;
      }
    }else{
      updateIsMeasring=false;
    }
  }
yonkerBpMachine(value){
  if (value.isNotEmpty) {
    if (value[0] == 128) {
      // updateIsMeasuring = true;
      updateMesasringbpValue= value[2].toString();
      updateIsMeasring=true;
    } else if (value[0] == 129) {
      updateBpSys=value[1].toString();
    updateBpDia= value[2].toString();
    updatePr=value[3].toString();
      updateMesasringbpValue='0.0';
      updateIsMeasring=false;
      // updateIsMeasuring = false;

    }
  }else{
    updateIsMeasring=false;
  }
}
  oximeterValue(List oxiList){

    List hexData=[];

    for(int i=0;i<oxiList.length;i++){
      hexData.add(oxiList[i].toRadixString(16));
    }



    if(hexData.isNotEmpty){

    if(hexData[0].toString().toUpperCase()=='AA'){
      if(hexData[1].toString()=='55'){
        if(hexData[2].toString().toUpperCase()=='F'){
          if(hexData[3].toString()=='8'){
            print('nnnnnn'+hexData.toString());

            if (oxiList[6].toString() != '0') {

              updatePr=oxiList[6].toString();
            }

            if (oxiList[5].toString() != '0') {
              updateSpo2=oxiList[5].toString();

            }
            updateIsMeasring=false;
          }
        }
      }
    }
    else{
      updateIsMeasring=true;
    }

    }
    else{
      updateIsMeasring=false;
    }
  }


  omranData(List value){
    if(value.toList().isNotEmpty){
      if (value.toList()[0].toString() == '22') {
        updateBpSys = value.toList()[1].toString();
        updateBpDia = value.toList()[3].toString();
        updatePr = value.toList()[14].toString();
        updateIsMeasring=false;
      }else{
        updateIsMeasring=true;
      }
    }else{
      updateIsMeasring=false;
    }
  }


  // FlutterOximeter oxi=FlutterOximeter();
  Timer? timer;

  String macAddress = '';
  set updateMacAddress(String val){
    macAddress=val;
    update();
  }
  StreamSubscription? subscriptions;
  StreamSubscription? subscriptionss;
  // Ctoximeter(context){
  //
  //   timer=Timer.periodic(Duration(seconds: 5), (timer) {
  //     print('nnnnnnvnnnnnnnnnvnnvnvnnnn ' );
  //      oxi.startScanDevice();
  //   });
  //
  //   subscriptions=oxi.getScanningStateStream.listen((event) {
  //
  //     isScanning=event;
  //
  //   });




//
// int i=0;
//     subscriptionss=  oxi.deviecFoundStream.listen((event) {

    //
    //   Future.delayed(Duration(seconds: 1)).then((value) {
    //     i=i+1;
    //    // oxi.connect(macAddress: event!.macAddress??'', deviceName: event!.deviceName??'');
    //     updateIsConnected=true;
    //     updateMacAddress=event.macAddress.toString();
    //     print('nnnnnnvnnnnnnnnnvnnvnvnnnn '+event.macAddress.toString().toString());
    //     if( isConnected){
    //       if(i==1){
    //         Get.to(() => Oximeters());
    //       }
    //     }
    //
    //
    //
    //
    //   });
    //
    //
    // });

    // oxi.getConnectionStateStream.listen((event) {
    //   isConnected=event;
    //
    //   if(mounted){
    //     setState(() {
    //
    //     });
    //   }
    // });
  // }

  //   _scanState(List<int> value) {
  //   int val =value.length==1? value[0]:value[2];
  //
  //   // val=(value.length<6 && val==252)?
  //   // 0:val;
  //   switch (val){
  //     case 165:
  //       return CtBpScanState.initial;
  //     case 251:
  //       return CtBpScanState.scanning;
  //     case 252:
  //       return CtBpScanState.complete;
  //     case 253:
  //       return CtBpScanState.noDataFound;
  //     default:
  //       return CtBpScanState.initial;
  //   }
  // }
}