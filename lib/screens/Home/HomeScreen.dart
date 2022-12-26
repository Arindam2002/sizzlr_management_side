import 'package:flutter/material.dart';
import 'package:sizzlr_management_side/screens/Home/MenuScreen.dart';
import 'package:sizzlr_management_side/screens/Home/Orders/OrdersScreen.dart';
import 'package:sizzlr_management_side/screens/Home/ProfileScreen.dart';
import 'package:sizzlr_management_side/screens/Home/components/components.dart';

import '../../constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  List<Widget> _titleWidgetOptions = <Widget>[
    Text(
      'Menu',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    ),
    Text(
      'Orders',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    ),
    // Text(
    //   'Budget Management',
    //   style: TextStyle(color: kPrimaryGreen),
    // ),
    Text(
      'Profile',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    ),
  ];

  List<Widget> _widgetOptions = <Widget>[
    MenuScreen(),
    OrdersScreen(),
    // Text(
    //   'Index 2: School',
    //   style: optionStyle,
    // ),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kPrimaryGreenAccent,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: kPrimaryGreenAccent,
        title: _titleWidgetOptions.elementAt(_selectedIndex),
        elevation: 0,
        shadowColor: Colors.black,
      ),
      floatingActionButton: _selectedIndex == 0 ? AnimatedContainer(
        duration: Duration(seconds: 4),
        curve: Curves.easeInCubic,
        child: FloatingActionButton(
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.75,
                    child: AddItemDialog()),
              ),
            );
          },
          tooltip: 'New in menu',
          child: Icon(Icons.add_rounded),
        ),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: TextStyle(fontSize: 10, color: Color(0xFF868686)),
        selectedLabelStyle: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black),
        selectedIconTheme: IconThemeData(color: kPrimaryGreen),
        unselectedIconTheme: IconThemeData(color: Color(0xFF868686)),
        selectedItemColor: Colors.black,
        unselectedItemColor: Color(0xFF868686),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: _selectedIndex == 0
                  ? Icon(Icons.food_bank_rounded)
                  : Icon(Icons.food_bank_outlined),
            ),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: _selectedIndex == 1
                  ? Icon(Icons.lunch_dining_rounded)
                  : Icon(Icons.lunch_dining_outlined),
            ),
            label: 'Orders',
          ),
          // BottomNavigationBarItem(
          //   icon: Padding(
          //     padding: const EdgeInsets.only(bottom: 2.0),
          //     child: Icon(Icons.school),
          //   ),
          //   label: 'School',
          // ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: _selectedIndex == 2
                  ? Icon(Icons.person_rounded)
                  : Icon(Icons.person_outline),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
