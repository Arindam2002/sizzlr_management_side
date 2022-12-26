import 'package:flutter/material.dart';
import 'package:sizzlr_management_side/screens/TermsAndConditions/TermsAndConditions.dart';

import '../../constants/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _contactNumberFormKey = GlobalKey<FormState>();
  final _userNameFormKey = GlobalKey<FormState>();

  late String phoneNumber = '';
  late String userName = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      'Billie Eillish',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Center(
                    child: Text(
                      '+91-8573918274',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(1, 2),
                              ),
                            ]),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(
                              'Person Details',
                              style: TextStyle(color: Colors.black),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 8.0,
                                    top: 2.0,
                                    bottom: 10.0),
                                child: Form(
                                  key: _userNameFormKey,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                            initialValue: 'Billie Eilish',
                                            onChanged: (val) {
                                              userName = val;
                                            },
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return 'This field cannot be empty';
                                              }
                                              return null;
                                            },
                                            style: TextStyle(fontSize: 12),
                                            decoration: kFormFieldDecoration
                                                .copyWith(
                                              labelText: 'Name',
                                            )),
                                      ),
                                      IconButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey.shade200
                                                        .withOpacity(0.5))),
                                        color: Colors.black54,
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 8.0,
                                    top: 2.0,
                                    bottom: 10.0),
                                child: Form(
                                  key: _contactNumberFormKey,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                            initialValue: '7261738192',
                                            onChanged: (val) {
                                              phoneNumber = val;
                                            },
                                            validator: (val) {
                                              if (val!.isEmpty ||
                                                  val.length != 10) {
                                                return 'This field cannot be empty';
                                              }
                                              return null;
                                            },
                                            style: TextStyle(fontSize: 12),
                                            decoration: kFormFieldDecoration
                                                .copyWith(
                                              labelText: 'Mobile Number',
                                            )),
                                      ),
                                      IconButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey.shade200
                                                        .withOpacity(0.5))),
                                        color: Colors.black54,
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(1, 2),
                              ),
                            ]),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ListTile(
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                              ),
                            ),
                            title: Text(
                              'Terms & Conditions',
                              style: TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TermsAndConditions()),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Copyright © 2022 Sizzlr.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              const Text(
                'All rights reserved',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child:
                    ElevatedButton(onPressed: () {}, child: Text('Logout')),
              )
            ],
          ),
        ],
      ),
    );
  }
}
