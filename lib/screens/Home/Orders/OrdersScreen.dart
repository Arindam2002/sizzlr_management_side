import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizzlr_management_side/providers/authProvider.dart';
import 'package:sizzlr_management_side/providers/canteenProvider.dart';

import '../../../constants/constants.dart';
import '../../../providers/ordersProvider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Widget> items = [
    ItemRowInOrderCard(itemName: 'Peri Peri Maggi', quantity: 1, price: 65, itemId: '',),
    ItemRowInOrderCard(itemName: 'Fries', price: 80, quantity: 1, itemId: '',),
    ItemRowInOrderCard(itemName: 'Peri Peri Maggi', quantity: 1, price: 65, itemId: '',),
    ItemRowInOrderCard(itemName: 'Fries', price: 80, quantity: 1, itemId: '',),
  ];

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
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(
                              'institutions/X9ydF3xqSTtwR2lBmcUN/canteens/${context.watch<AuthProvider>().thisCanteenId}/orders(testing)')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('No requests available right now!'));
                        }
                        else if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(semanticsLabel: 'Loading data...',);
                        }
                        final requests = snapshot.data!.docs;
                        final requestsListFilter = requests.where((request) => request['request_accepted'] == null).toList();
                        final requestsList = requestsListFilter.map((req) {
                          final Map<String, dynamic> itemsOrdered =
                              req['items_ordered'];
                          final itemsOrderedList = <Widget>[];
                          // final list = [];
                          // itemsOrdered.forEach((key, value) async {
                          //   final data = await context.read<OrdersProvider>().getItemDetails(key, context.watch<AuthProvider>().thisCanteenId!);
                          //   itemsOrderedList.add(ItemRowInOrderCard(itemName: data['name'], price: data['price'], quantity: value));
                          // });
                          return ItemCardRequests(
                            orderId: req['order_id'],
                            canteenId: req['canteen_id'],
                            orderedBy: req['ordered_by'],
                            pickUpBy: req['pick_up_by'],
                            couponApplied: req['coupon_applied'],
                            couponId: req['coupon_id'],
                            orderCompleted: req['order_completed'],
                            delivered: req['delivered'],
                            itemsOrdered: req['items_ordered'],
                            timestamp: req['timestamp'],
                            transactionId: req['transaction_id'],
                            orderItemsList: itemsOrderedList,
                            totalAmount: req['total_amount'],
                          );
                        }).toList();
                        // print(requestsList);
                        return ListView(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            children: requestsList
                            // [
                            //   SizedBox(
                            //     height: 10,
                            //   ),
                            //   ItemCardRequests(items: items),
                            // ],
                            );
                      }),
                  // ListView(
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   children: [
                  //     SizedBox(
                  //       height: 10,
                  //     ),
                  //     ItemCardPreparing(items: items),
                  //   ],
                  // ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(
                          'institutions/X9ydF3xqSTtwR2lBmcUN/canteens/${context.watch<AuthProvider>().thisCanteenId}/orders(testing)')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('No orders are under preparation right now!'));
                        }
                        else if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(semanticsLabel: 'Loading data...',);
                        }
                        final requests = snapshot.data!.docs;
                        final requestsListFilter = requests.where((request) => request['request_accepted'] != null).toList();
                        final requestsList = requestsListFilter.map((req) {
                          final Map<String, dynamic> itemsOrdered = req['items_ordered'];
                          final itemsOrderedList = <Widget>[];
                          // final list = [];
                          // itemsOrdered.forEach((key, value) async {
                          //   final data = await context.read<OrdersProvider>().getItemDetails(key, context.watch<AuthProvider>().thisCanteenId!);
                          //   itemsOrderedList.add(ItemRowInOrderCard(itemName: data['name'], price: data['price'], quantity: value));
                          // });
                          return ItemCardPreparing(
                            orderId: req['order_id'],
                            canteenId: req['canteen_id'],
                            orderedBy: req['ordered_by'],
                            pickUpBy: req['pick_up_by'],
                            couponApplied: req['coupon_applied'],
                            couponId: req['coupon_id'],
                            orderCompleted: req['order_completed'],
                            delivered: req['delivered'],
                            itemsOrdered: req['items_ordered'],
                            timestamp: req['timestamp'],
                            transactionId: req['transaction_id'],
                            orderItemsList: itemsOrderedList,
                            totalAmount: req['total_amount'],
                          );
                        }).toList();
                        // print(requestsList);
                        return ListView(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            children: requestsList
                          // [
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          //   ItemCardRequests(items: items),
                          // ],
                        );
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}

class ItemCardRequests extends StatefulWidget {
  const ItemCardRequests({
    super.key,
    /*required this.items,*/ required this.orderId,
    required this.canteenId,
    required this.orderedBy,
    this.requestAccepted,
    this.askAFriend,
    required this.pickUpBy,
    required this.couponApplied,
    required this.couponId,
    required this.orderCompleted,
    required this.delivered,
    required this.itemsOrdered,
    required this.timestamp,
    required this.transactionId,
    required this.orderItemsList,
    required this.totalAmount,
  });

  // final List<Widget> items;
  final String orderId;
  final String canteenId;
  final String orderedBy;
  final dynamic requestAccepted;
  final dynamic askAFriend;
  final String pickUpBy;
  final bool couponApplied;
  final String couponId;
  final bool orderCompleted;
  final bool delivered;
  final Map<String, dynamic> itemsOrdered;
  final Timestamp timestamp;
  final String transactionId;
  final List<Widget> orderItemsList;
  final int totalAmount;

  @override
  State<ItemCardRequests> createState() => _ItemCardRequestsState();
}

class _ItemCardRequestsState extends State<ItemCardRequests> {
  final _estTimeFormKey = GlobalKey<FormState>();
  late int estimatedTime = 0;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 2,
        color: Colors.white,
        child: SizedBox(
          // height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${widget.orderId.substring(0, 5)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '00:30',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    )
                  ],
                ),
                Divider(
                  thickness: 0.5,
                ),
                SizedBox(
                  height: 100,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(
                              'institutions/X9ydF3xqSTtwR2lBmcUN/canteens/${context.watch<AuthProvider>().thisCanteenId}/orders(testing)/${widget.orderId}/items')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('Fetching data...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black54),));
                        }
                        final items = snapshot.data!.docs;
                        final itemsList = items.map((item) async {
                          final data = await Provider.of<OrdersProvider>(context)
                              .getItemDetails(item['item_id'],
                                  context.watch<AuthProvider>().thisCanteenId!);
                          return ItemRowInOrderCard(
                              itemName: data['name'],
                              price: data['price'],
                              quantity: item['quantity_ordered'],
                              itemId: item['item_id']);
                        }).toList();
                        return ListView.builder(
                            itemCount: itemsList.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                  future: itemsList[index],
                                  builder:
                                      (context, AsyncSnapshot<Widget> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return snapshot.data!;
                                    } else {
                                      return Container();
                                    }
                                  });
                            });
                      }),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ViewCompleteOrderDialog(
                            orderId: widget.orderId,
                            totalAmount: widget.totalAmount,
                            // items: widget.items,
                            // orderNumber: 120,
                          ),
                        );
                      },
                      child: Text('View complete order'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFB3261E)),
                            ),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              FirebaseFirestore.instance
                                  .collection(
                                  'institutions/X9ydF3xqSTtwR2lBmcUN/canteens/${Provider.of<AuthProvider>(context, listen: false).thisCanteenId}/orders(testing)').doc(widget.orderId).delete();
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Text(
                              'Reject',
                              style: TextStyle(color: Colors.white),
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
                                  MaterialStateProperty.all(Color(0xFF039487)),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Form(
                                  key: _estTimeFormKey,
                                  child: AlertDialog(
                                    title: Text(
                                      'Enter the estimated time for completion of the order:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    content: TextFormField(
                                        onChanged: (val) {
                                          estimatedTime = int.parse(val);
                                        },
                                        keyboardType: TextInputType.number,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'This field cannot be empty';
                                          }
                                          if (int.parse(val) <= 0) {
                                            return 'Enter a valid time';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(fontSize: 12),
                                        decoration: kFormFieldDecoration.copyWith(
                                            labelText: 'Estimated time (mins)',
                                            hintText: 'Ex. 20')),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            if (_estTimeFormKey.currentState!
                                                .validate()) {
                                              // TODO: Save the estimated time
                                              setState(() {
                                                isLoading = true;
                                              });
                                              FirebaseFirestore.instance
                                                  .collection(
                                                  'institutions/X9ydF3xqSTtwR2lBmcUN/canteens/${Provider.of<AuthProvider>(context, listen: false).thisCanteenId}/orders(testing)').doc(widget.orderId).update({
                                                'request_accepted': true,
                                                'expected_preparation_time_management': estimatedTime,
                                              });
                                              setState(() {
                                                isLoading = false;
                                              });
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
                              style: TextStyle(color: Colors.white),
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
    );
  }
}

class ItemCardPreparing extends StatefulWidget {
  const ItemCardPreparing({
    super.key, required this.orderId, required this.canteenId, required this.orderedBy, this.requestAccepted, this.askAFriend, required this.pickUpBy, required this.couponApplied, required this.couponId, required this.orderCompleted, required this.delivered, required this.itemsOrdered, required this.timestamp, required this.transactionId, required this.orderItemsList, required this.totalAmount,
    /*required this.items,*/
  });

  // final List<Widget> items;
  final String orderId;
  final String canteenId;
  final String orderedBy;
  final dynamic requestAccepted;
  final dynamic askAFriend;
  final String pickUpBy;
  final bool couponApplied;
  final String couponId;
  final bool orderCompleted;
  final bool delivered;
  final Map<String, dynamic> itemsOrdered;
  final Timestamp timestamp;
  final String transactionId;
  final List<Widget> orderItemsList;
  final int totalAmount;

  @override
  State<ItemCardPreparing> createState() => _ItemCardPreparingState();
}

class _ItemCardPreparingState extends State<ItemCardPreparing> {
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 2,
      color: Colors.white,
      child: SizedBox(
        // height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${widget.orderId.substring(0, 5)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '00:30',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  )
                ],
              ),
              Divider(
                thickness: 0.5,
              ),
              SizedBox(
                height: 100,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(
                        'institutions/X9ydF3xqSTtwR2lBmcUN/canteens/${context.watch<AuthProvider>().thisCanteenId}/orders(testing)/${widget.orderId}/items')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('Fetching data...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black54),));
                      }
                      final items = snapshot.data!.docs;
                      final itemsList = items.map((item) async {
                        final data = await Provider.of<OrdersProvider>(context)
                            .getItemDetails(item['item_id'],
                            context.watch<AuthProvider>().thisCanteenId!);
                        return ItemRowInOrderCard(
                            itemName: data['name'],
                            price: data['price'],
                            quantity: item['quantity_ordered'],
                            itemId: item['item_id']);
                      }).toList();
                      return ListView.builder(
                          itemCount: itemsList.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: itemsList[index],
                                builder:
                                    (context, AsyncSnapshot<Widget> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return snapshot.data!;
                                  } else {
                                    return Container();
                                  }
                                });
                          });
                    }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ViewCompleteOrderDialog(
                          orderId: widget.orderId,
                          totalAmount: widget.totalAmount,
                          // items: widget.items,
                          // orderNumber: 120,
                        ),
                      );
                    },
                    child: Text('View complete order'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryGreen),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Ready!',
                            style: TextStyle(color: Colors.white),
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
    );
  }
}

class ItemRowInOrderCard extends StatefulWidget {
  ItemRowInOrderCard({
    Key? key,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.itemId,
  }) : super(key: key);

  final String? itemId;
  late final String? itemName;
  late final int? price;
  final int? quantity;

  @override
  State<ItemRowInOrderCard> createState() => _ItemRowInOrderCardState();
}

class _ItemRowInOrderCardState extends State<ItemRowInOrderCard> {
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
                '${widget.itemName}',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              Text(
                ' (x${widget.quantity})',
                style: TextStyle(
                    color: Colors.black54, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          Text(
            '₹ ${widget.price}',
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
    required this.orderId,
    required this.totalAmount,
  }) : super(key: key);

  // final int? orderNumber;
  // final List<Widget> items;
  final String? orderId;
  final int totalAmount;

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
                'Order #${widget.orderId?.substring(0, 5)}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Divider()
            ],
          ),
          content: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(
                              'institutions/X9ydF3xqSTtwR2lBmcUN/canteens/${context.watch<AuthProvider>().thisCanteenId}/orders(testing)/${widget.orderId}/items')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('Fetching data...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black54),));
                        }
                        final items = snapshot.data!.docs;
                        final itemsList = items.map((item) async {
                          final data =
                              await Provider.of<OrdersProvider>(context)
                                  .getItemDetails(
                                      item['item_id'],
                                      context
                                          .watch<AuthProvider>()
                                          .thisCanteenId!);
                          return ItemRowInOrderCard(
                              itemName: data['name'],
                              price: data['price'],
                              quantity: item['quantity_ordered'],
                              itemId: item['item_id']);
                        }).toList();
                        return ListView.builder(
                            itemCount: itemsList.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                  future: itemsList[index],
                                  builder: (context,
                                      AsyncSnapshot<Widget> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return snapshot.data!;
                                    } else {
                                      return const Text('Fetching data...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black54),);
                                    }
                                  });
                            });
                      })
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
                      '₹ ${widget.totalAmount}',
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
