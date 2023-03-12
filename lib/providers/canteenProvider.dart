import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizzlr_management_side/providers/authProvider.dart';

class CanteenProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // String? _canteenId;

  // String? get thisCanteenId => _canteenId;

  Future<String> onboardCanteen(String instituteId, String canteenName) async {
    CollectionReference canteens = _db.collection('institutions').doc(instituteId).collection('canteens');
    DocumentReference newCanteenRef = canteens.doc();

    Map<String, dynamic> data = {
      'canteen_id': newCanteenRef.id,
      'name': canteenName,
      // TODO: Get the canteen location
      // 'location': ,
      'manager_id': _auth.currentUser?.uid,
    };


    // newCanteenRef.update(data);
    print("Onboarding...");
    await canteens.doc(newCanteenRef.id).set(data, SetOptions(merge: true));
    print("Onboarded!");

    // _canteenId = newCanteenRef.id;

    notifyListeners();

    return newCanteenRef.id;
  }

  Future<void> addItemToMenu({required String instituteId, required String canteenId, required Map<String, dynamic> itemToBeAdded}) async {
    CollectionReference menu = _db.collection('institutions').doc(instituteId).collection('canteens').doc(canteenId).collection('menu');
    DocumentReference newItemRef = menu.doc();

    print('In Provider');
    itemToBeAdded.addAll({
      'item_id': newItemRef.id,
    });

    await menu.doc(newItemRef.id).set(itemToBeAdded, SetOptions(merge: true));

    notifyListeners();
  }

  Future<void> updateItemInMenu({required String instituteId, required String? canteenId, required String itemId, required Map<String, dynamic> updatedItem}) async {

    await _db.collection('institutions').doc(instituteId).collection('canteens').doc(canteenId).collection('menu').doc(itemId).update(updatedItem);

    notifyListeners();
  }
  
  Future<void> deleteItemFromMenu({required String instituteId, required String? canteenId, required String itemId}) async {
    await FirebaseFirestore.instance.collection('institutions/$instituteId/canteens/$canteenId/menu').doc(itemId).delete();
  }

  Future<void> updateAvailability({required String? instituteId, required String? canteenId, required String itemId, required bool isAvailable}) async {
    await FirebaseFirestore.instance.collection(
        'institutions').doc(instituteId).collection('canteens').doc(canteenId).collection('menu').doc(itemId).update({
      'is_available': isAvailable
    });

    notifyListeners();
  }
}