import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizzlr_management_side/constants/constants.dart';
import 'package:sizzlr_management_side/providers/authProvider.dart';
import 'package:sizzlr_management_side/providers/canteenProvider.dart';
import 'package:sizzlr_management_side/providers/itemProvider.dart';

import '../../providers/categorySelectorProvider.dart';
import 'components/components.dart';
import 'components/itemCardInMenu.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TabBar(
            indicatorColor: kPrimaryGreen,
            unselectedLabelColor: Colors.black,
            labelColor: kPrimaryGreen,
            tabs: [
              Tab(text: 'All Items'),
              Tab(
                text: 'Out of Stock',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Consumer<AuthProvider>(builder: (context, authProvider, child) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('institutions')
                        .doc('X9ydF3xqSTtwR2lBmcUN')
                        .collection('canteens')
                        .doc('${authProvider.thisCanteenId}')
                        .collection('menu')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        // return Text('Unable to fetch categories at the moment!', style: TextStyle(color: Colors.red),);
                        return Center(child: Text('Loading menu items, hang on...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.black54),));
                      }
                      final menuItems = snapshot.data!.docs;
                      final availableItems = menuItems.where((item) => item['is_available'] == true).toList();
                      if (availableItems.isEmpty) {
                        return Center(child: Text('No items'));
                      }
                      final itemMenuCards = availableItems.map((item) {
                        return ItemCardInMenu(
                          dishName: item['name'],
                          quantity: item['quantity'],
                          estTime: item['preparation_time'],
                          price: item['price'],
                          imageUrl: /*item['image_url']*/ "DUMMY IMAGE URL",
                          isAvailable: item['is_available'],
                          isVeg: item['is_veg'],
                          itemId: item['item_id'],
                          categoryId: item['category_id'],
                        );
                      }).toList();
                      return ListView(
                        shrinkWrap: true,
                        children: itemMenuCards,
                      );
                    },
                  );
                }),
                Consumer<AuthProvider>(builder: (context, authProvider, child) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('institutions')
                        .doc('X9ydF3xqSTtwR2lBmcUN')
                        .collection('canteens')
                        .doc('${Provider.of<AuthProvider>(context, listen: false).thisCanteenId}')
                        .collection('menu')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        // return Text('Unable to fetch categories at the moment!', style: TextStyle(color: Colors.red),);
                        return Text('Loading items not in stock, hang on...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black54),);;
                      }
                      final menuItems = snapshot.data!.docs;
                      final unAvailableItems = menuItems.where((item) => item['is_available'] == false).toList();
                      if (unAvailableItems.isEmpty) {
                        return Center(child: Text('No items'));
                      }
                      final itemMenuCards = unAvailableItems.map((item) {
                        return ItemCardInMenu(
                          dishName: item['name'],
                          quantity: item['quantity'],
                          estTime: item['preparation_time'],
                          price: item['price'],
                          imageUrl: /*item['image_url']*/ "DUMMY IMAGE URL",
                          isAvailable: item['is_available'],
                          isVeg: item['is_veg'],
                          itemId: item['item_id'],
                          categoryId: item['category_id'],
                        );
                      }).toList();
                      return ListView(
                        shrinkWrap: true,
                        children: itemMenuCards,
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
