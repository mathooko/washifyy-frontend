import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:washifyy/controllers/homecontroller.dart';
import 'package:washifyy/views/Cart.dart';
import 'package:washifyy/views/checkout.dart';
import 'package:washifyy/views/dashboard.dart';



HomeController homeController = Get.put(HomeController());

class Home_No_app extends StatelessWidget {
  final Widget body;

  Home_No_app({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: homeController.selectedPage.value,
          onTap: (index) {
            homeController.selectedPage.value = index;
            switch (index) {
              case 0:
                Get.to(() => Dashboard());
                break;
              case 1:
                Get.to(() => Cart());
                break;
              case 2:
                Get.to(() => Checkout());
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
              BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Checkout',
            ),
          ],
        ),
        body: body);
  }
}
