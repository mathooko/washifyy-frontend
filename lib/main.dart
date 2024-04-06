import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:washifyy/utils/routes.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: "/",
    debugShowCheckedModeBanner: false,
    getPages: Routes.routes,
  ));
}
 