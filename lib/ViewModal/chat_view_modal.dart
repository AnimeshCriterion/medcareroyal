import 'dart:convert';

import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';
import '../Modal/ChatDataModal.dart';
import '../View/widget/common_method/show_progress_dialog.dart';
import '../app_manager/api/api_util.dart';
import '../authenticaton/user_repository.dart';
import '../medcare_utill.dart';

class ChatViewModal extends ChangeNotifier {



  ScrollController scrollController = ScrollController();

  scrollToBottom() {
    scrollController.jumpTo(scrollController.position.minScrollExtent+0);
    notifyListeners();
  }

  TextEditingController msgC = TextEditingController();

  final Api _api = Api();

  String imgPath = '';

  String get getImgPath => imgPath;

  set updateImgPath(String val) {
    imgPath = val;
    notifyListeners();
  }

  sendMsg(context) async {
    ProgressDialogue().show(context, loadingText: "Sending message");
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    Map<String, String> body={
      'MessageType': getImgPath.isNotEmpty ? '2' : '1',
      'SendTo': userRepository.getUser.admitDoctorId.toString(),
      'Message': msgC.text.toString(),
      'ThumbnailImage': '',
      'SendFrom': userRepository.getUser.pid.toString(),
      // 'ChatFile': getImgPath.toString(),
      'IsGroupChating': 'false',
      'IsContact': 'false',
      'GroupId': '0',
      'IsPatient': "true"
    };
    dPrint(body);
    var request = http.MultipartRequest(
        'POST', Uri.parse("https://apimedcareroyal.medvantage.tech:7100/SaveUserChat"));

    request.fields.addAll(body);
    if(getImgPath.toString()!=''){
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('ChatFile', getImgPath.toString());

      request.files.add(multipartFile);
    }

    http.StreamedResponse response = await request.send();




    var data=await response.stream.bytesToString();
    dPrint('nnnnn ${data}');

    if (response.statusCode == 200) {
      ProgressDialogue().hide();
      // dPring(await response.stream.bytesToString());
      // await userChat(context);
      Map abc=Map.from(jsonDecode(data))['responseValue'];

      dPrint('nnnnn${abc.runtimeType}');

       chatList.insert(0,ChatDataModal(
         chatDate: abc['chatDate'],
         chatTime: abc['chatTime'],
         fileLength: abc['fileSize'].toString(),
         fileName:abc['filePath'].toString().split(':7100').last,
         fileUrl: abc['filePath'],
         groupId:abc['groupId'] ,
         id: 0,
         isOnline: 0 ,
         message:abc['message']??'' ,
         messageDateTime: '',
         messageDay: abc['messageDay'],
         sendFrom:abc['sendFrom'] ,
         sendFromName:abc['sendFromName'] ,
         sendTo: abc['sendTo'],
       )
           );

    }
    else {
      ProgressDialogue().hide();
      dPrint(response.reasonPhrase);
    }

    updateImgPath = '';
  }

  List<ChatDataModal> chatList = [];

  List<ChatDataModal> get getChatList => chatList;

  set updateChatList(List val) {
    // chatList=[];
    chatList = List<ChatDataModal>.from(
        val.map((e) => ChatDataModal.fromJson(e)));
    notifyListeners();
  }

  userChat(context) async {
    ProgressDialogue().show(context, loadingText: 'Loading messages...');
    updateIsOnline=false;
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    try {
      var data = await _api.callMedvanatagePatient7100(context,
          url:
              "GetUserChat?sendFrom=${userRepository.getUser.pid}&sendTo=0&groupId=0",
          apiCallType: ApiCallType.get());

      ProgressDialogue().hide();
      var dataList=data['responseValue'].toList();
      if (data["status"] == 1) {
        updateChatList = dataList.toList();
        dPrint('nnnnnnnnnnnnnnnnnnnnvnvnnvn ${getChatList.length}');
      } else {
      }
    } catch (e) {
      ProgressDialogue().hide();
      dPrint(e.toString());
    }
  }



  set updateChat(var val){
    dPrint('nnnnnnvvnv${val.toList().runtimeType}');
   if(val.toList().isNotEmpty) {
      chatList.insert(0,ChatDataModal.fromJson(val.toList()[0]['responseValue']));
    }
   dPrint('nnnnnnvvnv${val.toList().runtimeType}');
    notifyListeners();
  }


  // final notificationUrl="ChatHubService";


  bool isOnline=false;
  bool get getIsOnline=>isOnline;
  set updateIsOnline(bool val){
    isOnline=val;
    notifyListeners();
  }

  connectServer(context)async{
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    try{
      final hubConnection =await HubConnectionBuilder()
          .withUrl(
              'https://apimedcareroyal.medvantage.tech:7100/ChatHubService').withAutomaticReconnect()
          .build();

      hubConnection.serverTimeoutInMilliseconds = 300000; // 2 minutes
      hubConnection.keepAliveIntervalInMilliseconds = 60000; // 30 seconds
      dPrint('nnnnndsffdsfdfdnn ${userRepository.getUser.clientId!.toString()}');
      await hubConnection.start();

      dPrint('nnnnndsffdsfdfdnn ${userRepository.getUser.clientId!.toString()}');
      dPrint('nnnnndsffdsfdfdnn ${hubConnection.state.toString()}');
      dPrint('nnnnndsffdsfdfdnn ${userRepository.getUser.clientId!.toString()}');
      dPrint('nnnnndsffdsfdfdnn ${userRepository.getUser.pid.toString()}');
      dynamic data = await hubConnection.invoke("AddUser", args: <Object>[
        int.parse(userRepository.getUser.clientId!.toString()), int.parse(userRepository.getUser.pid!.toString())
      ]);
      dPrint('nnnnndsffdsfdfdnnnnnnndsffdsfdfdnn $data');

      hubConnection.on("ReceiveMessage", (arguments) {
        dPrint('nnnnnnvvnv$arguments');
        updateChat = (arguments ?? []).toList();
        dPrint('nnnnnnvvnv$arguments');
        scrollToBottom();
      });

      hubConnection.on("OnlineUser", (arguments) {

        updateIsOnline = (arguments ?? []).toList().isNotEmpty;
        dPrint('nnnnnnnnnnn OnlineUser $arguments');
      });
      hubConnection.onclose(({Exception? error}) async {
        dPrint('Connection closed: ${error?.toString() ?? 'Unknown error'}');
        hubConnection.serverTimeoutInMilliseconds = 300000; // 2 minutes
        hubConnection.keepAliveIntervalInMilliseconds = 60000; // 30 seconds
        await hubConnection.start();
      });

    }
    catch(e){
      dPrint('nnnnndsffdsfdfdnnnnnnndsffdsfdfdnn $e nnnnndsffdsfdfdnnnnnnndsffdsfdfdnn');
    }
    // dPring('nnnnnnnnnnn'+data.toString());
  }


  List notificationList=[];
  List get getNotificationList=>notificationList;
  set updateNotificationList(List val){
    notificationList=val;
    notifyListeners();
  }

  connectServerNotification(context)async{
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);

      final hubConnection =await HubConnectionBuilder()
          .withUrl(
          'https://apimedcareroyal.medvantage.tech:7101/Notification',options: HttpConnectionOptions(
        transport: HttpTransportType.LongPolling, // Enable Long Polling
      ),).withAutomaticReconnect()
          .build();

    await hubConnection.start();
      hubConnection.serverTimeoutInMilliseconds = 300000; // 2 minutes
      hubConnection.keepAliveIntervalInMilliseconds = 60000; // 30 seconds
      dPrint('Notification1 ${userRepository.getUser.clientId!.toString()}');
      dPrint('Notification1 ${hubConnection.state.toString()}');

      dynamic data = await hubConnection.invoke("AddUser", args: <Object>[
        int.parse(userRepository.getUser.clientId!.toString()), int.parse(userRepository.getUser.userId!.toString())
      ]);
      dPrint('Notification1 $data');
    updateNotificationList=data['notificationResponse'];
      // hubConnection.on("ReceiveMessage", (arguments) {
      //   dPring('nnnnnnvvnv$arguments');
      //   updateChat = (arguments ?? []).toList();
      //   dPring('nnnnnnvvnv$arguments');
      //   scrollToBottom();
      // });
      //
      // hubConnection.on("OnlineUser", (arguments) {
      //
      //   updateIsOnline = (arguments ?? []).toList().isNotEmpty;
      //   dPring('nnnnnnnnnnn OnlineUser $arguments');
      // });
      // hubConnection.onclose(({Exception? error}) async {
      //   dPring('Connection closed: ${error?.toString() ?? 'Unknown error'}');
      //   hubConnection.serverTimeoutInMilliseconds = 300000; // 2 minutes
      //   hubConnection.keepAliveIntervalInMilliseconds = 60000; // 30 seconds
      //   await hubConnection.start();
      // });


    // dPring('nnnnnnnnnnn'+data.toString());
  }





// getProfilePath(context) async {
//   var data = await _api.call(context,
//       url:' ',
//       apiCallType: ApiCallType.multiPartRequest(
//         filePath: getSelectedImage.toString(),
//         fileParameter: 'files',
//         body: {},
//       ),
//       token: true);
//   // return jsonDecode(data['responseValue'])[0]['filePath'];
// }
}

