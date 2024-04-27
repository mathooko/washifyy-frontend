import 'package:get/get.dart';

class CheckoutController extends GetxController {
  var checkedOutItems = <int, Map<String, dynamic>>{}.obs;

  void addOrderDetails(int orderId, Map<String, dynamic> details) {
    checkedOutItems.value
        .update(orderId, (value) => details, ifAbsent: () => details);
  }
}
