
import 'package:medvantage_patient/app_manager/theme/text_theme.dart';
import 'package:medvantage_patient/app_manager/widgets/buttons/custom_ink_well.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:medvantage_patient/common_libs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


import 'app_color.dart';
import 'package:get/get.dart';



class PdfViewer extends StatefulWidget {
  final pdfUrl;

  const PdfViewer({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  //get comparision => null;
  double?_progress;

  getPermission()async{

  }
  @override
  void initState() {
    // TODO: implement initState
    getPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ColoredSafeArea(
      child: ColoredSafeArea(
        child: SafeArea(
          child: Scaffold(
            body:Stack(
              children: [
                widget.pdfUrl==''?
                Center(
                  child: Text("No pdf found",style: MyTextTheme.largeBCB,),
                ) :
                SfPdfViewer.network( widget.pdfUrl.toString()
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 5),
                  child: CustomInkWell(
                    onTap: (){
                       Get.back();
                    },
                      child: const Icon(Icons.arrow_back_ios_sharp)),
                )
              ],
            ),
            floatingActionButton: Visibility(
            visible: widget.pdfUrl!="",
              child:
                FloatingActionButton(
              onPressed: ()async {

                try{
                  await FileDownloader.downloadFile(
                    url: widget.pdfUrl.toString(),
                    onDownloadCompleted: (value) {ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(backgroundColor: Colors.green,
                        content: Text('File Downloaded Successfully\n $value'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    print('path  $value ');


                    },
                    onDownloadError: (String error) {
                      print('DOWNLOAD ERROR: $error');
                    },
                  );

                }catch (e){
                  print(e);
                }

                    },
              child: const Icon(Icons.download_rounded,size:30),
          ),
            ),
          ),
        ),
      ),
    );
  }}
