import 'dart:io';
import 'package:fire_base_first/screens/authenticate/sign_in.dart';
import 'package:fire_base_first/services/add_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

import 'add_info.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  File? profileImage;
  String info = " ";
  bool rakaz = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      rakaz = (name == "ליאור שטיינברג" || name == "אסף דסה");


      String imagePath = prefs.getString('profileImage') ?? '';
      if (imagePath.isNotEmpty) {
        profileImage = File(imagePath);
      }
    });
  }

  Future<void> saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (profileImage != null) {
      prefs.setString('profileImage', profileImage!.path);
    }
  }

  Stream<DocumentSnapshot> getProfileStream() {
    // Replace 'users' with your desired collection name
    String documentId = name.isNotEmpty ? name : 'default';
    return FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .snapshots();

  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        profileImage = File(pickedImage.path);
      });

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users')
          .child(name)
          .child(path.basename(profileImage!.path));

      try {
        await ref.putFile(profileImage!);
        String downloadUrl = await ref.getDownloadURL();
        print('Image uploaded to Firebase Storage. Download URL: $downloadUrl');
      } catch (e) {
        print('Failed to upload image to Firebase Storage: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6D4AC),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Color(0xFFF6D4AC),
          flexibleSpace: Column(
            children: [
              Gap(15),
              Image.asset('assets/images/symbol_app2.png', width: 115),
              Text(
                "הפרופיל שלי",
                style: TextStyle(
                  fontSize: 55,
                  color: Color(0xFF93130A),
                  fontFamily: 'babergerBold',
                ),
              ),
            ],
          ),
          elevation: 0,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: getProfileStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('User profile not found.'),
            );
          }

          var data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return Center(
              child: Text('User profile data is null.'),
            );
          }

          info = data['info'] ?? '';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 0, top: 0),
                  child: TextButton.icon(
                    onPressed: () async {
                      // Handle signout
                      _signOut();
                    },
                    icon: Icon(Icons.person, color: Colors.black),
                    label: Text(
                      'התנתקות',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: 'babergerbold',
                      ),
                    ),
                  ),
                ),
                Gap(10),
                CircleAvatar(
                  radius: 80,
                  backgroundImage:
                  profileImage != null ? FileImage(profileImage!) : null,
                ),
                SizedBox(height: 20),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: 'babergerbold',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'לבחירתך',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontFamily: 'babergerbold',
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                GestureDetector(
                                  child: Text(
                                    'צלם תמונה',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: 'babergerLight',
                                    ),
                                  ),
                                  onTap: () {
                                    pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  child: Text(
                                    'בחירה מהגלריה',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: 'babergerLight',
                                    ),
                                  ),
                                  onTap: () {
                                    pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'שנה תמונת פרופיל',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'babergerlight',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF93130A),
                  ),
                ),
                Gap(10),
                Text(info, style: TextStyle( fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'babergerlight',),),
                Gap(10),
                addInfoButton(documentId: name, fieldToUpdate: "info"),
                if (rakaz)
                  add_email(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    saveProfile();
    super.dispose();
  }
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
      // Handle the error if needed
    }
  }
}