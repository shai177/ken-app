import 'dart:async';

import 'package:fire_base_first/services/aproved_button.dart';
import 'package:fire_base_first/services/edit_order_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/given_button.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  StreamSubscription<QuerySnapshot>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {}); // Trigger a rebuild when the data changes
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

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
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(document.id)
                            .collection('orders')
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> subSnapshot) {
                          if (!subSnapshot.hasData) {
                            return Container(); // Return an empty Container when subSnapshot has no data
                          }
                          final itemCount = subSnapshot.data!.docs.length;
                          final containerHeight = (itemCount + 1) * 94;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(

                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
                              // Use FractionallySizedBox for responsiveness
                              child: FractionallySizedBox(
                                widthFactor: screenWidth >= 600 ? 0.8 : 1.0,
                                child: Container(

                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "$name",
                                          style: TextStyle(
                                            fontSize: 40,
                                            color: Color(0xFF93130A),
                                            fontFamily: 'babergerBold',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: subSnapshot.data!.docs.map((subDocument) {
                                            String itemName = subDocument['name'] ?? 'Unknown Item';
                                            String amount = subDocument['amount'] ?? 'Unknown Item';
                                            String status = subDocument['status'] ?? 'Unknown Status';
                                            Color containerColor = getColorForStatus(status);

                                            double fontSize = itemName.length > 10 ? 20.0 : 30.0;

                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                                              child: AnimatedContainer(
                                                duration: Duration(milliseconds: 500),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: containerColor,
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
                                                              fontSize: fontSize,
                                                            ),
                                                          ),
                                                          Text(
                                                            '$amount',
                                                            style: TextStyle(fontFamily: 'babergerBold', fontSize: 30),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        if (status == 'לא אושר')
                                                          UpdateStatusButton(takerName: name, itemName: itemName),
                                                        if (status == 'אושר')
                                                          givenButton(itemName: itemName, amount: amount, takerName: name),
                                                        changeOrder(takerName: name, itemName: itemName),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
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
              SizedBox(height: 15),
              Image.asset('assets/images/symbol_app2.png', width: 115),
              Text(
                "הזמנות",
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

  Future<bool> _hasItems(DocumentSnapshot<Object?> document) async {
    final subCollection =
    FirebaseFirestore.instance.collection('users').doc(document.id).collection('orders');
    final subSnapshot = await subCollection.get();
    return subSnapshot.docs.isNotEmpty;
  }

  Color getColorForStatus(String status) {
    if (status == 'אושר') {
      return Color(0xFF5EAE49);
    } else if (status == 'לא אושר') {
      return Color(0xFFD9D2D2);
    }
    return Colors.white;
  }
}
