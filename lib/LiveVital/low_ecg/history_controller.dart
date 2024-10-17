import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../app_manager/alert_dialogue.dart';
import '../../app_manager/alert_toast.dart';
import '../../authenticaton/user_repository.dart';


class HistoryController extends GetxController{

  List selectedData=[];

  List get getSelectedData=>selectedData;

  updateSelectedData(context,{required Map val, required String date,required String jsonFile}){

      if(selectedData.map((e) => e['Date'].toString().trim()).toList().contains(date.toString().trim())){
        selectedData.removeAt(selectedData.map((e) => e['Date'].toString().trim()).toList().indexOf(date.toString().trim()));
      }
      else{
        if(selectedData.length<2){
        selectedData.add({"jsonFile":jsonFile, "ColumnData":val, "Date":date,});
        }
        else{

          Get.showSnackbar( MySnackbar.ErrorSnackBar(  message: 'Only two column can be selected'));
          // alertToast(context, 'Only two column can be selected');
        }
      }

    update();
    print("ssssss"+selectedData.toString());
  }

  historyReportTableData({required int index,required String intervalValue,required String value}){
    return  getSelectedData[index]['ColumnData']==null? '0':
    getSelectedData[index]['ColumnData']['Lead_II']==null? '0':
    getSelectedData[index]['ColumnData']['Lead_II'][intervalValue]==null?'0':
    getSelectedData[index]['ColumnData']['Lead_II'][intervalValue][value];
  }



  historyTablata({required int index1,required int index2,required String leadIntervel,required String leadValue}){
    var data=jsonDecode(getPreviousDataList[
    index1]['responce'] ==
        "NA"
        ? "[]"
        : getPreviousDataList[
    index1][
    'responce'])['perlead'][index2];

    return data['Lead_II'].isEmpty?  "":(data['Lead_II'][leadIntervel.toString()]??{}).isEmpty? '':data['Lead_II'][leadIntervel][leadValue];

  }

  List previousDataList=[];
  List get getPreviousDataList=>previousDataList;
  set updatePreviosDataList(List val){
    previousDataList=val;
    update();
  }

  changeObsValue({required int index, required String keyName, required double firstValue, required double secondValue}){

    var data=getSelectedData[index]['ColumnData']['Lead_II'][keyName]==null? 0.0:
    getSelectedData[index]['ColumnData']['Lead_II'][keyName]['V'] < firstValue ?
    getSelectedData[index]['ColumnData']['Lead_II'][keyName]==null? 0.0:
    getSelectedData[index]['ColumnData']['Lead_II'][keyName]['V'] - firstValue
        : getSelectedData[index]['ColumnData']['Lead_II'][keyName]==null? 0.0:getSelectedData[index]['ColumnData']['Lead_II'][keyName]
    ['V'] > secondValue ? getSelectedData[index]['ColumnData']['Lead_II'][keyName]==null? 0.0:
    getSelectedData[index]['ColumnData']['Lead_II'][keyName]['V'] - secondValue : 0;

   return data;

  }

  subtackObsValue({required String key}){

    String data='';
    if(getSelectedData.length>1){
     data=(double.parse(getSelectedData[1]['ColumnData']['Lead_II'][key]==null? "0.0":
     getSelectedData[1]['ColumnData']['Lead_II'][key]['V'].toString()) -
         double.parse(getSelectedData[0]['ColumnData']['Lead_II'][key]==null? "0.0":
         getSelectedData[0]['ColumnData']['Lead_II'][key]['V'].toString())).toStringAsFixed(2);
    }
    else{
      data='';
    }
    return data;
  }

  getHistory(context) async {

    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    try{
      var response = await http.get(Uri.parse('http://182.156.200.179:1880/ecg/responce?pid=${userRepository.getUser.pid.toString()}&limit=5'),
          headers:{
            "authKey": "4S5NF5N0F4UUN6G",
            "content-type": "application/json",
          }
      );

      var data=await json.decode(response.body);
      updatePreviosDataList=data;
      print('dddddd' + data.toString());

    }
    catch(e){
      print('eeeeee' + e.toString());
    }
  }


  graphList(index){
    print('nnnnnvvvvvvvvvvvvvnnnnnn'+getFileDataList.length.toString());
    var data=getFileDataList==null? '':getFileDataList.length>1? getFileDataList[index]['payLoad']['data'].split(','):[];
    return  data;
  }

 List fileDataList=[];
  List get getFileDataList=>fileDataList;
  set updateFileDataList(Map<dynamic, dynamic> val){
    fileDataList.add(val);
    update();
  }

  fileData() async {
    fileDataList=[];
    print('ffffff'+fileDataList.toString());
    for(int i=0;i<=selectedData.length;i++){
     await fileApiData(selectedData[i]['jsonFile']);
    }
  }

  fileApiData(filePath) async {
    try{
      var response=await http.get(Uri.parse('http://182.156.200.179:1880/ecg/responce?file=${filePath}'),
          headers:{
            "authKey": "4S5NF5N0F4UUN6G",
            "content-type": "application/json",
          }
      );
      print('uuuuuu http://182.156.200.179:1880/ecg/responce?file=${filePath}');
      print('rrrrrr'+response.body.toString());

      updateFileDataList=jsonDecode(response.body);
      print('gggggg'+getFileDataList.length.toString());
    }catch(e){
    }
  }

}
