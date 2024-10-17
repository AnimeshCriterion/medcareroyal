import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/back_button.dart';

import '../theme/text_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Color? color;
  final Color? titleColor;
  final Color? primaryBackColor;
  // final color?

  const CustomAppBar({
    Key? key,
    this.title,
    this.actions, this.color, this.titleColor, this.primaryBackColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return AppBar(
      leading: PrimaryBackButton(color:primaryBackColor ?? AppColor.grey),
      actions: actions,
      centerTitle: false,
      elevation: 0,
      backgroundColor:color==null? AppColor.white: color,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title ?? '',
          style:titleColor==null? MyTextTheme.largeGCB.copyWith(fontSize: 17):
          MyTextTheme.largeGCB.copyWith(fontSize: 17,color: titleColor),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
