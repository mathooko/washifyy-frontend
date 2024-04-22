import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:washifyy/controllers/HomeController.dart';
import 'package:washifyy/views/checkout.dart';
import 'package:washifyy/views/dashboard.dart';
import 'package:washifyy/views/donations.dart';

HomeController homeController = Get.put(HomeController());

var Screens = [
  Dashboard(),
  Checkout(),
  Donations(orderItems: [],),
];

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: homeController.selectedPage.value,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.black,
            selectedIconTheme: IconThemeData(color: Colors.deepPurple),
            onTap: (index) {
              homeController.selectedPage.value = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Basket',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.credit_card),
                label: 'Checkout',
              ),
            ],
          )),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => Center(child: Screens[homeController.selectedPage.value]),
            ),
          ),
        ],
      ),
    );
  }
}
