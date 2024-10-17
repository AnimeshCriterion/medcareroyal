

import 'package:medvantage_patient/Localization/app_localization.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oximeter/flutter_oximeter.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/tab_responsive.dart';
import '../../theme/theme.dart';
import 'oximeter_modal.dart';


class Oximeter extends StatefulWidget {
  const Oximeter({Key? key}) : super(key: key);

  @override
  State<Oximeter> createState() => _OximeterState();
}

class _OximeterState extends State<Oximeter> {
  bool isScanning = false;
  bool isConnected = false;
  bool foundDevice = false;
  String macAddress = '';


  OximeterModal modal=OximeterModal();

  FlutterOximeter oxi=FlutterOximeter();


  @override
  void initState() {
    super.initState();
    initPlatformState();


  }

  @override
  void dispose() {

    super.dispose();
    oxi.disConnect(macAddress: macAddress);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    oxi.getScanningStateStream.listen((event) {


      isScanning=event;

      if(mounted){
        setState(() {

        });
      }
    });


    oxi.getConnectionStateStream.listen((event) {
      isConnected=event;

      if(mounted){
        setState(() {

        });
      }
    });


    oxi.startScanDevice();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return  ColoredSafeArea(

      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(title:'Oximeter',color:  themeChange.darkTheme
              ? AppColor.darkshadowColor1
              : AppColor.lightshadowColor1,
            // bgColor: AppColor().orangeButtonColor,
            // title:  modal.dashC.selectedHead.value.headDescription.toString(),
            // subtitle:modal.ipdC.selectedPatient.value.pname.toString()+
            //     ' ('+modal.ipdC.selectedPatient.value.pid.toString()+')',
            // subtitle: patient.pid,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow:  [
                        BoxShadow(
                          color: isConnected? Colors.green: Colors.red,
                          blurRadius: 6.0,
                          spreadRadius: 0.0,
                          offset: const Offset(
                            0.0,
                            3.0,
                          ),
                        ),
                      ]),
                  child: const SizedBox(
                    height: 60,
                    child: Image(
                      image: AssetImage('assets/oximeter_ct.webp'),
                    ),
                  ),
                ),
              ),
            ]
          ),
          body: Container(   decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeChange.darkTheme
                    ? AppColor.darkshadowColor1
                    : AppColor.lightshadowColor1,
                themeChange.darkTheme
                    ? AppColor.darkshadowColor1
                    : AppColor.lightshadowColor1,
                themeChange.darkTheme ? AppColor.black :
                AppColor.lightshadowColor2,
              ],
            ),
          ),
            child: Column(
              children: [


                Expanded(
                  child: TabResponsive(
                    child: StreamBuilder<Object>(
                        stream: null,
                        builder: (context, snapshot) {
                          return StreamBuilder<DeviceData>(
                              stream: oxi.deviecFoundStream,
                              builder: (context, deviceSnapshot) {

                                if(deviceSnapshot.data!=null){
                                  macAddress=deviceSnapshot.data!.macAddress!;
                                  foundDevice=true;

                                }
                                else{
                                  macAddress='';
                                  foundDevice=false;

                                }

                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: deviceSnapshot.data==null? (isScanning && !foundDevice)?
                                        Lottie.asset('assets/scanning.json')
                                        :
                                        _searchAgainWidget()
                                            :Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              !isConnected?

                                              PrimaryButton(
                                                  onPressed: () async{

                                                   oxi.connect(macAddress: deviceSnapshot.data!.macAddress??'', deviceName: deviceSnapshot.data!.deviceName??'');

                                                  },
                                                  width: 100,
                                                  title: 'connect'):
                                                  Container()
                                              // MyButton2(
                                              //     onPress: (){
                                              //       oxi.disConnect(macAddress: deviceSnapshot.data!.macAddress??'');
                                              //     },
                                              //     width: 100,
                                              //     title: 'DisConnect')
                                              ,
                                              PrimaryButton(
                                                  onPressed: () async{
                                                    modal.saveData(context);

                                                  },
                                                  width: 100,
                                                  title: localization.getLocaleData.save.toString())

                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: foundDevice,
                                        child: Expanded(
                                          child:                   Visibility(
                                            visible: !(isScanning && !foundDevice),
                                            child: Center(
                                              child:

                                              StreamBuilder<OximeterData>(
                                                  stream: oxi.detectedDataStream,
                                                  builder: (context, snapshot) {


                                                    var size=MediaQuery.of(context).size;

                                                    if(snapshot.data!=null){
                                                      modal.controller.updateOximeterData=snapshot.data!;
                                                    }
                                                    else{
                                                      modal.controller.updateOximeterData=OximeterData();
                                                    }

                                                    return Padding(
                                                      padding:  EdgeInsets.fromLTRB(
                                                          size.width/8
                                                          ,  size.height/30,  size.width/8,  size.height/30),
                                                      child: _oximeter(snapshot),
                                                    );
                                                  }
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],

                                  );
                              }
                          );
                        }
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton:  Visibility(
            visible: !isConnected,
            child: InkWell(
              onTap: (){
                oxi.startScanDevice();
              },
              child: Container(

                decoration: BoxDecoration(
                    color: AppColor.orange,
                    borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                child: isScanning?
                Stack(
                  children: const [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation( Colors.orange),
                    ),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Icon(Icons.search,
                          color: Colors.white,)),
                  ],
                )
                    :const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search,
                    color: Colors.white,),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }




  Widget _searchAgainWidget(){
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    return   Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset('assets/search.json'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: Column(
              children: [
                Text('Device Not Found',
                  textAlign: TextAlign.center,
                  style: MyTextTheme.mediumBCB,),
              ],
            ),
          ),
          const SizedBox(height: 30,),

          PrimaryButton(
            width: 200,
            color: AppColor.orange,
            title: 'Search Again',
            onPressed: (){
              oxi.startScanDevice();
            },
          ),
        ],
      ),
    );
  }


  Widget _oximeter(snapshot){
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    return  Container(

      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(80),
            bottomRight: Radius.circular(80),
          ),
          border: Border.all(color: AppColor.black,
              width: 3),
          boxShadow:  [
            BoxShadow(
              color: isConnected? Colors.blue: Colors.white,
              blurRadius: 6.0,
              spreadRadius: 0.0,
              offset: const Offset(
                0.0,
                6.0,
              ),
            ),
          ]
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20,20,20,0,),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  border: Border.all(color: AppColor.black,
                      width: 3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [

                      snapshot.data==null?
                      Expanded(
                        child: Center(
                          child: Text('Connect Device For Data',
                            textAlign: TextAlign.center,
                            style: MyTextTheme.mediumWCB,),
                        ),
                      )
                          :Expanded(
                        child: Column(
                          children: [

                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('spO2',
                                      style: MyTextTheme.mediumWCB.copyWith(
                                      ),),

                                    Text((snapshot.data!.spo2??'0').toString()+' %',
                                      style: MyTextTheme.mediumWCB.copyWith(
                                          fontSize: 50
                                      ),),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [

                                    Text('Pulse Rate',
                                      style: MyTextTheme.mediumWCB.copyWith(
                                      ),),

                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: SizedBox(
                                              height: 20,
                                              child: Lottie.asset('assets/heart.json')),
                                        ),
                                        Text((snapshot.data!.heartRate??'0').toString()+' bpm',
                                          style: MyTextTheme.mediumWCB.copyWith(
                                              fontSize: 30
                                          ),),

                                        Container(
                                          width: 25,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),



                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,0,10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text('hRV',
                                            style: MyTextTheme.mediumWCB.copyWith(
                                            ),),
                                          Text((snapshot.data!.hrv??'0').toString()+' ms',
                                            style: MyTextTheme.mediumWCB.copyWith(
                                                fontSize: 15
                                            ),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text('pI',
                                            style: MyTextTheme.mediumWCB.copyWith(
                                            ),),
                                          Text((snapshot.data!.perfusionIndex!.toStringAsFixed(1)).toString()+' %',
                                            style: MyTextTheme.mediumWCB.copyWith(
                                                fontSize: 15
                                            ),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),




                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow:  [
                        BoxShadow(
                          color: isConnected? Colors.blue: Colors.white,
                          blurRadius: 6.0,
                          spreadRadius: 0.0,
                          offset: const Offset(
                            0.0,
                            3.0,
                          ),
                        ),
                      ]),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Icon(Icons.bluetooth,
                          color: Colors.white,),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,20),
            child: Text(localization.getLocaleData.criterionTech.toString(),
              style: MyTextTheme.mediumBCB,),
          )
        ],
      ),
    );
  }

}
