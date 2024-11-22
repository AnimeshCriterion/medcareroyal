import 'package:medvantage_patient/app_manager/alertdialog/my_alert_dialog.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import '../../../Modal/attribute_data_modal.dart';
import '../../../Modal/selected_symptoms.dart';
import '../../../Modal/symptoms_problem_data_modal.dart';
import '../../../ViewModal/symptoms_tracker_view_modal.dart';
import '../../../app_manager/app_color.dart';
import '../../../app_manager/widgets/buttons/custom_ink_well.dart';
import '../../../app_manager/widgets/text_field/primary_text_field.dart';
import '../../../common_libs.dart';

ShowSymptomsAttributeDataShow(context) {
  AlertDialogue2().show(context, "", "", newWidget:
  Consumer<SymptomsTrackerViewModal>(
      builder: (context, symptomtrackerVM, _) {

        List selectedAttribute=symptomtrackerVM.getSelectedSymptomAttribute.where((element) =>
        element.organ!.id.toString()==symptomtrackerVM.getSelectedSymptomProblem.problemId.toString()).toList();

        return Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                child: Row(
                  children: [
                    Text(
                      "Attribute List",
                      style: MyTextTheme.mediumGCB,
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: () {
                           Get.back();
                        },
                        icon: Icon(Icons.clear))
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PrimaryTextField(
                  controller: symptomtrackerVM.searchC,
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Disease',
                  onChanged: (val) async {},
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:  symptomtrackerVM.getSymptomsAttributeList.length,
                  itemBuilder: (BuildContext context, int index) {

                    AttributeDataModal symptomData = symptomtrackerVM.getSymptomsAttributeList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(symptomData.attributeName.toString(),style: MyTextTheme.mediumGCB.copyWith(fontSize: 16)  ,),
                        ),
                        StaggeredGrid.count(
                          crossAxisCount: 2,
                          children: List.generate(symptomData.attributeDetails!.length,
                                  (index2) {
                                AttributeDetailsDataModal attributeDetailsData = symptomData.attributeDetails![index2];

                                return CustomInkWell(
                                  onTap: () {
                                    symptomtrackerVM.OnPressedSelectAttributeSymptom(attributeData:attributeDetailsData);
                                    dPrint('nnnnnnnnnnn');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                            backgroundColor:symptomtrackerVM.getSelectedSymptomAttribute.map((e) => e.id.toString()).toList().contains(attributeDetailsData.attributeValueId.toString())?
                                          AppColor.primaryColor: AppColor.red,
                                            radius: 10),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(child: Text(attributeDetailsData.attributeValue.toString()))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    );
                  },),
              ),
              Visibility(
                visible:  selectedAttribute.isNotEmpty,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:10,top: 10),
                            child: Text("Attribute List",style: MyTextTheme.mediumGCB,),
                          ),

                          Wrap(children:  List.generate(selectedAttribute.length, (index2) {
                            SelectedSymptoms selectedSymptomsData =selectedAttribute[index2];
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                    color:   AppColor.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Wrap(crossAxisAlignment: WrapCrossAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Text(
                                            selectedSymptomsData.symptoms.toString(),
                                            style: MyTextTheme.mediumWCB,
                                          )),
                                      CustomInkWell(onTap: (){

                                        symptomtrackerVM.deleteSymptomsData(index2);
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

                          )]
                    ),
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: PrimaryButton(color: AppColor.orange,
                    onPressed: (){
                   Get.back();
                    }, title: "Ok"),
              )
                  // Expanded(
              //   child: SingleChildScrollView(
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              //       child: StaggeredGrid.count(
              //         crossAxisCount: 2,
              //         children: List.generate(
              //             symptomtrackerVM.getSymptomsAttributeList.length,
              //             (index) {
              //           SymptomsTrackerViewModal symptomtrackerVM =
              //               Provider.of<SymptomsTrackerViewModal>(context,
              //                   listen: false);
              //           AttributeDataModal symptomData =
              //               symptomtrackerVM.getSymptomsAttributeList[index];
              //
              //           return InkWell(
              //             onTap: () {},
              //             child: Padding(
              //               padding: const EdgeInsets.all(5),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   CircleAvatar(
              //                       backgroundColor:
              //                           AppColor.red,
              //                       radius: 10),
              //                   const SizedBox(
              //                     width: 5,
              //                   ),
              //                   Expanded(
              //                       child: Text(symptomData.attributeName.toString()))
              //                 ],
              //               ),
              //             ),
              //           );
              //         }),
              //       ),
              //     ),
              //   ),
              // ),
            ],),);
      }));
}
