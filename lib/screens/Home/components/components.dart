import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../constants/constants.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({Key? key}) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late String dishName;
  late String quantity;
  late String estTime;
  late String price;

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.symmetric(horizontal: 0),
      titlePadding: EdgeInsets.only(left: 0, right: 0, bottom: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      title: const Text('Add item'),
      content: ListView(
        children: [
          SizedBox(
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
                style: TextStyle(fontSize: 12),
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
                style: TextStyle(fontSize: 12),
                decoration: kFormFieldDecoration.copyWith(
                    labelText: 'Quantity', hintText: 'Ex. 1 paratha')),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
                autofocus: true,
                onChanged: (val) {
                  estTime = val;
                },
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 12),
                decoration: kFormFieldDecoration.copyWith(
                    labelText: 'Estimated time (in minutes)',
                    hintText: 'Ex. 10 min')),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
                autofocus: true,
                onChanged: (val) {
                  price = val;
                },
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 12),
                decoration: kFormFieldDecoration.copyWith(
                    labelText: 'Price', hintText: 'Ex. 15')),
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
                          ? Icon(
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
                child: Row(
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
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
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Add'),
          child: const Text('Add'),
        ),
      ],
    );
  }
}


class EditItemDialog extends StatefulWidget {
  const EditItemDialog({Key? key, required this.dishName, required this.quantity, required this.estTime, required this.price, required this.imageUrl}) : super(key: key);

  final String? dishName;
  final String? quantity;
  final int? estTime;
  final int? price;
  final String? imageUrl;

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {

  late String dishName;
  late String quantity;
  late String estTime;
  late String price;

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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.symmetric(horizontal: 0),
      titlePadding: EdgeInsets.only(left: 0, right: 0, bottom: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      title: const Text('Edit item'),
      content: ListView(
        children: [
          SizedBox(
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
                style: TextStyle(fontSize: 12),
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
                style: TextStyle(fontSize: 12),
                decoration: kFormFieldDecoration.copyWith(
                    labelText: 'Quantity', hintText: 'Ex. 1 paratha')),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: TextFormField(
                initialValue: '${widget.estTime}',
                autofocus: true,
                onChanged: (val) {
                  estTime = val;
                },
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 12),
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
                  price = val;
                },
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 12),
                decoration: kFormFieldDecoration.copyWith(
                    labelText: 'Price', hintText: 'Ex. 15')),
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
                          ? Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      )
                          : Image.file( //TODO: Use imageUrl here
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
                child: Row(
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
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
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Add'),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
