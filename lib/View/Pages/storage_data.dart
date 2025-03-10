import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import '../../common_libs.dart';
import '../../medcare_utill.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,  });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".




  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>   {
  int _counter = 0;


  List<dynamic> phoneDirectory = [];

  @override
  void initState() {
    super.initState();
    // fetchAndStoreData();
    get();
  }

  get() async {
    await Permission.manageExternalStorage.request();
    // final path= "/sdcard/nn";
    // final dir= Directory(path);
    //
    // await dir.create(recursive  : true);

    // await  writeToFile();
    // await readFromFile();


    // phoneDirectory=await InternalStorage().getData();
    // setState(() {
    //
    // });
    // await InternalStorage()._writeData(
    //     currentData: {'title':'n'},);

    WidgetsFlutterBinding.ensureInitialized();
    await Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    );

    Workmanager().registerPeriodicTask(
      "periodic-task-identifier",
      "simplePeriodicTask",
        constraints: Constraints(
            networkType: NetworkType.connected,

            // requiresBatteryNotLow: true,
            // requiresCharging: true,
            // requiresDeviceIdle: true,
            // requiresStorageNotLow: true
        ) ,

        // When no frequency is provided the default 15 minutes is set.
      // Minimum frequency is 15 min. Android will automatically change
      // your frequency to 15 min if you have configured a lower frequency.
      frequency: Duration(minutes: 15),
    );

  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
      ),
      body: ListView.builder(
        itemCount: phoneDirectory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(phoneDirectory[index]['title']),
            // subtitle: Text(phoneDirectory[index]['description']),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: readFromFile,
      //   tooltip: 'Refresh',
      //   child: const Icon(Icons.refresh),
      // ),
    );
  }



}

callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {


    return geet();
  });
}

geet(){
  Timer.periodic(Duration(seconds: 5), (timer) {
    dPrint('nnnnnvnvnnv  Workmanager');
  });
}

//
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key,  }) : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   initState() {
//     _downloadAndSavePhoto();
//     super.initState();
//   }
//   List n=[];
//
//   _downloadAndSavePhoto() async {
//
//
//     await Permission.manageExternalStorage.request();
//     // Get file from internet
//     var url = "https://apishfc.medvantage.tech:7080/Images/Banner/MicrosoftTeams-image(13).png"; //%%%
//     var response = await get(Uri.parse(url));
//     var filePathAndName ='/sdcard/Android/data/android.nn.nnn'+ '/files/pic.jpg';
//
//
//     File file2 = new File(filePathAndName);
//
//     file2.writeAsBytesSync(response.bodyBytes);
//     setState(() {
//       imageData = filePathAndName;
//       dataLoaded = true;
//     });
//
//
//   }
//
//   String imageData='';
//   bool dataLoaded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     if (dataLoaded) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               // imageData holds the path AND the name of the picture.
//               Image.file(File(imageData), width: 600.0, height: 290.0)
//             ],
//           ),
//         ),
//       );
//     } else {
//       return CircularProgressIndicator(
//         backgroundColor: Colors.cyan,
//         strokeWidth: 5,
//       );
//     }
//   }
// }






class InternalStorage{

  String fileName='/.not_saved_data.json';

  Map initialData={
    'userId':0,
    'dataList':[],
  };


  Map apiData={
    'fullUrl':'',
    'parameters':{},
    'isToken':false,
    'methodName':''
  };


  _createFolder()async{
    await Permission.manageExternalStorage.request();
    final nn = await getExternalStorageDirectory();
    dPrint(nn);
    final folderName="mPateint";
    final path= Directory("${nn!.path.split('/data')[0]}/.$folderName");
    if ((await path.exists())){
       
      return path.path;

    }else{
      path.create();
      final file =await  _createFile(path.path);
      await file.writeAsString(jsonEncode(initialData));
      return path.path;
    }
  }


  _createFile(folderPath) async {
    final file = File(folderPath.toString()+fileName);
    // dPring('nnnvnvnnv '+file.path.toString());
    return file;
  }

  _returnFilePath() async {
    var folderPath= await _createFolder();
    var file= await  _createFile(folderPath);

    dPrint('nnnvnvnnv '+file.path.toString());
    return file;
  }


  storeData(context,{  Map? currentData,List? storedData, }) async {

    // UserRepository userRepository =
    // Provider.of<UserRepository>(context, listen: false);
    //
    //
    // final file =await _returnFilePath();
    //
    // Map  initialData=  await _readData();
    //
    // List temp=[];
    //
    // if(initialData['userId'].toString()==userRepository.getUser.userId.toString()){
    //   temp= storedData??  initialData['dataList'];
    // }
    // else{
    //   initialData['userId']=userRepository.getUser.userId.toString();
    //   temp=[];
    // }
    // if(currentData!=null){
    //   temp.add(currentData);
    //
    //   Get.showSnackbar( MySnackbar.SuccessSnackBar(  message: 'Your data automatically save when internet is on'.toString()));
    //   // Alert.show('Your data automatically save when internet is on');
    // }
    // initialData['dataList']=temp;
    //
    // dPrint('nnnvnvnnv '+initialData.toString());
    // await file.writeAsString(jsonEncode(initialData));
    // await getData();


  }

  _readData() async {

    final file =await _returnFilePath();

    var decodedString = await   file.readAsString();
    return jsonDecode(decodedString);
    }


  getData() async {
    final file =await _returnFilePath();
    var jsonString = await   file.readAsString();
    dPrint('nnnvnvnnv '+jsonString.toString());
    List temp=jsonDecode(jsonString)['dataList'];
    dPrint('nnnvnvnnv '+jsonDecode(jsonString)['dataList'].toString());
    return temp;
  }






  insertStoredData(BuildContext context   ) async {
    List temp=await InternalStorage().getData();


    for(int i=0;i<temp.length;i++){
      dPrint('nnnvnnvnnvvvnn nn '+temp[i]['parameters'].toString());
      dPrint('nnnvnnvnnvvvnn nn '+Map<String, String>.from(temp[i]['header']).toString());
      await apiMethods(context,temp[i]['methodName'].toString(),
        body: temp[i]['parameters'],
        myUrl: temp[i]['fullUrl'],
        header:   Map<String, String>.from(temp[i]['header']) ,
        fileParameter: temp[i]['fileParameter'],
        filePath:  temp[i]['filePath'],
        token: temp[i]['isToken'],
      );
      dPrint('nnnvnnvnnvvvnn nntemp '+temp .toString());
      temp.removeAt(i);
      dPrint('nnnvnnvnnvvvnn nntemp '+temp .toString());
      await InternalStorage().storeData(context, storedData: temp);
    }


  }

  apiMethods(BuildContext context,ApiType,{myUrl,body, header,fileParameter,filePath,token }) async {
    dPrint('nnnvnnvnnvvvnn nn '+ApiType.toString());
    http.Response? response;
    http.StreamedResponse? streamResponse;
    try{
      switch (ApiType) {
        case 'ApiType.post':
          response =
          await http.post(Uri.parse(myUrl), body: body, headers: header);
          break;

        case 'ApiType.get':
          response = await http.get(Uri.parse(myUrl), headers: header);
          break;

        case 'ApiType.rawPost':
          var request = http.Request('POST', Uri.parse(myUrl));
          request.body = json.encode(body);
          request.headers.addAll(header ?? {'Content-Type': 'application/json'});
          streamResponse = await request.send();
          break;

        case 'ApiType.rawPut':
          response = await http.put(Uri.parse(myUrl), body: jsonEncode(body));
          break;

        case 'ApiType.multiPartRequest':
        // Alert.show("Not implemented");
        // var request = http.Request('POST', Uri.parse(myUrl));
        // request.body = json.encode(body);
        // request.headers.addAll(header??{
        //   'Content-Type': 'application/json'
        // });
        // streamResponse = await request.send();

          var request = http.MultipartRequest('POST', Uri.parse(myUrl));
          Map<String, String> body = {};
          request.fields.addAll(body);
          String imagePath = filePath.toString();
          String imagePathName = fileParameter.toString();
          request.files
              .add(await http.MultipartFile.fromPath(imagePathName, imagePath));
          request.headers.addAll(header ?? {});
          streamResponse = await request.send();

          break;
        default:
          break;
      }
    }
    catch(e){
      dPrint('nnnvnnvnnvvvnn '+e.toString());
      Map currentData={
        'fullUrl':myUrl,
        'parameters':body,
        'isToken':token,
        'header':header,
        'methodName':ApiType.toString(),
        'fileParameter': fileParameter.toString(),
        'filePath':filePath.toString()
      };

      await  InternalStorage().storeData(context,currentData: currentData);
    }


  }

}

