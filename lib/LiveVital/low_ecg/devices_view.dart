
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'ecg_view.dart';
import 'history.dart';

class MyAllDevicesView extends StatefulWidget {
  const MyAllDevicesView({Key? key}) : super(key: key);

  @override
  State<MyAllDevicesView> createState() => _AllDevicesViewState();
}

class _AllDevicesViewState extends State<MyAllDevicesView> {



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(

            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: Text("Lead II ECG"),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // ECG electrodes image
               Padding(
                 padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                 child: Container(
                   height: MediaQuery.of(context).size.height/3.5,
                   child: Image.asset('assets/ecg_lead_II.png',
                     fit: BoxFit.fill,),
                 ),
               ),

                // About electrodes connecting detail
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Connect the electrodes as shown in the figure above",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14),
                  ),
                ),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Start test button
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/4.4 : MediaQuery.of(context).size.width/2.5,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Get.to(ECGView());
                          },
                          icon: Icon(Icons.play_arrow, size: 26, color: Colors.white),
                          label: Text("Start Test",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ),

                    // History button
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/4.4 : MediaQuery.of(context).size.width/2.5,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Get.to(ReportHistory());
                          },
                          icon: Icon(Icons.history, size: 26, color: Colors.white),
                          label: Text("History",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
