import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String takerName;

  const MyButton({required this.takerName});

  void openAlertDialog(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(takerName)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String info = (documentSnapshot.data() as Map<String, dynamic>)['info'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('מידע משתמש',style: TextStyle( fontSize: 25,
                color: Colors.black,
                fontFamily: 'babergerbold',),),
              content: Text(info,style: TextStyle( fontSize: 20,
                color: Colors.black,
                fontFamily: 'babergerlight',)),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF93130A),),
                  child: Text('אחלה',style: TextStyle( fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'babergerbold',)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('User not found'),
              content: Text('No user found with the given name.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          openAlertDialog(context);
        },
        child: Icon(Icons.info_outline, color: Colors.grey,),
        backgroundColor: Colors.white,
      ),
    );
  }
}
