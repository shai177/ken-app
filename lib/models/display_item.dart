import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart' as globals;

import '../globals.dart';
import '../services/edit_button.dart';
import '../services/favorite_button.dart';
import '../services/taker_button.dart';

class DisplayItem extends StatefulWidget {
  final String name;
  final String amount;

  DisplayItem({required this.name, required this.amount});

  @override
  _DisplayItemState createState() => _DisplayItemState();
}

class _DisplayItemState extends State<DisplayItem> {


  @override
  void initState() {
    super.initState();
    getStringList();
  }

  addStringToList(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stringList.add(value);
    });
    await prefs.setStringList('stringList', stringList);
  }

  removeStringFromList(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stringList.remove(value);
    });
    await prefs.setStringList('stringList', stringList);
  }

  getStringList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stringList = prefs.getStringList('stringList') ?? [];
    });
  }

  bool isItemInList(String value) {
    return stringList.contains(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 100,
      margin: const EdgeInsets.only(right: 7, left: 7, top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'babergerLight',
                ),
              ),
              Text(
                widget.amount.toString(),
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontFamily: 'babergerLight',
                ),
              ),
              const SizedBox(height: 5),
              globals.job == 'giver'
                  ? editButton(documentId: widget.name, fieldToUpdate:'amount')
                  : FutureBuilder<String>(
                future: getName(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        takeButton(documentId: widget.name, fieldToUpdate: widget.amount),
                        SizedBox(width: 5,),
                        HeartButton(
                          itemName: widget.name,
                          isPressed: isItemInList(widget.name),
                          onPressed: () {
                            if (isItemInList(widget.name)) {
                              removeStringFromList(widget.name);
                            } else {
                              addStringToList(widget.name);
                            }
                          },

                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> getName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('name') ?? '';
  }
}
