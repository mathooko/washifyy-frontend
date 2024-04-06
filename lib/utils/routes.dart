// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:washifyy/views/checkout.dart';
import 'package:washifyy/views/dashboard.dart';
import 'package:washifyy/views/donations.dart';
import 'package:washifyy/views/home.dart';
import 'package:washifyy/views/login.dart';
import 'package:washifyy/views/sign.dart';

class Routes {
  static var routes = [
    GetPage(name: "/", page: () => Login()),
    GetPage(name: "/home", page: () => Home()),
    GetPage(name: "/checkout", page: () => Checkout()),
    GetPage(name: "/donations", page: () => Donations()),
    GetPage(name: "/dashboard", page: () => Dashboard()),
    GetPage(name: "/sign", page: () => Sign()),
  ];
}
