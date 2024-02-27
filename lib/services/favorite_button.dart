import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';
class HeartButton extends StatefulWidget {
  final String itemName;
  final bool isPressed;
  final VoidCallback onPressed;

  const HeartButton({
    required this.itemName,
    required this.isPressed,
    required this.onPressed,
  });

  @override
  _HeartButtonState createState() => _HeartButtonState();
}
class _HeartButtonState extends State<HeartButton> {
  late bool isPressed;
  late Color buttonColor;

  @override
  void initState() {
    super.initState();
    isPressed = widget.isPressed;
    buttonColor = isPressed ? Color(0xFF93130A) : Colors.grey;
  }

  @override
  void didUpdateWidget(HeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPressed != isPressed) {
      setState(() {
        isPressed = widget.isPressed;
        buttonColor = isPressed ? Colors.red : Colors.grey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPressed = !isPressed;
          buttonColor = isPressed ? Color(0xFF93130A) : Colors.grey;
        });
        widget.onPressed();
        print(stringList);
      },
      child: Icon(
        Icons.favorite,
        color: buttonColor,
        size: 26,
      ),
    );
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

}
