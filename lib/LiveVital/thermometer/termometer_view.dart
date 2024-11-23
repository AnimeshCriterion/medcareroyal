import 'dart:math';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:medvantage_patient/LiveVital/live_vital_controller.dart';
import 'package:medvantage_patient/LiveVital/thermometer/thermometer_vm.dart';
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../app_manager/app_color.dart';
import '../../app_manager/theme/text_theme.dart';
import '../../medcare_utill.dart';


String tempVar = '0.0';

class ThermometerView extends StatefulWidget {
  final BluetoothDevice device;
    final String deviceName;

  const ThermometerView(
      {Key? key, required this.device, required this.deviceName})
      : super(key: key);

  @override
  State<ThermometerView> createState() => _ThermometerViewState();
}

class _ThermometerViewState extends State<ThermometerView> {
  LiveVitalModal liveVitalModal=LiveVitalModal();


  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics.map((c) {
              // dPring('nnnnnnnnnnnnnnnn${c.value}');
              return CharacteristicTile(
                characteristic: c,
                onReadPressed: () => c.read(),
                onWritePressed: () async {
                  await c.write(_getRandomBytes(), withoutResponse: true);
                  await c.read();
                },
                onNotificationPressed: () async {
                  await c.setNotifyValue(!c.isNotifying);
                  await c.read();
                },
                descriptorTiles: c.descriptors
                    .map(
                      (d) => DescriptorTile(
                        descriptor: d,
                        onReadPressed: () => d.read(),
                        onWritePressed: () => d.write(_getRandomBytes()),
                      ),
                    ).toList(),
              );
            }).toList(),
          ),
        )
        .toList();
  }

  get(){

    ThermometerVM thermometerVM =
    Provider.of<ThermometerVM>(context, listen: false);
    thermometerVM.updateGetmyv='';
    thermometerVM.updateGettmpType='';
  }
@override
  void initState() {
get();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThermometerVM thermometerVM =
        Provider.of<ThermometerVM>(context, listen: true);
    return Container(
      color: AppColor.primaryColor,
      child: SafeArea(
        child: Scaffold(
            appBar:CustomAppBar(

              title: 'Thermometer',
            ),
            body: Visibility(
              visible:
                  widget.device.name.toString().substring(0,12) == widget.deviceName.toString(),
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children:   [
                  //       MyButton2(title: 'Connect',width: 150,onPress: (){
                  //          widget.device.connect();
                  //       },),
                  //       const MyButton2(title: 'Save',width: 150,),
                  //     ],
                  //   ),
                  // ),

                  StreamBuilder<BluetoothConnectionState>(
                    stream: widget.device.state,
                    initialData: BluetoothConnectionState.connecting,
                    builder: (c, snapshot) => ListTile(
                      leading: (snapshot.data == BluetoothConnectionState.connected)
                          ? const Icon(Icons.bluetooth_connected)
                          : const Icon(Icons.bluetooth_disabled),
                      title: Text(
                          'Device is ${snapshot.data.toString().split('.')[1]}.'),
                      subtitle: Text('${widget.device.id}'),
                      trailing: StreamBuilder<bool>(
                        stream: widget.device.isDiscoveringServices,
                        initialData: false,
                        builder: (c, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.toString() == '0') {
                              if (snapshot.data
                                      .toString()
                                      .split('.')[1]
                                      .toString() !=
                                  'disconnected') {
                                widget.device.discoverServices();
                              }
                            }
                          }

                          return IndexedStack(
                            index: snapshot.data! ? 1 : 0,
                            children: <Widget>[
                              IconButton(
                                icon: (snapshot.data??0)== 1? const Icon(Icons.download,size: 30,):
                                const Icon(Icons.file_download_off_sharp,size: 30),
                                onPressed: () =>
                                    widget.device.discoverServices(),
                              ),
                              const IconButton(
                                icon: SizedBox(
                                  width: 18.0,
                                  height: 18.0,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.grey),
                                  ),
                                ),
                                onPressed: null,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  // StreamBuilder<int>(
                  //   stream:  widget.device.mtu,
                  //   initialData: 0,
                  //   builder: (c, snapshot)
                  //     {
                  //       if(snapshot.hasData){
                  //         widget.device.requestMtu(223);
                  //       }
                  //       return
                  //         ListTile(
                  //           title: const Text('MTU Size'),
                  //           subtitle: Text('${snapshot.data} bytes'),
                  //           trailing: IconButton(
                  //             icon: const Icon(Icons.edit),
                  //             onPressed: () =>  widget.device.requestMtu(223),
                  //           ),
                  //         );
                  //     }
                  //
                  //
                  // ),

                  //
                  // Stack(
                  //   children: [
                  //     Image.asset('assets/thermameter1.png',
                  //         height: MediaQuery.of(context).size.height / 2.7,
                  //         fit: BoxFit.fitHeight),
                  //     Positioned(
                  //       top: 110,
                  //       left: 180,
                  //       child: Column(
                  //         children: [
                  //           Text(
                  //             thermometerVM.getTempValue.toString(),
                  //             style: MyTextTheme().largeBCN.copyWith(
                  //                 fontSize: 35, color: AppColor.black),
                  //           )
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),

                  StreamBuilder<List<BluetoothService>>(
                    stream: widget.device.services,
                    initialData: const [],
                    builder: (c, snapshot) {
                      // for(int i=0;i<snapshot.data!.length;i++){
                      //   for(int j=0;j<snapshot.data!.length;j++){
                      //     dPring('nnnnnnnn'+snapshot.data![i].characteristics[j].uuid.toString());
                      //   }
                      // }
                      return Column(
                        children: _buildServiceTiles(snapshot.data ?? []),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile(
      {Key? key, required this.service, required this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.length > 0) {
      return Visibility(
          visible: service.uuid
                  .toString()
                  .toUpperCase()
                  .substring(4, 8)
                  .toString() ==
              '1809',
          child: Column(
            children: characteristicTiles,
          )

          // ExpansionTile(
          //   title: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       const Text('Service'),
          //       Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
          //           style: TextStyle( color: Theme.of(context).textTheme.caption?.color))
          //     ],
          //   ),
          //   children: characteristicTiles,
          // ),

          );
    } else {
      return ListTile(
        title: const Text('Service'),
        subtitle:
            Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
      );
    }
  }
}

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;
  final VoidCallback? onNotificationPressed;

  const CharacteristicTile(
      {Key? key,
       required this.characteristic,
        required  this.descriptorTiles,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed})
      : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  LiveVitalModal liveVitalModal=LiveVitalModal();
  @override
  Widget build(BuildContext context) {
    String tempv='';


    ThermometerVM thermometerVM =
        Provider.of<ThermometerVM>(context, listen: true);
    return StreamBuilder<List<int>>(
      stream: widget.characteristic.value,
      initialData: widget.characteristic.lastValue,
      builder: (c, snapshot)
    {



      var c;
      final value = snapshot.data;
      if (widget.characteristic.uuid
          .toString()
          .toUpperCase()
          .substring(4, 8)
          .toString() ==
          '2A1C') {

        dPrint("ssssssssssssssssssssss"+value.toString());

        if (value!.isNotEmpty && value.toString() != '') {

          dPrint("ssssssssssssssssssssss");
          dPrint(value);
          c = value[2].toRadixString(16) + value[1].toRadixString(16);
          dPrint('cccccccccccc' + c.toString());
          final number = int.parse(c, radix: 16);

          for (int i = 0; i < number
              .toString()
              .length - 1; i++) {
            dPrint(number.toString()[i].toString());
            tempv = tempv + number.toString()[i];
          }
          tempv = tempv + '.' + number.toString()[number
              .toString()
              .length - 1];
        }

        else {
          dPrint("ddddddddddddddddd");
          dPrint(value);
        }
        if (tempv.toString() != '') {
          var typet = value[0].toRadixString(2);

          thermometerVM.updateGetmyv='';
          thermometerVM.updateGettmpType='';


          thermometerVM.updateGetmyv = tempv;
          thermometerVM.updateGettmpType = typet.toString()[typet
              .toString()
              .length - 1];

           dPrint('tttttttttttt111111' );
          // temp2=tempv;
        }

        dPrint('tttttttttttt' + tempv.toString());
      }



      return

        Visibility(
          visible: widget.characteristic.uuid
              .toString()
              .toUpperCase()
              .substring(4, 8)
              .toString() ==
              '2A1C',
          child: Column(
            children: [
              // Text(value.toString()),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                      PrimaryButton(
                        width: 150,
                      onPressed: () {

                        widget.onNotificationPressed!();

                        // (context as Element).reassemble();

                        },
                      title: 'Fetch Data',
                    ),
                  PrimaryButton(
                        width: 150,
                      onPressed: () async {

                      await  liveVitalModal.addVitalsData(context,tmp: thermometerVM.getmyv.toString());

                        },
                      title: 'Save',
                    ),


                ],
              ),
              const SizedBox(height: 30,),
              Stack(
                children: [
                  Image.asset('assets/thermometer.webp',
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 1.7,
                      fit: BoxFit.fitHeight),
                  Positioned(
                    top: 110,
                    left: 150,
                    child: Row(
                      children: [
                        Text(
                          thermometerVM.getmyv.toString()+' ',
                          style: MyTextTheme
                              .largeBCN
                              .copyWith(fontSize: 30, ),
                        ),
                        Visibility(
                            visible: thermometerVM.gettmpType.toString()!='' ,
                            child: RichText(
                              text: TextSpan(
                                  children: [

                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: const Offset(2, -20),
                                        child: Text(
                                          'o',
                                          //superscript is usually smaller in size
                                          textScaleFactor: 0.9,
                                          style:  MyTextTheme
                                              .smallBCB,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text:  thermometerVM.gettmpType.toString() == '0' ? 'C' : 'F',
                                      style:  MyTextTheme
                                          .largeBCN
                                          .copyWith(fontSize: 26, ),
                                    )

                                  ]),
                            )

                          // Text(
                          //   thermometerVM.gettmpType.toString() == '0' ? ' C' : ' F',
                          //   style: MyTextTheme()
                          //       .largeBCN
                          //       .copyWith(fontSize: 35, color: AppColor.black),
                          // ),
                        )
                      ],
                    )

                    // Row(
                    //   children: [
                    //
                    //     TextButton(
                    //       onPressed: (){
                    //       (context as Element).reassemble();
                    //     }, child:  Row(
                    //       children: [
                    //         Text(
                    //           thermometerVM.getmyv.toString()+' ',
                    //           style: MyTextTheme()
                    //               .largeBCN
                    //               .copyWith(fontSize: 35, color: AppColor.black),
                    //         ),
                    //         Visibility(
                    //           visible: thermometerVM.gettmpType.toString()!='' ,
                    //           child: RichText(
                    //             text: TextSpan(
                    //                 children: [
                    //
                    //               WidgetSpan(
                    //               child: Transform.translate(
                    //                 offset: const Offset(2, -20),
                    //                 child: Text(
                    //                   'o',
                    //                   //superscript is usually smaller in size
                    //                   textScaleFactor: 0.9,
                    //                   style:  MyTextTheme()
                    //                       .smallBCB,
                    //                 ),
                    //               ),
                    //             ),
                    //               TextSpan(
                    //                   text:  thermometerVM.gettmpType.toString() == '0' ? 'C' : 'F',
                    //                   style:  MyTextTheme()
                    //                         .largeBCN
                    //                         .copyWith(fontSize: 35, color: AppColor.black),
                    //               )
                    //
                    //             ]),
                    //           )
                    //
                    //           // Text(
                    //           //   thermometerVM.gettmpType.toString() == '0' ? ' C' : ' F',
                    //           //   style: MyTextTheme()
                    //           //       .largeBCN
                    //           //       .copyWith(fontSize: 35, color: AppColor.black),
                    //           // ),
                    //         )
                    //       ],
                    //     ),),
                    //     // Text(
                    //     //   tempType.toString() == '0' ? 'C' : 'F',
                    //     //   style: MyTextTheme()
                    //     //       .largeBCN
                    //     //       .copyWith(fontSize: 35, color: AppColor.black),
                    //     // )
                    //   ],
                    // ),
                  ),


                ],
              ),
            ],
          ));

      },
    );
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;

  const DescriptorTile(
      {Key? key,
      required this.descriptor,
      this.onReadPressed,
      this.onWritePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
              // style:
              //     TextStyle(color: Theme.of(context).textTheme.caption?.color
              //     )
          )
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
        stream: descriptor.value,
        initialData: descriptor.lastValue,
        builder: (c, snapshot) => Text(snapshot.data.toString()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onReadPressed,
          ),
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onWritePressed,
          )
        ],
      ),
    );
  }
}
