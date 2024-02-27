import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A widget representing a button used for editing a specific document field in Firestore.
class editButton extends StatefulWidget {
  /// The ID of the document to be updated.
  final String documentId;

  /// The field within the document to be updated.
  final String fieldToUpdate;

  editButton({required this.documentId, required this.fieldToUpdate});

  @override
  _editButtonState createState() => _editButtonState();
}

class _editButtonState extends State<editButton> {
  final _formKey = GlobalKey<FormState>();
  late String _newValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            //creatin allert dialog
            builder: (context) => AlertDialog(
              content: Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
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
                      FirebaseFirestore.instance.collection('items').doc(widget.documentId).update({
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
        backgroundColor: Color(0xA50E3488),
        child: Icon(
          Icons.edit,
          size: 15,
        ),
      ),
    );
  }
}
