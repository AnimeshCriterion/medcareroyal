import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/neomorphic/neomorphic.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';

import '../../Localization/app_localization.dart';
import '../../app_manager/alert_toast.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/navigator.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import 'add_device_connect.dart';

class AddDeviceView extends StatefulWidget {
  const AddDeviceView({super.key,  });

  @override
  State<AddDeviceView> createState() => _AddDeviceViewState();
}

class _AddDeviceViewState extends State<AddDeviceView> {

  Location location = new Location();
  late bool _serviceEnabled;
  late LocationData _locationData;
  _enableBluetooth(context, {required Widget route}) async {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    if (Platform.isAndroid) {
      bool permissionGiven = false;
      print('nnnnnnnvvvvvvv');
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          debugPrint('Location Denied once');
        }
      }

      var permissionStatus = await Permission.location.request();
      permissionGiven = permissionStatus.isGranted;
      var permissionloc = await Permission.locationWhenInUse.request();
      print('nnnnnnnn'+permissionStatus.isGranted.toString());
      permissionGiven = permissionloc.isGranted;
      var permissionBluC = await Permission.bluetoothConnect.request();
      permissionGiven = permissionBluC.isGranted;
      var permissionBlu = await Permission.bluetooth.request();
      await Permission.nearbyWifiDevices.request();
      permissionGiven = permissionBlu.isGranted;
      var permissionBluScan = await Permission.bluetoothScan.request();
      permissionGiven = permissionBluScan.isGranted;

      // bool locationEnable = await LocationService().enableGPS();
      //
      // await FlutterBluetoothSerial.instance.requestEnable();
      // bool bluetoothEnable =
      //     (await FlutterBluetoothSerial.instance.isEnabled) ?? false;

      if (permissionGiven) {
        // if (locationEnable) {
        // if (bluetoothEnable) {
          if (permissionGiven) {
            MyNavigator.push(context, route);
          } else {
            Alert.show('some Permissions Are Not Granted');
          }
        // } else {
        //   Alert.show('Please Enable Bluetooth Use This Feature');
        // }
        // } else {
        //   Alert.show('Please Enable Location Use This Feature');
        // }
      } else {
        Alert.show('Some Permission Are NotGranted');
      }
    } else {
      MyNavigator.push(context, route);
    }
  }


  // bool trunonBt=false;
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    return Container(
      color: AppColor.green,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            primaryBackColor:
                themeChange.darkTheme ? AppColor.white : AppColor.greyDark,
            title: localization.getLocaleData.addVital.toString(),
            color: themeChange.darkTheme == true
                ? AppColor.blackDark2
                : AppColor.neoBGWhite1,
            titleColor:
                themeChange.darkTheme ? AppColor.white : AppColor.greyDark,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    themeChange.darkTheme == true
                        ? AppColor.blackDark2
                        : AppColor.neoBGWhite1,
                    themeChange.darkTheme == true
                        ? AppColor.blackDark2
                        : AppColor.neoBGWhite1,
                    themeChange.darkTheme == true
                        ? AppColor.blackDark2
                        : AppColor.neoBGWhite1,
                    themeChange.darkTheme == true
                        ? AppColor.black.withOpacity(.8)
                        : AppColor.neoBGWhite1,
                  ]),
              color: Colors.grey.shade800,
            ),
            child:Padding(
              padding: const EdgeInsets.all(15.0),
              child: turnonBluetooth()









            )




                      // SizedBox(height: 15,),
                      // Text("Turn on bluetooth"),




          ),
        ),
      ),
    );
  }
  turnonBluetooth(){
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    return  Column(


      children: [
        Image.asset(
          "assets/add_device/turn_on_bt.png",
          fit: BoxFit.fitHeight,
          height: 211,
        ),
        const SizedBox(height: 15,),
        Text("Turn on bluetooth",
          style: MyTextTheme.mediumGCN.copyWith(fontSize: 15,
              color: themeChange.darkTheme?AppColor.green12:AppColor.greyDark,
              fontWeight: FontWeight.w600
          ),),
        Text("to start searching for device",
          style: MyTextTheme.mediumGCN.copyWith(fontSize: 13,
            color: themeChange.darkTheme?AppColor.grey:AppColor.greyDark,

          ),)
        ,


        const Expanded(child: SizedBox()),
        NeoButton(title: "Turn on now",
            textStyle: TextStyle(
                fontSize: 13,
                color: themeChange.darkTheme?AppColor.green12:AppColor.greyDark,fontWeight: FontWeight.w600
            ),

            func: ()async{
              _enableBluetooth(context, route: AddDeviceConnectView( ));

            })
      ],
    );
  }
  selectDevice(){
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    return  Column(
      children: [

        Image.asset("assets/add_device/bluetooth.png"),
        Text("Select device to connect",
        style: MyTextTheme.mediumGCB.copyWith(color:themeChange.darkTheme? AppColor.white.withOpacity(.9):AppColor.grey),),
       Text("Make sure the device is turn on and in connection mode",
           ),

       Expanded(child: SizedBox()),

        NeoButton(title: "Connect",
            textStyle: TextStyle(
                fontSize: 13,
                color: themeChange.darkTheme?AppColor.green12:AppColor.greyDark,fontWeight: FontWeight.w600
            ),

            func: ()async{

            })
      ],
    );
  }
}
