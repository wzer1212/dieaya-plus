// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../UI/widgets/no_internet_connection.dart';


class InternetController extends GetxController {
  // final Connectivity _connectivity = Connectivity();.
  //
  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    // _connectivity.onConnectivityChanged.listen(netStatus);
  }

  Future<void> _checkInitialConnection() async {
    // ConnectivityResult result = await _connectivity.checkConnectivity();
    // netStatus(result);
  }

  // Future<void> netStatus(ConnectivityResult result) async {
  //   if (result == ConnectivityResult.none) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Get.rawSnackbar(
  //         titleText: SizedBox(
  //             width: double.infinity,
  //             height: Get.size.height / 1.1,
  //             child: const Align(
  //               alignment: Alignment.bottomCenter,
  //               child: NoInternetConnection(),
  //             )),
  //         messageText: Container(),
  //         backgroundColor: Colors.transparent,
  //         isDismissible: false,
  //         duration: const Duration(days: 1),
  //       );
  //     });
  //   } else {
  //     if (Get.isSnackbarOpen) {
  //       Get.closeCurrentSnackbar();
  //     }
  //   }
  // }
}