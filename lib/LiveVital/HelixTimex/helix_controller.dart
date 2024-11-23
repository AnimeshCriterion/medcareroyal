



import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helix_timex/helix_timex.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../app_manager/theme/text_theme.dart';
import '../../medcare_utill.dart';
import '../live_vital_controller.dart';


class HelixController extends GetxController{



  Widget _measuring(){

    return SizedBox(
        height: 10,
        width: 30,
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Lottie.asset('assets/pulse_white.json')));
  }
  RxBool insidePage=false.obs;

  bool get showOutside=>Platform.isIOS? false:(conState.value==TimexConnectionState.connected && !insidePage.value);
  Widget get outsideDataWidget=>
      ( selectedTimePeriod.value!='Repeat' &&  readingData.value=='')?

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Next ',
                style: MyTextTheme.smallWCB,),
              Text(DateFormat('hh:mm a').format(nextMeasure.value).toString(),
                style: MyTextTheme.smallWCB,),
            ],
          ):

      readingData.value=='sp'?
  Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _measuring(),
      Text('SpO2',
      style: MyTextTheme.smallWCB,)
    ],
  )
  :
  readingData.value=='hr'?
  Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _measuring(),
      Text('HR',
        style: MyTextTheme.smallWCB,)
    ],
  )

      :

  readingData.value=='bp'?
  Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _measuring(),
      Text('SpO2',
        style: MyTextTheme.smallWCB,)
    ],
  )
      :
  Container();


  LiveVitalModal liveVitalModal=LiveVitalModal();

  RxBool isScanning = false.obs;
  RxBool foundDevice = true.obs;
  RxString macAddress = ''.obs;
  RxString readingData = ''.obs;


  Rx<DateTime> nextMeasure=DateTime.now().obs;
  Rx<TimexConnectionState> conState = TimexConnectionState.connected.obs;

  HelixTimex timex=HelixTimex();

  RxString selectedTimePeriod='Repeat'.obs;



  RxString heartRate=''.obs;
  RxString spo2=''.obs;
  RxString sis=''.obs;
  RxString dis=''.obs;
  Timer? _timer;



  List timePeriodList=[
    {
      'title': "Repeat"
    },
    {
      'title': "5 Min"
    },
    {
      'title': "10 Min"
    },
    {
      'title': "15 Min"
    },
    {
      'title': "20 Min"
    },
    {
      'title': "25 Min"
    },
    {
      'title': "30 Min"
    },
    {
      'title': "35 Min"
    },
    {
      'title': "40 Min"
    },
    {
      'title': "45 Min"
    },
    {
      'title': "50 Min"
    },
    {
      'title': "55 Min"
    },
    {
      'title': "60 Min"
    },

  ];


  firstInitiate() async{
    isScanning.value=false;
    if (await timex.isConnected()){
    conState.value=TimexConnectionState.connected;
    }
    else {
    conState.value=TimexConnectionState.disconnected;
    }
    update();
  }


  Future<void> initPlatformState(context) async {
    insidePage.value=true;
   await firstInitiate();



    update();

    if (await timex.isConnected()){
    }
    else {
      timex.startScanDevice();
    }

    timex.getScanningStateStream.listen((event) {
      dPrint('My Scanning State '+ event.toString());
      isScanning.value=event;
      update();
    });


    timex.getConnectionStateStream.listen((event) {
      if(event.connectionState==TimexConnectionState.connected){
        selectedTimePeriod.value='Repeat';
        measureSpO2();
        update();
      }
      else{
            readingData.value='';
            update();
      }

      dPrint('My Connection State'+event.connectionState.toString());
      conState.value=event.connectionState!;
      update();
    });






    timex.getHeartRateStream.listen((event) {
      readingData.value='';
      update();
       // vitalModal.controller.vitalTextX[0].text=event.toString();
      liveVitalModal.addVitalsData(context,hr: event.toString());
      if(selectedTimePeriod=='Repeat'){
        measureSpO2();
      }
      dPrint('My Heart Rate'+event.toString());
      heartRate.value=event.toString();
      update();
    });

    timex.getSpo2Stream.listen((event) {
      readingData.value='';
      update();



        // vitalModal.controller.vitalTextX[2].text=event.toString();
      liveVitalModal.addVitalsData(context,hr:event.toString());


      dPrint('My SpO2'+event.toString());


      measureBP();
      update();
      spo2.value=event.toString();
      update();
    });

    timex.getBloodPressureStream.listen((event) {
      readingData.value='';
      update();


      // vitalModal.controller.vitalTextX[0].text=event['sbp'].toString();
      //   vitalModal.controller.vitalTextX[1].text=event['dbp'].toString();

      liveVitalModal.addVitalsData(context,BPSys: event['sbp'].toString(),BPDias: event['dbp'].toString());


      measureHR();
      update();
      dPrint('My Blood Pressure'+event.toString());
      sis.value=event['sbp'].toString();
      dis.value=event['dbp'].toString();
      update();
    });

    dPrint('MYYYYY'+(await timex.isConnected()).toString());










  }



  connectDevice(macAddress,deviceName) async{
    if (await timex.isConnected()){

    }
    else {
      timex.connect(macAddress: macAddress, deviceName: deviceName);
    }

  }




  void updateSelectedTimePeriod(String val){

    selectedTimePeriod.value=val;
    update();

    if(selectedTimePeriod=='Repeat'){
      if(_timer!=null){
        _timer!.cancel();
      }
      measureSpO2();
      update();
    }
    else{
      if(_timer!=null){
        _timer!.cancel();
      }

      nextMeasure.value=DateTime.now().add(Duration(minutes: int.parse(val.split(' ')[0])));
      _timer=Timer.periodic(Duration(minutes: int.parse(val.split(' ')[0])), (timer) {

        nextMeasure.value=DateTime.now().add(Duration(minutes: int.parse(val.split(' ')[0])));
        measureSpO2();
        update();
      });
    }


  }



  void measureSpO2(){
    startBackgroundService("SpO2");
    timex.measureSpo2();
    readingData.value='sp';
    update();
  }

  void measureBP(){
    startBackgroundService("Blood Pressure");
    timex.measureBloodPressure();
    readingData.value='bp';
    update();
  }

  void measureHR(){
    startBackgroundService("Heart Rate");
    timex.measureHeartRate();
    readingData.value='hr';
    update();
  }



  void startBackgroundService(String title) async{

  }







  void disposeData(){
   // timex.disConnect();

    insidePage.value=false;

    WidgetsBinding.instance
        .addPostFrameCallback((_) =>    update());
    // if(_timer!=null){
    //   _timer!.cancel();
    // }
  }



}