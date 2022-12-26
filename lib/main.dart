import 'package:flutter/material.dart';
import 'package:sizzlr_management_side/constants/constants.dart';
import 'package:sizzlr_management_side/screens/Authentication/LoginScreen.dart';
import 'package:sizzlr_management_side/screens/Authentication/OtpVerificationScreen.dart';
import 'package:sizzlr_management_side/screens/Authentication/RegistrationScreen.dart';
import 'package:sizzlr_management_side/screens/Home/HomeScreen.dart';
import 'package:sizzlr_management_side/screens/Onboarding/OnboardingScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sizzlr Management side Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color(0xFF27742D)
      ),
      home: HomeScreen(),
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
      floatingActionButton: FloatingActionButton(onPressed: (){}, foregroundColor: Color(0xFF6D49A7),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sizzlr\'s Management Side',
            ),
            ElevatedButton(onPressed: (){}, child: Text('hoi'),)
          ],
        ),
      ),
    );
  }
}
