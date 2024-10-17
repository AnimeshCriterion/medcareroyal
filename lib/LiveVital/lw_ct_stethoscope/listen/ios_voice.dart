import 'dart:async';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/tau.dart';

//import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'listen_controller.dart';

class IosVoice extends StatefulWidget {
  final String url;
  final String title;
  final String port;
  final String? name;
  final String? age;
  final String? pid;
  final String? gender;

  const IosVoice(
      {Key? key,
      required this.url,
      required this.title,
      required this.port,
      required this.name,
      required this.age,
      this.pid,
      this.gender})
      : super(key: key);

  @override
  State<IosVoice> createState() => _IosVoiceState();
}

class _IosVoiceState extends State<IosVoice> {
  bool isPlaying = false;
  FlutterSoundPlayer player = FlutterSoundPlayer();

  ListenController controller = Get.put(ListenController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    playAudio();
    startStreaming();
  }

  var channel;

  StreamSubscription? subscription;

  Future<void> playAudio() async {
    // channel.sink.close();
    setState(() {
      isPlaying = false;
    });
    try {
      Codec codec = Codec.pcm16;

      // final socket = await Socket.connect(widget.url, int.parse(widget.port.toString()));

      channel = IOWebSocketChannel.connect(widget.url);

      await player.openPlayer(enableVoiceProcessing: true);

      await player.startPlayerFromStream(
          codec: codec, numChannels: 1, sampleRate: 44100);

      print('kkkkkkkkkkkkkkkk' + channel.toString());

      subscription = channel.stream.listen((data) async {
        print('kkkkkkkkkkkkkkkk' + data.toString());
        if (player.isPlaying) {
          setState(() {
            isPlaying = true;
          });
          // await Helper.setSpeakerphoneOn(!isSpeker);
        }

        player.foodSink!.add(FoodData(data));
        controller.updateStethoData=data;
      });
    } catch (e) {
      print('Connection error: $e');
    }
    // await player.setAudioSource(myCustomSource);
    // player.play();
  }

  @override
  Future<void> dispose() async {
    subscription!.cancel();
    timer!.cancel();
    super.dispose();
  }

  onPressedBack() async {
    player.stopPlayer();
     Get.back();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stethoscope'),
        ),
        body: WillPopScope(
          onWillPop: () {
            return onPressedBack();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Name : '+(
                        widget.name ?? ''),
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      Text('('+(
                        (widget.age ?? '')+' /'+(widget.gender??""))+')',
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),   SizedBox(
                        width: 20,
                      ),
                      Text("PID : ${(widget.pid??'').toString()}",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                //  isPlaying?
                // const CircularProgressIndicator()
                //    :
                Expanded(
                  child: Sparkline(
                    // pointsMode: PointsMode.last,
                    enableGridLines: true,
                    useCubicSmoothing: true,
                    cubicSmoothingFactor: 0.2,
                    sharpCorners: true,
                    lineWidth: 3,
                    lineColor: Colors.blue,
                    data: controller.getStethoData.toList().length < 100
                        ? controller.getStethoData.toList()
                        : controller.getStethoData
                            .toList()
                            .getRange(
                                (controller.getStethoData.toList().length -
                                    100),
                                controller.getStethoData.toList().length)
                            .toList(),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        child: IconButton(
                          icon:
                              Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: _togglePlayer,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            value: playPosition,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    // Container(
                    //   height: 100,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       LoadingAnimationWidget.staggeredDotsWave(color: Colors.lightGreen, size: 100),
                    //       LoadingAnimationWidget.staggeredDotsWave(color: Colors.lightGreen, size: 100),
                    //       LoadingAnimationWidget.staggeredDotsWave(color: Colors.lightGreen, size: 100),
                    //     ],),
                    // ),

                    // Play/Pause Button
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double playPosition = 0.0;

  Timer? timer;

  void startStreaming() async {
    await player.startPlayer(
      codec: Codec.pcm16,
      whenFinished: () {
        setState(() {
          isPlaying = false;
        });
      },
    );

    setState(() {
      isPlaying = true;
    });
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      if (channel!.sink != null) {
        // final data = await channel!.sink.stream.first;
        print('nnnnnnnnnnvvvvnn' + playPosition.toString());
        if (isPlaying) {
          // player.feedFromStream(data);

          print('nnnnnnnnnnvvvvnn' + playPosition.toString());
          playPosition += 0.1; // Update the position based on elapsed time
        }
      }
    });
  }

  void _togglePlayer() async {
    if (isPlaying) {
      await player.pausePlayer();
    } else {
      await player.resumePlayer();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }
}
