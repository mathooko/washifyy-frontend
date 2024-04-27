import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:washifyy/controllers/checkout.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  List<OrderItem> orderItems = [];

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? orderId = prefs.getInt('checkedOutOrderId');

    if (orderId != null) {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/customers/edit/$orderId/'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Receipt',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                final item = orderItems[index];
                return ListTile(
                  title: Text('${item.quantity} x ${item.name}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;

  OrderItem({required this.name, required this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      quantity: json['quantity'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkout Page',
      home: Payment(),
    );
  }
}
