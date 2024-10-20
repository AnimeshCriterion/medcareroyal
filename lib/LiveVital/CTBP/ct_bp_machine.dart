



import 'dart:async';



import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'ct_bp_gatt.dart';




class CTBpMachine {

   final StreamController<CTBpMachineData> _controller = StreamController<CTBpMachineData>();
   Stream<CTBpMachineData> get machineDataStream =>_controller.stream;



  void  initiateCTService(BluetoothService service) async{
    List<BluetoothCharacteristic> gattCharacteristics = service
        .characteristics;
    if (service.uuid.toString().toUpperCase().contains(CTBpGattAttributes.SERVICE_UU.toUpperCase())) {
      for (int i=0; i<gattCharacteristics.length;i++) {
        BluetoothCharacteristic gattCharacteristic=gattCharacteristics[i];

        String uuid1 = gattCharacteristic.uuid.toString();
        if (uuid1.toString().toUpperCase().contains(CTBpGattAttributes.NOTIFY_UU.toUpperCase())) {


          await gattCharacteristic.setNotifyValue(true);
          gattCharacteristic.value.listen((value) {

           print("Device Data: "+value.toString());

           if(value.isNotEmpty){
             _controller.add( CTBpMachineData(
               scanState: _scanState(value),
               sys: _parseSYS(value),
               dia: _parseDIA(value),
               pulseRate: _parsePulseRate(value),
               measuringPressure: _measuringPressure(value),

             ));
           }
          });

        }
        if (uuid1.toString().toUpperCase().contains(CTBpGattAttributes.WRITE_UU.toUpperCase())) {

          print("qwertyyyyyyyyyyyyyyyyyyyyyy");
          List<int> send = [-3,-3,-6,5,13,10];
          gattCharacteristic.write(send);
         // await gattCharacteristic.write([0x12, 0x34]);
        }
      }
    }
  }



   static int _measuringPressure(List<int> value) {
     if(_scanState(value)==CtBpScanState.scanning)
     {
       return value[4];
     }
     else{
       return 0;
     }

   }


  static int _parseSYS(List<int> value) {
    if(_scanState(value)==CtBpScanState.complete)
    {
      return value[3];
    }
    else{
      return 0;
    }

  }


  static int _parseDIA(List<int> value) {
    if(_scanState(value)==CtBpScanState.complete)
    {
      return value[4];
    }
    else{
      return 0;
    }

  }


  static int _parsePulseRate(List<int> value) {
    if(_scanState(value)==CtBpScanState.complete)
    {
      return value[5];
    }
    else{
      return 0;
    }

  }



  static CtBpScanState _scanState(List<int> value) {
    int val =value.length==1? value[0]:value[2];

    // val=(value.length<6 && val==252)?
    // 0:val;
    switch (val){
      case 165:
        return CtBpScanState.initial;
      case 251:
        return CtBpScanState.scanning;
      case 252:
        return CtBpScanState.complete;
      case 253:
        return CtBpScanState.noDataFound;
      default:
        return CtBpScanState.initial;
    }
  }


}







class CTBpMachineData {
  CtBpScanState? scanState;
  int? sys;
  int? dia;
  int? pulseRate;
  int? measuringPressure;

  CTBpMachineData({this.scanState, this.sys, this.dia,
    this.pulseRate,
    this.measuringPressure,
  });

  CTBpMachineData.fromJson(Map<String, dynamic> json) {
    scanState = json['scanState'];
    sys = json['sys'];
    dia = json['dia'];
    pulseRate = json['pulseRate'];
    measuringPressure = json['measuringPressure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['scanState'] = this.scanState;
    data['sys'] = this.sys;
    data['dia'] = this.dia;
    data['pulseRate'] = this.pulseRate;
    data['measuringPressure'] = this.measuringPressure;
    return data;
  }
}


enum CtBpScanState {
  initial,
  scanning,
  complete,
  noDataFound,
}