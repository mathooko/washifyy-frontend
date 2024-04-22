import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LaundryService {
  final int id;
  final int trousers;
  final int tshirts;
  final int sweaters;
  final int shorts;
  final int personal;
  final int duvet;
  final int shoes;
  final double price;

  LaundryService({
    required this.id,
    required this.trousers,
    required this.tshirts,
    required this.sweaters,
    required this.shorts,
    required this.personal,
    required this.duvet,
    required this.shoes,
    required this.price,
  });

  factory LaundryService.fromJson(Map<String, dynamic> json) {
    return LaundryService(
      id: json['id'],
      trousers: json['trousers'],
      tshirts: json['tshirts'],
      sweaters: json['sweaters'],
      shorts: json['shorts'],
      personal: json['personal'],
      duvet: json['duvet'],
      shoes: json['shoes'],
      price: json['price'].toDouble(),
    );
  }
}

class Checkout extends StatefulWidget {
  @override
  _LaundryServiceListViewState createState() => _LaundryServiceListViewState();
}

class _LaundryServiceListViewState extends State<Checkout> {
  late Future<List<LaundryService>> _laundryServices;

  Future<List<LaundryService>> fetchLaundryServices() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/customers/selected/<int:pk>/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => LaundryService.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load laundry services');
    }
  }

  @override
  void initState() {
    super.initState();
    _laundryServices = fetchLaundryServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laundry Services'),
      ),
      body: FutureBuilder<List<LaundryService>>(
        future: _laundryServices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                LaundryService laundryService = snapshot.data![index];
                return ListTile(
                  title: Text('ID: ${laundryService.id}'),
                  subtitle: Text(
                      'Price: \$${laundryService.price.toStringAsFixed(2)}'),
                  // Add more ListTile properties to display other fields as desired
                );
              },
            );
          }
        },
      ),
    );
  }
}
