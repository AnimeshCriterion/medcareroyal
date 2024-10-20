
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/devices_with_new_ui/device_connnect_controller.dart';
import '../../LiveVital/pmd/my_text_theme.dart';
import '../../ViewModal/add_device_view_modal.dart';
import '../../app_manager/appBar/custom_app_bar.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/neomorphic/neomorphic.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import '../LiveVital/bp_watch/watch_view.dart';
import '../LiveVital/google_fit/google_fit_view.dart';
import '../Localization/app_localization.dart';
import '../assets.dart';
import '../LiveVital/low_ecg/devices_view.dart';
import '../LiveVital/ptt/ptt_view.dart';
import '../LiveVital/stetho_bluetooth/pid_page_for_stetho.dart';
import '../Localization/app_localization.dart';
import '../authenticaton/user_repository.dart';
import 'bp_data_view.dart';

class AddDeviceConnectView extends StatefulWidget {

  const AddDeviceConnectView({super.key,  });

  @override
  State<AddDeviceConnectView> createState() => _AddDeviceConnectViewState();
}

class _AddDeviceConnectViewState extends State<AddDeviceConnectView> {
  @override

  DeviceConnectController controller=Get.put(DeviceConnectController());

  void initState() {
    controller.updateSelectedDevice=Map<String, dynamic>.from({});
    // TODO: implement initState
    // AddDeviceViewModal addDevicevm =
    // Provider.of<AddDeviceViewModal>(context, listen: false);
    // addDevicevm.updateSelectedIndex="";
    super.initState();
  }


  Location location = new Location();
  late bool _serviceEnabled;
  late LocationData _locationData;
  _enableBluetooth(context,  ) async {
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

      await FlutterBluetoothSerial.instance.requestEnable();
      bool bluetoothEnable =
          (await FlutterBluetoothSerial.instance.isEnabled) ?? false;

      if (permissionGiven) {
        // if (locationEnable) {
        if (bluetoothEnable) {
          if (permissionGiven) {

          } else {
            Alert.show('some Permissions Are Not Granted');
          }
        } else {
          Alert.show('Please Enable Bluetooth Use This Feature');
        }
        // } else {
        //   Alert.show('Please Enable Location Use This Feature');
        // }
      } else {
        Alert.show('Some Permission Are NotGranted');
      }
    } else {

    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<DeviceConnectController>();

  }

  onPressBack() async {
    try{

      controller.timer!.cancel();
        controller.subscription!.cancel();
        controller.subscription1!.cancel();

      controller.updateSelectedDevice = Map<String, dynamic>.from({});
      FlutterBluePlus.stopScan();
      await controller.devicesData!.disconnect();

      controller.update();
    }catch(e){

      FlutterBluePlus.stopScan();

      if(controller.timer!=null){
        controller.timer!.cancel();
      }
    }
    Get.back();
  }
  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    // AddDeviceViewModal addDevicevm =
    // Provider.of<AddDeviceViewModal>(context, listen: true);

    return Container(
      color: AppColor.white,
      child: SafeArea(
        child: Scaffold(
          // appBar: CustomAppBar(
          //   primaryBackColor:
          //   themeChange.darkTheme ? AppColor.white : AppColor.greyDark,
          //   title: "Add Device",
          //   color: themeChange.darkTheme == true
          //       ? AppColor.blackDark2
          //       : AppColor.neoBGWhite1,
          //   titleColor:
          //   themeChange.darkTheme ? AppColor.white : AppColor.greyDark,
          // ),
          body: WillPopScope(
            onWillPop: () async {
              await onPressBack();
              return Future.value(false);
            },
            child: Column(
              children: [
                // Row(children: [
                //   InkWell(
                //     onTap: () async {
                //       await onPressBack();
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(15),
                //       child: Icon(Icons.arrow_back),
                //     ),
                //   ),
                //   Text("Add Device",style: MyTextTheme().largeBCB,)
                // ],),
                userRepository.currentUser!.uhID.toString().toLowerCase()=="uhid01169"?Center(child: Text("Coming Soon")):
                Expanded(
                  child: Container(
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
                      child: connectBluetooth()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  connectBluetooth() {
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: true);

    List addDeviceConnect=[
      {
        "id":1,
        "name": localization.getLocaleData.yonker.toString(),
        "deviceType":localization.getLocaleData.oximeter.toString(),
        "image":ImagePaths.omran.toString(),
        'device':'BleModuleA',
        'suuid':'cdeacd80-5235-4c07-8846-93a37ee6b86d',
        'cuuid':'cdeacd81-5235-4c07-8846-93a37ee6b86d'

      },
      {
        "id":1,
        "name":localization.getLocaleData.wellue.toString(),
        "deviceType":localization.getLocaleData.oximeter.toString(),
        "image":ImagePaths.omran.toString(),
        'device':'OxySmart',
        'suuid':'6e400001-b5a3-f393-e0a9-e50e24dcca9e',
        'cuuid':'6e400003-b5a3-f393-e0a9-e50e24dcca9e'

      },
      {
        // '28:FF:B2:F9:B4:14',
        "id":2,
        "name":localization.getLocaleData.omran.toString(),
        "deviceType":localization.getLocaleData.bpMachine.toString(),
        "image":ImagePaths.yonker.toString(),
        'device':'BLESmart_00000' ,
        'suuid':'00001810-0000-1000-8000-00805f9b34fb',
        'cuuid':'00002a35-0000-1000-8000-00805f9b34fb'
      },
      {
        "id":3,
        "name":localization.getLocaleData.ctBp.toString(),
        "deviceType":localization.getLocaleData.bpMachine.toString(),
        "image":ImagePaths.ct.toString(),
        'device':'CT033',
        'suuid':'0000FFF0-0000-1000-8000-00805f9b34fb',
        'cuuid':'0000FFF1-0000-1000-8000-00805f9b34fb'
      },
      {
        "id":4,
        "name":localization.getLocaleData.yonker.toString(),
        "deviceType":localization.getLocaleData.bpMachine.toString(),
        "image":ImagePaths.wrist.toString(),
        'device':'BleModuleB',
        'suuid':'cdeacd80-5235-4c07-8846-93a37ee6b86d',
        'cuuid':'cdeacd81-5235-4c07-8846-93a37ee6b86d'
      },
      {
        "id":4,
        "name":localization.getLocaleData.ctOximeter.toString(),
        "deviceType":localization.getLocaleData.oximeter.toString(),
        "image":ImagePaths.wrist.toString(),
        'device':'CTP005',
        'suuid':'cdeacd80-5235-4c07-8846-93a37ee6b86d',
        'cuuid':'cdeacd81-5235-4c07-8846-93a37ee6b86d'
      },
      {
        "id":4,
        "name":localization.getLocaleData.bpw1Watch.toString(),
        "deviceType":localization.getLocaleData.watch.toString(),
        "image":ImagePaths.wrist.toString(),
        'device':'BleMod',
        'suuid':'cde 37ee6b86d',
        'cuuid':'cdeacd81-523 37ee6b86d'
      },
      {
        "id":4,
        "name":localization.getLocaleData.apple.toString(),
        "deviceType":localization.getLocaleData.watch.toString(),
        "image":ImagePaths.wrist.toString(),
        'device':'BLEsmart_00000150D50708A43200',
        'suuid':'ecbe3980-c9a2-11e1-b1bd-0002a5d5c51b',
        'cuuid':'0348f9c3-f773-4af8-90dd-25a99ad0518b'
      },

    ];

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    return GetBuilder(
        init: DeviceConnectController(),
        builder: (_) {
        return Column(
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      controller.getSelectedIndex.isNotEmpty?
                      Image.asset(
                        "assets/add_device/bt_lottie.gif",
                        fit: BoxFit.fill,
                        height: 74,
                      ):Image.asset(
                        "assets/add_device/bluetooth.png",
                        fit: BoxFit.fill,
                        height: 74,
                      ),
                      SizedBox(width: 15,),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            controller.getSelectedIndex.isNotEmpty?    Text(
                              localization.getLocaleData.automaticDeviceConnect.toString(),
                              style: MyTextTheme().mediumGCN.copyWith( fontSize: 15,
                                       color: themeChange.darkTheme
                                      ? AppColor.grey
                                      : AppColor.greyDark,
                                  fontWeight: FontWeight.w600),
                            ):Text(
                              localization.getLocaleData.selectDeviceToConnect.toString(),

                              style: MyTextTheme().mediumGCN.copyWith(
                                fontSize: 15,
                                  color: themeChange.darkTheme
                                      ? AppColor.white
                                      : AppColor.greyDark,
                                  fontWeight: FontWeight.w600),
                            ),
                             Text(
                               localization.getLocaleData.makeSureTheDeviceIsTurnedOn.toString(),

                              style: MyTextTheme().mediumGCN.copyWith(
                                fontSize: 13,
                                color: themeChange.darkTheme
                                    ? AppColor.grey
                                    : AppColor.greyDark,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            controller.getSelectedDeviceIndex.toString().isNotEmpty?     Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                JumpingText(
                  localization.getLocaleData.connecting.toString(),
                  style: MyTextTheme().mediumGCN.copyWith(
                      color: AppColor.green,
                      fontWeight: FontWeight.bold

                  ),
                ),
              ],
            ):SizedBox(),
            SizedBox(height: 15,),
            Expanded(
              child: SingleChildScrollView(
                child: StaggeredGrid.extent(
                    maxCrossAxisExtent: 250,
                    children:
                    List.generate(controller.addDeviceConnect.length, (index) {
                      var data = controller.addDeviceConnect[index];
                      return    ((Platform.isAndroid) &&  data['name']=='Apple')? SizedBox():InkWell(onTap: () async {
                        try{
                              await _enableBluetooth(
                                context,
                              );
                            } catch (e) {}
                            controller.updateSelectedDeviceIndex=index.toString();
                        controller.updateSelectedDevice = Map.from(data);
                        try {
                          FlutterBluePlus.stopScan();
                          // controller.oxi.disConnect(
                          //     macAddress:
                          //     controller.macAddress.toString());
                        } catch (e) {}
                        if (  data['name'].toString() != 'BPW1 Watch' && data['name'].toString() !='Apple'&& data['name'].toString() !='ECG'&& data['name'].toString() !='StethoScope'&& data['name'].toString() !='PTT') {


                              if (data['device'].toString() == 'CTP005') {
                                // controller.Ctoximeter(context);

                              } else {

                                await controller.scanDevices();
                              }
                            }
                        else if (data['name'].toString() =='Apple'){

                          Get.to(GoogleFitView());
                        }
                        else if (data['name'].toString() =='ECG'){

                          Get.to(MyAllDevicesView());

                          controller.updateSelectedDeviceIndex = '';
                          controller.updateSelectedDevice = Map.from({});
                        }
                        else if (data['name'].toString() =='StethoScope'){

                          Get.to(PidPageForStethoView());
                          controller.updateSelectedDeviceIndex = '';
                          controller.updateSelectedDevice = Map.from({});
                        }
                        else if (data['name'].toString() =='PTT'){

                          Get.to(PulseTransitTimeView());
                          controller.updateSelectedDeviceIndex = '';
                          controller.updateSelectedDevice = Map.from({});
                        }
                        else  if ( data['name'].toString() == 'BPW1 Watch'){

                          Get.to(Watch());
                        }
                          }, child:
                      deviceWidget(
                          device: data["name"].toString(),
                          modal: data["modal"].toString(),
                          deviceType: data["deviceType"].toString(),
                          image: data["image"].toString(),
                          color: controller.getSelectedDeviceIndex == index.toString()
                              ? Colors.green
                              :AppColor.transparent),);
                    })),
              ),
            ),
            // NeoButton(
            //     title: "Connect",
            //     textStyle: TextStyle(
            //         fontSize: 13,
            //         color: controller.getSelectedIndex.isNotEmpty?Colors.green:AppColor.greyDark,
            //         // themeChange.darkTheme
            //         //     ? AppColor.green12
            //         //     : AppColor.greyDark,
            //         fontWeight: FontWeight.w600),
            //     func: () async {
            //
            //      // await controller. deviceData();
            //      //  if(controller.getSelectedDevice.name!=''){
            //      //      Navigator.push(
            //      //          context,
            //      //          MaterialPageRoute(
            //      //              builder: (context) => BpDeviceDataView(
            //      //                  // deviceData: controller.getSelectedDeviceData,
            //      //                  )));
            //      //    }else{
            //      //    Alert.show('Please select device.');
            //      //  }
            //       })
          ],
        );
      }
    );
  }

  deviceWidget({device, deviceType, image, required Color color,modal}) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    return GetBuilder(
        init: DeviceConnectController(),
        builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: color
                      // color: AppColor.green
                    ),
                    color: themeChange.darkTheme
                        ? AppColor.greyDark.withOpacity(.3)
                        : AppColor.grey.withOpacity(.5)),
                child: Row(
                  children: [
                    Expanded(flex: 4,
                      child: Image.asset(
                        image,
                        height:( device.toString()=='yonker'||
                            device.toString()=='Omron'||
                            device.toString()=='CT BP')? 74:53,
                        width:( device.toString()=='yonker'||
                            device.toString()=='Omron'||
                            device.toString()=='CT BP')? 74:53,
                      ),
                    ),
                    Expanded(flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device.toString().toUpperCase() ,
                              style: MyTextTheme().mediumGCN.copyWith(
                                fontSize: 15,
                                  color: themeChange.darkTheme
                                      ? AppColor.grey.withOpacity(.9)
                                      : AppColor.greyDark,
                                  fontWeight: FontWeight.w600),
                            ),
                            modal==' '? SizedBox(): Text('model:  '+ modal+' ',
                              style: MyTextTheme().mediumGCN.copyWith(
                                  fontSize: 8,
                                  color: themeChange.darkTheme
                                      ? AppColor.grey.withOpacity(.9)
                                      : AppColor.greyDark,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(deviceType.toString(),
                              style: MyTextTheme().mediumGCN.copyWith(
                                  color: themeChange.darkTheme
                                      ? AppColor.grey.withOpacity(.9)
                                      : AppColor.greyDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }





}
