import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:washifyy/controllers/checkout.dart';
import 'package:washifyy/utils/routes.dart';

void main() {
  Get.put(CheckoutController());
  runApp(GetMaterialApp(
    initialRoute: "/",
    debugShowCheckedModeBanner: false,
    getPages: Routes.routes,
  ));
}
