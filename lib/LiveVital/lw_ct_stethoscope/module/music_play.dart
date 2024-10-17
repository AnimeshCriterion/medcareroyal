import 'dart:async';

import 'package:flutter/material.dart';

class PlayMusic extends StatefulWidget {
  const PlayMusic({Key? key}) : super(key: key);

  @override
  State<PlayMusic> createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {
  bool isPlaying = false;
  bool isOn = false;
  final Stopwatch _stopwatch = Stopwatch()..start();
  final Duration _timerDuration = Duration(seconds: 60);
  double _progressValue = 0.0;

  void _updateProgress() {
    const totalDuration = 20; // seconds
    const updateInterval = 200; // milliseconds
    const totalSteps = (totalDuration * 1000) ~/ updateInterval;

    Timer.periodic(Duration(milliseconds: updateInterval), (timer) {
      if (_progressValue >= 1.0) {
        timer.cancel();
      } else {
        setState(() {
          _progressValue += 1 / totalSteps;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: const Text("Play Music"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [



                Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     SizedBox(width: 300,child:     LinearProgressIndicator(
                       value: _progressValue,
                       backgroundColor: Colors.grey[300],
                       valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                     )),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        isPlaying
                            ? IconButton(
                          icon: Icon(Icons.pause_circle_filled),
                          iconSize: 34.0,
                          onPressed: (){
                            togglePlayPause();

                            print("pause");
                          }
                        )
                            : IconButton(
                          icon: Icon(Icons.play_circle_filled),
                          iconSize: 34.0,
                          onPressed:(){
                            togglePlayPause();
                            _updateProgress();
                            print("play");
                          }
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


//
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        isOn
                            ? Row(
                              children: [
                                IconButton(
                                icon: Icon(Icons.volume_up),
                                iconSize: 34.0,
                                onPressed: (){
                                  speakerOnOff();
                                  print("speaker on");
                                }
                        ),Text("Speaker On")
                              ],
                            )
                            : Row(
                              children: [
                                IconButton(
                                icon: Icon(Icons.volume_off),
                                iconSize: 34.0,
                                onPressed:(){
                                  speakerOnOff();
                                  print("speaker off");
                                }
                        ),Text("Speaker Off")
                              ],
                            ),
                      ],
                    ),


                ],),
                SizedBox(height: 20,),

               






          ]),
        ),
      ),
    );
  }
  togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }
speakerOnOff(){
  setState(() {
    isOn = !isOn;
  });
}

}


