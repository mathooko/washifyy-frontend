import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washifyy/views/checkout.dart';
import 'package:washifyy/views/edit.dart';
import 'package:washifyy/views/home.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late List<dynamic> ordersInfo = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final userInfo = await _getUserInfo();
      int userId = userInfo['userId'] ?? 1;

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/customers/selected/$userId/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          List<int> checkedOutItemIds = await getCheckedOutItemIds();

          setState(() {
            ordersInfo = jsonResponse
                .where((item) => !checkedOutItemIds.contains(item['id']))
                .toList();
          });
          saveOrderInfo(jsonResponse);
        } else {
          throw Exception('No orders found for the user');
        }
      } else {
        throw Exception(
            'Failed to load orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    return {
      'userId': userId,
    };
  }

  Future<void> saveOrderInfo(List<dynamic> jsonResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('orderinfo', json.encode(jsonResponse));
  }

  Future<void> saveCheckedOutItemIds(List<int> itemIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'checkedOutItemIds', itemIds.map((id) => id.toString()).toList());
  }

  Future<List<int>> getCheckedOutItemIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? itemIdsString = prefs.getStringList('checkedOutItemIds');
    if (itemIdsString != null) {
      return itemIdsString.map((id) => int.parse(id)).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Home_No_app(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: Text('Cart'),
            centerTitle: true,
          ),
          Expanded(
            child: ordersInfo.isEmpty
                ? Center(child: Text('No Orders Made.'))
                : SingleChildScrollView(
                    child: Column(
                      children: ordersInfo.map((order) {
                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(
                              'Order Number:${order['id']} ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.to(() =>
                                            UpdateInfo(OrderId: order['id']));
                                      },
                                      child: Text('Edit'),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        cancelBooking(order['id']);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await checkoutOrder(order['id']);
                                      },
                                      child: Text('Checkout'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> checkoutOrder(int orderId) async {
    try {
      final userInfo = await _getUserInfo();
      int userId = userInfo['userId'] ?? 1;

      await saveCheckedOutItemId(userId, orderId);

      // Remove the checked out item from the cart
      setState(() {
        ordersInfo.removeWhere((order) => order['id'] == orderId);
      });

      // Update shared preferences with the latest orders after checkout
      await saveOrderInfo(ordersInfo);

      // Navigate to the Checkout page
      Navigator.popUntil(context, ModalRoute.withName('/'));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Checkout()));
    } catch (e) {
      print('Error checking out Order: $e');
    }
  }

  Future<void> cancelBooking(int orderId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/customers/edit/$orderId/'),
      );

      if (response.statusCode == 200) {
        setState(() {
          ordersInfo.removeWhere((order) => order['id'] == orderId);
        });
        // Update shared preferences with the latest orders after cancellation
        await saveOrderInfo(ordersInfo);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Order canceled successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to cancel Order');
      }
    } catch (e) {
      print('Error canceling Order: $e');
    }
  }

  Future<void> saveCheckedOutItemId(int userId, int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<int> checkedOutItemIds = await getCheckedOutItemIds();
    checkedOutItemIds.add(orderId);
    await prefs.setStringList('checkedOutItemIds',
        checkedOutItemIds.map((id) => id.toString()).toList());
  }
}
