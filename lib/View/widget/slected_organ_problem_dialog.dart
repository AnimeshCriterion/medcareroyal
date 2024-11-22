import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../Modal/organ_system_data_modal.dart';
import '../../Modal/selected_symptoms.dart';
import '../../ViewModal/fullbody_checkup_viewmodal.dart';
import '../../app_manager/alertdialog/my_alert_dialog.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/widgets/buttons/custom_ink_well.dart';
import '../../common_libs.dart';

import 'package:get/get.dart';
 ShowSymptomDataShow(context,) {
  AlertDialogue2().show(context, "", "", newWidget:
  Consumer<FullBodyCheckupDataModal>(builder: (context, bodycheckupVM, _) {
        return Container(
        height: 100,
        decoration: BoxDecoration(
            color: AppColor.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                child: Row(
                  children: [
                    Text(
                      "Disease List",
                      style: MyTextTheme.mediumBCB,
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: () {
                           Get.back();
                          // modal.clearSelectedList();
                        },
                        icon: const Icon(
                          Icons.clear,
                        )),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PrimaryTextField(
                  controller: bodycheckupVM.searchC,
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Disease',

                  // controller: modal.controller.searchC.value,
                  onChanged: (val) async {
                    // await bodycheckupVM.getSymptomByProblem(context);
                    // setState(() {});
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      children: List.generate(bodycheckupVM.getOrganList.length,
                          (index) {
                        FullBodyCheckupDataModal bodycheckupVM =
                            Provider.of<FullBodyCheckupDataModal>(context,
                                listen: false);
                        OrganSymptomDataModal organData = bodycheckupVM.getOrganList[index];

                        return CustomInkWell(
                          onTap: () {

                              // bodycheckupVM.onPressedSelectedDisease(index, organData);
                              bodycheckupVM.selectOrganSymptomList( organData);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundColor:
                                    bodycheckupVM.getSelectedSymptomsList.map((e) => e.id).toList().contains(organData.id.toString()) ?
                                    AppColor.primaryColor : AppColor.red,
                                    radius: 10),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: Text(organData.symptoms.toString()))
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              // Divider(color: AppColor.greyVeryLight,),

              Visibility(
                visible: bodycheckupVM.getSelectedSymptomsList.isNotEmpty,
                child: Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10,top: 10),
                        child: Text("Disease List",style: MyTextTheme.mediumGCB,),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(children:  List.generate(
                              bodycheckupVM.getSelectedSymptomsList.length, (index) {
                            SelectedSymptoms selectedDiseaseData =bodycheckupVM.getSelectedSymptomsList[index];
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                    color: AppColor.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Wrap(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            selectedDiseaseData.symptoms.toString(),
                                            style: MyTextTheme.mediumWCB,
                                          )),
                                      InkWell(onTap: (){

                                          bodycheckupVM.deleteSymptoms(index);
                                      },
                                          child: Icon(
                                            Icons.close,
                                            color: AppColor.white,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),

                         )
                      ),
                      )]
                  ),
                ),
              ),

              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: PrimaryButton(
                  title: "Ok",
                  color: AppColor.orange,
                  onPressed: () {
                     Get.back();
                    // dPring('nnnnnn' +
                    //     bodycheckupVM.getOrganList[0].isSelected.toString());
                  },
                ),
              )
            ]));
  }));
}
