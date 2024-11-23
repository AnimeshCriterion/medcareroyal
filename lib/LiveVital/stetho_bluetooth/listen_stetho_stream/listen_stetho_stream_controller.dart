


import 'dart:async';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';

import 'package:web_socket_channel/io.dart';

import '../../../authenticaton/user_repository.dart';
import '../../../common_libs.dart';

class ListenStethoStreamController extends GetxController{


  TextEditingController uhidC=TextEditingController();

  List<double> graphData=[0.0];

  List<double> get getGraphData=>graphData;
  set updateGraphData(List val){
    // dPring(getGraphData.length.toString());
    for(int i=0;i<val.length;i++){
      if(getGraphData.length<300){
        graphData.add(double.parse(val[i].toString()));
      }else{
        graphData=[0.0];
      }
    }
    update();
  }


  late IOWebSocketChannel channel;

  StreamSubscription? subscription;


  void reconnect(context) {
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);

    channel =  IOWebSocketChannel.connect('ws://corncall.in:8888/${uhidC.text.toString()}');
  }




  bool isPlay=true;
  bool get getIsPlay=>isPlay;
  set updateIsPlay(bool val){
    isPlay=val;
    update();
  }



  bool isWebSocketConnected=false;
  bool get getIsWebSocketConnected=>isWebSocketConnected;
  set updateIsWebSocketConnected(bool val){
    isWebSocketConnected=val;
    update();
  }

  FlutterSoundPlayer player = FlutterSoundPlayer();






  Future<void> webSocketConnect(context) async {
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);

    dPrint('ws://corncall.in:8888/${uhidC.text.toString()}');

    try{
      // 'ws://172.16.19.162:5001/ws/audio/'

      channel =  IOWebSocketChannel.connect('ws://corncall.in:8888/${uhidC.text.toString()}');
      await channel.ready;

      // final session = await AudioSession.instance;
      // await session.configure(const AudioSessionConfiguration.speech());
      // await session.setActive(true);
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));

      await player.openPlayer(enableVoiceProcessing: true);


      //
       dPrint('nnnvvv' + channel.toString());

      await player.startPlayerFromStream(
          codec: Codec.pcm16, numChannels: 1, sampleRate: 44100
      );

      subscription= channel.stream.listen( (data) async {
         dPrint('nnnvvv' + data.toString());

        updateIsWebSocketConnected=true;
         if(data is Uint8List) {
           updateGraphData = data;
         }

        if(getIsPlay){
          try{
            if (data is Uint8List) {
              player.foodSink!.add(FoodData(data));
            }
          }
          catch(e){
            dPrint(e);
          }
        }



      },
        onDone:  (){
          reconnect(context);
        }
      );
    }
    catch(e){
      dPrint('response '+e.toString());
    }



    // try {
    //
    //   // final socket = await Socket.connect('ws://aws.edumation.in', 5031);
    //   // socket.write('n');
    //
    //   channel = IOWebSocketChannel.connect('ws://corncall.in:8888/2236241');
    //
    //   // Codec codec = Codec.pcm16;
    //   // await player.openPlayer(enableVoiceProcessing: true);
    //   //
    //   // await player.startPlayerFromStream(
    //   //     codec: codec, numChannels: 1, sampleRate: 44100);
    //    dPring('kkkkkkkkkkkkkkkk' + channel.toString());
    //
    //   // subscription = channel.stream.listen((data) async {
    //   //
    //   //   dPring('kkkkkkkkkkkkkkkk' + data.toString());
    //   //
    //   //   player.foodSink!.add(FoodData(data));
    //   //   dPring('kkkkkkkkkkkkkkkk' + data.toString());
    //   // },  onDone: reconnect);
    // } catch (e) {
    //   dPring('Connection error: $e');
    // }
  }





}