import 'package:fire_base_first/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base_first/models/display_item.dart';
import 'package:flutter/cupertino.dart';
import '../../models/settings_form.dart';

class HomeTaker extends StatelessWidget {
  // Reference to the collection in Firestore that contains items
  final CollectionReference itemsCollection =
  FirebaseFirestore.instance.collection('items');

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      // Show a modal bottom sheet to display the settings form
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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
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
                  fontSize: 50,
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
            buildCategorySection(
              context,
              'אחר',
              'אחר',
            ),
            buildCategorySection(
              context,
              'ציוד משרדי',
              'ציוד משרדי',
            ),
            buildCategorySection(
              context,
              'כלי יצירה',
              'כלי יצירה',
            ),
            buildCategorySection(
              context,
              'ציוד יצירה',
              'ציוד יצירה',
            ),
          ],
        ),
      ),
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
          height: 150, // Adjust the height of each category container as desired
          child: StreamBuilder<QuerySnapshot>(
            stream: itemsCollection.snapshots(),
            builder: (context, snapshot) {
              // Display a loading indicator while waiting for the stream to emit data
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final items = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index].data() as Map<String, dynamic>;
                  final type = item['type'];

                  // Display only items of the specific category
                  if (type != categoryName) {
                    return Container();
                  }

                  final name = item['name'];
                  final amount = item['amount'];

                  // Use the diaplayItem widget to display each item in the list
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
