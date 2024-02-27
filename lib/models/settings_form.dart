

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SettingForm extends StatefulWidget {
  const SettingForm({Key? key}) : super(key: key);

  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool? selectedRet = false;
  String? selectedType;

  void addItem() {
    String name = nameController.text;
    String amount = amountController.text;
    FirebaseFirestore.instance.collection('items').doc(name).set({
      'name': name,
      'amount': amount,
      'type': selectedType,
      'return': selectedRet,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'שם',
              ),
            ),
            TextField(
              cursorColor: Color(0xFF93130A),
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'כמות',

              ),
            ),

            DropdownButtonFormField<String>(
              value: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'קטגוריה',
              ),
              items: [
                DropdownMenuItem(
                  value: 'ציוד יצירה',
                  child: Text('ציוד יצירה'),
                ),
                DropdownMenuItem(
                  value: 'ציוד משרדי',
                  child: Text('ציוד משרדי'),
                ),
                DropdownMenuItem(
                  value: 'אחר',
                  child: Text('אחר'),
                ),
                DropdownMenuItem(
                  value: 'כלי יצירה',
                  child: Text('כלי יצירה'),
                ),
              ],
            ),
            DropdownButtonFormField<bool>(
              value: selectedRet,
              onChanged: (value) {
                setState(() {
                  selectedRet = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'להחזיר?',
              ),
              items: [
                DropdownMenuItem(
                  value: true,
                  child: Text('כן'),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text('לא'),
                ),

              ],
            ),

            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor:Color(0xFF93130A)),
              child: Text('הוסף פריט',style: TextStyle(
                fontSize: 20,
                fontFamily: 'babergerlight',
              ),),
              onPressed: addItem,
            ),
          ],
        ),
      ),
    );
  }
}
