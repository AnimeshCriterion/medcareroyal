
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:flutter/material.dart';

import '../../app_manager/app_color.dart';
import '../../app_manager/widgets/buttons/custom_ink_well.dart';

class DashboardGridList extends StatelessWidget {
  final List gridList;
  final Function onTapEvent;

  const DashboardGridList({Key? key, required this.gridList, required this.onTapEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: gridList.length,
      gridDelegate:
        SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          mainAxisExtent: 140,
          childAspectRatio:MediaQuery.of(context).orientation == Orientation.landscape? 6/ 10:6 / 8.9,
          crossAxisSpacing: 10,
         ),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            CustomInkWell(
              onTap: () {
                onTapEvent(
                    context,
                    gridList[index]['navigateKey']
                        .toString());
              },
              child: Container(

                decoration:
                BoxDecoration(color: AppColor.greyVeryVeryLight,borderRadius: BorderRadius.circular(5)),
                child: Image.asset(gridList[index]['icons']
                      .toString(),
                  height: 75,
                    fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(height: 2,),
            Text(gridList[index]['title']
                  .toString(),style: MyTextTheme.mediumGCB.copyWith(color: AppColor.greyDark),
              textAlign: TextAlign.center,
            )
          ],
        );
      },
    );
  }
}
