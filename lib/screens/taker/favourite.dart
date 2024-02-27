import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base_first/models/display_item.dart';
import 'package:flutter/cupertino.dart';

import '../../globals.dart';

class userfavourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold widget is the main container for the screen
    return Scaffold(
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
                "מועדפים",
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: []),
          Flexible(
            child: FutureBuilder<String>(
              future: getName(),
              builder: (context, snapshot) {
                // Display a loading indicator while waiting for the future to complete
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                // Handle the case when no data is available
                if (!snapshot.hasData) {
                  return Text('No data found');
                }

                final String name = snapshot.data!;

                final CollectionReference itemsCollection =
                FirebaseFirestore.instance.collection('items');

                return StreamBuilder<QuerySnapshot>(
                  stream: itemsCollection.snapshots(),
                  builder: (context, snapshot) {
                    // Display a loading indicator while waiting for the stream to emit data
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final items = snapshot.data!.docs;

                    // Filter the items based on the names in the stringList
                    final filteredItems = items.where((item) {
                      final itemData = item.data() as Map<String?, dynamic>;
                      final itemName = itemData['name'];
                      return stringList.contains(itemName);
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final itemData = filteredItems[index].data() as Map<String?, dynamic>;
                        final name = itemData['name'];
                        final amount = itemData['amount'];

                        // Use the DisplayItem widget to display each item in the list
                        return SizedBox(
                          height: 140,
                          child: DisplayItem(name: name, amount: amount),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF6D4AC),
    );
  }

  Future<String> getName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('name') ?? "";
  }
}
