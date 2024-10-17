import 'dart:async';


import 'package:medvantage_patient/LiveVital/CTBP/scan_cr_bp_machine_modal.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../Localization/app_localization.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../authenticaton/user_repository.dart';
import '../../theme/theme.dart';
import '../live_vital_controller.dart';
import 'ct_bp_machine.dart';


class CTBpScreenView extends StatefulWidget {

  final ScanResult device;

  const CTBpScreenView({Key? key, required this.device}) : super(key: key);


  @override
  State<CTBpScreenView> createState() => _CTBpScreenViewState();
}

class _CTBpScreenViewState extends State<CTBpScreenView> {

    late ScanResult device;
  FlutterBlue flutterBlue = FlutterBlue.instance;



  CTBpMachine bpMachine = CTBpMachine();

  @override
  void initState() {
    super.initState();
    device = widget.device;
    initiate();
  }

  @override
  void dispose() {
    device.device.disconnect();

    if (deviceStateStream != null) {
      deviceStateStream!.cancel();
    }

    super.dispose();
  }

  StreamSubscription? deviceStateStream;


  void initiate() async {
    try {
      await device.device.connect();
    }
    catch (e) {

    }


    deviceStateStream = device.device.state.listen((scan) async {
      if (scan == BluetoothDeviceState.connected) {
        List<BluetoothService> services = await device.device.discoverServices();
        for (var service in services) {
          bpMachine.initiateCTService(service);
        }
      }
      else {
        //   await device.connect();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        // title: Text(device.name),
        title: Text(localization.getLocaleData.bloodPressure.toString()),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.device.disconnect();
                  text = 'Disconnect';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.device.connect();
                  text = 'Connect';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: TextStyle(color:Colors.white),
                  ));
            },
          )
        ],
      ),
      body: Container( decoration: BoxDecoration(
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
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) =>
                  ListTile(
                    leading: (snapshot.data == BluetoothDeviceState.connected)
                        ? const Icon(Icons.bluetooth_connected)
                        : const Icon(Icons.bluetooth_disabled),
                    title: Text('Device Connected' +
                        ' ${snapshot.data.toString().split('.')[1]}.'),
                    subtitle: Text('${device.device.id}'),
                    trailing: StreamBuilder<bool>(
                      stream: device.device.isDiscoveringServices,
                      initialData: false,
                      builder: (c, snapshot) =>
                          IndexedStack(
                            index: snapshot.data! ? 1 : 0,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () => device.device.discoverServices(),
                              ),
                              const IconButton(
                                icon: SizedBox(
                                  width: 18.0,
                                  height: 18.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        Colors.grey),
                                  ),
                                ),
                                onPressed: null,
                              )
                            ],
                          ),
                    ),
                  ),
            ),

            Expanded(
              child: StreamBuilder<CTBpMachineData>(
                  stream: bpMachine.machineDataStream,
                  builder: (c, snapshot) {
                    CTBpMachineData? data = snapshot.data;

                    return  currentWidget(data);
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget currentWidget(CTBpMachineData? data){

    CtBpScanState scanState = data==null? CtBpScanState.initial:
    data.scanState??CtBpScanState.initial;

    switch(scanState){
      case CtBpScanState.initial:
        return const InitialState();
      case CtBpScanState.scanning:
        return data==null? Container():ScanningCTBP(data: data,);
      case CtBpScanState.noDataFound:
        return const ErrorCTBp();
      case CtBpScanState.complete:
        return data==null? Container():CompletedCTBp(data: data);

      default:
        return const InitialState();
    }
  }
}




class ScanningCTBP extends StatelessWidget {
  final CTBpMachineData data;
  const ScanningCTBP({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);
    return   Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              SvgPicture.asset('assets/blood_pressure.svg',),
              Positioned(
                top: 51,
                left: 0,
                right: 0,
                child: CircularPercentIndicator(
                  circularStrokeCap: CircularStrokeCap.round,
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: double.parse(
                      data.measuringPressure.toString())>=200.0? 200:double.parse(
                      data.measuringPressure.toString()) / 300,

                  center: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(''.toString()),
                  ),
                  progressColor: AppColor.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Text('${data.measuringPressure}mmHg' ,style: MyTextTheme.largePCB)
        ],
      ),
    );
  }
}



class CompletedCTBp extends StatelessWidget {

  final CTBpMachineData data;
  const CompletedCTBp({Key? key,

  required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);

    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 4,
                  child: Text('BP systolic',textAlign: TextAlign.end,style: MyTextTheme.veryLargeBCB.copyWith(color: AppColor.primaryColor))),
              Expanded(flex: 6,
                  child: Text( '   ${data.sys.toString()}' + 'mmHg',style: MyTextTheme.veryLargeBCB),)
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 4,
                  child: Text('BP diastolic',textAlign: TextAlign.end,style: MyTextTheme.veryLargeBCB.copyWith(color: AppColor.primaryColor))),
              Expanded(
                  flex: 6,
                  child: Text('   ${data.dia.toString()} '+ 'mmHg',style: MyTextTheme.veryLargeBCB),)
            ],
          ),     const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 4,
                  child: Text('Pulse Rate',textAlign: TextAlign.end,style: MyTextTheme.veryLargeBCB.copyWith(color: AppColor.primaryColor))),
              Expanded(
                  flex: 6,
                  child: Text('   ${data.pulseRate.toString()} '+ 'pul/min',style: MyTextTheme.veryLargeBCB),)
            ],
          ),
          const SizedBox(height: 25,),

          PrimaryButton(title: localization.getLocaleData.save.toString(),color: AppColor.primaryColor,width: 200,onPressed: () async {

            LiveVitalModal modal=LiveVitalModal();
            ScanCtBpMachineModal scanCtBpMachineModal=ScanCtBpMachineModal();


            print('----------nn'+data.sys.toString());
           await modal.addVitalsData(context,pr:data.pulseRate.toString(),
               BPSys: data.sys.toString(),
               BPDias: data.dia.toString(),
           );

          },)
        ],
      ),
    );
  }
}


class InitialState extends StatelessWidget {
  const InitialState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    return Center(child: Text('please Start Measuring Blood Pressure',style: MyTextTheme.mediumBCN,),);
  }
}




class ErrorCTBp extends StatelessWidget {
  const ErrorCTBp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);
    return Center(child: Text(localization.getLocaleData.dataNotFound.toString(),style: MyTextTheme.mediumBCN,),);
  }
}


