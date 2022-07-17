import 'package:get/get.dart';

import '../controllers/OrdersController.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrdersController());
  }
}
