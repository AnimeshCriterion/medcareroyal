

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../Localization/app_localization.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../medcare_utill.dart';
import '../../theme/theme.dart';
import '../CTBP/scan_ct_bp_machine_controller.dart';
import 'termometer_view.dart';

class ThermometerScanView extends StatefulWidget {
  const ThermometerScanView({Key? key}) : super(key: key);

  @override
  _ThermometerScanViewState createState() => _ThermometerScanViewState();
}

class _ThermometerScanViewState extends State<ThermometerScanView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<ScanCtBpMachineController>();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Container(
      color: themeChange.darkTheme
          ? AppColor.darkshadowColor1
          : AppColor.lightshadowColor1,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(color: themeChange.darkTheme
              ? AppColor.darkshadowColor1
              : AppColor.lightshadowColor1,
            title: 'Search Device',
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
            child: StreamBuilder<BluetoothAdapterState>(
                stream: FlutterBluePlus.state,
                initialData: BluetoothAdapterState.unknown,
                builder: (c, snapshot) {
                  return const FindDevicesScreen();
                  // final state = snapshot.data;
                  //
                  // if (state == BluetoothState.on) {
                  //   return FindDevicesScreen();
                  // }
                  // else {
                  //   return BluetoothOffScreen(state: state);
                  // }
                }),
          ),
        ),
      ),
    );
  }

  Widget _searchAgainWidget() {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset('assets/search.json'),
          ),
          Text(
           "No Device Found",
            style: MyTextTheme.mediumBCB,
          ),
          const SizedBox(
            height: 20,
          ),
          PrimaryButton(
            width: 200,
            color: AppColor.primaryColor,
            title: "search again",
            onPressed: () {
              FlutterBluePlus.startScan();
            },
          ),
        ],
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  @override
  const FindDevicesScreen({
    Key? key,
  }) : super(key: key);

  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  // String foundDeviceID = "F8:33:31:46:86:CA";
  // String foundDeviceID = "F8:33:31:46:71:63";


  String foundDeviceName = "A&D_UT201BLE";
  bool isScanning = false;
  bool isDeviceFound = false;


  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        body: Container( color: themeChange.darkTheme
            ? AppColor.darkshadowColor1
            : AppColor.lightshadowColor1,
          child: RefreshIndicator(
            onRefresh: () => FlutterBluePlus
                .startScan(timeout: const Duration(seconds: 4)),
            child: GetBuilder(
                init: ScanCtBpMachineController(),
                builder: (_) {
                  return StreamBuilder<bool>(
                    stream: FlutterBluePlus.isScanning,
                    initialData: false,
                    builder: (c, deviceSnapshot) {
                      isDeviceFound = false;
                      if (deviceSnapshot.data!) {
                        isScanning = true;
                      } else {
                        isScanning = false;
                      }

                      return Center(
                        child: isScanning
                            ? Lottie.asset('assets/scanning.json')
                            : StreamBuilder<List<ScanResult>>(
                                stream: FlutterBluePlus.scanResults,
                                initialData: const [],
                                builder: (c, snapshot) {
                                  for (int i = 0;
                                      i < snapshot.data!.length;
                                      i++) {

                                    // dPring(snapshot.data![i].device.id.id.toString());
                                    if(snapshot.data![i].device.name.toString().length>13){
                                      dPrint('nnn'+snapshot.data![i].device.name
                                          .toString()
                                          .substring(0, 12).toString()+'nnn'+foundDeviceName);
                                      if (snapshot.data![i].device.name.toString().substring(0, 12).toString()==foundDeviceName.toString()) {
                                        dPrint('nnnnnnnnnnnnnnn');
                                        isDeviceFound = true;
                                        // isScanning = true;
                                      }
                                    }
                                  }
                                  return isDeviceFound == false
                                      ? _searchAgainWidget()
                                      :Column(
                                    children: snapshot.data!
                                        .map(
                                            (r) {
                                          dPrint(r.device.id.toString()+r.device.name.toString());

                                          return Visibility(
                                            // visible: r.device.id.toString()!='F8:33:31:46:86:CA',
                                              visible:r.device.name.length>14 && r.device.name.toString().substring(0,12)==foundDeviceName,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [

                                                  ScanResultTile(
                                                    result: r,
                                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                      // dPring( 'nnnnnnnnn'+r.device.id.toString());
                                                      r.device.connect();
                                                      return ThermometerView(device: r.device,  deviceName: foundDeviceName
                                                          .toString(),);
                                                    })),
                                                  ),
                                                ],
                                              ) );

                                        }).toList(),
                                  );

                                },
                              ),
                      );
                    },
                  );
                }),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBluePlus.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data!) {
              return FloatingActionButton(
                child: const Icon(Icons.stop),
                onPressed: () => FlutterBluePlus.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  backgroundColor: AppColor.primaryColor,
                  child: const Icon(Icons.search),
                  onPressed: () => FlutterBluePlus
                      .startScan(timeout: const Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }

  Widget _searchAgainWidget() {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Lottie.asset('assets/search.json'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              Text(
               "Device Not found",
                textAlign: TextAlign.center,
                style: MyTextTheme.mediumBCB,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        PrimaryButton(
          width: 200,
          color: AppColor.primaryColor,
          title: "Search again",
          onPressed: () {
            FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
          },
        ),
      ],
    );
  }
}

// class FindDevicesScreen extends StatefulWidget {
//   @override
//   const FindDevicesScreen({Key? key,  }) : super(key: key);
//
//   State<FindDevicesScreen> createState() => _FindDevicesScreenState();
// }
//
// class _FindDevicesScreenState extends State<FindDevicesScreen> {
//
//   String foundDeviceID = "F8:33:31:46:86:CA";
//   bool isScanning=false;
//   bool isDeviceFound=false;
//
//   List<int> _getRandomBytes() {
//     final math = Random();
//     return [
//       math.nextInt(255),
//       math.nextInt(255),
//       math.nextInt(255),
//       math.nextInt(255)
//     ];
//   }
//
//   _buildServiceTiles(List<BluetoothService> services) {
//     return services
//         .map(
//           (s) => ServiceTile(
//         service: s,
//         characteristicTiles: s.characteristics
//             .map(
//                 (c) {
//               dPring('nnnnnnnnnnnnnnnn${c.value}');
//               return CharacteristicTile(
//                 characteristic: c,
//                 onReadPressed: () => c.read(),
//                 onWritePressed: () async {
//                   await c.write(_getRandomBytes(), withoutResponse: true);
//                   await c.read();
//                 },
//                 onNotificationPressed: () async {
//                   await c.setNotifyValue(!c.isNotifying);
//                   await c.read();
//                 },
//                 descriptorTiles: c.descriptors
//                     .map(
//                       (d) => DescriptorTile(
//                     descriptor: d,
//                     onReadPressed: () => d.read(),
//                     onWritePressed: () => d.write(_getRandomBytes()),
//                   ),
//                 )
//                     .toList(),
//               );
//             }
//         )
//             .toList(),
//       ),
//     )
//         .toList();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return SafeArea(
//       child: Scaffold(
//
//         body: RefreshIndicator(
//           onRefresh: () => FlutterBluePlus
//               .startScan(timeout: const Duration(seconds: 4)),
//           child: GetBuilder(
//               init: ScanCtBpMachineController(),
//               builder: (_) {
//                 return StreamBuilder<bool>(
//                   stream: FlutterBluePlus.isScanning,
//                   initialData: false,
//                   builder: (c, deviceSnapshot) {
//                     isDeviceFound= false;
//                     if (deviceSnapshot.data!) {
//                       isScanning = true;
//                     } else {
//                       isScanning = false;
//                     }
//
//                     return Center(
//                       child: isScanning
//                           ? Lottie.asset('assets/scanning.json')
//                           : StreamBuilder<List<ScanResult>>(
//                         stream: FlutterBluePlus.scanResults,
//                         initialData: const [],
//                         builder: (c, snapshot) {
//                           for (int i = 0;  i < snapshot.data!.length; i++) {
//
//
//                             if (snapshot.data![i].device.id.toString() == foundDeviceID.toString()) {
//
//                               isDeviceFound = true;
//                               // isScanning = true;
//                             }
//                           }
//                           return isDeviceFound ==  false
//                               ? _searchAgainWidget()
//                               : Column(
//                             children: snapshot.data!
//                                 .map(
//                                     (r) =>  Visibility(
//                                   visible: r.device.id.toString() == foundDeviceID.toString(),
//                                   child: Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children:   [
//                                             MyButton2(title: 'Connect',width: 150,onPress: (){
//                                               r.device.connect();
//                                             },),
//                                             const MyButton2(title: 'Save',width: 150,),
//                                           ],
//                                         ),
//                                       ),
//                                       StreamBuilder<BluetoothDeviceState>(
//                                         stream: r.device.state,
//                                         initialData: BluetoothDeviceState.connecting,
//                                         builder: (c, snapshot) => ListTile(
//                                           leading: (snapshot.data == BluetoothDeviceState.connected)
//                                               ? const Icon(Icons.bluetooth_connected)
//                                               : const Icon(Icons.bluetooth_disabled),
//                                           title: Text(
//                                               'Device is ${snapshot.data.toString().split('.')[1]}.'),
//                                           subtitle: Text('${r.device.id}'),
//                                           trailing: StreamBuilder<bool>(
//                                             stream: r.device.isDiscoveringServices,
//                                             initialData: false,
//                                             builder: (c, snapshot) => IndexedStack(
//                                               index: snapshot.data! ? 1 : 0,
//                                               children: <Widget>[
//                                                 IconButton(
//                                                   icon: const Icon(Icons.refresh),
//                                                   onPressed: () => r.device.discoverServices(),
//                                                 ),
//                                                 const IconButton(
//                                                   icon: SizedBox(
//                                                     child: CircularProgressIndicator(
//                                                       valueColor: AlwaysStoppedAnimation(Colors.grey),
//                                                     ),
//                                                     width: 18.0,
//                                                     height: 18.0,
//                                                   ),
//                                                   onPressed: null,
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//
//                                       StreamBuilder<int>(
//                                         stream: r.device.mtu,
//                                         initialData: 0,
//                                         builder: (c, snapshot) => ListTile(
//                                           title: const Text('MTU Size'),
//                                           subtitle: Text('${snapshot.data} bytes'),
//                                           trailing: IconButton(
//                                             icon: const Icon(Icons.edit),
//                                             onPressed: () => r.device.requestMtu(223),
//                                           ),
//                                         ),
//                                       ),
//
//                                       StreamBuilder<List<BluetoothService>>(
//                                         stream: r.device.services,
//                                         initialData: [],
//                                         builder: (c, snapshot) {
//                                           for(int i=0;i<snapshot.data!.length;i++){
//                                             for(int j=0;j<snapshot.data!.length;j++){
//                                               dPring('nnnnnnnn'+snapshot.data![i].characteristics[j].uuid.toString());
//                                             }
//                                           }
//
//
//                                           return Column(
//                                             children: _buildServiceTiles(snapshot.data!),
//                                           );
//                                         },
//                                       ),
//                                       const SizedBox(height: 15,),
//                                       Stack(
//                                         children: [
//                                           Image.asset('assets/thermameter1.png',
//                                             height:MediaQuery.of(context).size.height/1.3,fit: BoxFit.fitHeight),
//
//                                           Positioned(
//                                             top: 180,
//                                             left: 180,
//                                             child: Column(
//                                               children: [
//                                                 Text('38.7',style: MyTextTheme().largeBCN.copyWith(fontSize: 35),)
//                                               ],
//                                             ),
//                                           )
//
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               // Text(r.device.name.toString()),
//
//                               //         Visibility(
//                               //   visible: r.device.id.toString() == foundDeviceID.toString(),
//                               //   child: ScanResultTile(
//                               //     result: r,
//                               //     onTap: () => App()
//                               //         .navigate(
//                               //         context, CTBpScreenView(
//                               //             device: r
//                               //                 .device)),
//                               //   ),
//                               // ),
//
//                             ).toList(),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 );
//               }),
//         ),
//         floatingActionButton: StreamBuilder<bool>(
//           stream: FlutterBluePlus.isScanning,
//           initialData: false,
//           builder: (c, snapshot) {
//             if (snapshot.data!) {
//               return FloatingActionButton(
//                 child: const Icon(Icons.stop),
//                 onPressed: () => FlutterBluePlus.stopScan(),
//                 backgroundColor: Colors.red,
//               );
//             } else {
//               return FloatingActionButton(
//                   backgroundColor: AppColor.orangeButtonColor,
//                   child: const Icon(Icons.search),
//                   onPressed: () => FlutterBluePlus
//                       .startScan(timeout: const Duration(seconds: 4)));
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _searchAgainWidget() {
//     ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Lottie.asset('assets/search.json'),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//           child: Column(
//             children: [
//               Text(
//                 localization.getLocaleData.deviceNotFound.toString(),
//                 textAlign: TextAlign.center,
//                 style: MyTextTheme().mediumBCB,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 30,
//         ),
//         MyButton2(
//           width: 200,
//           color: AppColor.orangeButtonColor,
//           title: localization.getLocaleData.searchAgain.toString(),
//           onPress: () {
//             FlutterBluePlus
//                 .startScan(timeout: const Duration(seconds: 4));
//           },
//         ),
//       ],
//     );
//   }
// }



class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap})
      : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            // style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              // style: Theme.of(context).textTheme.caption
          ),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              // style: Theme.of(context)
              //     .textTheme
              //     .caption
              //     ?.apply(color: Colors.black
              // ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

      Image.asset('assets/thermometer.webp',   height:MediaQuery.of(context).size.height/1.8,fit: BoxFit.fitHeight),
        PrimaryButton(title: 'CONNECT',width: 200
            ,onPressed: (){
              (result.advertisementData.connectable) ? onTap : null;
            })
      ],
    );
  }
}
