// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:washifyy/configs/constants.dart';
import 'package:washifyy/controllers/HomeController.dart';
import 'package:washifyy/views/checkout.dart';
import 'package:washifyy/views/dashboard.dart';
import 'package:washifyy/views/donations.dart';

HomeController homeController = Get.put(HomeController());
var Screen = [
  Dashboard(),
  Checkout(),
  Donations(),
];

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: homeController.selectedPage.value,
        onTap: (index) {
          homeController.selectedPage.value = index;
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Basket',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Checkout',
              backgroundColor: Colors.black),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => Center(child: Screen[homeController.selectedPage.value]),
            ),
          ),
        ],
      ),
    );
  }
}
