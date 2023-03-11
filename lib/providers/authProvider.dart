import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";


class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  String? _canteenId;
  String? _instituteId;

  User? get user => _user;
  String? get thisCanteenId => _canteenId;
  String? get thisInstituteId => _instituteId;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      _user = userCredential.user;

      // Check if the document with the user's UID already exists in the `users` collection
      final DocumentSnapshot docSnapshot = await _db.collection('managers').doc(_user!.uid).get();
      if (!docSnapshot.exists) {
        // Update user details in Firestore database
        await _db.collection('managers').doc(_user!.uid).set({
          'user_id': _user!.uid,
          'canteen_id': "",
          'institute_id': "",
          'phone_number': null,
          'name': _user!.displayName,
          'email': _user!.email,
          'photoURL': _user!.photoURL,
        });
      } else {
        _canteenId = docSnapshot.get('canteen_id');
        _instituteId = docSnapshot.get('institute_id');
        print("(INSTITUTE ID, CANTEEN ID): ($_instituteId, $_canteenId)");
      }

      notifyListeners();
    }
  }

  Future<void> updateManagerDetails(String instituteId, String canteenId, int phoneNumber) async {
    await _db.collection('managers').doc(_user!.uid).update({
      'institute_id': instituteId,
      'canteen_id': canteenId,
      'phone_number': phoneNumber,
      'name': _user!.displayName,
      'email': _user!.email,
      'photoURL': _user!.photoURL,
    });

    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
    notifyListeners();
  }
}