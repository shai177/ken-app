import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final Function(String) onChanged;

  const Bar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
        color: Colors.white54,),
      child: Padding(
        padding: const EdgeInsets.only(right: 8,left: 8),
        child: Container(
          height: 40,
          child: TextFormField(
            onChanged: onChanged,

            decoration: InputDecoration(
              labelStyle: TextStyle(fontFamily: 'babergerBold'),
              labelText: 'חיפוש',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }
}