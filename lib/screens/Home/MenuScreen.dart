import 'package:flutter/material.dart';
import 'package:sizzlr_management_side/constants/constants.dart';

import 'components/components.dart';

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
                ListView(
                  children: [
                    SizedBox(height: 10,),
                    for (int i = 0; i < 5; i++) ItemCardInMenu(dishName: 'Peri Peri Fries', quantity: '1 Plate', estTime: 10, price: 80, imageUrl: 'imageUrl'),
                    // ItemCardInMenu(dishName: 'Cheese Sandwich', quantity: '4 triangles', estTime: 10, price: 45, imageUrl: 'imageUrl')
                  ],
                ),
                Text('OUT OF STOCK SCREEN'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCardInMenu extends StatefulWidget {
  const ItemCardInMenu({
    Key? key, required this.dishName, required this.quantity, required this.estTime, required this.price, required this.imageUrl,
  }) : super(key: key);

  final String? dishName;
  final String? quantity;
  final int? estTime;
  final int? price;
  final String? imageUrl;

  @override
  State<ItemCardInMenu> createState() => _ItemCardInMenuState();
}

class _ItemCardInMenuState extends State<ItemCardInMenu> {

  bool switchVal = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 7.5, horizontal: 15),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: kBoxShadowList),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: Image.asset('assets/images/fries.jpg',   //TODO: Use imageUrl here
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 15),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.dishName}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0),
                                  child: Text(
                                    '${widget.quantity}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54),
                                  ),
                                ),
                                // Text(
                                //   'Noon',
                                //   style: TextStyle(),
                                // ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  color: Colors.black54,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  '${widget.estTime} mins',
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.circular(100),
                                onTap: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height / 1.75,
                                          child: EditItemDialog(dishName: '${widget.dishName}', quantity: '${widget.quantity}', estTime: widget.estTime, price: widget.price, imageUrl: '${widget.imageUrl}')),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                      Colors.transparent,
                                  child: Icon(
                                    Icons.edit,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Switch(
                              activeColor: Color(0xFF039487),
                              inactiveThumbColor: Color(0xFFd50c11),
                              inactiveTrackColor: Color(0xFFd50c11).withAlpha(100),

                              value: switchVal,
                              onChanged: (val) {
                                setState(() {
                                  switchVal = val;
                                });
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            '₹ ${widget.price}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
