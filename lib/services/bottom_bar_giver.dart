import 'package:fire_base_first/screens/authenticate/sign_in.dart';
import 'package:fire_base_first/screens/home.dart';
import 'package:fire_base_first/services/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../screens/giver/didnt_return_page.dart';
import '../screens/giver/orders_page.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  //lists of the pages in the appbar
  List pages = [
   Home(), DidntReturnPage(),OrdersPage(),ProfilePage()
  ];

  @override
  _TappedItem(int index){
    setState(() {
      _selectedIndex = index;

    }
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body:  pages[_selectedIndex],


      bottomNavigationBar:

         Container(
           color: Color(0xFFF6D4AC),
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
              height: 70,

              decoration:BoxDecoration(


                  color: Color(0xFFF6D4AC)),
              child: GNav(

                gap: 8,
                //changing according to the users tap
                selectedIndex: _selectedIndex,
                onTabChange: _TappedItem,
                activeColor: Colors.white,
                tabBackgroundColor: Color(
                    0xFF93130A),
                padding: EdgeInsetsDirectional.all(10),
                tabs: const [
                  GButton(icon: Icons.home,
                    text:'רשימת ציוד',textStyle: TextStyle(fontSize:13, color: Colors.white , fontFamily: 'babergerBold' ),),
                  GButton(icon: Icons.warning,text:'לא הוחזר',textStyle: TextStyle(fontSize:13, color: Colors.white
                      , fontFamily: 'babergerBold' ),),
                  GButton(icon: Icons.access_time_filled,text:'הזמנות',textStyle: TextStyle(fontSize:13, color: Colors.white
                      , fontFamily: 'babergerBold' ), ),
                  GButton(icon: Icons.person,text:'פרופיל',textStyle: TextStyle(fontSize:13, color: Colors.white
                      , fontFamily: 'babergerBold' ), ),
                ],

              ),
        ),
           ),
         ),



    );
  }
}
