



import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:audio_input_type_plugin/audio_input_type_plugin.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:intl/intl.dart';
import 'package:medvantage_patient/app_manager/alert_dialogue.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'package:dio/dio.dart' as dioo;

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../Localization/app_localization.dart';
import '../../View/widget/common_method/show_progress_dialog.dart';
import '../../app_manager/alert_toast.dart';
import '../../authenticaton/user_repository.dart';
import '../../common_libs.dart';
import 'app_api.dart';
import 'data_modal/patient_details_data_modal.dart';
class StethoBluetoothController extends GetxController{



  RxBool showNoData=false.obs;
  bool get getShowNoData=>(showNoData.value);

  set updateShowNoData(bool val){
    showNoData.value=val;
    update();
  }

  bool isRecording = false;
  set updateIsRecording(bool val) {
    isRecording = val;
    update();
  }

  late final AudioRecorder audioRecorder;

  final audioPlayer = ap.AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  String audioPath = '';
  set updateAudioPath(String val){
    audioPath=val;
    update();
  }

  bool isPlayer = false;

  String playFile  = '';

  Future<void> play(filePath) async {
    //
    // playFile = filePath.toString().split('/').last.split('.wav')[0].toString();
    //
    // if(isPlayer) {
    //   audioPlayer.stop();
    //   isPlayer = false;
    //   playFile = '';
    // } else {
    //   audioPlayer.play(ap.DeviceFileSource(filePath));
    //   audioPlayer.onPlayerStateChanged.listen((event) {
    //     if(event==PlayerState.completed){
    //       playFile = '';
    //     }
    //   });
    //   isPlayer = true;
    // }
    // update();

  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  List audioFileList = [];
  List get getAudioFileList=>audioFileList;
  set updateAudioFileList(List val){
    audioFileList=val;
    update();
  }

  storeDataLocally({filePath}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List tempList=[];
    //
    List getLocalData = await getAudioFiles();

    tempList=getLocalData;

    tempList.add(
        {'file':filePath.toString()}
    );


    print('nnnnvnnvnn '+tempList.toString());

    prefs.setString('audioFiles',jsonEncode(tempList));

  }

  Future<List> getAudioFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var localData=  prefs.getString('audioFiles');
    updateAudioFileList=jsonDecode(localData?? "[]");
    return getAudioFileList;
  }



  String tappedBodyPoint='';
  String  get getTappedBodyPoint=>tappedBodyPoint;
  set updateTappedBodyPoint(String val){
    tappedBodyPoint=val;
    update();
  }






  int minutes = 0;
  set updateMinutes(int val){
    minutes=val;
    update();
  }
  int seconds = 0;
  set updateSeconds(int val){
    seconds=val;
    update();
  }
  bool isRunning = false;


    Timer? timer;

  onPressesStartStropRecording(context) async {



    startRecording();
    // startTimer();

    //
    timer = Timer(Duration(seconds: 15), ()
    async {
      print('nvnnnvnnvv ');
          minutes = 0;
          seconds = 0;

      String? microphone = await AudioInputTypePlugin.getConnectedMicrophone();

      await stopRecording();
      initPlugin();
      print("Connected Microphone: $microphone");
      if((microphone??'')=='Bluetooth Microphone') {

        await  storeDataLocally(filePath: audioPath);
        await insertPatientMediaData(context,filePath: audioPath);
      }
      else{
        Alert.show(' Stethoscope is not connected.');
      }
      updateTimerVal=0;
      // updateTappedBodyPoint ='';

    });

    update();
  }


  startRecording() async {

    Permission.storage;
    Permission.microphone;
    Permission.accessMediaLocation;
    Permission.audio;
    Permission.bluetooth;

    var status = await Permission.microphone.status;
    if(status != PermissionStatus.granted) {
      await Permission.microphone.request();
    }

    status = await Permission.storage.status;
    if(status != PermissionStatus.granted) {
      await Permission.storage.request();
    }

    status = await Permission.bluetooth.status;
    if(status != PermissionStatus.granted) {
      await Permission.bluetooth.request();
    }
    // var tempDir = await getDownloadsDirectory();

    var tempDir =   Platform.isAndroid? await getDownloadsDirectory() : await getApplicationSupportDirectory();
     updateAudioPath = "${tempDir!.path}/REC${DateFormat('ddMMyyyyHHmmss').format(DateTime.now()).toString()}.wav";
    String? microphone = await AudioInputTypePlugin.getConnectedMicrophone();
    // print("Connected Microphone: $microphone");

    if((microphone??'')=='Bluetooth Microphone') {
      await audioRecorder.start(
        RecordConfig(encoder: AudioEncoder.wav,
            numChannels: 1,
            sampleRate: 44100
        ),
        path: audioPath,
      );
    }




    updateIsRecording = true;

       update();

  }



  List<double> graphData=[0.0];

  List<double> get getGraphData=>graphData;
  set updateGraphData(List val){
    // print(getGraphData.length.toString());
    for(int i=0;i<val.length;i++){
      if(getGraphData.length<300){
        graphData.add(double.parse(val[i].toString()));
      }else{
        graphData.removeAt(0);
        graphData.insert(graphData.length, double.parse(val[i].toString()));
      }
    }
    update();
  }


  bool isPlay=true;
  bool get getIsPlay=>isPlay;
  set updateIsPlay(bool val){
    isPlay=val;
    update();
  }

  late StreamSubscription recorderStatus;
  late StreamSubscription socketStream;
  late StreamSubscription micStream;

  FlutterSoundPlayer player = FlutterSoundPlayer();
  AudioPlayer _audioPlayer = AudioPlayer();

  // final dataQueue = Queue<Uint8List>();
  // // Function to process the data queue and send chunks over WebSocket
  // void processDataQueue() {
  //   // Process a limited number of chunks from the queue
  //   final int chunksToSend = 512; // Adjust the number based on your needs
  //   print('#####################');
  //   for (int i = 0; i < chunksToSend && dataQueue.isNotEmpty; i++) {
  //     final Uint8List chunk = dataQueue.removeFirst();
  //     // Send the chunk over WebSocket (replace this with your WebSocket logic)
  //     print('Sending chunk: ${chunk.length} items');
  //   }
  // }


  Future<void> initPlugin() async {
    print('nnnvnvnnv ');
    if(Platform.isAndroid) {
      await AndroidAudioManager().startBluetoothSco();
      await AndroidAudioManager().setBluetoothScoOn(true);
    }

    Stream<Uint8List> streams = MicStream.microphone(
        sampleRate: 44100,
        channelConfig:ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AudioFormat.ENCODING_PCM_16BIT
    );

    print('nnnvnvnnv');
    // await player.openPlayer(enableVoiceProcessing: true);
    //
    // await player.startPlayerFromStream(
    //     codec: Codec.pcm16, numChannels: 1, sampleRate: 44100);

    // int? bufferSize = await MicStream.bufferSize;
    // micStream = stream.listen((samples) async {
    //   // feedHim(samples);
    //   //player.foodSink!.add(FoodData(samples));
    //
    //   print('nnnvnvnnv'+samples.length.toString());
    //
    //   channel.sink.add(samples);
    //   updateGraphData=samples;
     // channel.sink.add(samples);
     //  sendDataInChunks(amplitudesToByteBuffer(samples),512);





    // });



    //     await _recorder!.startRecorder(
    //   toStream: (data) {
    //     if (socket != null) {
    //       // Convert to a base64 string
    //       String base64Audio = base64Encode(data!);
    //       // Send the audio data
    //       socket!.emit('audio_data', base64Audio);
    //     }
    //   },
    // );

    var stream = await audioRecorder.startStream(const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        numChannels: 1 ,
        sampleRate: 44100
    ));



    // await player.openPlayer(enableVoiceProcessing: true);
    //
    // await player.startPlayerFromStream(
    //     codec: Codec.pcm16WAV, numChannels: 1, sampleRate: 44100);

    try{
      await AndroidAudioManager().startBluetoothSco();
      await AndroidAudioManager().setBluetoothScoOn(true);
    }
    catch(e){

    }
    micStream= stream.listen((data) async {

      String? microphone = await AudioInputTypePlugin.getConnectedMicrophone();
      print("Connected Microphone: $microphone");

      // if((microphone??'')=='Bluetooth Microphone') {
        // print('nnnvnvnnv'+data.length.toString());
        channel.sink.add(data);
        updateGraphData = data;
      // }


    });





    update();
  }


  stopRecording() async {
    String? microphone = await AudioInputTypePlugin.getConnectedMicrophone();

    print("stopRecordingstopRecordingstopRecording Microphone: $microphone");
    await  audioRecorder.stop();
    updateIsRecording = false;
  }
  bool isPlaying=false;
  bool get getIsPlaying=> isPlaying;
  set updateIsPlaying(bool val){
    isPlaying=val;
    update();
  }


  late WebSocketChannel channel;

  StreamSubscription? subscription;

  void reconnect(context) {


    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);
    channel =  IOWebSocketChannel.connect('ws://corncall.in:8888/${userRepository.getUser.uhID.toString()}');
  }



  Future<void> webSocketConnect(context) async {
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);
    try {
      // final socket = await Socket.connect('ws://aws.edumation.in', 5031);
      // socket.write('n');
      // final wsUrl = Uri.parse('ws://corncall.in:8888/2236241');
      // 'ws://172.16.19.162:5001/chat/',
      // 'ws://172.16.19.162:5001/ws/audio?token=1'
      // channel = WebSocketChannel.connect(wsUrl);

      print('nnvnvnnv '+userRepository.getUser.uhID.toString().toString());
      channel =  IOWebSocketChannel.connect('ws://corncall.in:8888/${userRepository.getUser.uhID.toString()}');

         print('kkkkkkkkkkkkkkkk' + channel.toString());

        subscription = channel.stream.listen((data) async {


             print('nnnvvv' + data.length.toString());


       },  onDone: (){
          reconnect(context);
        });


    } catch (e) {
      print('Connection error: $e');
    }
  }





  int selectedBodyTab = 0;

  int get getSelectedBodyTab => selectedBodyTab;

  set updateSelectedBodyTab(int val) {
    selectedBodyTab = val;
    update();
  }
  List bodyList = [
    {'id': 0, 'name': 'Cardiac Auscultation\n(Front Heart)'},
    {'id': 1, 'name': 'Anterior\n(Front Lungs)'},
    {'id': 2, 'name': 'Posterior\n(Back Lungs)'},
  ];
  String selectedBodyPoint='';
  String get getSelectedBodyPoint=>selectedBodyPoint;
  set updateSelectedBodyPoint(String val){
    selectedBodyPoint=val;
    update();
  }

  insertPatientMediaData(context,{ filePath}) async {
 bool isSavedData=false;
    final prefs = await SharedPreferences.getInstance();

    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: false);
 ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());

    Map<String, String> body={
      'uhId': userRepository.getUser.uhID.toString(),
      'category': 'stethoscope',
      'dateTime':DateTime.now().toString(),
      'userId':userRepository.getUser.admitDoctorId.toString(),
      // 'formFile':getImgPath.toString()

    };
    print("mdkgmg"+body.toString());
    try{
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://apimedcareroyal.medvantage.tech:7082/api/PatientMediaData/InsertPatientMediaData?uhId=${userRepository.getUser.uhID.toString()}&category=stethoscope&dateTime=${DateTime.now().toString()}&userId=${userRepository.getUser.admitDoctorId.toString()}'));

      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('formFile', filePath.toString());

      request.files.add(multipartFile);

      http.StreamedResponse response = await request.send();
      Get.back();
      if (response.statusCode == 200) {
        isSavedData=true;
        Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: 'Recording uploaded successfully'.toString()));
        // alertToast(context, 'Recording uploaded successfully');

      } else {
        isSavedData=false;
        await  saveFileLocally(filePath: filePath.toString() ,isSaved:false );
        print(response.reasonPhrase);
      }
    } on SocketException catch (_) {

      isSavedData=false;
      await  saveFileLocally(filePath: filePath.toString() ,isSaved:false );

    }

    catch(e){
      isSavedData=false;
      await saveFileLocally(filePath: filePath.toString() ,isSaved:false );
       Get.back();
    }
    return
      isSavedData;
  }

  saveFileLocally({filePath,isSaved}) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      List data = [];
      data = jsonDecode(prefs.getString('stetho') ?? "[]");
      print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn '+data.toString());

        data.add({'filePath': filePath.toString(), 'isSaved': isSaved});
        await prefs.setString('stetho', jsonEncode(data));

    }
    catch(e){

      print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn '+e.toString());
    }
  }


  int timerval=0;
  int get getTimerVal=>timerval;
  set updateTimerVal(int val){
    timerval=val;
    update();
  }

  // saveAudio(context, { filePath}) async {
  //
  //   ProgressDialogue().show(context, loadingText: 'Loading...');
  //
  //     var body={
  //       'pid': stethoPidC.text.toString(),
  //       'position':  tappedBodyPoint.toString(),
  //       'userID': '1234567',
  //       'stethoName': 'stethoName',
  //     };
  //
  //     print('nnnvnnvnv '+body.toString());
  //     print(filePath.toString());
  //     var request = http.MultipartRequest('POST', Uri.parse('http://182.156.200.179:201/patientStethoFile.ashx'));
  //     request.fields.addAll(body);
  //     // request.headers.addAll({
  //     //   'Content-Type': 'multipart/form-data'
  //     // });
  //     // final bytes = await File(filePath.toString()).readAsBytes();
  //     // request.files.add(await http.MultipartFile.fromBytes('files', bytes));
  //       request.files.add(await http.MultipartFile.fromPath('file', filePath.toString()));
  //
  //     http.StreamedResponse response = await request.send();
  //
  //     print(await response.statusCode.toString());
  //     print('nnnnvnn ');
  //     // print(await response.stream.bytesToString());
  //      Get.back();
  //
  //     if (response.statusCode == 200) {
  //       alertToast(context,await response.stream.bytesToString().toString());
  //
  //       // print(await response.stream.bytesToString());
  //     }
  //     else {
  //       // print(response.reasonPhrase);
  //     }
  // }

  Map<String, dynamic> patientData={};
  PatientDetailsDataModal get getPatientData=>PatientDetailsDataModal.fromJson(patientData);
  set updatePatientData(Map<String, dynamic> val){
    patientData=val;
    update();
  }
  TextEditingController stethoPidC=TextEditingController();

  PatientData(context, pid, {bool isNotDashboard=false}) async {
    ApplicationLocalizations localization = Provider.of<ApplicationLocalizations>(context, listen: false);
    ProgressDialogue().show(context, loadingText: localization.getLocaleData.Loading.toString());
    var body = {'id':  pid.toString()};

    var data = await App().api(
        'PatientRegistration/GetPatientRegistrationDetails', body, context,token: true);


    ProgressDialogue().hide();

    print('nnnvnnv '+data.toString());

    if((data['patientRegistration'] ?? []).isNotEmpty){
      updatePatientData =   data['patientRegistration'][0];
      // App().navigate(context, StethoBluetoothView());
    }


    print('nnnnnnnn'+patientData.toString());

  }


  int recodingcouter=0;
  set setRecodingCounter(int val){
    recodingcouter=val;
    update();
  }


}