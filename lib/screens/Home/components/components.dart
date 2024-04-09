import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizzlr_management_side/providers/authProvider.dart';
import 'package:sizzlr_management_side/providers/canteenProvider.dart';

import '../../../constants/constants.dart';
import '../../../providers/categorySelectorProvider.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({Key? key}) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late String dishName;
  late String quantity;
  late int preparationTime;
  late int price;
  late String categoryIdSelected;
  late bool isVegLabelSelected;

  File? image;

  Future pickImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  final _addItemFormKey = GlobalKey<FormState>();

  ChoiceChip buildCanteenChip(BuildContext context,
      {required String? text,
      required String? categoryId,
      required int? keyValue}) {
    return ChoiceChip(
      label: Text('$text'),
      labelStyle: const TextStyle(fontSize: 12),
      side: context.watch<Filter>().value == keyValue
          ? BorderSide(color: kPrimaryGreen)
          : BorderSide(color: Colors.grey.shade300),
      selectedColor: kPrimaryGreenAccent,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: kPrimaryGreen)),
      labelPadding: EdgeInsets.zero,
      selected: context.watch<Filter>().value == keyValue,
      onSelected: (bool selected) {
        selected ? context.read<Filter>().updateValue(keyValue!) : null;
        categoryIdSelected = categoryId!;
      },
    );
  }

  Padding buildVegLabelSelector(BuildContext context,
      {required String? text, required int? keyValue, required bool isVeg}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border:
                      Border.all(color: isVeg ? Colors.green : Colors.brown),
                ),
                child: Icon(
                  Icons.circle,
                  size: 8,
                  color: isVeg ? Colors.green : Colors.brown,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text('$text'),
          ],
        ),
        labelStyle: const TextStyle(fontSize: 12),
        side: context.watch<VegSelector>().value == keyValue
            ? BorderSide(color: kPrimaryGreen)
            : BorderSide(color: Colors.grey.shade300),
        selectedColor: kPrimaryGreenAccent,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: kPrimaryGreen)),
        labelPadding: EdgeInsets.zero,
        selected: context.watch<VegSelector>().value == keyValue,
        onSelected: (bool selected) {
          selected ? context.read<VegSelector>().updateValue(keyValue!) : null;
          isVegLabelSelected = isVeg;
        },
      ),
    );
  }

  bool isAddingItem = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isAddingItem,
      child: AlertDialog(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 0),
        titlePadding: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        title: const Text('Add item'),
        content: Form(
          key: _addItemFormKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                    autofocus: true,
                    onChanged: (val) {
                      dishName = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 12),
                    decoration: kFormFieldDecoration.copyWith(
                        labelText: 'Name', hintText: 'Ex. Aloo Paratha')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                    autofocus: true,
                    onChanged: (val) {
                      quantity = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 12),
                    decoration: kFormFieldDecoration.copyWith(
                        labelText: 'Quantity', hintText: 'Ex. 1 paratha')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                    autofocus: true,
                    onChanged: (val) {
                      preparationTime = int.parse(val);
                    },
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 12),
                    decoration: kFormFieldDecoration.copyWith(
                        labelText: 'Estimated time (in minutes)',
                        hintText: 'Ex. 10 min')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                    autofocus: true,
                    onChanged: (val) {
                      price = int.parse(val);
                    },
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 12),
                    decoration: kFormFieldDecoration.copyWith(
                        labelText: 'Price', hintText: 'Ex. 15')),
              ),
              const Text(
                'Category',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      // return Text('Unable to fetch categories at the moment!', style: TextStyle(color: Colors.red),);
                      return const Text('Loading categories, hang on...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black54),);
                    }
                    final categories = snapshot.data!.docs;
                    final chips = categories
                        .map(
                          (category) => buildCanteenChip(
                            context,
                            text: category['name'],
                            keyValue: category['name'].hashCode,
                            categoryId: category['category_id'],
                          ),
                        )
                        .toList();
                    return Wrap(
                      spacing: 10,
                      children: chips,
                    );
                  },
                ),
              ),
              const Text(
                'Label',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Wrap(
                  spacing: 10,
                  children: [
                    buildVegLabelSelector(context,
                        text: 'veg', keyValue: 0, isVeg: true),
                    buildVegLabelSelector(context,
                        text: 'non-veg', keyValue: 1, isVeg: false),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: image?.path == null
                              ? const Icon(
                                  Icons.image_outlined,
                                  color: Colors.grey,
                                )
                              : Image.file(
                                  File(
                                    image!.path,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      pickImage(context);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          size: 18,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text(
                            'Add Image',
                          ),
                        ),
                      ],
                    ),
                    // style: ButtonStyle(
                    //     backgroundColor:
                    //         MaterialStateProperty.all(kPrimaryColor)),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.read<Filter>().resetValue();
              context.read<VegSelector>().resetValue();
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          ),
          Consumer<CanteenProvider>(builder: (context, canteenProvider, child) {
            return Builder(builder: (context) {
              return TextButton(
                onPressed: () async {
                  if (_addItemFormKey.currentState!.validate()) {
                    setState(() {
                      isAddingItem = true;
                    });
                    Map<String, dynamic> itemData = {
                      'category_id': categoryIdSelected,
                      'name': dishName,
                      'price': price,
                      'quantity': quantity,
                      'preparation_time': preparationTime,
                      'is_available': true,
                      'is_veg': isVegLabelSelected,
                    };
                    print(itemData);
                    canteenProvider.addItemToMenu(
                        instituteId: 'X9ydF3xqSTtwR2lBmcUN',
                        itemToBeAdded: itemData,
                        canteenId:
                            '${Provider.of<AuthProvider>(context, listen: false).thisCanteenId}');

                    setState(() {
                      isAddingItem = false;
                    });

                    context.read<Filter>().resetValue();
                    context.read<VegSelector>().resetValue();

                    Navigator.pop(context, 'Add');
                  }
                },
                child: const Text('Add'),
              );
            });
          }),
        ],
      ),
    );
  }
}

class EditItemDialog extends StatefulWidget {
  const EditItemDialog(
      {Key? key,
      required this.dishName,
      required this.quantity,
      required this.estTime,
      required this.price,
      required this.imageUrl,
      required this.itemId,
      required this.categoryIdSelected,
      required this.isVegLabelSelected, required this.outerContext})
      : super(key: key);

  final String? dishName;
  final String? itemId;
  final String? quantity;
  final int? estTime;
  final int? price;
  final String? imageUrl;
  final String? categoryIdSelected;
  final bool? isVegLabelSelected;
  final BuildContext outerContext;

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late String? dishName;
  late String? quantity;
  late int? preparationTime;
  late int? price;
  late String? categoryIdSelected;
  late bool? isVegLabelSelected;

  File? image;

  Future pickImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  final _editItemFormKey = GlobalKey<FormState>();

  ChoiceChip buildCanteenChip(BuildContext context,
      {required String? text,
      required String? categoryId,
      required int? keyValue}) {
    return ChoiceChip(
      label: Text('$text'),
      labelStyle: const TextStyle(fontSize: 12),
      side: context.watch<Filter>().value == keyValue
          ? BorderSide(color: kPrimaryGreen)
          : BorderSide(color: Colors.grey.shade300),
      selectedColor: kPrimaryGreenAccent,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: kPrimaryGreen)),
      labelPadding: EdgeInsets.zero,
      selected: context.watch<Filter>().value == keyValue,
      onSelected: (bool selected) {
        selected ? context.read<Filter>().updateValue(keyValue!) : null;
        categoryIdSelected = categoryId!;
      },
    );
  }

  Padding buildVegLabelSelector(BuildContext context,
      {required String? text, required int? keyValue, required bool isVeg}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border:
                      Border.all(color: isVeg ? Colors.green : Colors.brown),
                ),
                child: Icon(
                  Icons.circle,
                  size: 8,
                  color: isVeg ? Colors.green : Colors.brown,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text('$text'),
          ],
        ),
        labelStyle: const TextStyle(fontSize: 12),
        side: context.watch<VegSelector>().value == keyValue
            ? BorderSide(color: kPrimaryGreen)
            : BorderSide(color: Colors.grey.shade300),
        selectedColor: kPrimaryGreenAccent,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: kPrimaryGreen)),
        labelPadding: EdgeInsets.zero,
        selected: context.watch<VegSelector>().value == keyValue,
        onSelected: (bool selected) {
          selected ? context.read<VegSelector>().updateValue(keyValue!) : null;
          isVegLabelSelected = isVeg;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    dishName = widget.dishName;
    quantity = widget.quantity;
    preparationTime = widget.estTime;
    price = widget.price;
    categoryIdSelected = widget.categoryIdSelected;
    isVegLabelSelected = widget.isVegLabelSelected;
  }

  @override
  Widget build(BuildContext context) {
    bool isEditingItem = false;

    return ModalProgressHUD(
      inAsyncCall: isEditingItem,
      child: AlertDialog(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 0),
        titlePadding: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        title: Stack(
          children: [
            const Text('Edit item'),
            Positioned(
              right: -10,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.delete),
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                onPressed: () async {
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: const Text('Delete this item?'),
                    content: const Text('Once deleted, you can\'t recover this data!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Provider.of<Filter>(context, listen: false).resetValue();
                          Provider.of<VegSelector>(context, listen: false).resetValue();
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<Filter>(context, listen: false).resetValue();
                          Provider.of<VegSelector>(context, listen: false).resetValue();
                          Provider.of<CanteenProvider>(context, listen: false).deleteItemFromMenu(instituteId: 'X9ydF3xqSTtwR2lBmcUN', canteenId: Provider.of<AuthProvider>(context, listen: false).thisCanteenId, itemId: widget.itemId!);
                          Navigator.pop(context, 'Delete');
                          Navigator.pop(widget.outerContext);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ));
                },
              ),
            ),
          ],
        ),
        content: Form(
          key: _editItemFormKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                    initialValue: '${widget.dishName}',
                    autofocus: true,
                    onChanged: (val) {
                      dishName = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 12),
                    decoration: kFormFieldDecoration.copyWith(
                        labelText: 'Name', hintText: 'Ex. Aloo Paratha')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                    initialValue: '${widget.quantity}',
                    autofocus: true,
                    onChanged: (val) {
                      quantity = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 12),
                    decoration: kFormFieldDecoration.copyWith(
                        labelText: 'Quantity', hintText: 'Ex. 1 paratha')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                    initialValue: '${widget.estTime}',
                    autofocus: true,
                    onChanged: (val) {
                      preparationTime = int.parse(val);
                    },
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 12),
                    decoration: kFormFieldDecoration.copyWith(
                        labelText: 'Estimated time (in minutes)',
                        hintText: 'Ex. 10 min')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                    initialValue: '${widget.price}',
                    autofocus: true,
                    onChanged: (val) {
                      price = int.parse(val);
                    },
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 12),
                    decoration: kFormFieldDecoration.copyWith(
                        labelText: 'Price', hintText: 'Ex. 15')),
              ),
              const Text(
                'Category',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      // return Text('Unable to fetch categories at the moment!', style: TextStyle(color: Colors.red),);
                      return const Text('Loading categories, hang on...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black54),);
                    }
                    final categories = snapshot.data!.docs;
                    final chips = categories
                        .map(
                          (category) => buildCanteenChip(
                            context,
                            text: category['name'],
                            keyValue: category['category_id'].hashCode,
                            categoryId: category['category_id'],
                          ),
                        )
                        .toList();
                    return Wrap(
                      spacing: 10,
                      children: chips,
                    );
                  },
                ),
              ),
              const Text(
                'Label',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Wrap(
                  spacing: 10,
                  children: [
                    buildVegLabelSelector(context,
                        text: 'veg', keyValue: true.hashCode, isVeg: true),
                    buildVegLabelSelector(context,
                        text: 'non-veg',
                        keyValue: false.hashCode,
                        isVeg: false),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: image?.path == null
                              ? const Icon(
                                  Icons.image_outlined,
                                  color: Colors.grey,
                                )
                              : Image.file(
                                  //TODO: Use imageUrl here
                                  File(
                                    image!.path,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      pickImage(context);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          size: 18,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text(
                            'Add Image',
                          ),
                        ),
                      ],
                    ),
                    // style: ButtonStyle(
                    //     backgroundColor:
                    //         MaterialStateProperty.all(kPrimaryColor)),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.read<Filter>().resetValue();
              context.read<VegSelector>().resetValue();
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          ),
          Consumer2<AuthProvider, CanteenProvider>(
              builder: (context, authProvider, canteenProvider, child) {
            return Builder(builder: (context) {
              return TextButton(
                onPressed: () async {
                  if (_editItemFormKey.currentState!.validate()) {
                    setState(() {
                      isEditingItem = true;
                    });
                    Map<String, dynamic> itemData = {
                      'category_id': categoryIdSelected,
                      'name': dishName,
                      'price': price,
                      'quantity': quantity,
                      'preparation_time': preparationTime,
                      'is_veg': isVegLabelSelected,
                    };
                    canteenProvider.updateItemInMenu(
                        instituteId: 'X9ydF3xqSTtwR2lBmcUN',
                        updatedItem: itemData,
                        itemId: '${widget.itemId}',
                        canteenId: authProvider.thisCanteenId);

                    setState(() {
                      isEditingItem = false;
                    });

                    context.read<Filter>().resetValue();
                    context.read<VegSelector>().resetValue();
                    Navigator.pop(context, 'Add');
                  }
                },
                child: const Text('Add'),
              );
            });
          }),
        ],
      ),
    );
  }
}
