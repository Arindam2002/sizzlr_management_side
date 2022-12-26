import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizzlr_management_side/constants/constants.dart';

import '../Home/components/components.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kPrimaryGreenAccent,
      floatingActionButton: FloatingActionButton(
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
        backgroundColor: kPrimaryGreenAccent,
        child: Icon(
          Icons.add_rounded,
          color: kPrimaryGreen,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Create Menu',
          style: TextStyle(color: kPrimaryGreen),
        ),
        elevation: 0,
        shadowColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          SizedBox(
            height: 7.5,
          ),
          AddMenuItemCard(),
          AddMenuItemCard(),
          AddMenuItemCard(),
          AddMenuItemCard(),
          AddMenuItemCard(),
          AddMenuItemCard(),
          AddMenuItemCard(),
        ],
      ),
    );
  }
}

class AddMenuItemCard extends StatelessWidget {
  const AddMenuItemCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: kBoxShadowList
        ),
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
                  child:
                      Image.asset('assets/images/fries.jpg', fit: BoxFit.cover),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Fries',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '1 Plate',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                            ),
                            // Text(
                            //   'Noon',
                            //   style: TextStyle(),
                            // ),
                          ],
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.timer_outlined,
                              color: Colors.black54,
                              size: 18,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              '10 mins',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              //TODO: Delete item logic
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '₹ 45',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
