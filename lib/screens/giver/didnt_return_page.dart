import 'package:fire_base_first/services/lost_button.dart';
import 'package:fire_base_first/services/show_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';

import '../../services/notification_button.dart';
import '../../services/returnd_button.dart';

/// The page that displays the items that haven't been returned.
class DidntReturnPage extends StatefulWidget {
  const DidntReturnPage({Key? key}) : super(key: key);

  @override
  State<DidntReturnPage> createState() => _DidntReturnPageState();
}

class _DidntReturnPageState extends State<DidntReturnPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = snapshot.data!.docs;

          return ListView(
            children: documents.map((document) {
              return FutureBuilder<bool>(
                future: _hasItems(document),
                builder: (BuildContext context, AsyncSnapshot<bool> hasItemsSnapshot) {
                  if (!hasItemsSnapshot.hasData) {
                    return Container(); // Return an empty Container while waiting for the result
                  }
                  if (!hasItemsSnapshot.data!) {
                    return Container(); // Skip the container if subcollection is empty
                  }

                  String name = document['name'] ?? 'Unknown';

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust the vertical padding as desired
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(document.id)
                            .collection('items')
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> subSnapshot) {
                          if (!subSnapshot.hasData) {
                            return Container(); // Return an empty Container when subSnapshot has no data
                          }
                          final itemCount = subSnapshot.data!.docs.length;
                          final containerHeight = (itemCount + 1) * 92;

                          return FractionallySizedBox(
                            widthFactor: screenWidth >= 600 ? 0.8 : 0.93,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: containerHeight.toDouble(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Row(

                                        children: [
                                          Expanded(
                                            child: Text(
                                              "$name",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 40,
                                                color: Color(0xFF93130A),
                                                fontFamily: 'babergerBold',
                                              ),
                                            ),
                                          ),
                                          MyButton(takerName: name),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: subSnapshot.data!.docs.map((subDocument) {
                                        String itemName = subDocument['name'] ?? 'Unknown Item';
                                        String amount = subDocument['amount'] ?? 'Unknown Item';
                                        double fontSize = itemName.length > 10 ? 20.0 : 30.0;
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Color(0xFFD9D2D2),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '$itemName',
                                                        style: TextStyle(
                                                          fontFamily: 'babergerBold',
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                      Text(
                                                        '$amount',
                                                        style: TextStyle(
                                                          fontFamily: 'babergerBold',
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    UpdateAmountButton(
                                                      name: itemName,
                                                      amount: amount,
                                                      taker: name,
                                                    ),
                                                    SizedBox(width: 10,),
                                                    lostButton(
                                                      name: itemName,
                                                      amount: amount,
                                                      taker: name,
                                                    ),
                                                    SizedBox(width: 10,),
                                                    NotificationButton(userName: name),

                                                  ],
                                                ),
                                                Gap(10),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Gap(20),

                                ],
                              ),),
                          );},),),);},);
            }).toList(),
          );
        },
      ),
      backgroundColor: Color(0xFFF6D4AC),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(81),
        child: AppBar(
          backgroundColor: Color(0xFFF6D4AC),
          flexibleSpace: Column(
            children: [
              Gap(15),
              Image.asset('assets/images/symbol_app2.png', width: 115),
              Text(
                "ציוד שלא הוחזר",
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
    );
  }

  /// Checks if the given document has any items in its subcollection.
  Future<bool> _hasItems(DocumentSnapshot<Object?> document) async {
    final subCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(document.id)
        .collection('items');
    //creating snapshots
    final subSnapshot = await subCollection.get();
    return subSnapshot.docs.isNotEmpty;
  }
}
