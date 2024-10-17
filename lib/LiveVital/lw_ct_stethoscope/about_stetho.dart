
import 'package:flutter/material.dart';

import '../../app_manager/theme/text_theme.dart';

class AboutStetho extends StatefulWidget {
  const AboutStetho({super.key});

  @override
  State<AboutStetho> createState() => _AboutStethoState();
}

class _AboutStethoState extends State<AboutStetho> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: SafeArea(

          child: Scaffold(
            appBar: AppBar(title: const Text('About Stethoscope')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('1.',style: MyTextTheme.mediumBCB,),
                  SizedBox(  width: 5, ),
                  Text('Scan your Device',style: MyTextTheme.mediumBCB,),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('2.',style: MyTextTheme.mediumBCB,),
                  SizedBox(  width: 5, ),
                  Expanded(child: Text('Find your Stethoscope Device and click on connect button',style: MyTextTheme.mediumBCB,)),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                children: [
                  Text('3.',style: MyTextTheme.mediumBCB,),
                  SizedBox(  width: 5, ),
                  Text('update your Wifi',style: MyTextTheme.mediumBCB,),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                children: [
                  Text('4.',style: MyTextTheme.mediumBCB,),
                  SizedBox(  width: 5, ),
                  Text('Click on Listen Stethoscope Audio ',style: MyTextTheme.mediumBCB,),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                children: [
                  Text('5.',style: MyTextTheme.mediumBCB,),
                  SizedBox(  width: 5, ),
                  Text('Select member or enter patient detail ',style: MyTextTheme.mediumBCB,),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                children: [
                  Text('6.',style: MyTextTheme.mediumBCB,),
                  SizedBox(  width: 5, ),
                  Text('Click on Listen Button',style: MyTextTheme.mediumBCB,),
                ],
              ),


            ],
          ),
        ),
      )),
    );
  }
}
