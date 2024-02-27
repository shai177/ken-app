import 'package:fire_base_first/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base_first/models/display_item.dart';
import 'package:flutter/cupertino.dart';
import '../models/settings_form.dart';
import '../services/search_ber.dart';
import  '../globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CollectionReference itemsCollection =
  FirebaseFirestore.instance.collection('items');

  String searchQuery = '';
  bool showFloatingActionButton = false;
  double height = 140;
  String job = '';

  @override
  void initState() {
    super.initState();
    checkJob();
  }

  Future<void> checkJob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    job = prefs.getString('job') ?? '';

    setState(() {
      showFloatingActionButton = globals.job == 'giver';
      height = 140;
    });
  }

  void _showSettingsPanel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SettingForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(84),
        child: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFF6D4AC),
          flexibleSpace: Column(
            children: [
              Gap(15),
              Image.asset('assets/images/symbol_app2.png', width: 125),
              Text(
                "המחסן",
                style: TextStyle(
                  fontSize: 55,
                  color: Color(0xFF93130A),
                  fontFamily: 'babergerBold',
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFF6D4AC),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(children: []),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildCategorySection(
                context,
                'אחר',
                'אחר',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildCategorySection(
                context,
                'ציוד משרדי',
                'ציוד משרדי',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildCategorySection(
                context,
                'כלי יצירה',
                'כלי יצירה',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildCategorySection(
                context,
                'ציוד יצירה',
                'ציוד יצירה',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: showFloatingActionButton && globals.job == 'giver'
          ? FloatingActionButton(
        backgroundColor: Color(0xFF93130A),
        splashColor: Colors.blue,
        onPressed: () => _showSettingsPanel(),
        child: Container(
          height: 70,
          width: 70,
          child: Icon(Icons.add, size: 40),
        ),
      )
          : null,
    );
  }

  Widget buildCategorySection(
      BuildContext context, String categoryName, String categoryText) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4),
              child: Text(
                categoryText,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontFamily: 'babergerBold',
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: height, // Adjust the height of each category container as desired
          child: StreamBuilder<QuerySnapshot>(
            stream: itemsCollection.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final items = snapshot.data!.docs;

              // Filter items based on search query
              final filteredItems = items.where((item) {
                final itemData = item.data() as Map<String, dynamic>;
                final type = itemData['type'];
                final name = itemData['name'];
                final lowercaseQuery = searchQuery.toLowerCase();

                if (type == categoryName &&
                    name.toLowerCase().contains(lowercaseQuery)) {
                  return true;
                }
                return false;
              }).toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item =
                  filteredItems[index].data() as Map<String, dynamic>;
                  final name = item['name'];
                  final amount = item['amount'];

                  return DisplayItem(name: name, amount: amount);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
