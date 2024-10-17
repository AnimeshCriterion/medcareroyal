import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medvantage_patient/LiveVital/ptt/ptt_view.dart';

class DeviceView extends StatefulWidget {
  const DeviceView({super.key});

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pulse Transit Time'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.05 : MediaQuery.of(context).size.width/1.2,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Get.to(PulseTransitTimeView());
              },
              child: Text('Click Pulse Transit Time App',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
