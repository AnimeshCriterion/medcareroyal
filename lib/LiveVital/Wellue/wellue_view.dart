import 'dart:async';
import 'dart:ui';
import 'package:medvantage_patient/LiveVital/Wellue/wellue_view_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../app_manager/widgets/coloured_safe_area.dart';
import '../../theme/theme.dart';


class WellueView extends StatefulWidget {
  const WellueView({Key? key}) : super(key: key);

  @override
  State<WellueView> createState() => _WellueViewState();
}

class _WellueViewState extends State<WellueView>with SingleTickerProviderStateMixin {


  Timer? timer;


  get() async {

    WellueViewModal yonkerVM =
        Provider.of<WellueViewModal>(context, listen: false);

    yonkerVM.clearData();
    await yonkerVM.getDevices();

    timer = Timer.periodic(
        const Duration(seconds: 15),
            (timer) async {
              yonkerVM.CheckUserConnection();
          /// callback will be executed every 1 second, increament a count value
          /// on each callback

              if(yonkerVM.getActiveConnection){
                await yonkerVM.saveVital(context, );
              }
          // tempList.add(val);

        }
    );
  }

  late AnimationController _animationController;
  @override
  void initState() {
    get();
    _animationController=AnimationController(vsync: this,duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
    _animationController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    WellueViewModal yonkerVM =
        Provider.of<WellueViewModal>(context, listen: true);
    return ColoredSafeArea(
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(backgroundColor:  themeChange.darkTheme
                  ? AppColor.darkshadowColor1
                  : AppColor.lightshadowColor1,
                title: const Text('Wellue Oximeter'),
                actions: [
                  Visibility(
                    visible: yonkerVM.getIsDeviceFound,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(foregroundColor: Colors.white,backgroundColor: Colors.white),
                          onPressed: () async {
                            yonkerVM.getIsDeviceConnected
                                ?   yonkerVM.disConnected()
                                : await yonkerVM.onPressedConnect(context);

                            yonkerVM.ckeckDeviceConnection();
                          },
                          child: Text(
                             !yonkerVM.getIsDeviceConnected
                                ? 'Connect'
                                : 'Disconnect',
                            style:MyTextTheme.mediumPCB,
                          )),
                    ),
                  ),
                ],
              ),
              body: WillPopScope(
                onWillPop: (){
                 return yonkerVM.onPressedBack(context);
                },
                child: Container( decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      themeChange.darkTheme
                          ? AppColor.darkshadowColor1
                          : AppColor.lightshadowColor1,
                      themeChange.darkTheme
                          ? AppColor.darkshadowColor1
                          : AppColor.lightshadowColor1,
                      themeChange.darkTheme ? AppColor.black :
                      AppColor.lightshadowColor2,
                    ],
                  ),
                ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: !yonkerVM.getIsDeviceFound
                        ? yonkerVM.getIsScanning
                            ? scanDevice()
                            : connectDevice()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(10, 10),
                                        color: Colors.grey,spreadRadius: 10,
                                        blurRadius: 20,
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(20, 20),
                                        topRight: Radius.elliptical(20, 20),
                                        bottomLeft: Radius.elliptical(20, 20),
                                        bottomRight: Radius.elliptical(20, 20)),
                                    color: Colors.black87,
                                  ),
                                  height: orientation ? height / 1.6 : height / 1.6,
                                  width: orientation ? width / 1.5 : width / 3,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(3, 0),
                                                        color: Colors.white30,
                                                        spreadRadius: 1,
                                                        blurRadius: 7,
                                                      )
                                                    ],
                                                  ),
                                                  padding: const EdgeInsets.all(2),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                        width: orientation
                                                            ? width / 3.1
                                                            : width / 6,
                                                        child: CustomPaint(
                                                            painter: ArcPainter())),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    SizedBox(
                                                        width: orientation
                                                            ? width / 3.7
                                                            : width / 7,
                                                        child: CustomPaint(
                                                            painter: ArcPainter())),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 15),
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets.fromLTRB(
                                                                    5, 15, 5, 15),
                                                            decoration:
                                                                const BoxDecoration(
                                                                    // boxShadow: const [
                                                                    //   BoxShadow(
                                                                    //     offset: Offset(0, 8),
                                                                    //     color: Colors.white12,
                                                                    //     blurRadius: 20,
                                                                    //   )
                                                                    // ],

                                                                    color: Colors
                                                                        .black54,
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft: Radius
                                                                            .circular(
                                                                                45),
                                                                        topRight:
                                                                            Radius.circular(
                                                                                45),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                45),
                                                                        bottomRight:
                                                                            Radius.circular(
                                                                                45))),
                                                            width: orientation
                                                                ? width / 2
                                                                : width / 3.5,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            22),
                                                                color: Colors.black,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        15,
                                                                        10,
                                                                        15,
                                                                        10),
                                                                child: Column(
                                                                    children: [
                                                                      const Center(
                                                                          child:
                                                                              Text(
                                                                        "Wellue",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                25,
                                                                            color: Colors
                                                                                .white70),
                                                                      )),
                                                                      Expanded(
                                                                          child:
                                                                              Padding(
                                                                        padding: const EdgeInsets
                                                                                .only(
                                                                            top: 10,
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Colors
                                                                                  .white10,
                                                                              borderRadius:
                                                                                  BorderRadius.circular(10)),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                8,
                                                                                8,
                                                                                8,
                                                                                8),
                                                                            child: Column(
                                                                                crossAxisAlignment:
                                                                                    CrossAxisAlignment.start,
                                                                                children: [
                                                                                    const SizedBox(
                                                                                    height: 20,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      RichText(text: const TextSpan(children: [
                                                                                        TextSpan(text: "%"+"Spo",style: TextStyle(color: Colors.blue,fontSize: 24)),
                                                                                        TextSpan(text: '2',
                                                                                            style: TextStyle(
                                                                                                color: Colors.blue,
                                                                                                fontSize: 10,
                                                                                                fontFeatures: [FontFeature.subscripts()]))
                                                                                      ])),
                                                                                      Image.asset(
                                                                                        "assets/battery.webp",
                                                                                        color: Colors.orangeAccent,
                                                                                        height: 20,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    (yonkerVM.getOximeterData.spo2?? '__').toString(),
                                                                                    style: const TextStyle(fontSize: 50, color: Colors.blue,fontWeight: FontWeight.w700),
                                                                                  ),
                                                                                    const SizedBox(
                                                                                    height: 25,
                                                                                  ),
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      const Text(
                                                                                        "PR%",
                                                                                        style: TextStyle(fontSize: 24, color: Colors.blue,),
                                                                                      ),
                                                                                      FadeTransition(opacity:_animationController ,child: const Icon(Icons.favorite,color: Colors.red,size: 22,)),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        (yonkerVM.getOximeterData.pr??'--').toString(),
                                                                                        style: const TextStyle(fontSize: 50, color: Colors.blue,fontWeight: FontWeight.w700),
                                                                                      ),
                                                                                      // Icon(
                                                                                      //   Icons.network_cell,
                                                                                      //   color: Colors.orangeAccent,
                                                                                      // )
                                                                                    ],
                                                                                  ),
                                                                                ]),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.fromLTRB(
                                                                                0,
                                                                                5,
                                                                                0,
                                                                                15),
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              26,
                                                                          backgroundColor:
                                                                              Colors
                                                                                  .white70,
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(50),
                                                                              boxShadow: [
                                                                                yonkerVM.getIsDeviceConnected
                                                                                    ? const BoxShadow(
                                                                                        offset: Offset(0, 0),
                                                                                        color: Colors.blue,
                                                                                        spreadRadius: 10,
                                                                                        blurRadius: 15,
                                                                                      )
                                                                                    : const BoxShadow()
                                                                              ],
                                                                            ),
                                                                            child: ClipRRect(
                                                                                child: CircleAvatar(
                                                                              backgroundColor:
                                                                                  Colors.black,
                                                                              child: IconButton(
                                                                                  onPressed: () {},
                                                                                  icon: Icon(
                                                                                    Icons.ads_click_rounded,
                                                                                    color: yonkerVM.getIsDeviceConnected ? Colors.blue : Colors.white,
                                                                                  )),
                                                                            )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(-3, 0),
                                                        color: Colors.white30,
                                                        spreadRadius: 1,
                                                        blurRadius: 7,
                                                      )
                                                    ],
                                                  ),
                                                  padding: const EdgeInsets.all(2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ))),
    );
  }

  connectDevice() {
    WellueViewModal yonkerVM =
        Provider.of<WellueViewModal>(context, listen: true);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Device Not Found',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 15,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 35,
              ),
            ),
            onPressed: () async {
              await yonkerVM.getDevices();
            },
          ),
        ],
      ),
    );
  }

  scanDevice() {
    return Center(
        child: Lottie.asset('assets/scanning.json', fit: BoxFit.fill));
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black45
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;
    final arc1 = Path();
    arc1.moveTo(size.width * 0.1, size.height * 0.2);
    arc1.arcToPoint(
      Offset(size.width * .8, size.height * .2),
      radius: const Radius.circular(120),
    );

    canvas.drawPath(arc1, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
