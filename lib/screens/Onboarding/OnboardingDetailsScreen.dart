import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizzlr_management_side/providers/authProvider.dart';
import 'package:sizzlr_management_side/providers/canteenProvider.dart';

import '../../constants/constants.dart';

class OnboardingDetailsScreen extends StatefulWidget {
  const OnboardingDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingDetailsScreen> createState() =>
      _OnboardingDetailsScreenState();
}

class _OnboardingDetailsScreenState extends State<OnboardingDetailsScreen> {
  final _onboardingDeatilsFormKey = GlobalKey<FormState>();

  late String instituteName;
  late String canteenName;
  late int phoneNumber = 9876543211;

  // late LatLng canteenLocation;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryGreenAccent,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: LayoutBuilder(
            builder: (context, constraints) => ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 40),
                        child: Text(
                          'Commercial Details',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: kBoxShadowList),
                        child: Consumer<CanteenProvider>(
                            builder: (context, canteen, child) {
                          return Form(
                            key: _onboardingDeatilsFormKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: TextFormField(
                                      onChanged: (val) {
                                        instituteName = val;
                                      },
                                      keyboardType: TextInputType.name,
                                      validator: (val) {
                                        if (val.toString().length <= 5) {
                                          return 'Institute name must be greater than 5 characters';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(fontSize: 12),
                                      decoration: kFormFieldDecoration.copyWith(
                                        labelText: 'Institute Name',
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: TextFormField(
                                      onChanged: (val) {
                                        canteenName = val;
                                      },
                                      keyboardType: TextInputType.name,
                                      validator: (val) {
                                        if (val.toString().length <= 5) {
                                          return 'This field cannot not be empty';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(fontSize: 12),
                                      decoration: kFormFieldDecoration.copyWith(
                                        labelText: 'Canteen Name',
                                      )),
                                ),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Set Canteen Location')),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Consumer<AuthProvider>(builder:
                                          (context, authProvider, child) {
                                        return ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            if (_onboardingDeatilsFormKey
                                                .currentState!
                                                .validate()) {
                                              String canteenId = await canteen.onboardCanteen('X9ydF3xqSTtwR2lBmcUN', canteenName);
                                              await authProvider.updateManagerDetails('X9ydF3xqSTtwR2lBmcUN', canteenId, phoneNumber);
                                            }
                                            setState(() {
                                              isLoading = false;
                                            });
                                          },
                                          child: Text('Proceed'),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
