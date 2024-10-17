


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app_manager/app_color.dart';
import '../../../../app_manager/my_button.dart';
import '../../../../app_manager/theme/text_theme.dart';
import '../../stethoscope_controller.dart';
import '../stetho_controller.dart';

viewAllPIDModule(context) {
  StethoscopeController controller=Get.put(StethoscopeController());
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          alignment: Alignment.center,
          title: Text("Select Member"),
          content:  Container(
            height: 250,
            width: MediaQuery.of(context).size.width/1.2,
            child: Center(
              child: GetBuilder(
                  init: StethoscopeController(),
                  builder: (_) {
                    return Material(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.getMemberList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var data=controller.getMemberList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      controller.pidTextC.value.text=data['pid'].toString();
                                      controller.update();
                                       Get.back();
                                    },
                                    child: Card(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Text(data['name'].toString(),style: MyTextTheme.mediumBCB,),
                                            SizedBox(width: 10,),
                                            Text('(${data['pid'].toString()})',style: MyTextTheme.mediumBCB,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },

                            ),
                          )
                        ],
                      ),
                    );

                  }),
            ),
          ),
          actions: <Widget>[
            MyButton(title: 'Close',color: AppColor.orange,onPress: (){
               Get.back();
            },)
          ],
        );
      }
  );
  ;}