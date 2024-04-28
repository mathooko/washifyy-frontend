import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washifyy/views/Cart.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final Map<String, int> _quantities = {
    'trousers': 0,
    'tshirts': 0,
    'sweaters': 0,
    'shorts': 0,
    'personal': 0,
    'duvet': 0,
    'shoes': 0,
  };

  bool _orderSubmitted = false;
  late SharedPreferences _prefs;
  late int _userId;
  bool _includeIroning = false;

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  void _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _userId =
        _prefs.getInt('userId') ?? 0; // Treat as integer, default to 0 if null
  }

  void navigateToCart() {
    Get.offNamed('/cart');
  }

  void _increaseQuantity(String item) {
    setState(() {
      _quantities[item] = (_quantities[item] ?? 0) + 1;
    });
  }

  void _decreaseQuantity(String item) {
    if (_quantities[item]! > 0) {
      setState(() {
        _quantities[item] = (_quantities[item] ?? 0) - 1;
      });
    }
  }

Future<void> _submitOrder() async {
    if (_orderSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have already submitted an order.')),
      );
      return;
    }

    final Uri apiUrl = Uri.parse('http://127.0.0.1:8000/customers/services/');

    try {
      // Convert null quantities to 0
      Map<String, int?> quantities = Map.from(_quantities);
      quantities.updateAll((key, value) => value ?? 0);

      final response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user': _userId,
          'trousers': quantities['trousers'],
          'tshirts': quantities['tshirts'],
          'sweaters': quantities['sweaters'],
          'shorts': quantities['shorts'],
          'personal': quantities['personal'],
          'duvet': quantities['duvet'],
          'shoes': quantities['shoes'],
          'iron': _includeIroning,
        }),
      );

      // Log the request body for debugging
      print('Request Body: ${jsonEncode({
            'user': _userId,
            'trousers': quantities['trousers'],
            'tshirts': quantities['tshirts'],
            'sweaters': quantities['sweaters'],
            'shorts': quantities['shorts'],
            'personal': quantities['personal'],
            'duvet': quantities['duvet'],
            'shoes': quantities['shoes'],
            'iron': _includeIroning,
          })}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed successfully!')),
        );

        // Navigate to the Cart page
        Navigator.popUntil(context, ModalRoute.withName('/'));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Cart()));

        setState(() {
          _orderSubmitted = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make an Order'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Quantity for Each Service:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _quantities.length,
              itemBuilder: (context, index) {
                String key = _quantities.keys.elementAt(index);
                int value = _quantities.values.elementAt(index)!;
                return _buildServiceItem(key, value, index);
              },
            ),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text('Include Ironing'),
              value: _includeIroning,
              onChanged: (value) {
                setState(() {
                  _includeIroning = value ?? false;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitOrder,
                child: Text('Make Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(String label, int quantity, int index) {
    Color color;
    String description;
    switch (label) {
      case 'trousers':
        color = Colors.blue[100]!;
        description = 'For pants, jeans, and trousers';
        break;
      case 'tshirts':
        color = Colors.green[100]!;
        description = 'For T-shirts, polo shirts, and tank tops';
        break;
      case 'sweaters':
        color = Colors.orange[100]!;
        description = 'For sweaters, pullovers, and cardigans';
        break;
      case 'shorts':
        color = Colors.purple[100]!;
        description = 'For shorts and bermuda shorts';
        break;
      case 'personal':
        color = Colors.yellow[100]!;
        description = 'For undergarments, socks, and towels';
        break;
      case 'duvet':
        color = Colors.red[100]!;
        description = 'For duvets and blankets';
        break;
      case 'shoes':
        color = Colors.teal[100]!;
        description = 'For shoes and footwear';
        break;
      default:
        color = Colors.transparent;
        description = '';
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => _increaseQuantity(label),
                    icon: Icon(Icons.add),
                  ),
                  Text(
                    '$quantity',
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () => _decreaseQuantity(label),
                    icon: Icon(Icons.remove),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension StringCapitalize on String {
  String get capitalize => this[0].toUpperCase() + this.substring(1);
}
