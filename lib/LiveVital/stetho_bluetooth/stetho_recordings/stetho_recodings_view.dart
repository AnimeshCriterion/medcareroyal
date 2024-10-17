


import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/alert_dialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_manager/alert_toast.dart';
import '../stetho_bluetooth_controller.dart';

class StethoRecordingView extends StatefulWidget {

  const StethoRecordingView({super.key,  });

  @override
  State<StethoRecordingView> createState() => _StethoRecordingViewState();
}

class _StethoRecordingViewState extends State<StethoRecordingView> {
  StethoBluetoothController controller=Get.put(StethoBluetoothController());

  get() async {
    controller.playFile='';
    await controller.getAudioFiles();
  }

  @override
  void initState() {
    storageFile();
    get();
    super.initState();
  }

  Back() async {
    controller.audioPlayer.stop();
     Get.back();
    // Get.offAll(Recorder());
  }

  deleteFile(File file) async {
    try {
         await file.delete();
         await file.delete();
         storageFile();
         get();
         Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: 'File deleted successfully'.toString()));
        // alertToast(context,'File deleted successfully');
    } catch (e) {
      print('Error deleting file : ' + e.toString());
    }
  }




  storageFile() async {
    List temp = await controller.getAudioFiles();
    List isExitingsFiles = [];
    for(var i=0; i<temp.length; i++){
      if(await File(temp[i]['file']).exists()) {
        isExitingsFiles.add(temp[i]);
        print('==============='+temp.length.toString());
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('audioFiles',jsonEncode(isExitingsFiles));

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      appBar: AppBar(title: Text('Recordings')),
      body: WillPopScope(
        onWillPop: () {
          Back();
          return  Future.value(false);
        },
        child: GetBuilder(
          init: StethoBluetoothController(),
          builder: (_) {
            return Column(
              children: [

                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.black, height: 1);
                    },
                    itemCount: controller.getAudioFileList.length,
                    itemBuilder: (context, index) {
                      var file = controller.getAudioFileList[index];
                      return ListTile(
                        title: Container(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              controller.playFile == file['file'].toString().split('/').last.split('.wav')[0].toString()
                                  ? Icon(Icons.pause, size: 38)
                                  : Icon(Icons.play_arrow, size: 38),

                              Expanded(child: Text(file['file'].toString().split('/').last.split('.wav')[0].toString())),

                              SizedBox(width: 15),

                              ElevatedButton(
                                onPressed: () async {
                                  await deleteFile(File(file['file'].toString()));
                                  await deleteFile(File(file['file'].toString()));
                                   Get.back();
                                  Get.to(StethoRecordingView());
                                },
                                child: Icon(Icons.delete),
                              ),

                              SizedBox(width: 10,),

                              ElevatedButton(
                                onPressed: () {
                                  // Share.share(file['file'].toString());
                                },
                                child: Icon(Icons.share),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          controller.play(file['file'].toString());
                        },
                      );
                    },
                  ),
                ),

              ],
            );
          }
        ),
      ),
    ));
  }
}
