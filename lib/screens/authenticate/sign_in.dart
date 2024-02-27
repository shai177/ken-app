
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base_first/models/register.dart';
import 'package:fire_base_first/models/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/AppUser.dart';
import '../../models/register.dart';


class SignIn extends StatefulWidget {
  final Function? toggleView;
  SignIn({this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Authservices _auth = Authservices();
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  double cont = 500;
  String? selectedJob;

  final List<String> jobOptions = [
    'רכז/ת',
    'קומונר/ית',
    'משצ"ית',
    'רכז/ת ארגון',
    'מדריכ/ה',
    'מחסנאי/ת'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
      Container(
      decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/connect_screen.png"),
      fit: BoxFit.cover,
    ),
    ),
    ),
    Center(
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(
    height: 490,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    color: Color(0xFFFFFFFF),
    ),
    child: Form(
    key: _formKey,
    child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    children: [
    Gap(20),
    TextFormField(
    style: TextStyle(
    color: Colors.black,
    fontFamily: 'babergerBold',
    ),
    decoration: const InputDecoration(
    hintText: 'אימייל',
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
    color: Colors.brown,
    ),
    ),
    ),
    validator: (val) =>
    val!.isEmpty ? 'להכניס מייל' : null,
    onChanged: (val) {
    setState(() => email = val);
    },
    ),
    Gap(20),
    TextFormField(
    style: TextStyle(
    color: Colors.black,
    fontFamily: 'babergerBold',
    ),
    decoration: const InputDecoration(
    hintText: 'סיסמא',
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
    color: Colors.brown,
    ),
    ),
    ),
    validator: (val) =>
    val!.isEmpty ? 'סיסמא בבקשה' : null,
    obscureText: true,
    onChanged: (val) {
    setState(() => password = val);
    },
    ),
    Gap(20),
    TextFormField(
    style: TextStyle(
    color: Colors.white,
    fontFamily: 'babergerBold',
    ),
    decoration: const InputDecoration(
    hintText: 'שם מלא',
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    ),
    ),
    validator: (val) =>
    val!.isEmpty ? 'מה השם שלך?' : null,
    onChanged: (val) async {
    await saveName(val);
    },
    ),
      Gap(20),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Color(0xFF414142),
          ),
        ),
        child: ListTile(
          title: Text(
            'תפקיד',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'babergerBold',
            ),
          ),
          trailing: PopupMenuButton<String>(
            icon: Icon(Icons.arrow_drop_down),
            onSelected: (String value) {
              setState(() {
                selectedJob = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return jobOptions.map((String job) {
                return PopupMenuItem<String>(
                  value: job,
                  child: Text(job),
                );
              }).toList();
            },
          ),
        ),
      ),
      Gap(30),
    TextButton(
    onPressed: () async {
    if (_formKey.currentState!.validate()) {
    dynamic result =
    await _auth.signIn(email, password);
    if (result == null) {
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return CupertinoAlertDialog(
    title: Text('התרחשה תקלה'),
    content: Text('מייל או סיסמא לא נכונים'),
    actions: [
    TextButton(
    onPressed: () {
    Navigator.of(context).pop();
    },
    child: Text('אישור'),
    ),
    ],
    );
    },
    );
    } else {
    // User signed in successfully
    }
    } else {
    cont = 550;
    setState(() {});
    }
    },
    child: Text(
    'התחברות',
    style: TextStyle(
    color: Colors.black,
    fontFamily: 'babergerlight',
    fontSize: 20,
    ),
    ),
    ),
    TextButton(
    onPressed: () async {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Register()));
    },
    child: Text(
    "אין לי משתמש",
    style: TextStyle(
    color: Colors.black,
    fontFamily: 'babergerlight',
    fontSize: 20,
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    );
    }

  saveName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', value);
  }

  Future<String> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? "";
  }
}