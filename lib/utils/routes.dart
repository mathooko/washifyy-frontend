// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:washifyy/views/Cart.dart';
import 'package:washifyy/views/checkout.dart';
import 'package:washifyy/views/dashboard.dart';

import 'package:washifyy/views/login.dart';
import 'package:washifyy/views/order.dart';
import 'package:washifyy/views/sign.dart';

class Routes {
  static var routes = [
    GetPage(name: "/", page: () => Login()),
    GetPage(name: "/checkout", page: () => Checkout()),
    GetPage(name: "/dashboard", page: () => Dashboard()),
    GetPage(name: "/sign", page: () => Sign()),
    GetPage(name: "/order", page: () => Order()),
    GetPage(name: "/cart", page: () => Cart())
  ];
}
