import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/canteenProvider.dart';
import '../../../providers/categorySelectorProvider.dart';
import 'components.dart';

class ItemCardInMenu extends StatefulWidget {
  const ItemCardInMenu({
    Key? key,
    required this.itemId,
    required this.dishName,
    required this.categoryId,
    required this.quantity,
    required this.estTime,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    required this.isVeg,
  }) : super(key: key);

  final String? itemId;
  final String? dishName;
  final String? categoryId;
  final String? quantity;
  final int? estTime;
  final int? price;
  final String? imageUrl;
  final bool isAvailable;
  final bool isVeg;

  @override
  State<ItemCardInMenu> createState() => _ItemCardInMenuState();
}

class _ItemCardInMenuState extends State<ItemCardInMenu> {
  late bool switchVal;

  @override
  void initState() {
    super.initState();
    switchVal = widget.isAvailable;
    // context.read<ItemProvider>().updateValue(widget.isAvailable);
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdatingAvailability = false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
      child: ModalProgressHUD(
        inAsyncCall: isUpdatingAvailability,
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
                    child: Image.asset(
                        'assets/images/fries.jpg', //TODO: Use imageUrl here
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.dishName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 3.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(4),
                                            border: Border.all(
                                                color: widget.isVeg
                                                    ? Colors.green
                                                    : Colors.brown),
                                          ),
                                          child: Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: widget.isVeg
                                                ? Colors.green
                                                : Colors.brown,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 5),
                                        child: Text(
                                          '${widget.quantity}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),

                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('categories')
                                        .doc(widget.categoryId)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                        snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text('Loading...');
                                      }

                                      final data = snapshot.data?.data()
                                      as Map<String, dynamic>;

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 5),
                                        child: Text(
                                          '${data['name']}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      );
                                    },
                                  )

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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    context.read<Filter>().updateValue(
                                        widget.categoryId.hashCode);
                                    context
                                        .read<VegSelector>()
                                        .updateValue(widget.isVeg.hashCode);
                                    showDialog<String>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) => Dialog(
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height /
                                                1.75,
                                            child: EditItemDialog(
                                              dishName: '${widget.dishName}',
                                              quantity: '${widget.quantity}',
                                              estTime: widget.estTime,
                                              price: widget.price,
                                              imageUrl: '${widget.imageUrl}',
                                              itemId: '${widget.itemId}',
                                              categoryIdSelected:
                                              widget.categoryId,
                                              isVegLabelSelected: widget.isVeg, outerContext: context,
                                            )),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Icons.edit,
                                      size: 24,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Consumer2<AuthProvider, CanteenProvider>(builder:
                                  (context, authProvider, canteenProvider,
                                  child) {
                                return Switch(
                                  activeColor: Color(0xFF039487),
                                  inactiveThumbColor: Color(0xFFd50c11),
                                  inactiveTrackColor:
                                  Color(0xFFd50c11).withAlpha(100),
                                  value: switchVal,
                                  // value: context.watch<ItemProvider>().toggleVal,
                                  onChanged: (val) async {
                                    setState(() {
                                      switchVal = val;
                                      print(switchVal);
                                    });
                                    // context.read<ItemProvider>().updateValue(val);
                                    // if (kDebugMode) {
                                    //   print("Updating Availability Status...");
                                    // }
                                    await canteenProvider.updateAvailability(
                                        instituteId:
                                        authProvider.thisInstituteId,
                                        canteenId: authProvider.thisCanteenId,
                                        itemId: "${widget.itemId}",
                                        isAvailable: switchVal);
                                    // if (kDebugMode) {
                                    //   print("Successfully Updated!");
                                    // }
                                  },
                                );
                              }),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Text(
                              '₹ ${widget.price}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}