import 'dart:async';

import 'package:dieaya_market/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class TestInAppPurchase extends StatefulWidget {
  const TestInAppPurchase({super.key});

  @override
  State<TestInAppPurchase> createState() => _TestInAppPurchaseState();
}

class _TestInAppPurchaseState extends State<TestInAppPurchase> {
  var _subscription;


  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print('_showPendingUI()');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
         print(' bool valid = await _verifyPurchase(purchaseDetails)');
          // if (valid) {
          //   print(purchaseDetails);
          // } else {
          //   print(purchaseDetails);
          // }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  @override
  void initState() {
    print('1237');
    final Stream purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      print('_listenToPurchaseUpdated');
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print('onDone');
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
      print('------------------>Error >$error');
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,

      ),
      body: Column(
        children: [],
      ),
      backgroundColor: AppColors.primary,
    );
  }
}
