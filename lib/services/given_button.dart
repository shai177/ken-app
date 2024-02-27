import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class givenButton extends StatelessWidget {
  final String itemName;
  final String amount;
  final String takerName;

  givenButton({
    required this.itemName,
    required this.amount,
    required this.takerName,
  });

  // Function to delete an item from the 'orders' collection of the user
  Future<void> deleteItem(String itemName, String taker) async {
    final firestoreInstance = FirebaseFirestore.instance;

    // Get a reference to the item document in the 'orders' collection
    final itemRef = firestoreInstance.collection('users').doc(taker).collection('orders').doc(itemName);

    // Check if the item document exists
    final itemSnapshot = await itemRef.get();
    if (itemSnapshot.exists) {
      // If the document exists, delete it
      await itemRef.delete();
    } else {
      // If the document doesn't exist, throw an exception
      throw Exception('Document $itemName does not exist');
    }
  }

  // Function to create a new document in the 'items' collection of the user
  Future<void> createNewDocument() async {
    final firestoreInstance = FirebaseFirestore.instance;

    // Get a reference to the item document in the 'orders' collection
    final ordersRef = firestoreInstance
        .collection('users')
        .doc(takerName)
        .collection('orders')
        .doc(itemName);

    // Check if the item document exists
    final ordersSnapshot = await ordersRef.get();

    if (ordersSnapshot.exists) {
      // If the item document exists, check if 'return' field is set to true
      final bool shouldCreateDocument = ordersSnapshot.data()?['return'];

      if (shouldCreateDocument == true) {
        // If 'return' field is true, create a new document in the 'items' collection

        // Get a reference to the item document in the 'items' collection
        final itemRef = firestoreInstance
            .collection('users')
            .doc(takerName)
            .collection('items')
            .doc(itemName);

        // Set the fields 'name' and 'amount' in the item document
        await itemRef.set({
          'name': itemName,
          'amount': amount,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF336799)),
      onPressed: () async {
        // When the button is pressed, asynchronously perform the following actions:
        await createNewDocument(); // Create a new document in the 'items' collection of the user
        await deleteItem(itemName, takerName); // Delete the item from the 'orders' collection of the user
      },
      child: Text(
        'נלקח',
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'babergerLight',
        ),
      ),
    );
  }
}
