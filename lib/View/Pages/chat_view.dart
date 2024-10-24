import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/View/Pages/my_video_player.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/bottomSheet/bottom_sheet.dart';
import 'package:medvantage_patient/app_manager/camera_and%20images/image_picker.dart';
import 'package:medvantage_patient/app_manager/imageViewer/ImageView.dart';
import 'package:medvantage_patient/app_manager/imageViewer/image_view.dart';
import 'package:medvantage_patient/app_manager/navigator.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/theme/theme_provider.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/my_text_field_2.dart';
import 'package:medvantage_patient/authenticaton/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medvantage_patient/theme/theme.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../../LiveVital/YonkerOximeter/module/mydialog.dart';
import '../../Localization/app_localization.dart';
import '../../Modal/ChatDataModal.dart';
import '../../ViewModal/chat_view_modal.dart';
import '../../ViewModal/dashboard_view_modal.dart';
import '../../app_manager/alert_dialogue.dart';
import '../../app_manager/neomorphic/hex.dart';
import '../../app_manager/widgets/buttons/custom_ink_well.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../assets.dart';
import '../../common_libs.dart';
import 'drawer_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      get();
    });
  }

  get() async {

    ChatViewModal chatVM = Provider.of<ChatViewModal>(context, listen: false);
    // await chatVM.connectServer(context);
    await chatVM.connectServerNotification(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      WidgetsFlutterBinding.ensureInitialized();

      await chatVM.userChat(context);
      chatVM.scrollToBottom();
    });


  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ChatViewModal chatVM = Provider.of<ChatViewModal>(context, listen: true);
    ApplicationLocalizations localization =
    Provider.of<ApplicationLocalizations>(context, listen: false);
    DashboardViewModal dashboardVM =
    Provider.of<DashboardViewModal>(context, listen: false);
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);

    return ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(key: scaffoldKey,
          drawer: const MyDrawer(), backgroundColor:  themeChange.darkTheme ? AppColor.darkshadowColor1 : AppColor.lightshadowColor1,
          // appBar: CustomAppBar(
          //   title: "SHFC Team",
          //     color: AppColor.primaryColor,
          //     titleColor: AppColor.white,
          //     primaryBackColor: AppColor.white,
          //   actions: [
          //     // Text(userRepository.getUser.pmid.toString(),style: MyTextTheme.smallBCB,),
          //     IconButton(
          //       icon: Icon(Icons.circle,
          //           color: chatVM.getIsOnline
          //               ? AppColor.green
          //               : Colors.grey), // Online status
          //       onPressed: () async {
          //         // Implement online/offline toggle logic here
          //       },
          //     ),
          //   ],
          // ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeChange.darkTheme ? AppColor.bgDark : AppColor.bgWhite,
                  themeChange.darkTheme ? AppColor.bgDark : AppColor.bgWhite,
                  themeChange.darkTheme ? AppColor.bgDark : AppColor.white,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  Row(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // InkWell(
                        //   onTap: (){
                        //      Get.back();
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Icon(Icons.arrow_back_ios,color: themeChange.darkTheme? Colors.white:Colors.grey,),
                        //   ),
                        // ),
                        InkWell(
                            onTap: (){
                              scaffoldKey.currentState!.openDrawer();
                            },
                            child: Image.asset(
                              // themeChange.darkTheme==true?ImagePaths.menuDark:
                                themeChange.darkTheme==true?ImagePaths.menuDark:ImagePaths.menulight,height: 40)),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(dashboardVM.getClintDetails.clientName.toString()+'Chat',
                                      style: MyTextTheme.largeGCB.copyWith(fontSize: 21,height: 0,color: themeChange.darkTheme==true?Colors.white70:null),),
                                  ),
                                ],
                              ),
                              Text(chatVM.getIsOnline?localization.getLocaleData.online.toString():localization.getLocaleData.offline.toString(),
                                  style: MyTextTheme.mediumGCN.copyWith(height: 1,fontWeight: FontWeight.bold,
                                    color:AppColor.green)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:  ListView.builder(
                        controller: chatVM.scrollController,
                        reverse: true,
                        itemCount: chatVM.getChatList.map((e) => e.messageDay).toList().toSet().length,
                        itemBuilder: (BuildContext context, int index) {
                          var data=chatVM.getChatList.map((e) => e.messageDay).toSet().toList()[index];
                        return Column(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Text(data.toString(),style: MyTextTheme.smallWCN.copyWith(color: themeChange.darkTheme==true?AppColor.neoBGWhite2:AppColor.bgDark),),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: chatVM.getChatList.where((element) => element.messageDay.toString()==data.toString()).toList().length,
                              itemBuilder: (BuildContext context, int index2) {
                                ChatDataModal chat = chatVM.getChatList.where((element) => element.messageDay.toString()==data.toString()).toList()[index2];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: userRepository.getUser.pid.toString() ==
                                              chat.sendFrom.toString()
                                          ? 0
                                          : 45,
                                      left: userRepository.getUser.pid.toString() !=
                                              chat.sendFrom.toString()
                                          ? 0
                                          : 45,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          userRepository.getUser.pid.toString() ==
                                                  chat.sendFrom.toString()
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        //  Text(chat.messageDay.toString()),
                                          Visibility(
                                            visible: chat.fileUrl != null && chat.fileUrl != '',
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [

                                                Container(
                                                  height: 150,
                                                  width: 100,
                                                  padding: ( chat.message != null || chat.message != '')?
                                                  EdgeInsets.fromLTRB(5,5,5,0):EdgeInsets.all(5),
                                                  child: fileViewWidget(
                                                      val:chat.fileUrl
                                                          .toString().split(':7100').last.split('.').last,
                                                      chat: chat
                                                  ) ,
                                                ),


                                                // SizedBox(height: 15,),
                                                // InkWell(
                                                //   onTap: (){
                                                //     if(chat.fileUrl
                                                //         .toString().split(':7100').last.split('.').last=='jpg'){
                                                //       MyNavigator.push(
                                                //           context,
                                                //           MyImageView(
                                                //               url: 'https://apishfc.medvantage.tech:7100/' +
                                                //                   chat.fileUrl
                                                //                       .toString().split(':7100').last));
                                                //     }
                                                //     else  if(chat.fileUrl
                                                //         .toString().split(':7100').last.split('.').last=='mp4'){
                                                //
                                                //       MyNavigator.push(
                                                //           context,
                                                //           VideoPlayer(
                                                //               url: 'https://apishfc.medvantage.tech:7100/' +
                                                //                   chat.fileUrl
                                                //                       .toString().split(':7100').last));
                                                //     }
                                                //   },
                                                //   child: CachedNetworkImage(
                                                //     imageUrl: 'https://apishfc.medvantage.tech:7100/' +
                                                //         chat.fileUrl
                                                //             .toString().split(':7100').last,
                                                //     placeholder: (context, url) => const Icon(Icons.error),
                                                //     errorWidget: (context, url, error) =>
                                                //         Container(
                                                //           color: AppColor.black,
                                                //           child: Icon(
                                                //             chat.fileUrl
                                                //                 .toString().split(':7100').last.toString().split('.').last=='mp4'?
                                                //               Icons.play_arrow:Icons.error,color: Colors.white,),
                                                //         ),
                                                //    height: 150,alignment:Alignment.center ,
                                                //       width: 150,
                                                //   ),
                                                // ),
                                                Visibility( visible: (chat.message == null || chat.message == ''),
                                                  child: Container(
                                                    height: 30,
                                                    width: 100,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        const SizedBox(height: 5),
                                                        Text(
                                                          chat.chatTime.toString(),
                                                          textAlign: TextAlign.right,
                                                          style: MyTextTheme.smallSCN
                                                              .copyWith(color: AppColor.primaryColor,fontSize: 11),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    Visibility(
                                      visible: chat.message!='',
                                        child:msgWidget(sendFrom:  userRepository.getUser.pid.toString() ==
                                            chat.sendFrom.toString()?true:false,
                                            message: chat.message,
                                            fileUrl: chat.fileUrl,
                                            chatTime: chat.chatTime,
                                        pid: userRepository.getUser.pid.toString(),color: userRepository.getUser.pid.toString() ==
                                                chat.sendFrom.toString()
                                                ?AppColor.green:(themeChange.darkTheme? AppColor.neoBGGrey1: AppColor.white),darkTheme:  themeChange.darkTheme),),
                                        Visibility(
                                          visible:  userRepository.getUser.pid.toString() !=
                                              chat.sendFrom.toString(),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: Text('Sent by : ${chat.sendFromName}',style: MyTextTheme.mediumGCN.copyWith(fontSize: 10),),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }
                    ),
                  ),

                  // Display chat messages here
                  // You can use ListView.builder for the chat messages
                  Visibility(
                    visible: chatVM.getImgPath.toString()!='',
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(
                          color: AppColor.grey
                        ),
                        left: BorderSide(
                            color: AppColor.grey
                        ),
                        right: BorderSide(
                            color: AppColor.grey
                        ),),
                        color: AppColor.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          chatVM.getImgPath.toString().split('.').last=='mp4'?
                      InkWell(
                        onTap: (){
                          MyNavigator.push(context, VideoPlayer(url: chatVM.getImgPath.toString()));
                        },
                        child: Container(
                          height: 150,
                          width: 100,
                          color: AppColor.black,
                          child: const Center(
                            child: Icon(Icons.play_arrow,color: Colors.white,),
                          ),
                        ),
                      ):
                          Image.file(File(chatVM.getImgPath.toString()),width: 100,fit: BoxFit.fitWidth,)
                        ],
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: themeChange.darkTheme==true?hexToColor('#24252B'):AppColor.white,
                            border: Border.all(color:themeChange.darkTheme==true?hexToColor('#24252B'): AppColor.greyVeryLight,
                                width: 1),
                            borderRadius: BorderRadius.circular(5),boxShadow: [
                              BoxShadow(color: themeChange.darkTheme==true?hexToColor('#24252B'):AppColor.grey,offset: const Offset(0,5),blurRadius: 5,spreadRadius:0)]),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: const TextStyle().copyWith(color:  themeChange.darkTheme? Colors.white:Colors.grey),
                                  controller: chatVM.msgC,
                                  decoration:   InputDecoration(
                                      labelStyle: const TextStyle().copyWith(color:  themeChange.darkTheme?
                                      Colors.white:Colors.grey,
                                      ),
                                    hintText: localization.getLocaleData.typeHereQueries.toString(),
                                    hintStyle: const TextStyle().copyWith(color:  themeChange.darkTheme? Colors.white70:Colors.grey,),
                                    border: InputBorder.none
                                  ),
                                  // Implement sending messages logic here
                                ),
                              ),
                               SizedBox(
                                height: 20,
                                  child: VerticalDivider(color: AppColor.bgDark)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: InkWell(
                                  onTap: ()
                                    async {
                                      await chatVM.sendMsg(context);
                                      chatVM.msgC.clear();
                                      chatVM.scrollToBottom();
                                      chatVM.notifyListeners();
                                      // Implement sending messages logic here
                                  },
                                    child: Image.asset('assets/send.png')),
                              ),


                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          pickFile();
                          // pickImg();
                          // XFile data = await MyImagePicker.pickImageFromCamera();
                          // chatVM.updateImgPath = data.path;
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration:  BoxDecoration(
                            color: AppColor.green,borderRadius: BorderRadius.circular(10)
                          ),
                          child: Image.asset('assets/attachment.png')
                        ),
                      )
                      // IconButton(
                      //   icon: const Icon(Icons.image),
                      //   onPressed: () async {
                      //     pickFile();
                      //     // pickImg();
                      //     // XFile data = await MyImagePicker.pickImageFromCamera();
                      //     // chatVM.updateImgPath = data.path;
                      //   },
                      // ),
                      // IconButton(
                      //   icon: const Icon(Icons.video_camera_front_sharp),
                      //   onPressed: () async {
                      //     var data =await MyImagePicker.getVideoFromGallery();
                      //     chatVM.updateImgPath = data.path;
                      //   },
                      // ),
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  fileViewWidget({val, required ChatDataModal chat}){
    switch(val){
      case 'jpg':
        return imageWidget(filename:chat.fileUrl );

      case 'mp4':
        return videoWidget(filename:chat.fileUrl  );

      case 'mp4':
        return Container();
      default:
        return Container();
    }
  }


  imageWidget({filename}){
    return InkWell(
      onTap: (){
        MyNavigator.push(
                      context,
                      MyImageView(
                          url: 'https://apishfc.medvantage.tech:7100/' +
                              filename
                                  .toString().split(':7100').last));
      },
      child: CachedNetworkImage(
        imageUrl: 'https://apishfc.medvantage.tech:7100/' +filename
            .toString().split(':7100').last,
        placeholder: (context, url) =>   Container(
          alignment: Alignment.center,
          color: AppColor.black,
          child: Icon( Icons.image,color: Colors.white,),
        ),
        errorWidget: (context, url, error) =>
            Container(
              alignment: Alignment.center,
              color: AppColor.black,
              child: Icon( Icons.image,color: Colors.white,),
            ),
        height: 150,alignment:Alignment.center ,
               width: 150,
      ),
    );
  }

  videoWidget({filename}){
    return InkWell(
      onTap: (){
        MyNavigator.push(
                      context,
                      VideoPlayer(
                          url: 'https://apishfc.medvantage.tech:7100/' +
                              filename
                                  .toString().split(':7100').last));
      },
      child: Container(
        height: 150,
          width: 150,color: AppColor.black,
        child: const Icon(Icons.videocam,color: Colors.white,),
      ),
    );
  }


  msgWidget({message,fileUrl,pid,sendFrom,chatTime,required Color color,darkTheme}){
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: sendFrom?   MainAxisAlignment.end:MainAxisAlignment.start,
      children: [ 
     Visibility(
       visible: sendFrom==false,
         child: Padding(
           padding: const EdgeInsets.only(right: 8.0),
           child: Image.asset('assets/Support Doctor.png'),
         )),

        Flexible(
          child: Container(
            decoration: BoxDecoration(
              borderRadius:  BorderRadius.only(topRight: const Radius.circular(20),topLeft:  Radius.circular(sendFrom?20:0),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(sendFrom?0:20)),
                color: color,
            gradient:  LinearGradient(
              begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color,
                  color,
                  color,
                  sendFrom==false?(darkTheme?AppColor.neoGreyLight:AppColor.neoBGWhite2): color,
                ]
            ),
            boxShadow: [
              BoxShadow(color:darkTheme?hexToColor('#24252B'): AppColor.greyLight,offset: const Offset(0,5),blurRadius: 5,spreadRadius: 2)]
            ),
            child: Padding(
              padding: fileUrl == ''?
              const EdgeInsets.fromLTRB(8,8,8,8):const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:
                sendFrom
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(message.toString(),style:  MyTextTheme.smallWCN.copyWith(color:
                      sendFrom
                      ?  Colors.white:((darkTheme? Colors.white:AppColor.bgDark)))),
                  // Text(chatTime.toString(),
                  //   textAlign: TextAlign.right,
                  //   style: MyTextTheme.smallWCN
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }




  pickFile() async {
    ChatViewModal chatVM = Provider.of<ChatViewModal>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
   return  Padding(
     padding: const EdgeInsets.symmetric(vertical: 35),
     child: AlertDialog(  alignment: Alignment.bottomCenter,
       contentPadding: const EdgeInsets.all(0),
       title: Container(
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [


           // InkWell(
           //   onTap: (){
           //
           //   },
           //   child:fileIconWidget(
           //       backgroundColor: Colors.blue,
           //       icon: Icons.file_copy,
           //       iconColor: Colors.white,
           //       TextStyle:MyTextTheme.smallBCB,
           //       title: 'Document' ) ,
           // ),
           //
           // SizedBox(width: 15,),
           InkWell(
             onTap: () async {

                Get.back();
               var data = await MyImagePicker.pickImageFromCamera();
               print(data.path.toString());
               chatVM.updateImgPath = data.path.toString();
             },
             child:
             fileIconWidget(
                 backgroundColor: Colors.deepOrangeAccent,
                 icon: Icons.camera_alt,
                 iconColor: Colors.white,
                 TextStyle:MyTextTheme.smallBCB,
                 title: 'Camera' ),
           ),
           InkWell(
             onTap: () async {
                Get.back();
               var data =await MyImagePicker.pickImageFromGallery();
               chatVM.updateImgPath = data.path;
             },
             child:
             fileIconWidget(
                 backgroundColor: Colors.greenAccent,
                 icon: Icons.image,
                 iconColor: Colors.white,
                 TextStyle:MyTextTheme.smallBCB,
                 title: 'Image' ),
           ),
           InkWell(
               onTap: () async {
                  Get.back();
                 var data =await MyImagePicker.getVideoFromGallery();
                    chatVM.updateImgPath = data.path;
               },
             child:
             fileIconWidget(
                 backgroundColor: Colors.grey,
                 icon: Icons.video_collection,
                 iconColor: Colors.white,
                 TextStyle:MyTextTheme.smallBCB,
                 title: 'Video' ),
           )


         ],
       )),),
   );

  });
  }

  fileIconWidget({backgroundColor,iconColor, icon,title,TextStyle}){
    return Container(
      child: Column(
        children: [
          CircleAvatar(radius: 25,backgroundColor:backgroundColor ,
              child: Icon(icon,size: 25,color: iconColor)),
          Text(title,style: TextStyle),
        ],
      ),
    );
  }





  pickImg(){
    ChatViewModal chatVM = Provider.of<ChatViewModal>(context, listen: false);
    CustomBottomSheet.open(
      context,
      child: Container(
        color: AppColor.white,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
                  decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                  child: Row(
                    children: [
                      IconButton(onPressed: (){
                         Get.back();
                      }, icon: Icon(
                        Icons.arrow_back_sharp,
                        color: AppColor.white,
                        size: 25,
                      ),),
                      Text('Add Picture', style: MyTextTheme.mediumWCB, )
                    ],
                  ),
                ),
                Positioned(
                    top: 45,
                    left: 15,
                    right: 15 ,
                    child:  Column(children: [

                      CustomInkWell(
                        onTap: () async {

                          var data = await MyImagePicker.pickImageFromCamera();
                          print(data.path.toString());
                          chatVM.updateImgPath = data.path.toString();
                           Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColor.orange),
                            child: Wrap(children: [
                              Icon(
                                Icons.camera_alt_sharp,
                                size: 25,
                                color: AppColor.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text('Use Camera' ,
                                style: MyTextTheme.largeWCN,
                              )
                            ]),
                          ),
                        ),
                      ),

                    ],)
                ),


              ],
            ),
            const SizedBox(height: 25,),
            Text('Or' ,style: MyTextTheme.largeGCN,),
            CustomInkWell(
              onTap: () async {
                print('nnnnnnnnnnn');
                var data =await MyImagePicker.pickImageFromGallery();
                chatVM.updateImgPath = data.path;
                 Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(children: [
                    Icon(
                      Icons.image,
                      size: 25,
                      color: AppColor.primaryColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text('Select Image From Gallery',
                      style: MyTextTheme.largePCN,
                    )
                  ]),
                ),
              ),
            ),

          ],
        ),
      ),
    );
    }



}
