// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washifyy/views/home.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late List<Map<String, dynamic>> checkedOutItems = [];
  late bool ironingRequested;
  String laundryName = '';
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchCheckedOutItems();
  }

  Future<void> fetchCheckedOutItems() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? itemIdsString = prefs.getStringList('checkedOutItemIds');
      if (itemIdsString != null) {
        List<int> itemIds = itemIdsString.map((id) => int.parse(id)).toList();
        List<dynamic> orderInfo = await fetchOrderInfoFromAPI(itemIds);
        bool ironingRequested = orderInfo.any((item) =>
            item['iron'] ?? false); // Check if any item includes ironing
        setState(() {
          checkedOutItems = orderInfo.cast<Map<String, dynamic>>();
          this.ironingRequested = ironingRequested;
          if (orderInfo.isNotEmpty &&
              orderInfo.first.containsKey('laundry_name')) {
            laundryName = orderInfo.first['laundry_name'] ?? '';
          }
        });
      } else {
        print('No checked-out item IDs found in shared preferences.');
      }
    } catch (e) {
      print('Error fetching checked-out items: $e');
    }
  }

  Future<List<dynamic>> fetchOrderInfoFromAPI(List<int> itemIds) async {
    try {
      List<dynamic> orderInfo = [];
      for (int itemId in itemIds) {
        final response = await http.get(
          Uri.parse(
              'http://127.0.0.1:8000/customers/edit/$itemId/'), // Adjust endpoint to fetch orders
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> item = json.decode(response.body);
          orderInfo.add(item);
        } else {
          throw Exception('Failed to fetch order with ID $itemId');
        }
      }
      return orderInfo;
    } catch (e) {
      print('Error fetching order information: $e');
      return [];
    }
  }

  int calculateTotalPrice(Map<String, dynamic> item, bool ironingRequested) {
    int totalPrice = 0;
    int? quantity = item['quantity'];
    String? itemType = item['type'];
    if (quantity != null && itemType != null) {
      totalPrice += calculateItemPrice(itemType, quantity);
      // Add additional charge for ironing if requested
      if (ironingRequested) {
        totalPrice += 200; // Additional charge for ironing
      }
    }
    return totalPrice;
  }

  int calculateItemPrice(String itemType, int quantity) {
    switch (itemType) {
      case 'trousers':
      case 'tshirts':
      case 'sweaters':
        return quantity * 20; // Base price for trousers, tshirts, sweaters
      case 'shorts':
      case 'personal':
        return quantity * 25; // Base price for shorts, personal
      case 'duvet':
        return quantity * 400; // Base price for duvet
      case 'shoes':
        return quantity * 100; // Base price for shoes
      default:
        return 0; // Default case
    }
  }

  @override
  Widget build(BuildContext context) {
    return Home_No_app(
      body: checkedOutItems.isEmpty
          ? Center(
              child: Text('No checked-out items found.'),
            )
          : ListView.builder(
              itemCount: checkedOutItems.length,
              itemBuilder: (context, index) {
                final item = checkedOutItems[index];

                // Calculate total price without ironing
                int totalPriceWithoutIroning = 0;
                totalPriceWithoutIroning +=
                    calculateItemPrice('trousers', item['trousers'] ?? 0);
                totalPriceWithoutIroning +=
                    calculateItemPrice('tshirts', item['tshirts'] ?? 0);
                totalPriceWithoutIroning +=
                    calculateItemPrice('sweaters', item['sweaters'] ?? 0);
                totalPriceWithoutIroning +=
                    calculateItemPrice('shorts', item['shorts'] ?? 0);
                totalPriceWithoutIroning +=
                    calculateItemPrice('personal', item['personal'] ?? 0);
                totalPriceWithoutIroning +=
                    calculateItemPrice('duvet', item['duvet'] ?? 0);
                totalPriceWithoutIroning +=
                    calculateItemPrice('shoes', item['shoes'] ?? 0);

                // Calculate total price with ironing
                int totalPriceWithIroning = totalPriceWithoutIroning +
                    (item['iron'] ?? false ? 200 : 0);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Center(
                          child: Text(
                            'Washifyy Laundry Services',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Order Number: ${item['id']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                'Date: ${currentDate}',
                                style: TextStyle(),
                              ),
                            ),
                            SizedBox(height: 10),
                            ListTile(
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('Price',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Trousers'),
                                      Text(
                                          '${calculateItemPrice("trousers", item['trousers'] ?? 0)}Ksh'),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('T-shirts'),
                                      Text(
                                          '${calculateItemPrice("tshirts", item['tshirts'] ?? 0)}Ksh'),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Sweaters'),
                                      Text(
                                          '${calculateItemPrice("sweaters", item['sweaters'] ?? 0)}Ksh'),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Shorts'),
                                      Text(
                                          '${calculateItemPrice("shorts", item['shorts'] ?? 0)}Ksh'),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Personal'),
                                      Text(
                                          '${calculateItemPrice("personal", item['personal'] ?? 0)}Ksh'),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Duvet'),
                                      Text(
                                          '${calculateItemPrice("duvet", item['duvet'] ?? 0)}Ksh')
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Shoes'),
                                      Text(
                                          '${calculateItemPrice("shoes", item['shoes'] ?? 0)}Ksh')
                                    ],
                                  ),
                                  if (item['iron'] ?? false) Divider(),
                                  if (item['iron'] ?? false)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Ironing'),
                                        Text(
                                          '200 Ksh',
                                        ),
                                      ],
                                    ),
                                  Divider(),
                                ],
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Total Price:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                '${(item['iron'] ?? false) ? totalPriceWithIroning : totalPriceWithoutIroning} Ksh',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(),
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                'Thank you for choosing us!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
