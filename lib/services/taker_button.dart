import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class takeButton extends StatefulWidget {
  final String documentId;
  final String fieldToUpdate;

  takeButton({required this.documentId, required this.fieldToUpdate});

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<takeButton> {
  final _formKey = GlobalKey<FormState>();
  late String _newValue;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _documentSnapshotStream;
  late double _previousValue;

  @override
  void initState() {
    super.initState();
    _newValue = '';
    _documentSnapshotStream = FirebaseFirestore.instance
        .collection('items')
        .doc(widget.documentId)
        .snapshots();
  }

  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF336799)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _documentSnapshotStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String previousValue = snapshot.data!.data()!['amount'];
                    _previousValue = double.parse(previousValue);
                    return Form(
                      key: _formKey,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'כמה לקחת?',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            fontFamily: 'babergerBold',
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (double.tryParse(value) != null) {
                              double userInput = double.parse(value);
                              if (userInput <= _previousValue) {
                                double result = _previousValue - userInput;
                                _newValue = userInput.toString();
                              } else {
                                // Show an error message if the input is greater than the current value
                                _newValue = '';
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'טיפה התבלבלת...',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'babergerBold',
                                      ),
                                    ),
                                    content: Text(
                                      'אין מספיק מכמה שאת/ה רוצה',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'babergerLight',
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'בסדר',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'babergerBold',
                                            color: Color(0xFF93130A),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              _newValue = '';
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'להכניס ערך';
                          }
                          return null;
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      'ביטול',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'babergerBold',
                        color: Color(0xFF93130A),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      double userInput = double.parse(_newValue);
                      double result = _previousValue - userInput;

                      await FirebaseFirestore.instance
                          .collection('items')
                          .doc(widget.documentId)
                          .update({
                        "amount": result.toInt().toString(),
                      });

                      setState(() {
                        _previousValue = result;
                      });
                      createNewDocument(userInput.toInt().toString());

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'הזמן',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'babergerBold',
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF93130A)),
                ),
              ],
            ),
          );
        },
        child: Center(
          child: Text(
            'אני רוצה',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'babergerLight',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createNewDocument(String amount) async {
    final firestoreInstance = FirebaseFirestore.instance;
    final name = await getName();
    final itemRef = firestoreInstance
        .collection('users')
        .doc(name)
        .collection('orders')
        .doc(widget.documentId);

    final itemSnapshot = await itemRef.get();
    if (!itemSnapshot.exists) {
      await itemRef.set({});
    }

    final itemDataSnapshot = await firestoreInstance
        .collection('items')
        .doc(widget.documentId)
        .get();

    final bool returnValue = itemDataSnapshot.data()?['return'] ?? false;

    await itemRef.set({
      'name': widget.documentId,
      'amount': amount,
      'return': returnValue,
      'status': 'לא אושר'
    });
  }

  Future<String> getName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('name') ?? "";
  }
}
