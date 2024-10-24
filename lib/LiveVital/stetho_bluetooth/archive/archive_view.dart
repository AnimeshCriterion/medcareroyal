

import 'dart:convert';
import 'dart:io';

import 'package:audio_input_type_plugin/audio_input_type_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app_manager/app_color.dart';
import '../../../app_manager/theme/text_theme.dart';
import '../../../common_libs.dart';
import '../../../theme/theme.dart';
import '../audio_player_stetho.dart';
import '../stetho_bluetooth_controller.dart';
import 'archive_controller.dart';

class ArchiveView extends StatefulWidget {
  const ArchiveView({super.key});

  @override
  State<ArchiveView> createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<ArchiveView> {

  ArchiveController controller=Get.put(ArchiveController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  StethoBluetoothController stethoscopeController=Get.put(StethoBluetoothController());
  get() async {
    controller.pidC.text=stethoscopeController.stethoPidC.value.text.toString();
    controller.update();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getAudioList(context,);
    });


    final prefs = await SharedPreferences.getInstance();
     var data= jsonDecode(prefs.getString('stetho'  )??"[]");

    print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnvnnvnnvnnnn '+data.toString());
    for(var i=0; i<data.length; i++){
      if(await File(data[i]['filePath']).exists() ) {
        if(data[i]['isSaved']==false ) {
       var savedData=   await stethoscopeController.insertPatientMediaData(context,filePath:data[i]['filePath'].toString() );
       if(savedData){
            data[i]['isSaved'] = true;
          }
        }
      }
    }
    await prefs.setString('stetho', jsonEncode(data));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<ArchiveController>();
  }

  void shareLinkWithDescription(String link, String description) {
    String message = '$description\n$link';
    Share.share(message,subject: 'Stethoscope audio');
  }


  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return Container(
      color:  AppColor.white,
      child: SafeArea(
        child: GetBuilder(
          init: ArchiveController(),
          builder: (_) {
            return Scaffold(
              appBar: AppBar(title: Text('Histoy'),
                backgroundColor: AppColor.white,
                foregroundColor: AppColor.black12,),
              body:  Container( decoration: BoxDecoration(
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
                    themeChange.darkTheme ? AppColor.black : AppColor.lightshadowColor2,
                  ],
                ),
              ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      //
                      // PrimaryTextField(
                      //   // keyboardType: TextInputType.number,
                      //   hintTextColor:  themeChange.darkTheme==true?Colors.white60: Colors.grey,
                      //   backgroundColor:themeChange.darkTheme==true?Colors.grey.shade800: Colors.white,
                      //   style: TextStyle(color:  themeChange.darkTheme==true?Colors.white: Colors.grey,),
                      //   controller: controller.pidC,
                      //   onChanged: (val) async {
                      //
                      //     if(val.length>6){
                      //       await controller.getAudioList(context,);
                      //     }
                      //     controller.update();
                      //
                      //   },
                      //   hintText:'Enter Uhid',
                      //   // borderColor: Colors.transparent,
                      //   borderRadius: 10,
                      // ),
                      // MyTextField2(hintText: 'Enter PID', label: Text('Enter PID',style: MyTextTheme.largePCN,) ,
                      //   borderColor: Colors.grey,
                      //   controller: controller.pidC,
                      //     keyboardType: TextInputType.number,
                      //     onChanged: (val) async {
                      //
                      //      if(val.length>6){
                      //        await controller.getAudioList(context,);
                      //      }
                      //     controller.update();
                      //
                      //     },),
                      SizedBox(height: 15,),

                      IntrinsicHeight(
                        child: Container(

                          decoration: BoxDecoration( color: AppColor.green,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text('File Name',style: MyTextTheme.mediumWCB,),
                                ),
                              ),
                              SizedBox(width: 15,),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text('Time',style: MyTextTheme.mediumWCB,),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.getStethoAudio.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0,10,0,8.0),
                              child: InkWell(
                                onTap: () async {



                                  String? microphone = await AudioInputTypePlugin.getConnectedMicrophone();
                                  // AudioPlayer myAudioPlayer=AudioPlayer();
                                  // late Source audioUrl;
                                  // audioUrl=UrlSource( controller.getStethoAudio[index]['url'].toString());
                                  //
                                  // myAudioPlayer.play(audioUrl);
                                  // controller.updateIsPlaying=true;
                                  // myAudioPlayer.onPlayerStateChanged.listen((event) {
                                  //
                                  //   print("Connected Microphone: $event");
                                  //   if(PlayerState.completed==event) {
                                  //     controller.updateIsPlaying = false;
                                  //     myAudioPlayer.stop();
                                  //   }
                                  // });

                                  // print("Connected Microphone: $microphone");
                                  // Get.to( VideoPlayer(url: controller.getStethoAudio[index]['url'].toString()));
                                  Get.to( AudioPlayerScreen(audioUrl: controller.getStethoAudio[index]['url'].toString()));
                                },
                                child: Card(elevation: 3,
                                  color: themeChange.darkTheme
                                      ? AppColor.darkshadowColor1
                                      : AppColor.lightshadowColor1,

                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.play_arrow,color: Colors.blue,),
                                                    const SizedBox(width:2,),
                                                    Expanded(child: Text(
                                                        (controller.getStethoAudio[index]['fileName']??'').toString(),style:
                                                    themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumBCN,),),
                                                    ],
                                                ),
                                              ),
                                              Text(DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(controller.getStethoAudio[index]['dateTime']??'') ),style:
                                              themeChange.darkTheme? MyTextTheme.mediumWCN: MyTextTheme.mediumBCN,)
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton<int>(color:   themeChange.darkTheme? Colors.white:Colors.grey,
                                          itemBuilder: (context) => [
                                            // popupmenu item 1
                                             PopupMenuItem(
                                              value: 1,
                                              // row has two child icon and text.
                                              child: ListTile(
                                                leading: Icon(Icons.share_outlined, ),
                                                title: Text('Share'),
                                              ),
                                            ),
                                          ],
                                          offset: const Offset(0, 50),
                                          elevation: 2,
                                          onSelected: (val){
                                            shareLinkWithDescription(controller.getStethoAudio[index]['url'].toString(), 'Hi there!! \n listen stethoscope audio by tapping on the link');
                                            print(val);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
