import 'package:flutter/material.dart';

class Donations extends StatelessWidget {
  final List<OrderItem> orderItems;

  Donations({required this.orderItems});

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;

    // Calculate total price
    orderItems.forEach((item) {
      totalPrice += item.price * item.quantity;
    });

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
                  subtitle: Text('\$${item.price * item.quantity}'),
                );
              },
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            Text(
              'Total Price:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$$totalPrice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem {
  final String name;
  final double price;
  final int quantity;

  OrderItem({required this.name, required this.price, required this.quantity});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkout Page',
      home: Donations(
        orderItems: [
          OrderItem(name: 'Trousers', price: 25.0, quantity: 2),
          OrderItem(name: 'T-shirts', price: 15.0, quantity: 3),
          OrderItem(name: 'Sweaters', price: 30.0, quantity: 1),
        ],
      ),
    );
  }
}
