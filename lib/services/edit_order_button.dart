import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class changeOrder extends StatefulWidget {
  final String takerName;
  final String itemName;

  changeOrder({required this.takerName, required this.itemName});

  @override
  _changeOrderState createState() => _changeOrderState();
}

class _changeOrderState extends State<changeOrder> {
  TextEditingController _amountController = TextEditingController();
  Color iconColor = Colors.grey; // Default color
  StreamSubscription<DocumentSnapshot>? _subscription;

  @override
  void initState() {
    super.initState();
    // Check the status of the order and update the icon color accordingly
    checkOrderStatus();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> checkOrderStatus() async {
    try {
      final DocumentReference orderDocumentRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.takerName)
          .collection('orders')
          .doc(widget.itemName);

      _subscription = orderDocumentRef.snapshots().listen((DocumentSnapshot snapshot) {
        String status = snapshot['status'] ?? '';

        setState(() {
          if (status == 'אושר') {
            iconColor = Colors.green[900]!;
          } else {
            iconColor = Colors.grey;
          }
        });
      });
    } catch (error) {
      print('Error checking order status: $error');
    }
  }

  Future<void> updateAmount() async {
    try {
      final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
      final DocumentSnapshot takerDocument =
      await usersCollection.doc(widget.takerName).get();
      final CollectionReference ordersCollection =
      takerDocument.reference.collection('orders');
      final DocumentSnapshot itemDocument =
      await ordersCollection.doc(widget.itemName).get();
      final DocumentReference itemReference = itemDocument.reference;

      int newAmount = int.parse(_amountController.text);
      await itemReference.update({'amount': newAmount.toString()});

      print('Amount updated successfully!');
      Navigator.pop(context); // Close the AlertDialog
    } catch (error) {
      print('Error updating amount: $error');
    }
  }

  void showAmountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Amount'),
          content: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'New Amount'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context); // Close the AlertDialog
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: updateAmount,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: IconButton(
        onPressed: showAmountDialog,
        icon: Icon(
          Icons.edit,
          color: iconColor,
          size: 18,
        ),
      ),
    );
  }
}
