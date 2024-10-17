



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import '../../app_manager/app_color.dart';
import '../../app_manager/navigator.dart';
import '../../app_manager/theme/theme_provider.dart';
import '../../common_libs.dart';

class Dose extends StatefulWidget {
  const Dose({
    super.key,
  });

  @override
  State<Dose> createState() => _DoseState();
}

class _DoseState extends State<Dose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VitalioColors.greyBG,
      body: InkWell(
        onTap: (){
          MyNavigator.push(context, const Connection());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('NEXT DOSE',style: MyTextTheme.mediumBCN.copyWith(fontSize: 16,fontWeight: FontWeight.w600,color: VitalioColors.greyLight),textAlign: TextAlign.center,),
            const SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(25),
                          alignment: Alignment.center,
                          width: 304,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child:  Column(
                            children: [
                              const SizedBox(height: 60),
                              Text(
                                'Vitamin',style: MyTextTheme.veryLargeBCB.copyWith(fontSize:26),
                              ),
                               Text('Take on an empty stomach',style: MyTextTheme.largeBCB.copyWith(color: VitalioColors.greyBlue,fontSize: 18),),
                              const SizedBox(height: 20),
                               Text('1 pill',style: MyTextTheme.largeBCB.copyWith(color: VitalioColors.greyBlue,fontSize: 18),),
                              const SizedBox(height: 60),
                               Row(
                                 children: [
                                   Text('Antidepressant',style: MyTextTheme.mediumBCB.copyWith(fontWeight: FontWeight.w600,fontSize: 16),),
                                 ],
                               ),
                              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut convallis metus eu enim vestibulum placerat. Nunc ac tellus metus. Duis suscipit tortor vel leo ullamcorper, eu facilisis mauris feugiat. Vivamus pretium lacinia lorem.',
                                textAlign: TextAlign.start,
                                softWrap: true,
                                style: MyTextTheme.mediumBCN.copyWith(color: VitalioColors.greyText2),
                              ),
                              Row(
                                children: [
                                  Text('More',style:MyTextTheme.largeBCN.copyWith(color: VitalioColors.primaryBlue,fontSize: 16),),
                                ],
                              )

                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                          shape: BoxShape.circle,color: Colors.white
                        ),
                        child: Icon(Icons.check,size: 50,color: Colors.indigoAccent.shade700)),
                      ],
                    ),
                  ),
                  Positioned(
                      child: Center(child: Image.asset('assets/A Vitalio/dosePill.png',width:140,))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Connection extends StatefulWidget {
  const Connection({super.key});

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: VitalioColors.greyBG,
        body: Column(
          children: [
            Row(
              children: [
                 InkWell(
                  onTap: (){
                    MyNavigator.push(context, const Connection());
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                ),
                Text('Connection',style: MyTextTheme.largeBCB,),
              ],
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                height:56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: VitalioColors.primaryBlue),
                  color: Colors.white
                ),
                child: Text('Add Vital Manually',style: MyTextTheme.largeBCN.copyWith(color: VitalioColors.primaryBlue),),
              ),
            )
          ],
        ),
      ),
    );
  }
}

