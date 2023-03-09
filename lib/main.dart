import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizzlr_management_side/constants/constants.dart';
import 'package:sizzlr_management_side/providers/authProvider.dart';
import 'package:sizzlr_management_side/providers/canteenProvider.dart';
import 'package:sizzlr_management_side/providers/categorySelectorProvider.dart';
import 'package:sizzlr_management_side/providers/itemProvider.dart';
import 'package:sizzlr_management_side/screens/Authentication/LoginScreen.dart';
import 'package:sizzlr_management_side/screens/Authentication/OtpVerificationScreen.dart';
import 'package:sizzlr_management_side/screens/Authentication/RegistrationScreen.dart';
import 'package:sizzlr_management_side/screens/Home/HomeScreen.dart';
import 'package:sizzlr_management_side/screens/Onboarding/OnboardingDetailsScreen.dart';
import 'package:sizzlr_management_side/screens/Onboarding/OnboardingScreen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CanteenProvider()),
        ChangeNotifierProvider(create: (_) => Filter()),
        ChangeNotifierProvider(create: (_) => VegSelector()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: MaterialApp(
          title: 'Sizzlr Management side Demo',
          theme:
              ThemeData(useMaterial3: true, colorSchemeSeed: Color(0xFF27742D)),
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.user == null) {
                return LoginScreen();
              } else {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('managers')
                      .doc(authProvider.user!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                        // TODO: ADD A CUSTOMIZED SIZZLR LOADER
                          body: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    if (data != null && data['canteen_id'] != "") {
                      return HomeScreen();
                    } else {
                      return OnboardingDetailsScreen();
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        foregroundColor: Color(0xFF6D49A7),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sizzlr\'s Management Side',
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('hoi'),
            )
          ],
        ),
      ),
    );
  }
}
