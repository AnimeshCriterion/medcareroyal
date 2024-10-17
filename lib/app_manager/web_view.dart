
import 'package:medvantage_patient/app_manager/appBar/custom_app_bar.dart';
import 'package:medvantage_patient/app_manager/app_color.dart';
import 'package:medvantage_patient/app_manager/widgets/coloured_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading=true;
  final _key = UniqueKey();


  @override
  Widget build(BuildContext context) {
    return ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(backgroundColor: AppColor.white,
          appBar:  CustomAppBar( title: widget.title.toString(),primaryBackColor:AppColor.greyDark,),
          body: Stack(
            children: <Widget>[
              // WebView(
              //   initialUrl: widget.url.toString(),
              //   javascriptMode: JavascriptMode.unrestricted,
              //   onPageFinished: (finish) {
              //     setState(() {
              //       isLoading = false;
              //     });
              //   },
              // ),
              isLoading ? Center( child: CircularProgressIndicator(),)
                  : Stack(),
            ],
          ),
        ),
      ),
    );
  }
}
