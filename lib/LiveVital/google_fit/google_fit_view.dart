
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:medvantage_patient/LiveVital/google_fit/vitals_moitoring_widget.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:health/health.dart';
import 'package:flutter/material.dart';
import '../../Localization/app_localization.dart';
import '../../View/widget/common_method/show_progress_dialog.dart';
import '../../app_manager/alert_dialogue.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/my_button.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../common_libs.dart';
import '../../devices_with_new_ui/device_connnect_controller.dart';
import '../../theme/theme.dart';
import '../live_vital_controller.dart';

class GoogleFitView extends StatefulWidget {
  const GoogleFitView({super.key});

  @override
  _GoogleFitViewState createState() => _GoogleFitViewState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}

class _GoogleFitViewState extends State<GoogleFitView> {

  DeviceConnectController controller=Get.put(DeviceConnectController());
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 10;
  double _mgdl = 10.0;

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  String hearRate = '';
  String bloodOxygen = '';
  String systolic = '';
  String dystolic = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.updateSelectedDeviceIndex = '';
    controller.updateSelectedDevice = Map.from({});
  }

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);

    // define the types to get
    final types = [
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC
      // Uncomment these lines on iOS - only available on iOS
      // HealthDataType.AUDIOGRAM
    ];

    // with coresponsing permissions
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ
      // HealthDataAccess.READ,
    ];

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 5));
    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested =
        await health.requestAuthorization(types, permissions: permissions);
    dPrint('requested: $requested');

    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data

        ProgressDialogue().show(context, loadingText: "Fetching Data");
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(yesterday, now, types);

        ProgressDialogue().hide();
        // save all the new data points (only the first 100)

        _healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));

        List<HealthDataPoint> heartRateList = _healthDataList
            .where((element) => element.type == HealthDataType.HEART_RATE)
            .toList();

        if (heartRateList.isNotEmpty) {
          setState(() {
            hearRate =
                heartRateList[Platform.isIOS ? 0 : (heartRateList.length - 1)]
                    .value
                    .toString();
          });
        }

        List<HealthDataPoint> bloodOxygenList = _healthDataList
            .where((element) => element.type == HealthDataType.BLOOD_OXYGEN)
            .toList();

        if (bloodOxygenList.isNotEmpty) {
          setState(() {
            bloodOxygen = (double.parse(bloodOxygenList[
                            Platform.isIOS ? 0 : (bloodOxygenList.length - 1)]
                        .value
                        .toString()) *
                (Platform.isIOS? 100: 1))
                .toString();
          });
        }

        List<HealthDataPoint> systolicList = _healthDataList
            .where((element) =>
                element.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC)
            .toList();

        if (systolicList.isNotEmpty) {
          setState(() {
            systolic =
                systolicList[Platform.isIOS ? 0 : systolicList.length - 1]
                    .value
                    .toString();
          });
        }

        List<HealthDataPoint> dystolicList = _healthDataList
            .where((element) =>
                element.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC)
            .toList();

        if (dystolicList.isNotEmpty) {
          setState(() {
            dystolic =
                dystolicList[Platform.isIOS ? 0 : dystolicList.length - 1]
                    .value
                    .toString();
          });
        }
        setState(() {});
      } catch (error) {
        dPrint("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // dPring the results
      _healthDataList.forEach((x) => dPrint(x));

      // update the UI to display the results
      setState(() {
        _state =
            _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      dPrint("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  /// Add some random health data.
  Future addData() async {
    final now = DateTime.now();
    final earlier = now.subtract(const Duration(minutes: 20));

    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.WORKOUT, // Requires Google Fit on Android
      // Uncomment these lines on iOS - only available on iOS
      // HealthDataType.AUDIOGRAM,
    ];
    final rights = [
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      // HealthDataAccess.WRITE
    ];

    final permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      // HealthDataAccess.READ_WRITE,
    ];
    late bool perm;
    bool? hasPermissions =
        await HealthFactory().hasPermissions(types, permissions: rights);
    if (hasPermissions == false) {
      perm = await health.requestAuthorization(types, permissions: permissions);
    }

    // Store a count of steps taken
    _nofSteps = Random().nextInt(10);
    bool success = await health.writeHealthData(
        _nofSteps.toDouble(), HealthDataType.STEPS, earlier, now);

    // Store a height
    success &=
        await health.writeHealthData(1.93, HealthDataType.HEIGHT, earlier, now);

    // Store a Blood Glucose measurement
    _mgdl = Random().nextInt(10) * 1.0;
    success &= await health.writeHealthData(
        _mgdl, HealthDataType.BLOOD_GLUCOSE, now, now);

    // Store a workout eg. running
    success &= await health.writeWorkoutData(
      HealthWorkoutActivityType.RUNNING, earlier, now,
      // The following are optional parameters
      // and the UNITS are functional on iOS ONLY!
      totalEnergyBurned: 230,
      totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
      totalDistance: 1234,
      totalDistanceUnit: HealthDataUnit.FOOT,
    );

    // Store an Audiogram
    // Uncomment these on iOS - only available on iOS
    // const frequencies = [125.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0];
    // const leftEarSensitivities = [49.0, 54.0, 89.0, 52.0, 77.0, 35.0];
    // const rightEarSensitivities = [76.0, 66.0, 90.0, 22.0, 85.0, 44.5];

    // success &= await health.writeAudiogram(
    //   frequencies,
    //   leftEarSensitivities,
    //   rightEarSensitivities,
    //   now,
    //   now,
    //   metadata: {
    //     "HKExternalUUID": "uniqueID",
    //     "HKDeviceName": "bluetooth headphone",
    //   },
    // );

    setState(() {
      _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
    });
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        dPrint("Caught exception in getTotalStepsInInterval: $error");
      }

      dPrint('Total number of steps: $steps');

      setState(() {
        _nofSteps = (steps == null) ? 0 : steps;
        _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      });
    } else {
      dPrint("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(
              strokeWidth: 10,
            )),
        const Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('hearRate :'.toString(),
                  textAlign: TextAlign.start,
                  style: MyTextTheme
                      .veryLargeBCB
                      .copyWith(color: AppColor.primaryColor)),
              Text(hearRate.toString(),
                  textAlign: TextAlign.start, style: MyTextTheme.veryLargeBCB)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('bloodOxygen :',
                  textAlign: TextAlign.start,
                  style: MyTextTheme
                      .veryLargeBCB
                      .copyWith(color: AppColor.primaryColor)),
              Text(bloodOxygen.toString(),
                  textAlign: TextAlign.start, style: MyTextTheme.veryLargeBCB)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('systolic :'.toString(),
                  textAlign: TextAlign.start,
                  style: MyTextTheme
                      .veryLargeBCB
                      .copyWith(color: AppColor.primaryColor)),
              Text(systolic.toString(),
                  textAlign: TextAlign.start, style: MyTextTheme.veryLargeBCB)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('diastolic :'.toString(),
                  textAlign: TextAlign.start,
                  style: MyTextTheme
                      .veryLargeBCB
                      .copyWith(color: AppColor.primaryColor)),
              Text(dystolic.toString(),
                  textAlign: TextAlign.start, style: MyTextTheme.veryLargeBCB)
            ],
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Widget _contentNoData() {
    return const Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
    );
  }

  Widget _authorizationNotGranted() {
    return const Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget _dataAdded() {
    return const Text('Data points inserted successfully!');
  }

  Widget _stepsFetched() {
    return Text('Total number of steps: $_nofSteps');
  }

  Widget _dataNotAdded() {
    return const Text('Failed to add data');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY) return _contentDataReady();
    // else if (_state == AppState.NO_DATA)
    //   return _contentNoData();
    // else if (_state == AppState.FETCHING_DATA)
    //   return _contentFetchingData();
    // else if (_state == AppState.AUTH_NOT_GRANTED)
    //   return _authorizationNotGranted();
    // else if (_state == AppState.DATA_ADDED)
    //   return _dataAdded();
    // else if (_state == AppState.STEPS_READY)
    //   return _stepsFetched();
    // else if (_state == AppState.DATA_NOT_ADDED) return _dataNotAdded();

    return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localizations =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Container(
      color: AppColor.green,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(backgroundColor: themeChange.darkTheme
              ? AppColor.darkshadowColor1
              : AppColor.lightshadowColor1,
            foregroundColor:  themeChange.darkTheme
              ?
                    AppColor.lightshadowColor1: AppColor.darkshadowColor1,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Platform.isAndroid ? localizations.getLocaleData.googleFit.toString() : localizations.getLocaleData.appleHealth.toString()),
                MyButton(
                  height: 35,
                  width: 100,
                  color: Colors.green,
                  title: localizations.getLocaleData.fetchData.toString(),
                  onPress: () {
                  MyNavigator.pushReplacement(context, GoogleFitView());
                  },
                ),
              ],
            ),
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
              children: [
                Expanded(child: SingleChildScrollView(child: _widgetAccordingToState(_state))),
                _state == AppState.DATA_READY
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: MyButton(
                          title: localizations.getLocaleData.saveData.toString(),
                          onPress: () async {
                            LiveVitalModal vitalModal=LiveVitalModal();
                            AlertDialogue().show(context,
                                msg: localizations.getLocaleData.areYouSureYouWantToddVitale.toString(),
                                firstButtonName: localizations.getLocaleData.save.toString(),
                                showOkButton: false, firstButtonPressEvent: () async{
                                   Get.back();
                                  vitalModal.addVitalsData(context,BPSys: systolic.toString(),BPDias: dystolic.toString(),
                                      hr: hearRate.toString(),spo2: bloodOxygen.toString());

                                }, showCancelButton: true);

                            // await GoogleFitModal().addVitalData(
                            //     context,
                            //     systolic.toString(),
                            //     dystolic.toString(),
                            //     hearRate.toString(),
                            //     bloodOxygen.toString());
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetAccordingToState(AppState state) {
    VitalData heart = VitalData.hearRate(val: hearRate.toString());
    VitalData bloodoxy = VitalData.spo2(val: bloodOxygen);
    VitalData bp = VitalData.bloodPressure(val: systolic, val2: dystolic);

    switch (state) {
      case AppState.DATA_NOT_FETCHED:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/startup2.svg', height: 200),
            const SizedBox(
              height: 10,
            ),
            Text("Please Fetch Data", style: MyTextTheme.largeBCB),
          ],
        );
      case AppState.FETCHING_DATA:
        return const CircularProgressIndicator();
      case AppState.DATA_READY:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            Align(
                alignment: Alignment.topLeft,
                child:
                    Text("Vitals Monitoring", style: MyTextTheme.largeBCB)),
            const SizedBox(
              height: 15,
            ),
            VitalsMonitoring(vitalData: heart),
            VitalsMonitoring(
              vitalData: bloodoxy,
            ),
            VitalsMonitoring(
              vitalData: bp,
            ),
          ]),
        );

      default:
        return Container();
    }
  }
}
//
// class VitalData {
//   String? hearRate;
//   String? sys;
//   String? dys;
//   String? spo2;
//
//   VitalData.hearRate({required this.hearRate});
//   VitalData.bloodPressure({
//     required this.sys,
//     required this.dys,
//   });
//
//   VitalData.spo2({required this.spo2});
// }



