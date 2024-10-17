import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field.dart';
import 'package:medvantage_patient/remote_dashboard/remote_dashboard_controller.dart';

import '../LiveVital/pmd/my_text_theme.dart';
import '../app_manager/app_color.dart';
class RemoteDashboardView extends StatefulWidget {
  const RemoteDashboardView({Key? key}) : super(key: key);

  @override
  State<RemoteDashboardView> createState() => _RemoteDashboardViewState();
}

class _RemoteDashboardViewState extends State<RemoteDashboardView>
    with SingleTickerProviderStateMixin {
  RemoteDashboardController controller = Get.put(RemoteDashboardController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
    controller.animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller.animationController.repeat(reverse: true);
    await controller.connectServer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:  controller.pageColor,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: controller.pageColor,
        body: GetBuilder(
            init: controller,
            builder: (_) {
              return Column(
                children: [

                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back,color: AppColor.white,),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text('RMD',style: MyTextTheme().mediumBCB.copyWith(fontSize: 16),)
                    ],
                  ),

                  // TextButton(onPressed: (){
                  //   controller.connectServer();
                  // }  , child: const Text(
                  //   'connectServer'
                  // )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 45,
                        child: PrimaryTextField(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.search,
                            ),
                            onPressed: () {},
                          ),

                          controller:controller.searchC,
                          hintText: 'Search Patient',
                          onChanged: (val) {
                            controller.update();
                            setState(() {});
                          },
                        ),
                      ),
                    ),


                  Wrap(
                    children: [
                      Wrap(
                        children: List.generate(
                            controller.colorCodes.length,
                            (index) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: controller
                                                .colorCodes[index].color,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(5))),
                                      ),
                                    ),
                                    Text(
                                      controller.colorCodes[index].title
                                          .toString(),
                                      style: MyTextTheme().mediumBCB,
                                    ),
                                  ],
                                )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.showVitals
                                  ? 'Vital Details'
                                  : "Other Details",
                              style: MyTextTheme().mediumBCB,
                            ),
                            Switch(
                              value: controller.showVitals,
                              onChanged: (val) {
                                controller.onPressSwitch();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Center(
                      child: Container(
                        color: controller.pageColor,
                        child: GetBuilder(
                            init: RemoteDashboardController(),
                            builder: (_) {
                              return Container(
                                child: Text('nnn'),
                              );

                            }),
                      ),
                    ),
                  ),
                ],
              );
            }),
      )),
    );
  }
}
