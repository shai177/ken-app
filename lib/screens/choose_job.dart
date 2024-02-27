import 'dart:io';

import 'package:fire_base_first/screens/taker/home_taker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../globals.dart' as globals;
import '../services/bottom_bar_giver.dart';
import '../services/bottom_bar_taker.dart';
import 'giver/didnt_return_page.dart';


class ChooseJob extends StatelessWidget {
  const ChooseJob({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Color(0xFFF6D4AC),
          flexibleSpace: Column(
            children: [
              Gap(15),
              Image.asset('assets/images/symbol_app2.png', width: 115),
              Text(
                "התפקיד שלי היום",
                style: TextStyle(
                  fontSize: 40,
                  color: Color(0xFF93130A),
                  fontFamily: 'babergerBold',
                ),
              ),
            ],
          ),
          elevation: 0,
        ),
      ),
      backgroundColor: Color(0xFFF6D4AC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/giver.png'),
              radius: 70,
              foregroundColor: Colors.brown,
            ),
            TextButton(
               child: Text('מחסנאי/ת',style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'babergerlight',
            ),),
      style: ElevatedButton.styleFrom(backgroundColor:Color(0xFF93130A)),
              onPressed: () {
                globals.job = "giver";
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomBar()),
                );
              },
            ),
            Gap(50),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/taker.png'),
              radius: 70,
              foregroundColor: Colors.brown,
            ),
            TextButton(
               child: Text('מדריכ/ה',style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'babergerlight',
            ),),
      style: ElevatedButton.styleFrom(backgroundColor:Color(0xFF93130A)),
              onPressed: () {
                globals.job = "taker";
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomBarTaker()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
