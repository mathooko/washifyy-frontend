import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Donations extends StatefulWidget {
  @override
  _DonationsState createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  final Map<String, int> _quantities = {
    'trousers': 0,
    'tshirts': 0,
    'sweaters': 0,
    'shorts': 0,
    'personal': 0,
    'suits': 0,
    'dresses': 0,
  };

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
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/customers/services/'),
      body: _quantities,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Order placed successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: ${response.body}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
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
            Center(
              child: ElevatedButton(
                onPressed: _submitOrder,
                child: Text('Proceed to Checkout'),
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
      case 'suits':
        color = Colors.red[100]!;
        description = 'For suits, blazers, and formal wear';
        break;
      case 'dresses':
        color = Colors.teal[100]!;
        description = 'For dresses, gowns, and formal attire';
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
          Text(
            label.capitalize,
            style: TextStyle(fontSize: 16),
          ),
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
