import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class add_email extends StatelessWidget {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');
  final String documentId = 'emails';

  Future<void> addEmail(String email) async {
    try {
      await usersCollection
          .doc(documentId)
          .update({'list': FieldValue.arrayUnion([email])});
      print('Email added successfully');
    } catch (e) {
      print('Error adding email: $e');
    }
  }

  Future<void> openDialog(BuildContext context) async {
    String? email = null; // Declare the email variable and initialize it as null

    email = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('הוסף אימייל',
            style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'babergerlight',)),
          content: TextField(
            onChanged: (value) {
              email = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(email);
              },
            ),
          ],
        );
      },
    );

    if (email != null) {
      addEmail(email!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF93130A)),
      onPressed: () {
        openDialog(context);
      },
      child: Text('הוסף אימייל',style: TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontFamily: 'babergerlight',)),
    );
  }
}
