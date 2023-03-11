import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  Future<void> fetchRequests(String canteenId) async {
    // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('institutions/X9ydF3xqSTtwR2lBmcUN/canteens/$canteenId/orders(testing)').get();
  }

  Future<Map<String, dynamic>> getItemDetails(String itemId, String canteenId) async {
    final snapshot = await FirebaseFirestore.instance.collection('institutions/X9ydF3xqSTtwR2lBmcUN/canteens/$canteenId/menu/').doc(itemId).get();
    return snapshot.data()!;
  }
}