


import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_manager/app_color.dart';
import '../../../app_manager/my_button.dart';
import '../../../app_manager/theme/text_theme.dart';
import '../../../authenticaton/user_repository.dart';
import '../../../common_libs.dart';
import 'listen_stetho_stream_controller.dart';

class ListenStethoStreamView extends StatefulWidget {
  final String uhid;

  const ListenStethoStreamView({super.key, required this.uhid,   });

  @override
  State<ListenStethoStreamView> createState() => _ListenStethoStreamViewState();
}

class _ListenStethoStreamViewState extends State<ListenStethoStreamView> {

  ListenStethoStreamController controller=Get.put(ListenStethoStreamController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
controller.uhidC.text=widget.uhid.toString();
    controller.update();
    await controller.webSocketConnect(context);

  }


  @override
  void dispose() {
    Get.delete<ListenStethoStreamController>();
    controller.subscription!.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    UserRepository  userRepository = Provider.of<UserRepository>(context, listen: true);

  return SafeArea(
        child: GetBuilder(
            init: ListenStethoStreamController(),
            builder: (_) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Listen'),
                  Text(controller.uhidC.text.toString(),
                    style: MyTextTheme.smallBCN,)
                ],
              ),
foregroundColor: AppColor.black,
actions: [
  Padding(
  padding: const EdgeInsets.all(8.0),
  child: SizedBox(width: 110,
      child: MyButton(title: controller.getIsWebSocketConnected? 'Connected': 'Connect',
        color: Colors.orange,
        onPress: () async {

          await controller.webSocketConnect(context);


        },)),
),
],
              ),
              body:WillPopScope(
                onWillPop: () {
                   Get.back();
                  controller.subscription!.cancel();
                  controller.player.stopPlayer();
                  Get.delete<ListenStethoStreamController>();
                  return  Future.value(false);
                },
                child: Column(
                  children: [


                       Stack(
                         children: [
                           Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.width,
                               child: Image.asset('assets/graph.png',
                                 height: MediaQuery.of(context).size.width,
                                 color: Colors.grey.shade300,fit: BoxFit.fitWidth,)),
                           Positioned(
                             left: 0,right: 0,bottom: 0,top: 0,
                             child: Sparkline(fillColor: Colors.grey,
                               // pointsMode: PointsMode.last,
                              gridLineAmount: 50,gridLineColor: Colors.grey,gridLineWidth: 3,
                    fillMode:FillMode.none ,
                               lineWidth: 3 ,lineColor: Colors.blue,
                               data: controller.getGraphData.toList().length < 50
                                   ? controller.getGraphData.toList()
                                   : controller.getGraphData
                                   .toList()
                                   .getRange(
                                   (controller.getGraphData.toList().length -
                                       50),
                                   controller.getGraphData.toList().length)
                                   .toList(),
                             ),
                           ),
                         ],
                       ),

                    SizedBox(height: 35,),

                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(101),
                          border: Border.all(width: 1,color: Colors.grey)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(101)),
                        child:InkWell(
                          onTap: (){
                            // controller.player.play();




                            if(controller.getIsPlay){
                              // controller.player.stopPlayer();
                              controller.updateIsPlay = false;
                            }
                            else{

                              controller.updateIsPlay = true;

                              // controller.player.startPlayerFromStream();
                            }
                          },
                          child: Icon(
                          controller.getIsPlay?
                          Icons.stop:  Icons.play_arrow_rounded,color: Colors.white,size: 50,),
                        )


                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ));
  }
}
