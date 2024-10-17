import 'package:get/get.dart';

import '../remote_dashboard_controller.dart';


class RemoteDashboardBinding extends Bindings{
@override
  void dependencies() {
    Get.lazyPut<RemoteDashboardController>(() => RemoteDashboardController());
  }
}
