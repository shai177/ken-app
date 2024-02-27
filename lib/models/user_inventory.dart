import 'package:fire_base_first/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserInventory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                "הציוד שלי",
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Text('No data found');
                }

                final String name = snapshot.data!;

                final DocumentReference didntReturnDoc =
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(name);
                final CollectionReference itemsCollection =
                didntReturnDoc.collection('items');

                return StreamBuilder<QuerySnapshot>(
                  stream: itemsCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final items = snapshot.data!.docs;

                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'הצלחה! החזרת את כל הציוד',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'babergerLight',

                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item =
                        items[index].data() as Map<String?, dynamic>;
                        final name = item['name'];
                        final amount = item['amount'];

                        return Container(
                          width: 100,
                          height: 111,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21),
                            color: Color(0xFF336799),
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width:300,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              color: Colors.white ,),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontFamily: 'babergerLight',
                                        ),
                                      ),
                                      Text(
                                        amount.toString(),
                                        style: TextStyle(
                                          fontSize: 35,
                                          color: Colors.black,
                                          fontFamily: 'babergerLight',
                                        ),
                                      ),
                                      Gap(5),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    return pref.getString('name') ?? '';
  }
}
