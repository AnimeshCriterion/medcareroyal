

import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/custom_sd.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helix_timex/helix_timex.dart';


import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../Localization/app_localization.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../app_manager/widgets/tab_responsive.dart';
import '../../theme/theme.dart';
import 'helix_controller.dart';
import 'helix_modal.dart';



class HelixTimexPage extends StatefulWidget {
  const HelixTimexPage({Key? key}) : super(key: key);

  @override
  State<HelixTimexPage> createState() => _HelixTimexPageState();
}

class _HelixTimexPageState extends State<HelixTimexPage> {




  HelixModal modal=HelixModal();







  @override
  void initState() {

    super.initState();
    modal.controller.initPlatformState(context);


  }

  // Platform messages are asynchronous, so we initialize in an async method.



  @override
  void deactivate() {
    // TODO: implement deactivate
    modal.controller.disposeData();
    super.deactivate();

  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();


  }






  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: true);

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return  ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(color: themeChange.darkTheme
                ? AppColor.darkshadowColor1
                : AppColor.lightshadowColor1,
                title: localization.getLocaleData.bloodPressure.toString(),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow:  [
                            BoxShadow(
                              color: (modal.controller.conState.value==TimexConnectionState.connected)? Colors.green: Colors.red,
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
                        child: Icon(Icons.watch)
                      ),
                    ),
                  ),
                ]
            ),
          body: GetBuilder(
            init: HelixController(),
            builder: (_) {
              return Container( decoration: BoxDecoration(
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
                                  stream: modal.controller.timex.deviecFoundStream,
                                  builder: (context, deviceSnapshot) {

                                    if(deviceSnapshot.data!=null){
                                      modal.controller.macAddress.value=deviceSnapshot.data!.macAddress!;
                                      modal.controller.foundDevice.value=true;

                                    }
                                    else{
                                      modal.controller.macAddress.value='';
                                      modal.controller.foundDevice.value=false;

                                    }

                                    return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: (deviceSnapshot.data==null &&
                                             modal.controller.conState.value!=TimexConnectionState.connected)? (modal.controller.isScanning.value && !modal.controller.foundDevice.value)?
                                            Lottie.asset('assets/scanning.json')
                                            :
                                            _searchAgainWidget()
                                                :Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [

                                                  Expanded(
                                                    child: Text('Helix',
                                                      style: MyTextTheme.mediumBCB,),
                                                  ),
                                                  (modal.controller.conState.value==TimexConnectionState.connecting)?
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(20,0,20,0),
                                                    child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation( Colors.orange),
                                                    ),
                                                  ):
                                                      !(modal.controller.conState.value==TimexConnectionState.connected)?
                                                  PrimaryButton(
                                                      onPressed: () async{

                                                       modal.controller.timex.connect(
                                                           macAddress: deviceSnapshot.data!.macAddress??'',
                                                           deviceName: deviceSnapshot.data!.deviceName??'');

                                                      },
                                                      width: 100,
                                                      title: 'Connect'):PrimaryButton(
                                                      onPressed: (){
                                                        modal.controller.timex.disConnect();
                                                      },
                                                      width: 100,
                                                      title:'DisConnect'),


                                                ],
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: (modal.controller.foundDevice.value ||
                                                modal.controller.conState.value==TimexConnectionState.connected),
                                            child: Expanded(
                                              child:                   Visibility(
                                                visible: !(modal.controller.isScanning.value && !(modal.controller.foundDevice.value ||
                                                    modal.controller.conState.value==TimexConnectionState.connected)),
                                                child: Center(
                                                  child:
                                                  Padding(
                                                    padding:  const EdgeInsets.all(8),
                                                    child: timexMeter(context),
                                                  )
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
              );
            }
          ),
          floatingActionButton:  Visibility(
            visible: !(modal.controller.conState.value==TimexConnectionState.connected),
            child: InkWell(
              onTap: (){
                modal.controller.timex.startScanDevice();
              },
              child: Container(

                decoration: BoxDecoration(
                    color: AppColor.orange,
                    borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                child: modal.controller.isScanning.value?
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
              modal.controller.timex.startScanDevice();
            },
          ),
        ],
      ),
    );
  }


  Widget timexMeter(context){
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: false);

    var size=MediaQuery.of(context).size.height;
    return  Padding(
      padding:  EdgeInsets.all(size/20),
      child: Stack(
        children: [
          Container(

            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border.all(color: AppColor.black,
                    width: 3),
                boxShadow:  [
                  BoxShadow(
                    color: (modal.controller.conState.value==TimexConnectionState.connected)? Colors.blue: Colors.white,
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

                            // spo2==""?
                            // Expanded(
                            //   child: Center(
                            //     child: Text('Connect Device For Data',
                            //       textAlign: TextAlign.center,
                            //       style: MyTextTheme().mediumWCB,),
                            //   ),
                            // )
                            //     :
                            Expanded(
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

                                          modal.controller.readingData.value=='sp'? measuring()
                                              :Text(modal.controller.spo2.value.toString()+' %',
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

                                        Text('Heart Rate',
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
                                              modal.controller.readingData.value=='hr'?measuring()
                                                  :Text(modal.controller.heartRate.value.toString()+' bpm',
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
                                                Text('sys BP',
                                                  style: MyTextTheme.mediumWCB.copyWith(
                                                  ),),
                                                modal.controller.readingData.value=='bp'?Expanded(child: measuring())
                                                    :Text( modal.controller.sis.value.toString()+' MM',
                                                  style: MyTextTheme.mediumWCB.copyWith(
                                                      fontSize: 15
                                                  ),),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text('dia BP',
                                                  style: MyTextTheme.mediumWCB.copyWith(
                                                  ),),
                                                modal.controller.readingData.value=='bp'?Expanded(child: measuring())
                                                    :Text(modal.controller.dis.value.toString()+' HG',
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
                                color: (modal.controller.conState.value==TimexConnectionState.connected)? Colors.blue: Colors.black,
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
                  child: Column(
                    children: [
                      Text(localization.getLocaleData.criterionTech.toString(),
                        style: MyTextTheme.mediumWCB,),
                      const SizedBox(height: 5,),
                      Text('Helix Timex',
                        style: MyTextTheme.mediumWCB,),
                    ],
                  ),
                )
              ],
            ),
          ),

          Visibility(
            visible: modal.controller.conState.value==TimexConnectionState.connected,
            child:    Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: modal.controller.readingData.value!=''? measuring() :Visibility(
                      visible: modal.controller.selectedTimePeriod.value!='Repeat',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('Next',
                            style: MyTextTheme.mediumWCB,),
                          Text(DateFormat('hh:mm a').format(modal.controller.nextMeasure.value).toString(),
                          style: MyTextTheme.mediumWCB,),
                        ],
                      ),
                    ),
                  ),
                ),

                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [

                    SizedBox(
                      width: 100,
                      child: CustomSD(
                          // labelStyle: MyTextTheme().mediumWCN,
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(5),
                          //     color: Colors.black,
                          //     border: Border.all(color: Colors.black)
                          // ),

                          initialValue: [
                            {
                              'parameter': 'title',
                              'value': modal.controller.selectedTimePeriod.value,
                            }
                          ],
                          hideSearch: true,
                          height: 200,
                          label: 'Duration',
                          listToSearch: modal.controller.timePeriodList, valFrom: 'title', onChanged: (val){
                        if(val!=null){
                          modal.controller.updateSelectedTimePeriod(val['title']);
                        }
                      }),
                    ),
                  ],
                ),

              ],
            ),
          )
        ],
      ),
    );
  }


  Widget measuring(){
    return SizedBox(
      height: 50,
        child: Lottie.asset('assets/pulse_white.json'));
  }

}
