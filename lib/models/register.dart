import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fire_base_first/models/auth.dart';
import 'package:gap/gap.dart';

import '../screens/authenticate/sign_in.dart';

class Register extends StatefulWidget {
  final Function? toggleView;

  Register({this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Authservices _auth = Authservices();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  double cont = 470;
  String error = '';
  String? selectedJob;

  final List<String> jobOptions = [
    'רכז/ת',
    'קומונר/ית',
    'משצ"ית',
    'רכז/ת ארגון',
    'מדריכ/ה',
    'מחסנאי/ת'
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_circles.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: AnimatedContainer(
                height: cont,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFFFFFFF),
                ),
                duration: const Duration(milliseconds: 100),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'babergerBold',
                          ),
                          decoration: const InputDecoration(
                            hintText: 'מייל',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (val) =>
                          val!.isEmpty ? 'תכניס את המייל' : null,
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
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'babergerBold',
                          ),
                          decoration: const InputDecoration(
                            hintText: 'סיסמא',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          obscureText: true,
                          validator: (val) =>
                          val!.length < 5 ? 'צריך מינימום 5 תווים' : null,
                          onChanged: (val) {
                            setState(() => password = val);
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
                        Gap(20),
                        ElevatedButton(
                          onPressed: () async {
                            String name = await getName();
                            bool emailExists = await checkEmailExists(email);

                            if (emailExists) {
                              await createNewDocument(name, selectedJob);

                              if (_formKey.currentState!.validate()) {
                                dynamic result =
                                await _auth.register(email, password);
                                if (result == null) {
                                  setState(() =>
                                  error = 'Please enter a valid email');
                                } else {
                                  // Successfully registered
                                }
                              } else {
                                cont = 520;
                                setState(() {});
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('אימייל לא נמצא'),
                                    content: Text(
                                      'הרכזים לא הוסיפו את המייל שהכנסת',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the alert dialog
                                        },
                                        child: Text('נו מה',style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'babergerLight',
                                  fontSize: 18,)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                            'הרשמה',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'babergerLight',
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Gap(8),
                        TextButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignIn()));
                          },
                          child: Text(
                            'כבר יש לי משתמש',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'babergerlight',
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
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

  Future<void> createNewDocument(String value, String? job) async {
    try {
      final CollectionReference didntReturnCollection =
      FirebaseFirestore.instance.collection('users');

      final DocumentReference newDocRef = didntReturnCollection.doc(value);
      final fcmToken = await FirebaseMessaging.instance.getToken();

      await newDocRef.set({
        'name': value,
        'role': job,
        'token': fcmToken,
      });

      final CollectionReference itemsCollection = newDocRef.collection('items');
      final CollectionReference ordersCollection =
      newDocRef.collection('orders');
      final CollectionReference favoriteCollection =
      newDocRef.collection('favorite');

      print('New document created with ID: ${newDocRef.id}');
    } catch (e) {
      print('Error creating new document: $e');
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
      await FirebaseFirestore.instance.collection('users').doc('emails').get();

      final List<dynamic> emailList = docSnapshot.data()?['list'];

      return emailList.contains(email);
    } catch (e) {
      print('Error checking email: $e');
      return false;
    }
  }

}


