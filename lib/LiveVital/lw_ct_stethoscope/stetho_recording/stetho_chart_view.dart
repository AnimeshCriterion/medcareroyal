//
// import 'dart:io';
//
// import 'package:digi_doctor/AppManager/app_color.dart';
// import 'package:digi_doctor/AppManager/my_text_theme.dart';
// import 'package:digi_doctor/AppManager/widgets/my_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../../../../../AppManager/widgets/my_app_bar.dart';
//
// import 'package:just_audio/just_audio.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
//
// class StethoChartView extends StatefulWidget {
//   const StethoChartView({Key? key}) : super(key: key);
//
//   @override
//   State<StethoChartView> createState() => _StethoChartViewState();
// }
//
// class _StethoChartViewState extends State<StethoChartView> {
//   late AudioPlayer _audioPlayer;
//   List<double> _audioData = [];
//
//   @override
//   void initState() {
//
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft,
//     ]);
//     super.initState();
//     _initializeAudioPlayer();
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   void _initializeAudioPlayer() {
//     _audioPlayer = AudioPlayer();
//     _audioPlayer.setVolume(1.0);
//     _audioPlayer.playbackEventStream.listen((event) {
//       _processAudioData(event.bufferedPosition.inMilliseconds);
//     });
//   }
//
//   void _processAudioData(int position) {
//     double amplitude = convertPositionToAmplitude(position);
//     setState(() {
//       _audioData.add(amplitude);
//     });
//   }
//
//   double convertPositionToAmplitude(int position) {
//     // Perform your conversion logic here based on the position value
//     // For simplicity, let's assume the amplitude is equal to the position
//     return position.toDouble();
//   }
//
//   List<charts.Series<LinearAudioData, int>> _createData() {
//     final data = _audioData
//         .asMap()
//         .entries
//         .map((entry) => LinearAudioData(entry.key, entry.value))
//         .toList();
//
//     return [
//       charts.Series<LinearAudioData, int>(
//         id: 'Audio',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (LinearAudioData data, _) => data.time,
//         measureFn: (LinearAudioData data, _) => data.amplitude,
//         // data: data,
//         data: data
//             .toList()
//             .length < 50
//             ? data.toList()
//             : data
//             .toList()
//             .getRange(
//             (data
//                 .toList()
//                 .length - 50),
//             data
//                 .toList()
//                 .length)
//             .toList(),
//       )
//     ];
//   }
//
//   onPressBack(){
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//      Get.back();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Audio Graph'),
//         actions: [
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: 150,
//               child: MyButton(
//                 color: AppColor.white,
//                 textStyle: MyTextTheme().mediumPCB,
//                 onPress: () {
//                   setState(() {
//                     _audioPlayer.setAsset('assets/original.wav');
//                   });
//                   // _audioPlayer.play();
//                 },
//                 title: 'Play Audio',
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: WillPopScope(
//         onWillPop: (){
//           return onPressBack();
//         },
//
//         child: Center(
//           child: Container(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: charts.LineChart(
//                     _createData(),
//                     animate: true,
//                     domainAxis: charts.NumericAxisSpec(
//                       tickProviderSpec:
//                       charts.BasicNumericTickProviderSpec(zeroBound: false),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class LinearAudioData {
//   final int time;
//   final double amplitude;
//
//   LinearAudioData(this.time, this.amplitude);
// }

import 'dart:developer';
import 'dart:io';
import 'package:medvantage_patient/LiveVital/lw_ct_stethoscope/stetho_recording/stetho_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../app_manager/app_color.dart';




class AudioGraphPage extends StatefulWidget {
  final String audioFilePathOne;
  final String audioFilePathTwo;

  AudioGraphPage({  required this.audioFilePathOne, required this.audioFilePathTwo});

  @override
  _AudioGraphPageState createState() => _AudioGraphPageState();
}

class _AudioGraphPageState extends State<AudioGraphPage> {
  StethoController controller=Get.put(StethoController());

  get() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    controller.updateAudioSamplesOne= await  readWavFile(widget.audioFilePathOne);
    controller.updateAudioSamplesTwo= await  readWavFile(widget.audioFilePathTwo);

  }
  @override
  void initState() {
    super.initState();
    get();
  }

  onPressBack(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
     Get.back();

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Graph'),
      ),
      body:  WillPopScope(
        onWillPop: (){
          return onPressBack();
        },
        child: GetBuilder(
          init: StethoController(),
          builder: (_) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      zoomMode: ZoomMode.x,
                      enablePanning: true,
                    ),
                      trackballBehavior: TrackballBehavior(
                          enable: false,
                          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints
                      ),
                      enableSideBySideSeriesPlacement: true,
                      primaryXAxis:NumericAxis(
                        placeLabelsNearAxisLine: false,
                        crossesAt:10,
                        zoomFactor: 0.2,
                        autoScrollingMode: AutoScrollingMode.start,
                        isVisible: false
                      ),
                      enableAxisAnimation: true,
                      tooltipBehavior: TooltipBehavior(
                          enable: false,
                          color: AppColor.greyDark,textStyle: const TextStyle(
                        color: Colors.black,
                      )),
                      series:
                      [
                        LineSeries<AudioData,int>(dataSource: List.generate(controller.getAudioSamplesOne.length, (index){
                          var vital=controller.getAudioSamplesOne[index];
                          return AudioData(index,
                              double.parse(vital.toString()));
                            }),
                            enableTooltip: true,
                            color:AppColor.red,
                            name: 'Audio File One',
                            xValueMapper: (AudioData sales, _) => sales.date,
                            yValueMapper: (AudioData sales, _) => sales.value),


                        LineSeries<AudioData,int>(
                            dataSource: List.generate(controller.getAudioSampleTwo.length, (index){
                          var vital=controller.getAudioSampleTwo[index];
                          return AudioData(index,
                              double.parse(vital.toString()));
                            }),
                            enableTooltip: true,
                            color:AppColor.primaryColorDark ,
                            name: 'Audio File Two',
                            xValueMapper: (AudioData sales, _) => sales.date,
                            yValueMapper: (AudioData sales, _) => sales.value),
                      ],
                    )
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Future<List<double>>  readWavFile(String filePath) async {
    final file = File(filePath);
    final bytes =file.readAsBytesSync();

    // Parse WAV header to determine sample rate and bit depth
    List<double> doubleList = bytes.map((value) => double.parse(value.toString())).toList();
    List<double> data =doubleList.getRange(0, doubleList.length<441000? doubleList.length:441000).toList();
    print('nnnnnnnvnvnvvv'+data.toString());
    return data;

  }
}

class AudioData{
  final int date;
  final double value;

  AudioData(this.date,this.value);
}