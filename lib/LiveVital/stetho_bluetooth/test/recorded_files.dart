// import 'dart:convert';
// import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:demo_app/unknown/stetho_controller.dart';
// import 'package:demo_app/unknown/two.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_extend/share_extend.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AllRecordedFiles extends StatefulWidget {
//   const AllRecordedFiles({super.key});
//
//   @override
//   State<AllRecordedFiles> createState() => _AllRecordedFilesState();
// }
//
// class _AllRecordedFilesState extends State<AllRecordedFiles> {
//
//   StethoController stethoController = Get.put(StethoController());
//
//   get() async {
//     await stethoController.getAudioFiles();
//   }
//
//   @override
//   void initState() {
//     storageFile();
//     get();
//     super.initState();
//   }
//
//   Back() async {
//     Get.offAll(Recorder());
//   }
//
//   deleteFile(File file) async {
//     try {
//          await file.delete();
//          storageFile();
//          get();
//         dPring('File deleted successfully');
//     } catch (e) {
//       dPring('Error deleting file : ' + e.toString());
//     }
//   }
//
//
//
//
//   storageFile() async {
//     List temp = await stethoController.getAudioFiles();
//     List isExitingsFiles = [];
//     for(var i=0; i<temp.length; i++){
//       if(await File(temp[i]['file']).exists()) {
//         isExitingsFiles.add(temp[i]);
//         dPring('==============='+temp.length.toString());
//       }
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       prefs.setString('audioFiles',jsonEncode(isExitingsFiles));
//        Get.back();
//
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recorded Files'),
//       ),
//       body: WillPopScope(
//         onWillPop: () {
//           Back();
//           return  Future.value(false);
//         },
//         child: GetBuilder(
//             init: StethoController(),
//             builder: (_) {
//             return Column(
//               children: [
//
//                 Expanded(
//                   child: ListView.separated(
//                     separatorBuilder: (context, index) {
//                       return Divider(color: Colors.black, height: 1);
//                     },
//                     itemCount: stethoController.getAudioFileList.length,
//                     itemBuilder: (context, index) {
//                         var file = stethoController.getAudioFileList[index];
//                         return ListTile(
//                           title: Container(
//
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 stethoController.playFile == file['file'].toString().split('/').last.split('.wav')[0].toString()
//                                     ? Icon(Icons.pause, size: 38)
//                                     : Icon(Icons.play_arrow, size: 38),
//
//                                 Text(file['file'].toString().split('/').last.split('.wav')[0].toString()),
//
//                                 SizedBox(width: 15),
//
//                                 ElevatedButton(
//                                     onPressed: () async {
//                                       await deleteFile(File(file['file'].toString()));
//                                     },
//                                     child: Icon(Icons.delete),
//                                 ),
//
//                                 SizedBox(width: 10,),
//
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     // Share.share(file['file'].toString());
//                                   },
//                                   child: Icon(Icons.share),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           onTap: () {
//                              stethoController.play(file['file'].toString());
//                           },
//                         );
//                     },
//                   ),
//                 ),
//
//               ],
//             );
//           }
//         ),
//       ),
//     );
//   }
// }
