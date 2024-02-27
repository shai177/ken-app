import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A widget representing a button used for editing a specific document field in Firestore.
class addInfoButton extends StatefulWidget {
  /// The ID of the document to be updated.
  final String documentId;

  /// The field within the document to be updated.
  final String fieldToUpdate;

  addInfoButton({required this.documentId, required this.fieldToUpdate});

  @override
  _addInfoButtonState createState() => _addInfoButtonState();
}

class _addInfoButtonState extends State<addInfoButton> {
  final _formKey = GlobalKey<FormState>();
  late String _newValue;

  @override
  Widget build(BuildContext context) {
    return Container(

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF93130A)),
        onPressed: () {
          showDialog(
            context: context,
            //creatin allert dialog
            builder: (context) => AlertDialog(
              content: Form(
                key: _formKey,
                child: TextFormField(

                  //changes every time a letter inserts
                  onChanged: (value) {
                    setState(() {
                      _newValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'צריך להכניס מספר';
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ביטול',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF93130A),
                      fontFamily: 'babergerLight',
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF93130A)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Update the specified document with the new value
                      FirebaseFirestore.instance.collection('users').doc(widget.documentId).update({
                        widget.fieldToUpdate: _newValue,
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'עדכן',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'babergerBold',
                    ),
                  ),
                )
              ],
            ),
          );
        },
        child: Text('עדכון מידע',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'babergerlight',
          ),

    )


      ),
    );
  }
}
