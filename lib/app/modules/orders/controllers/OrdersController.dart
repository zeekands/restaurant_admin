import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_admin/app/data/Orders.dart';

class OrdersController extends GetxController {
  final orderRef = FirebaseFirestore.instance.collection('order');
  final status = "menunggu".obs;
  final dataLength = 0.obs;
  final formatter = NumberFormat.decimalPattern('en_us');

  String currency(double value) {
    return formatter.format(value);
  }

  final selectedValueIndex = 0.obs;
  final buttonText = ["menunggu", "selesai"];

  Stream<List<Orders>> readOrder(String status) => FirebaseFirestore.instance
      .collection('order')
      .where('status', isEqualTo: status)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Orders.fromJson(doc.data())).toList());

  Future<void> updateStatus(String id, String status) async {
    await orderRef.doc(id).update({
      'status': status,
    });
  }
}
