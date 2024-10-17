// import 'dart:async';
// import 'dart:convert';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audioplayers.dart' as ap;
// import 'package:get/get.dart';
// import 'package:record/record.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class StethoController extends GetxController {
//
//   bool isRecording = false;
//
//   late final AudioRecorder audioRecorder;
//
//   final audioPlayer = ap.AudioPlayer()..setReleaseMode(ReleaseMode.stop);
//
//   String audioPath = '';
//   set updateAudioPath(String val){
//     audioPath=val;
//     update();
//   }
//
//   bool isPlayer = false;
//
//   String playFile  = '';
//
//   Future<void> play(filePath) async {
//
//     playFile = filePath.toString().split('/').last.split('.wav')[0].toString();
//
//     if(isPlayer) {
//       audioPlayer.stop();
//       isPlayer = false;
//       playFile = '';
//     } else {
//       audioPlayer.play(ap.DeviceFileSource(filePath));
//       isPlayer = true;
//     }
//     update();
//
//   }
//
//   Future<void> pause() async {
//     await audioPlayer.pause();
//   }
//
//   List audioFileList = [];
//   List get getAudioFileList=>audioFileList;
//   set updateAudioFileList(List val){
//     audioFileList=val;
//     update();
//   }
//
//   storeDataLocally({filePath}) async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     List tempList=[];
//
//     tempList.add(
//         {'file':filePath.toString()}
//     );
//
//    List getLocalData = await getAudioFiles();
//
//     tempList.addAll(getLocalData);
//
//     prefs.setString('audioFiles',jsonEncode(tempList));
//
//   }
//
//   Future<List> getAudioFiles() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var localData=  prefs.getString('audioFiles');
//     updateAudioFileList=jsonDecode(localData?? "[]");
//     return getAudioFileList;
//   }
//
// }
