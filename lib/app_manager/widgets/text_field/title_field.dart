



import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';


class TitleField extends StatelessWidget {
  final String title;
  final Widget child;
  const TitleField({Key? key,
  required this.title,
  required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: MyTextTheme.mediumBCB,),
        const SizedBox(height: 5,),
        child
      ],
    );
  }
}


class SmallTitleField extends StatelessWidget {
  final String title;
  final Widget child;
  const SmallTitleField({Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: MyTextTheme.smallBCB,),
        const SizedBox(height: 1,),
        child
      ],
    );
  }
}
