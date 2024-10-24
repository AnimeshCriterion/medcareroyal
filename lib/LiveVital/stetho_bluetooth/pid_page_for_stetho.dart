
import 'package:app_settings/app_settings.dart';
import 'package:audio_input_type_plugin/audio_input_type_plugin.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/LiveVital/stetho_bluetooth/stetho_bluetooth_controller.dart';
import 'package:medvantage_patient/LiveVital/stetho_bluetooth/stetho_bluetooth_view.dart';
import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';

import '../../Localization/app_localization.dart';
import '../../View/widget/common_method/show_progress_dialog.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/my_button.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/tab_responsive.dart';
import '../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../common_libs.dart';
import '../../theme/theme.dart';
import 'app_api.dart';
import 'listen_stetho_stream/listen_stetho_stream_view.dart';

class PidPageForStethoView extends StatefulWidget {
  const PidPageForStethoView({Key? key}) : super(key: key);

  @override
  _PidPageForStethoViewState createState() => _PidPageForStethoViewState();
}

class _PidPageForStethoViewState extends State<PidPageForStethoView> {
  TextEditingController stethoPidC = TextEditingController();
  TextEditingController listenC = TextEditingController();

  @override
  void initState() {
    var stethoController;
    // TODO: implement initState
    super.initState();
  }

  PatientData(context, pid, {bool isListenPage = false}) async {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    var body = {'id': pid.toString()};
    var data = await App().api(
        'PatientRegistration/GetPatientRegistrationDetails', body, context,
        token: true);
    ProgressDialogue().hide();
    print('nnnvnnv ' + data.toString());

    if ((data['patientRegistration'] ?? []).isNotEmpty) {
      if (isListenPage) {
        Get.back();
        // Get.to(
        // ListenStethoStreamView(
        //
        // ));
      } else {
        Get.to(StethoBluetoothView(
            // patientDetail: data['patientRegistration'][0],
            ));
      }
    }
    if (data['status'] == 0) {
      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: data['message'].toString()));
      // alertToast(context, data['message'].toString());
    }
  }
  @override
  Widget build(BuildContext context) {

    ApplicationLocalizations localizations =
    Provider.of<ApplicationLocalizations>(context, listen: true);
       final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Container(
      color: AppColor.white,
      child: SafeArea(
        child: GetBuilder(
            init: StethoBluetoothController(),
            builder: (_) {
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: AppColor.white,
                    foregroundColor: AppColor.black12,
                    title: const Text(
                      'Connect / Listen',
                    ),
                    // bottom: const TabBar(labelColor: Colors.white,
                    //   unselectedLabelColor: Colors.grey,
                    //   tabs: [
                    //     Tab(icon: Text("Connect")),
                    //     Tab(icon: Text('Listen')),
                    //   ],
                    // ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            // await AndroidAudioManager().startBluetoothSco();
                            // await AndroidAudioManager().setBluetoothScoOn(true);

                            AppSettings.openAppSettings(
                              type: AppSettingsType.bluetooth,
                            );
                            // String? microphone = await AudioInputTypePlugin.getConnectedMicrophone();
                            // print("Connected Microphone: $microphone");
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColor.greyLight,
                            fixedSize: Size(90, 40),
                          ),
                          child: Text(
                            localizations.getLocaleData.pair.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                    // actions: [
                    //   const SizedBox(width: 10,),
                    //   SizedBox(
                    //       width: 181,child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: MyButton(color: Colors.orange,title: 'Listen Live Data',
                    //       onPress: (){
                    //         listenC.clear();
                    //         setState(() {
                    //
                    //         });
                    //         pidWidget();
                    //         // App().navigate(context, ListenStethoStreamView());
                    //       },),
                    //   )),
                    //
                    //
                    //   // PopupMenuButton<int>(color: Colors.white, iconSize: 35,
                    //   //   onSelected: (val) async {
                    //   //     if(val==0){
                    //   //       App().navigate(context, ArchiveView());
                    //   //     }
                    //   //   },
                    //   //   itemBuilder: (context) {
                    //   //     return <PopupMenuEntry<int>>[
                    //   //       PopupMenuItem(child: Text('Archive'), value: 0),
                    //   //     ];
                    //   //   },
                    //   // ),
                    // ],
                  ),
                  body: Container(
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
                          themeChange.darkTheme
                              ? AppColor.black
                              : AppColor.lightshadowColor2,
                        ],
                      ),
                    ),
                    child: TabResponsive(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TabBarView(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // InkWell(
                                //   onTap: () async {
                                //     String barcodeScanRes =
                                //         await MyBarCodeScanner().scan();
                                //     if (barcodeScanRes.toString() == '-1') {
                                //       alertToast(context,
                                //           'Bar Code Or QR Code Not Found Try Again...');
                                //     } else {
                                //       await PatientData(
                                //           context, barcodeScanRes.toString());
                                //     }
                                //   },
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //         color: AppColor().orangeButtonColor,
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(5)),
                                //         border: Border.all(
                                //             color: AppColor().greyLight)),
                                //     child: Padding(
                                //       padding: const EdgeInsets.fromLTRB(
                                //           20, 0, 20, 20),
                                //       child: Column(
                                //         mainAxisSize: MainAxisSize.min,
                                //         children: [
                                //           SizedBox(
                                //             height: 100,
                                //             child: Lottie.asset(
                                //                 'assets/qr_scan.json'),
                                //           ),
                                //           Text(
                                //             'Scan PID',
                                //             style: MyTextTheme().mediumWCB,
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                // Padding(
                                //   padding: const EdgeInsets.all(20.0),
                                //   child: Row(
                                //     children: [
                                //       Expanded(
                                //         child: Container(
                                //           height: 1,
                                //           color: AppColor.greyLight,
                                //         ),
                                //       ),
                                //       Padding(
                                //         padding: const EdgeInsets.fromLTRB(
                                //             10, 0, 10, 0),
                                //         child: Text(
                                //           'OR',
                                //           style: MyTextTheme.mediumGCB,
                                //         ),
                                //       ),
                                //       Expanded(
                                //         child: Container(
                                //           height: 1,
                                //           color: AppColor.greyLight,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),

                                Column(
                                  children: [
                                    // PrimaryTextField(
                                    //   keyboardType: TextInputType.number,
                                    //   hintTextColor:  themeChange.darkTheme==true?Colors.white60: Colors.grey,
                                    //   backgroundColor:themeChange.darkTheme==true?Colors.grey.shade800: Colors.white,
                                    //
                                    //   controller: stethoPidC,
                                    //   hintText:'Enter PID',
                                    //   // borderColor: Colors.transparent,
                                    //   borderRadius: 10,
                                    // ),
                                    // MyTextField(
                                    //   controller: stethoPidC,
                                    //   keyboardType: TextInputType.number,
                                    //   hintText: 'Enter PID',
                                    //   onChanged: (val) {
                                    //     setState(() {});
                                    //   },
                                    // // ),
                                    // MyButton(
                                    //   width: 150,
                                    //   color: Colors.orange,
                                    //   title: 'Listen Live Data',
                                    //   onPress: () {
                                    //     listenC.clear();
                                    //     setState(() {});
                                    //     pidWidget();
                                    //     // App().navigate(context, ListenStethoStreamView());
                                    //   },
                                    // ),
                                    // SizedBox(
                                    //   height: 35,
                                    // ),
                                    //
                                    // Text('OR',style: themeChange.darkTheme? MyTextTheme.mediumWCB:MyTextTheme.mediumBCB,),
                                    //
                                    // SizedBox(
                                    //   height: 35,
                                    // ),
                                    // MyButton(title: 'Connected',onPress: () async {
                                    //
                                    //   String? microphone = await AudioInputTypePlugin.getConnectedMicrophone();
                                    //   print("Connected Microphone: $microphone");
                                    // },),
                                    MyButton(
                                      title: localizations.getLocaleData.connectStetho.toString(),
                                      width: 150,
                                      color: Colors.green,
                                      onPress: () async {

                                        await Permission.microphone.request();
                                        try{
                                          await AndroidAudioManager()
                                              .setBluetoothScoOn(true);
                                        }
                                        catch(e){

                                        }
                                        String? microphone = await AudioInputTypePlugin.getConnectedMicrophone();
                                          print("Connected Microphone: $microphone");

                                          if((microphone??'')=='Bluetooth Microphone'){
                                          MyNavigator.push(
                                              context, StethoBluetoothView());
                                        }
                                          else{
                                            Alert.show( 'Please pair your stethoscope.');
                                          }


                                        // if (stethoPidC.text.toString() != '' &&
                                        //     stethoPidC.text.toString().length >=
                                        //         6) {
                                        //   await PatientData(
                                        //     context,
                                        //     stethoPidC.text.toString(),
                                        //   );
                                        // } else if (stethoPidC.text.toString() ==
                                        //     '') {
                                        //   alertToast(context, 'Please enter pid');
                                        // } else {
                                        //   alertToast(
                                        //       context, 'Please enter valid pid');
                                        // }
                                      },
                                    ),

                                    SizedBox(
                                      height: 35,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(localizations.getLocaleData.note.toString(),style: MyTextTheme.mediumBCB,),
                                        Expanded(child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row( crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('1.',style: MyTextTheme.mediumBCB,),
                                                Expanded(child: Text(localizations.getLocaleData.pairYourStethoscope.toString())),
                                              ],
                                            ),
                                          SizedBox(height: 10,),
                                            Row(  crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('2. ',style: MyTextTheme.mediumBCB,),
                                                Expanded(child: Text(localizations.getLocaleData.selectMeasuringPoint.toString())),

                                              ],
                                            ),
                                          SizedBox(height: 10,),
                                          Row(  crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('3. ',style: MyTextTheme.mediumBCB,),
                                              Expanded(child: Text(localizations.getLocaleData.listenRecordedAudio.toString())),

                                            ],
                                          ),],)

                                        )
                                    ])
                                  ],
                                ),

                                // Padding(
                                //   padding: const EdgeInsets.fromLTRB(10,0,10,0,),
                                //   child: TextButton(
                                //     style: TextButton.styleFrom(
                                //         primary: Colors.black,
                                //         padding: const EdgeInsets.all(0),
                                //         minimumSize: const Size(0,0),
                                //         tapTargetSize: MaterialTapTargetSize.shrinkWrap
                                //     ),
                                //     onPressed: () async {
                                //       // controller.stethoPidC.value.text.toString();
                                //                     if ( stethoPidC
                                //                                 .text
                                //                                 .toString() !=
                                //                             '' &&
                                //                         stethoPidC.text
                                //                                 .toString()
                                //                                 .length >=
                                //                             6) {
                                //                       await PatientData(
                                //                           context,
                                //                           stethoPidC.text
                                //                               .toString(),);
                                //                     } else if (stethoPidC.text
                                //                             .toString() ==
                                //                         '') {
                                //                       alertToast(context,
                                //                           'Please enter pid');
                                //                     } else {
                                //                       alertToast(context,
                                //                           'Please enter valid pid');
                                //                     }
                                //
                                //                 },
                                //     child: CircleAvatar(
                                //       backgroundColor: AppColor().primaryColor,
                                //       child: Text('GO',
                                //         style: MyTextTheme().mediumWCB,),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            Container(
                              height: 50,
                              padding: const EdgeInsets.all(8),
                              width: Get.width,
                              alignment: Alignment.center,
                              child: MyButton(
                                color: Colors.orange,
                                title: 'Listen Live Data',
                                onPress: () {
                                  listenC.clear();
                                  setState(() {});
                                  pidWidget();
                                  // App().navigate(context, ListenStethoStreamView());
                                },
                              ),
                            ),
                            // MyButton(title: 'n',onPress: (){
                            //   print('${DateFormat('dd-MM-yyyy-HH-mm-ss').format(DateTime.now()).toString()}');
                            // },)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  pidWidget() {
    ApplicationLocalizations localizations =
    Provider.of<ApplicationLocalizations>(context, listen: false);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: false);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
              title: const Text("Uhid"),
              content: SizedBox(
                width: 150,
                child: PrimaryTextField(
                  // keyboardType: TextInputType.number,
                  hintTextColor: themeChange.darkTheme == true
                      ? Colors.white60
                      : Colors.grey,
                  backgroundColor: themeChange.darkTheme == true
                      ? Colors.grey.shade800
                      : Colors.white,

                  controller: listenC,
                  onChanged: (val) async {
                    setState(() {});
                  },
                  hintText: 'Enter Uhid',
                  // borderColor: Colors.transparent,
                  borderRadius: 10,
                ),
                // MyTextField2(
                //   hintText: 'Enter PID',
                //   keyboardType: TextInputType.number,
                //   controller: listenC,
                //   onChanged: (val) {
                //     setState(() {});
                //   },
                // )
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    child:  Text(
                      localizations.getLocaleData.cancel.toString(),
                      style: TextStyle(color: Colors.red, fontSize: 17),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // BluetoothState().requestDisableBluetooth();
                    if (listenC.text.toString() != '') {
                      Get.back();
                      Get.to(ListenStethoStreamView(
                        uhid: listenC.text.toString(),
                      ));
                    } else {
                      Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Please enter pid'.toString()));
                      // alertToast(context, 'Please enter pid');
                    }
                  },
                  child: Container(
                    child: Text(
                      "Listen",
                      style:
                          TextStyle(color: AppColor.primaryColor, fontSize: 17),
                    ),
                  ),
                ),
              ],
            ));
  }
}
