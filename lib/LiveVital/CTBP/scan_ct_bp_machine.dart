
import 'package:medvantage_patient/LiveVital/CTBP/scan_cr_bp_machine_modal.dart';
import 'package:medvantage_patient/LiveVital/CTBP/scan_ct_bp_machine_controller.dart';
import 'package:medvantage_patient/LiveVital/CTBP/scan_result_tile.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../Localization/app_localization.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../theme/theme.dart';
import 'ct_bp_screen.dart';

class ScanCTBpMachine extends StatefulWidget {
  const ScanCTBpMachine({Key? key}) : super(key: key);

  @override
  _ScanCTBpMachineState createState() => _ScanCTBpMachineState();
}

class _ScanCTBpMachineState extends State<ScanCTBpMachine> {

  ScanCtBpMachineModal modal =ScanCtBpMachineModal();


  @override
  void initState() {
    print('nnnnnnnnnnnnnnnnn');

    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {

    FlutterBlue.instance
        .startScan(timeout: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<ScanCtBpMachineController>();
  }


  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(title: 'Search Device',color:  themeChange.darkTheme
              ? AppColor.darkshadowColor1
              : AppColor.lightshadowColor1,),
          body: StreamBuilder<BluetoothState>(
              stream: FlutterBlue.instance.state,
              initialData: BluetoothState.unknown,
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
    );
  }

  Widget _searchAgainWidget() {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset('assets/search.json'),
          ),
          Text('No Device Found',
            style: MyTextTheme.mediumBCB,
          ),
          const SizedBox(
            height: 20,
          ),
          PrimaryButton(
            width: 200,
            color: AppColor.orange,
            title: 'search Again',
            onPressed: () {
              FlutterBlue.instance.startScan();
            },
          ),
        ],
      ),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text('Bluetooth Adapter Is' +
                  (state != null ? state.toString().substring(15) : 'not Available'
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({super.key});

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  String foundDevice = "CT033";

  ScanCtBpMachineModal modal = ScanCtBpMachineModal();

  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return SafeArea(
      child: Scaffold(

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
          child: RefreshIndicator(
            onRefresh: () => FlutterBlue.instance
                .startScan(timeout: const Duration(seconds: 4)),
            child: GetBuilder(
                init: ScanCtBpMachineController(),
                builder: (_) {
                  return StreamBuilder<bool>(
                    stream: FlutterBlue.instance.isScanning,
                    initialData: false,
                    builder: (c, deviceSnapshot) {
                      modal.controller.isDeviceFound.value = false;
                      if (deviceSnapshot.data!) {
                        modal.controller.isScanning.value = true;
                      } else {
                        modal.controller.isScanning.value = false;
                      }

                      return Center(
                        child: modal.controller.isScanning.value
                            ? Lottie.asset('assets/scanning.json')
                            : StreamBuilder<List<ScanResult>>(
                                stream: FlutterBlue.instance.scanResults,
                                initialData: const [],
                                builder: (c, snapshot) {
                                  for (int i = 0;
                                      i < snapshot.data!.length;
                                      i++) {
                                    if (snapshot.data![i].device.name ==
                                        foundDevice) {
                                      modal.controller.isDeviceFound.value = true;
                                    }
                                  }

                                  return modal.controller.isDeviceFound.value ==
                                          false
                                      ? _searchAgainWidget()
                                      : Column(
                                          children: snapshot.data!
                                              .map(
                                                (r) => Visibility(
                                                  visible: r.device.name ==
                                                      foundDevice,
                                                  child: ScanResultTile(
                                                    result: r,

                                                  ),
                                                ),
                                              )
                                              .toList(),
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
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data!) {
              return FloatingActionButton(
                onPressed: () => FlutterBlue.instance.stopScan(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop),
              );
            } else {
              return FloatingActionButton(
                  backgroundColor: AppColor.orange,
                  child: const Icon(Icons.search),
                  onPressed: () => FlutterBlue.instance
                      .startScan(timeout: const Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }

  Widget _searchAgainWidget() {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

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
              Text('device Not Found',
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
          color: AppColor.orange,
          title: 'Search Again',
          onPressed: () {
            FlutterBlue.instance
                .startScan(timeout: const Duration(seconds: 4));
          },
        ),
      ],
    );
  }
}
