import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateAmountButton extends StatelessWidget {
  final String name;
  final String amount;
  final String taker;

  const UpdateAmountButton({required this.name, required this.amount, required this.taker});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      child: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          try {
            await updateItemAmount(name, amount);
            await deleteItem(name, taker);
            // show a success message if the update was successful
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Item amount updated successfully'),
            ));
          } catch (e) {
            // show an error message if the update failed
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to update item amount: $e'),
            ));
          }
        },
        backgroundColor: Color(0xFF1A63AF),

      ),
    );
  }
  Future<void> updateItemAmount(String itemName, String amount) async {
    //update the current value to the value+returend amount
    //creat path tho firestore
    final firestoreInstance = FirebaseFirestore.instance;
    final itemRef = firestoreInstance.collection('items').doc(itemName);

    final itemSnapshot = await itemRef.get();
    if (itemSnapshot.exists) {
      final currentAmount = itemSnapshot.data()?['amount'] ?? '0';
      //add the returnd amount to the current status
      final newAmount = (int.parse(currentAmount) + int.parse(amount)).toString();
      await itemRef.update({'amount': newAmount});
    } else {
      throw Exception('Document $itemName does not exist');
    }
  }
  Future<void> deleteItem(String itemName, String taker) async {
    //delet the document under the user
    final firestoreInstance = FirebaseFirestore.instance;

    final itemRef = firestoreInstance.collection('users').doc(taker).collection('items').doc(itemName);
    final itemSnapshot = await itemRef.get();
    if (itemSnapshot.exists) {
      await itemRef.delete();
    } else {
      throw Exception('Document $itemName does not exist');
    }
  }

}
