import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateStatusButton extends StatelessWidget {
  final String takerName;
  final String itemName;

  UpdateStatusButton({required this.takerName, required this.itemName});

  Future<void> updateStatus() async {
    try {
      final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
      final DocumentSnapshot takerDocument =
      await usersCollection.doc(takerName).get();
      final CollectionReference ordersCollection =
      takerDocument.reference.collection('orders');
      final DocumentSnapshot itemDocument =
      await ordersCollection.doc(itemName).get();
      final DocumentReference itemReference = itemDocument.reference;

      await itemReference.update({'status': 'אושר'});

      print('Status updated successfully!');
    } catch (error) {
      print('Error updating status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: FloatingActionButton(
        onPressed: updateStatus,
        elevation: 2.0,
        backgroundColor: Color(0xFF336799),

        shape: CircleBorder(),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size:18,
        ),
      ),
    );
  }
}
