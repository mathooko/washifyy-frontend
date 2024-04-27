import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washifyy/controllers/checkout.dart';
import 'package:washifyy/views/checkout.dart';
import 'package:washifyy/views/edit.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _BookingInfoState();
}

class _BookingInfoState extends State<Cart> {
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

      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/customers/selected/$userId/'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          setState(() {
            ordersInfo = jsonResponse;
          });
          // Save Order info to local storage
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
      ),
      body: ordersInfo.isEmpty
          ? Center(child: Text('No Orders Made.'))
          : SingleChildScrollView(
              child: Column(
                children: ordersInfo.map((Order) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Order Number: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text('ID: ${Order['id']}'),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateInfo(OrderId: Order['id']),
                                    ),
                                  );
                                },
                                child: Text('Edit'),
                              ),
                              SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () {
                                  cancelBooking(Order['id']);
                                },
                                child: Text('Cancel'),
                              ),
                              SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () async {
                                  await checkoutOrder(Order['id']);
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
    );
  }

  Future<void> checkoutOrder(int OrderId) async {
    try {
      // Save the order ID in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('checkedOutOrderId', OrderId);

      // Remove the order from the cart
      setState(() {
        ordersInfo.removeWhere((Order) => Order['id'] == OrderId);
      });

      // Fetch order details and add them to the CheckoutController
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/customers/edit/$OrderId/'));
      if (response.statusCode == 200) {
        Map<String, dynamic> orderDetails = json.decode(response.body);
        final checkoutController = Get.find<CheckoutController>();
        checkoutController.addOrderDetails(OrderId, orderDetails);
      } else {
        print(
            'Failed to fetch order details. Status code: ${response.statusCode}');
      }

      // Navigate to the Checkout page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Checkout(),
        ),
      );
    } catch (e) {
      print('Error checking out Order: $e');
    }
  }

  Future<void> cancelBooking(int OrderId) async {
    try {
      final response = await http
          .delete(Uri.parse('http://127.0.0.1:8000/customers/edit/$OrderId/'));

      if (response.statusCode == 200) {
        setState(() {
          ordersInfo.removeWhere((Order) => Order['id'] == OrderId);
        });
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
}
