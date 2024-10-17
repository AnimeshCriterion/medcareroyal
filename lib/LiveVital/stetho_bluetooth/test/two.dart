// import 'package:demo_app/unknown/stetho_controller.dart';
// import 'package:demo_app/unknown/ten.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class Recorder extends StatefulWidget {
//   const Recorder({super.key});
//
//   @override
//   State<Recorder> createState() => _RecorderState();
// }
//
// class _RecorderState extends State<Recorder> {
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
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Stethoscope Recorder'),
//           centerTitle: true,
//         ),
//         body: Center(
//           child: Container(
//             width: MediaQuery.of(context).size.width/1.5,
//             height: 100,
//             child: ElevatedButton(
//               onPressed: () {
//                 Get.to(AudioRecorderScreen());
//               },
//               child: Text('Go to Stethoscope \n Audio Recorder',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
