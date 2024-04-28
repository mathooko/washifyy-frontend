import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washifyy/views/home.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Map<String, dynamic> username = {};
  List<int> checkedOutItemIds = [];

  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchCheckedOutItems();
  }

  Future<void> fetchUsername() async {
    try {
      final String? name = await getUsername();
      if (name != null) {
        setState(() {
          username['username'] = name;
        });
      }
    } catch (error) {
      print('Error fetching username: $error');
    }
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> fetchCheckedOutItems() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      checkedOutItemIds = prefs
              .getStringList('checkedOutItemIds')
              ?.map((id) => int.parse(id))
              .toList() ??
          [];
    } catch (e) {
      print('Error fetching checked-out items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current date
    String currentDate = DateFormat.yMMMMd().format(DateTime.now());

    return Home_No_app(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${username['username']}, welcome',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      currentDate,
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tap to make an order',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Icon(Icons.more_horiz)
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            navigateToOrder(); // Wash and Fold
                          },
                          child: _buildServiceCard(
                            icon: Icons.local_laundry_service,
                            label: 'Laundry',
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Orders Checked Out',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(255, 138, 91, 219),
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: checkedOutItemIds.length,
                      itemBuilder: (context, index) {
                        final orderId = checkedOutItemIds[index];
                        return GestureDetector(
                          onTap: () {
                            navigateToCheckout(orderId);
                          },
                          child: _buildOrderItem(orderId: orderId),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100, // Increase the size of the icon
            color: color,
          ),
          SizedBox(height: 20), // Increase the spacing
          Text(
            label,
            style: TextStyle(
              fontSize: 24, // Increase the font size
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem({
    required int orderId,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          'Order Number: $orderId',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void navigateToOrder() {
    Get.toNamed("/order");
  }

  void navigateToCheckout(int orderId) {
    Get.toNamed("/checkout", arguments: orderId);
  }
}
