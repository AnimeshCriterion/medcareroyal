
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../Localization/app_localization.dart';
import '../../app_manager/navigator.dart';
import 'ct_bp_screen.dart';


class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, required this.result,  })
      : super(key: key);

  final ScanResult result;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            // style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              // style: Theme.of(context).textTheme.caption
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              // style: Theme.of(context)
              //     .textTheme
              //     .caption
              //     ?.apply(color: Colors.black
              // ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization=Provider.of<ApplicationLocalizations>(context,listen: true);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/ctBP.webp',width: 300,),
            const SizedBox(height: 20,),
            PrimaryButton(title: 'View Data',width: 200,onPressed:
            (){
              MyNavigator
                  .push(
                  context,
                  CTBpScreenView(
                      device: result ));
            },)

          ],
        ),
      ),
    );
    //   ExpansionTile(
    //   title: _buildTitle(context),
    //   leading: Text(result.rssi.toString()),
    //   trailing: RaisedButton(
    //     child: Text('CONNECT'),
    //     color: Colors.black,
    //     textColor: Colors.white,
    //     onPressed: (result.advertisementData.connectable) ? onTap : null,
    //   ),
    //   children: <Widget>[
    //     _buildAdvRow(
    //         context, 'Complete Local Name', result.advertisementData.localName),
    //     _buildAdvRow(context, 'Tx Power Level',
    //         '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
    //     _buildAdvRow(context, 'Manufacturer Data',
    //         getNiceManufacturerData(result.advertisementData.manufacturerData)),
    //     _buildAdvRow(
    //         context,
    //         'Service UUIDs',
    //         (result.advertisementData.serviceUuids.isNotEmpty)
    //             ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
    //             : 'N/A'),
    //     _buildAdvRow(context, 'Service Data',
    //         getNiceServiceData(result.advertisementData.serviceData)),
    //   ],
    // );
  }

}