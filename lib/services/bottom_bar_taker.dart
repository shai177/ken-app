import 'package:fire_base_first/screens/home.dart';
import 'package:fire_base_first/screens/taker/users_order_page.dart';
import 'package:fire_base_first/services/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../models/user_inventory.dart';
import '../screens/taker/favourite.dart';
import '../screens/taker/home_taker.dart';

/// A bottom navigation bar widget for the taker section of the application.
/// Allows users to navigate between different pages using tabs at the bottom.
class BottomBarTaker extends StatefulWidget {
  const BottomBarTaker({Key? key}) : super(key: key);

  @override
  State<BottomBarTaker> createState() => _BottomBarTakerState();
}

class _BottomBarTakerState extends State<BottomBarTaker> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    Home(),
    UserInventory(),
    userfavourites(),
    UserOrders(),
    ProfilePage(),

  ];

  /// Updates the selected tab index when a tab is tapped.
  void _updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],

      bottomNavigationBar: Container(
        color: Color(0xFFF6D4AC),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFF6D4AC),
            ),
            child: GNav(
              backgroundColor: Color(0xFFF6D4AC),
              gap: 8,
              selectedIndex: _selectedIndex,
              onTabChange: _updateSelectedIndex,
              activeColor: Colors.white,
              tabBackgroundColor: Color(0xFF93130A),
              padding: EdgeInsets.all(10),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'רשימת ציוד',
                  textStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontFamily: 'babergerBold',
                  ),
                ),
                GButton(
                  icon: Icons.inventory_2_outlined,
                  text: 'הציוד שלי',
                  textStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontFamily: 'babergerBold',
                  ),
                ),
                GButton(
                  icon: Icons.favorite_border,
                  text: 'מועדפים',
                  textStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontFamily: 'babergerBold',
                  ),
                ),
                GButton(
                  icon: Icons.inventory_outlined,
                  text: 'ההזמנות שלי',
                  textStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontFamily: 'babergerBold',
                  ),
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'פרופיל',
                  textStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontFamily: 'babergerBold',
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
