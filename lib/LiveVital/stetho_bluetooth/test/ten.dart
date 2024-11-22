// import 'dart:async';
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
//
// class AudioRecorderScreen extends StatefulWidget {
//
//   @override
//   _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
// }
//
// class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
//
//   StethoController stethoController = StethoController();
//
//   @override
//   void initState() {
//     initPlugin();
//     AndroidAudioManager().startBluetoothSco();
//     AndroidAudioManager().setBluetoothScoOn(true);
//     stethoController.audioRecorder = AudioRecorder();
//     AudioSession.instance;
//     AudioSessionConfiguration(
//       // avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
//       avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
//       avAudioSessionMode: AVAudioSessionMode.defaultMode,
//     );
//     super.initState();
//   }
//
//   List audioRawData = [];
//
//   startRecording() async {
//
//     Permission.storage;
//     Permission.microphone;
//     Permission.accessMediaLocation;
//     Permission.audio;
//     Permission.bluetooth;
//
//     var status = await Permission.microphone.status;
//     if(status != PermissionStatus.granted) {
//       await Permission.microphone.request();
//     }
//
//     status = await Permission.storage.status;
//     if(status != PermissionStatus.granted) {
//       await Permission.storage.request();
//     }
//
//     status = await Permission.bluetooth.status;
//     if(status != PermissionStatus.granted) {
//       await Permission.bluetooth.request();
//     }
//
//     stethoController.updateAudioPath = "${'/sdcard/Download/'}/REC_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.wav";
//
//     await stethoController.audioRecorder.start(
//         RecordConfig(encoder: AudioEncoder.wav),
//         path: stethoController.audioPath,
//     );
//
//
//     // dPring('Recording and sampling ');
//     // final socket = await Socket.connect('ws://aws.edumation.in:5031/echo', 5031);
//     // Stream<Uint8List>? stream = await MicStream.mi
//
//
//
//
//
//
//     setState(() {
//       stethoController.isRecording = true;
//     });
//
//   }
//
//
//   late StreamSubscription _recorderStatus;
//   late StreamSubscription _playerStatus;
//   late StreamSubscription _audioStream;
//
//
//   Future<void> initPlugin() async {
//     _audioStream =  stethoController.audioPlayer.onLog.listen((recordState) {
//      dPring(recordState.toString());
//     });
//   }
//
//   stopRecording() async {
//     await stethoController.audioRecorder.stop();
//     setState(() {
//       stethoController.isRecording = false;
//     });
//   }
//
//   int minutes = 0;
//   int seconds = 0;
//   bool isRunning = false;
//   late Timer timer;
//
//   void startTimer() {
//     timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (seconds < 59) {
//         setState(() {
//           seconds++;
//         });
//       } else {
//         if (minutes < 59) {
//           setState(() {
//             minutes++;
//             seconds = 0;
//           });
//         } else {
//           stopTimer();
//         }
//       }
//     });
//   }
//
//   void stopTimer() {
//     timer.cancel();
//     setState(() {
//       isRunning = false;
//     });
//   }
//
//   void toggleTimer() {
//     if (isRunning) {
//       stopTimer();
//     } else {
//       setState(() {
//         isRunning = true;
//       });
//       startTimer();
//     }
//   }
//
//   @override
//   void dispose() {
//     Get.delete<StethoController>();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: GetBuilder(
//         init: StethoController(),
//         builder: (_) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Stethoscope Recorder'),
//               actions: [
//                 // Bluetooth ON/OFF
//                 Container(
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(right: 5),
//                         child: ElevatedButton(
//                           child: Text('Bluetooth ON/OFF',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           onPressed: () async {
//                             AppSettings.openAppSettings(
//                               type: AppSettingsType.bluetooth,
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               fixedSize: Size(180, 45),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             body: Center(
//               child:
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//
//                     // Start and stop with timer
//                     ElevatedButton(
//                       onPressed: () async {
//                         if(stethoController.isRecording) {
//                           stopTimer();
//                           setState(() {
//                             minutes = 0;
//                             seconds = 0;
//                           });
//                           stopRecording();
//                           await stethoController.storeDataLocally(filePath:stethoController.audioPath);
//                           Get.to(AudioRecorderScreen());
//                         } else {
//                           startRecording();
//                           startTimer();
//                         }
//                     },
//                       child: Text(stethoController.isRecording
//                           ? '$minutes:${seconds.toString().padLeft(2,'0')}\n' + 'Stop'
//                           : '$minutes:${seconds.toString().padLeft(2,'0')}\n' + 'Start',
//                         style: TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         fixedSize: Size(200, 200),
//                         shape: CircleBorder(
//                           side: BorderSide(
//                             style: BorderStyle.solid,
//                             width: 2,
//                             color: Colors.red,
//                           )
//                         ),
//                       ),
//                     ),
//
//                     // Recorded files
//                     ElevatedButton(
//                         onPressed: () {
//                           Get.to(AllRecordedFiles());
//                         },
//                         child: Text('Recorded Files',
//                           style: TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                           ),
//                         ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigoAccent,
//                         fixedSize: Size(250, 100),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//                       ),
//                     ),
//
//                   ],
//                 ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
