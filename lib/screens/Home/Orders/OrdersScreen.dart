import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Widget> items = [
    ItemRowInOrderCard(itemName: 'Peri Peri Maggi', quantity: 1, price: 65),
    ItemRowInOrderCard(itemName: 'Fries', price: 80, quantity: 1),
    ItemRowInOrderCard(itemName: 'Thali', price: 60, quantity: 1),
    ItemRowInOrderCard(
        itemName: 'Aloo Cheese Sandwhich', price: 45, quantity: 1),
    ItemRowInOrderCard(itemName: 'Schezwan Chutney', price: 10, quantity: 2),
    ItemRowInOrderCard(itemName: 'Peri Peri Maggi', quantity: 1, price: 65),
    ItemRowInOrderCard(itemName: 'Fries', price: 80, quantity: 1),
    ItemRowInOrderCard(itemName: 'Thali', price: 60, quantity: 1),
    ItemRowInOrderCard(
        itemName: 'Aloo Cheese Sandwhich', price: 45, quantity: 1),
    ItemRowInOrderCard(itemName: 'Schezwan Chutney', price: 10, quantity: 2),
    ItemRowInOrderCard(itemName: 'Peri Peri Maggi', quantity: 1, price: 65),
    ItemRowInOrderCard(itemName: 'Fries', price: 80, quantity: 1),
    ItemRowInOrderCard(itemName: 'Thali', price: 60, quantity: 1),
    ItemRowInOrderCard(
        itemName: 'Aloo Cheese Sandwhich', price: 45, quantity: 1),
    ItemRowInOrderCard(itemName: 'Schezwan Chutney', price: 10, quantity: 2),
  ];

  final _estTimeFormKey = GlobalKey<FormState>();
  late int? estimatedTime = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              indicatorColor: kPrimaryGreen,
              unselectedLabelColor: Colors.black,
              labelColor: kPrimaryGreen,
              tabs: [
                Tab(text: 'Requests'),
                Tab(
                  text: 'Preparing',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        surfaceTintColor: Colors.white,
                        elevation: 2,
                        color: Colors.white,
                        child: SizedBox(
                          // height: 200,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '#122',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '00:30',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 0.5,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return index < 4
                                          ? items[index]
                                          : Container();
                                    },
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ViewCompleteOrderDialog(
                                            items: items,
                                            orderNumber: 120,
                                          ),
                                        );
                                      },
                                      child: Text('View complete order'),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xFFB3261E)),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              'Reject',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xFF039487)),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    Form(
                                                      key: _estTimeFormKey,
                                                      child: AlertDialog(
                                                        title: Text('Enter the estimated time for completion of the order:', style: TextStyle(fontSize: 16),),
                                                        content: TextFormField(
                                                            onChanged: (val) {
                                                              estimatedTime = int.parse(val);
                                                            },
                                                            keyboardType: TextInputType.number,
                                                            validator: (val) {
                                                              if (val!.isEmpty) {
                                                                return 'This field cannot be empty';
                                                              }
                                                              if (int.parse(val)<=0) {
                                                                return 'Enter a valid time';
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(fontSize: 12),
                                                            decoration: kFormFieldDecoration.copyWith(labelText: 'Estimated time (mins)', hintText: 'Ex. 20')
                                                        ),
                                                        actions: [
                                                          TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
                                                          TextButton(
                                                              onPressed: (){
                                                                if (_estTimeFormKey.currentState!.validate()) {
                                                                  // TODO: Save the estimated time
                                                                  Navigator.pop(context);
                                                                }
                                                              },
                                                              child: Text('Approve the order')),
                                                        ],
                                                      ),
                                                    ),
                                              );
                                            },
                                            child: Text(
                                              'Approve',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        surfaceTintColor: Colors.white,
                        elevation: 2,
                        color: Colors.white,
                        child: SizedBox(
                          // height: 200,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '#122',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '00:30',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 0.5,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return index < 4
                                          ? items[index]
                                          : Container();
                                    },
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ViewCompleteOrderDialog(
                                            items: items,
                                            orderNumber: 120,
                                          ),
                                        );
                                      },
                                      child: Text('View complete order'),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      kPrimaryGreen),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              'Ready!',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class ItemRowInOrderCard extends StatelessWidget {
  const ItemRowInOrderCard({
    Key? key,
    required this.itemName,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  final String? itemName;
  final int? price;
  final int? quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '$itemName',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              Text(
                ' (x$quantity)',
                style: TextStyle(
                    color: Colors.black54, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          Text(
            '₹ $price',
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ViewCompleteOrderDialog extends StatefulWidget {
  const ViewCompleteOrderDialog({
    Key? key,
    required this.items,
    required this.orderNumber,
  }) : super(key: key);

  final int? orderNumber;
  final List<Widget> items;

  @override
  State<ViewCompleteOrderDialog> createState() =>
      _ViewCompleteOrderDialogState();
}

class _ViewCompleteOrderDialogState extends State<ViewCompleteOrderDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.75,
        child: AlertDialog(
          actionsPadding: EdgeInsets.symmetric(horizontal: 0),
          titlePadding: EdgeInsets.only(left: 0, right: 0, bottom: 20),
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Column(
            children: [
              Text(
                'Order #${widget.orderNumber}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Divider()
            ],
          ),
          content: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return widget.items[index];
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sum Total',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹ 300',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
