import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateInfo extends StatefulWidget {
  final int OrderId;

  const UpdateInfo({
    Key? key,
    required this.OrderId,
  }) : super(key: key);

  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  late int trousers = 0;
  late int? tshirts = 0;
  late int sweaters = 0;
  late int shorts = 0;
  late int personal = 0;
  late int duvet = 0;
  late int shoes = 0;

  @override
  void initState() {
    super.initState();
    fetchBookingInfo();
  }

  _UpdateInfoState() {}

  Future<void> fetchBookingInfo() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/customers/edit/${widget.OrderId}/'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Received JSON response: $jsonResponse'); // Debug print
        setState(() {
          trousers = jsonResponse['trousers'] ?? 0;
          tshirts = jsonResponse['tshirts'];
          sweaters = jsonResponse['sweaters'] ?? 0;
          shorts = jsonResponse['shorts'] ?? 0;
          personal = jsonResponse['personal'] ?? 0;
          duvet = jsonResponse['duvet'] ?? 0;
          shoes = jsonResponse['shoes'] ?? 0;
        });
      } else {
        throw Exception('Failed to fetch order info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Order info: $e'); // Debug print
    }
  }

  Future<void> updateOdersInfo() async {
    try {
      final Map<String, dynamic> updatedData = {
        'trousers': trousers,
        'tshirts': tshirts,
        'sweaters': sweaters,
        'shorts': shorts,
        'personal': personal,
        'duvet': duvet,
        'shoes': shoes
      };

      final response = await http.patch(
        Uri.parse('http://127.0.0.1:8000/customers/edit/${widget.OrderId}/'),
        body: json.encode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Order updated successfully'),
        ));
        Navigator.pop(context);
      } else {
        throw Exception('Failed to update Order info');
      }
    } catch (e) {
      print('Error updating Order info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Order '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('trousers:'),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (trousers > 0) trousers--;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$trousers'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        trousers++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Tshirts:'),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (tshirts != null && tshirts! > 0)
                          tshirts = tshirts! - 1;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('${tshirts ?? 0}'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        tshirts = (tshirts ?? 0) + 1;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('sweaters'),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (sweaters > 0) sweaters--;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$sweaters'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        sweaters++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Shorts'),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (shorts > 0) shorts--;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$shorts'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        shorts++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('personal'),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (personal > 0) personal--;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$personal'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        personal++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('duvet'),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (duvet > 0) duvet--;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$duvet'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        duvet++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('shoes'),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (shoes > 0) shoes--;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$shoes'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        shoes++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    updateOdersInfo();
                  },
                  child: Text('Update Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
