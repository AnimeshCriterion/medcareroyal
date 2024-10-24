import 'dart:io';

import 'package:medvantage_patient/LiveVital/stetho_bluetooth/pid_page_for_stetho.dart';
import 'package:medvantage_patient/LiveVital/thermometer/thermometer_scan_view.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../Localization/app_localization.dart';
import '../app_manager/alert_toast.dart';
import '../theme/theme.dart';
import 'CTBP/scan_ct_bp_machine.dart';
import 'HelixTimex/helix_timex.dart';
import 'Wellue/wellue_view.dart';
import 'YonkerBpMachine/yonker_bp_machine_view.dart';
import 'YonkerOximeter/yonker_oximeter_view.dart';
import 'bp_watch/watch_view.dart';
import 'google_fit/google_fit_view.dart';
import 'omran_bp/bp_view.dart';

class DeviceView extends StatefulWidget {
  final bool isHelix;
  final bool isCTBP;
  final bool isYonkerBPMachine;
  final bool isViaOximeter;
  final bool isThermometer;
  final bool isWellue;
  final bool isYonkerOximeter;
  final bool isAppleHealth;
  final bool isStetho;

  const DeviceView(
      {Key? key,
        this.isHelix=false,
        this.isCTBP=false,
        this.isYonkerBPMachine=false,
        this.isViaOximeter=false,
          this.isThermometer=false,   this.isWellue=false,
          this.isYonkerOximeter=false,  this.isAppleHealth=false,   this.isStetho=false,})
      : super(key: key);

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {

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

      // await FlutterBluetoothSerial.instance.requestEnable();
      // bool bluetoothEnable =
      //     (await FlutterBluetoothSerial.instance.isEnabled) ?? false;

      if (permissionGiven) {
        // if (locationEnable) {
        // if (bluetoothEnable) {
          if (permissionGiven) {
            MyNavigator.push(context, route);
          } else {
            Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'some Permissions Are Not Granted'.toString()));
            // Alert.show('some Permissions Are Not Granted');
          }
        // } else {
        //   Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Please Enable Bluetooth Use This Feature'.toString()));
        //   // Alert.show('Please Enable Bluetooth Use This Feature');
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

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Container(
      color: AppColor.white,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: localization.getLocaleData.selectDeviceToConnect.toString(),color:  themeChange.darkTheme
              ? AppColor.darkshadowColor1
              : AppColor.lightshadowColor1,
          ),
          body: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  // Row(
                  //   children: [
                  //     SvgPicture.asset('assets/bloodPressureImage.svg'),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     Text(
                  //       localization.getLocaleData.bloodPressure
                  //           .toString(),
                  //       style: MyTextTheme.mediumBCB,
                  //     ),
                  //   ],
                  // ),
                  Column(
                    children: [
                      Visibility(
                        visible: widget.isHelix,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _enableBluetooth(context,
                                    route: const HelixTimexPage());
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    40, 8, 40, 8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.blue.shade50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text('Helix',
                                          style: MyTextTheme.mediumBCB
                                              .copyWith(
                                                  color: AppColor
                                                      .primaryColorLight)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //: SizedBox(),
                      Visibility(
                        visible: widget.isAppleHealth && Platform.isIOS,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _enableBluetooth(context,
                                    route: const GoogleFitView());
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    40, 8, 40, 8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.blue.shade50,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text('Apple Health',
                                          style: MyTextTheme.mediumBCB
                                              .copyWith(
                                              color: AppColor
                                                  .primaryColorLight)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.isCTBP,
                        child: InkWell(
                          onTap: () {
                            _enableBluetooth(context,
                                route: const ScanCTBpMachine());
                            // App().navigate(context, ScanCTBpMachine( ));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(40, 0, 40, 8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.blue.shade50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text('CT Blood Pressure',
                                      style: MyTextTheme.mediumBCB
                                          .copyWith(
                                              color: AppColor
                                                  .primaryColorLight)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.isCTBP,
                        child: InkWell(
                          onTap: () {
                            _enableBluetooth(context,
                                route: const bpscreen());
                            // App().navigate(context, ScanCTBpMachine( ));
                          },
                          child: Padding(
                            padding:
                            const EdgeInsets.fromLTRB(40, 0, 40, 8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.blue.shade50,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text('Omron BP',
                                      style: MyTextTheme.mediumBCB
                                          .copyWith(
                                          color: AppColor
                                              .primaryColorLight)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),


                      Visibility(
                        visible: widget.isCTBP,
                        child: InkWell(
                          onTap: () {
                            _enableBluetooth(context,
                                route: const Watch());
                            // App().navigate(context, ScanCTBpMachine( ));
                          },
                          child: Padding(
                            padding:
                            const EdgeInsets.fromLTRB(40, 0, 40, 8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.blue.shade50,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text('BP Wacth',
                                      style: MyTextTheme.mediumBCB
                                          .copyWith(
                                          color: AppColor
                                              .primaryColorLight)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: widget.isYonkerBPMachine,
                        child: InkWell(
                          onTap: () {
                            _enableBluetooth(context,
                                route: YonkerBpMachineView());

                            // _enableBluetooth(context, route: BluetoothDeviceView(
                            //   deviceName: localization.getLocaleData.patientMonitor.toString(),
                            //
                            //   child: const PatientMonitorScreen(),
                            // ));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(40, 0, 40, 8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.blue.shade50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text('Yonker BP Machine',
                                      style: MyTextTheme.mediumBCB
                                          .copyWith(
                                              color: AppColor
                                                  .primaryColorLight)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Visibility(
                      //     visible: widget.isViaOximeter,
                      //     child: Column(
                      //       children: [
                      //         InkWell(
                      //           onTap: () async {
                      //             _enableBluetooth(context,
                      //                 route: const Oximeter());
                      //           },
                      //           child: Padding(
                      //             padding: const EdgeInsets.fromLTRB(
                      //                 40, 8, 40, 8),
                      //             child: Container(
                      //               padding: const EdgeInsets.all(8.0),
                      //               color: Colors.blue.shade50,
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   Text('Via Oximeter',
                      //                       style: MyTextTheme.mediumBCB
                      //                           .copyWith(
                      //                               color: AppColor
                      //                                   .primaryColorLight)),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 10,
                      //         ),
                      //         Visibility(
                      //           visible: widget.isWellue,
                      //           child: InkWell(
                      //             onTap: () {
                      //               _enableBluetooth(context,
                      //                   route: WellueView());
                      //             },
                      //             child: Padding(
                      //               padding: const EdgeInsets.fromLTRB(
                      //                   40, 0, 40, 8),
                      //               child: Container(
                      //                 padding: const EdgeInsets.all(8),
                      //                 color: Colors.blue.shade50,
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   children: [
                      //                     Text('Wellue Oximeter',
                      //                         style: MyTextTheme.mediumBCB
                      //                             .copyWith(
                      //                                 color: AppColor
                      //                                     .primaryColorLight)),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 10,
                      //         ),
                      //         Visibility(
                      //           visible: widget.isYonkerOximeter,
                      //           child: InkWell(
                      //             onTap: () {
                      //               _enableBluetooth(context,
                      //                   route: const YonkerOximeterView());
                      //             },
                      //             child: Padding(
                      //               padding: const EdgeInsets.fromLTRB(
                      //                   40, 0, 40, 8),
                      //               child: Container(
                      //                 padding: const EdgeInsets.all(8),
                      //                 color: Colors.blue.shade50,
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   children: [
                      //                     Text('Yonker Oximeter',
                      //                         style: MyTextTheme.mediumBCB
                      //                             .copyWith(
                      //                                 color: AppColor
                      //                                     .primaryColorLight)),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     )),


                      Visibility(
                          visible: widget.isStetho,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  _enableBluetooth(context,
                                      route: const PidPageForStethoView());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      40, 8, 40, 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colors.blue.shade50,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text('Stethoscope',
                                            style: MyTextTheme.mediumBCB
                                                .copyWith(
                                                color: AppColor
                                                    .primaryColorLight)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: widget.isWellue,
                                child: InkWell(
                                  onTap: () {
                                    _enableBluetooth(context,
                                        route: WellueView());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 0, 40, 8),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      color: Colors.blue.shade50,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text('Wellue Oximeter',
                                              style: MyTextTheme.mediumBCB
                                                  .copyWith(
                                                  color: AppColor
                                                      .primaryColorLight)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: widget.isYonkerOximeter,
                                child: InkWell(
                                  onTap: () {
                                    _enableBluetooth(context,
                                        route: const YonkerOximeterView());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 0, 40, 8),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      color: Colors.blue.shade50,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text('Yonker Oximeter',
                                              style: MyTextTheme.mediumBCB
                                                  .copyWith(
                                                  color: AppColor
                                                      .primaryColorLight)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),

                      Visibility(visible: widget.isThermometer,
                        child:
                      InkWell(
                        onTap: () {
                          // deviceType();
                          MyNavigator.push(
                              context, const ThermometerScanView());
                        },
                        child: Padding(
                          padding:
                          const EdgeInsets.fromLTRB(40, 0, 40, 8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.blue.shade50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Thermometer',
                                    style: MyTextTheme.mediumBCB.copyWith(
                                        color:
                                        AppColor.primaryColorLight)),
                              ],
                            ),
                          ),
                        ),
                      ),)

                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
