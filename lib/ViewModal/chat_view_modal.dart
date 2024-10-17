import 'dart:convert';

import 'package:medvantage_patient/app_manager/alert_toast.dart';
import 'package:medvantage_patient/app_manager/api/api_call.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:signalr_netcore/hub_connection_builder.dart';
import '../Modal/ChatDataModal.dart';
import '../View/widget/common_method/show_progress_dialog.dart';
import '../app_manager/api/api_util.dart';
import '../authenticaton/user_repository.dart';

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
    print(body);
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
    print('nnnnn ${data}');

    if (response.statusCode == 200) {
      ProgressDialogue().hide();
      // print(await response.stream.bytesToString());
      // await userChat(context);
      Map abc=Map.from(jsonDecode(data))['responseValue'];

      print('nnnnn${abc.runtimeType}');

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
      print(response.reasonPhrase);
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

    print("Animehs${userRepository.getUser.toJson()}");

    try {
      var data = await _api.callMedvanatagePatient7100(context,
          url:
              "GetUserChat?sendFrom=${userRepository.getUser.pid}&sendTo=0&groupId=0",
          apiCallType: ApiCallType.get());

      ProgressDialogue().hide();
      var dataList=data['responseValue'].toList();
      if (data["status"] == 1) {
        updateChatList = dataList.toList();
        print('nnnnnnnnnnnnnnnnnnnnvnvnnvn ${getChatList.length}');
      } else {
      }
    } catch (e) {
      ProgressDialogue().hide();
      print(e.toString());
    }
  }



  set updateChat(var val){
    print('nnnnnnvvnv${val.toList().runtimeType}');
   if(val.toList().isNotEmpty) {
      chatList.insert(0,ChatDataModal.fromJson(val.toList()[0]['responseValue']));
    }
   print('nnnnnnvvnv${val.toList().runtimeType}');
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
      print('nnnnndsffdsfdfdnn ${userRepository.getUser.clientId!.toString()}');
      await hubConnection.start();

      print('nnnnndsffdsfdfdnn ${userRepository.getUser.clientId!.toString()}');
      print('nnnnndsffdsfdfdnn ${hubConnection.state.toString()}');
      print('nnnnndsffdsfdfdnn ${userRepository.getUser.clientId!.toString()}');
      print('nnnnndsffdsfdfdnn ${userRepository.getUser.pid.toString()}');
      dynamic data = await hubConnection.invoke("AddUser", args: <Object>[
        int.parse(userRepository.getUser.clientId!.toString()), int.parse(userRepository.getUser.pid!.toString())
      ]);
      print('nnnnndsffdsfdfdnnnnnnndsffdsfdfdnn $data');

      hubConnection.on("ReceiveMessage", (arguments) {
        print('nnnnnnvvnv$arguments');
        updateChat = (arguments ?? []).toList();
        print('nnnnnnvvnv$arguments');
        scrollToBottom();
      });

      hubConnection.on("OnlineUser", (arguments) {

        updateIsOnline = (arguments ?? []).toList().isNotEmpty;
        print('nnnnnnnnnnn OnlineUser $arguments');
      });
      hubConnection.onclose(({Exception? error}) async {
        print('Connection closed: ${error?.toString() ?? 'Unknown error'}');
        hubConnection.serverTimeoutInMilliseconds = 300000; // 2 minutes
        hubConnection.keepAliveIntervalInMilliseconds = 60000; // 30 seconds
        await hubConnection.start();
      });

    }
    catch(e){
      print('nnnnndsffdsfdfdnnnnnnndsffdsfdfdnn $e nnnnndsffdsfdfdnnnnnnndsffdsfdfdnn');
    }
    // print('nnnnnnnnnnn'+data.toString());
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

