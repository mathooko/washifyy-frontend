import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washifyy/controllers/checkout.dart';
import 'package:http/http.dart' as http;

class Checkout extends StatefulWidget {
  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.find<CheckoutController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Obx(() {
        if (checkoutController.checkedOutItems.isEmpty) {
          return Center(child: Text('No items checked out.'));
        } else {
          return ListView.builder(
            itemCount: checkoutController.checkedOutItems.length,
            itemBuilder: (context, index) {
              int orderId =
                  checkoutController.checkedOutItems.keys.elementAt(index);
              Map<String, dynamic> orderDetails =
                  checkoutController.checkedOutItems[orderId]!;

              return Column(
                children: orderDetails.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key), // Display the item name
                    subtitle: Text('Quantity: ${entry.value}'),
                  );
                }).toList(),
              );
            },
          );
        }
      }),
    );
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    return {
      'userId': userId,
    };
  }

  Future<void> fetchOrderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? orderId = prefs.getInt('checkedOutOrderId');
    final userInfo = await _getUserInfo();
    int userId = userInfo['userId'] ?? 1;

    if (orderId != null) {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/customers/selected/$userId/'));
      print(response);
      if (response.statusCode == 200) {
        Map<String, dynamic>? orderDetails = json.decode(response.body);
        final checkoutController = Get.find<CheckoutController>();
        if (orderDetails != null) {
          checkoutController.addOrderDetails(orderId, orderDetails);
        } else {
          print('Order details are null.');
        }
      } else {
        print(
            'Failed to fetch order details. Status code: ${response.statusCode}');
      }
    }
  }
}
