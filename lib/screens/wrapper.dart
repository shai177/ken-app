import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:fire_base_first/models/AppUser.dart';
import 'package:fire_base_first/screens/authenticate/authenticate.dart';
import 'package:fire_base_first/screens/choose_job.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/bottom_bar_giver.dart';
import '../services/bottom_bar_taker.dart';
import '../globals.dart' as globals;

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return FutureBuilder<String?>(
        future: getName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final String name = snapshot.data ?? "";
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(name)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final role = snapshot.data!.get('role');
                  saveJob(role);
                  globals.job = role;


                  // Set up a flag or state variable here
                  bool shouldNavigate = true; // Set this based on your condition

                  // Return the appropriate screen here based on the flag
                  if (shouldNavigate) {
                    if (globals.job == 'giver') {
                      return BottomBar();
                    }if (globals.job == 'taker') {
                      return BottomBarTaker();
                    }
                    else {
                      // Return a placeholder or other widget
                      return ChooseJob();
                    }
                  }
                }
                return Center(child: ColorfulCircularProgressIndicator(colors: [Colors.red,Colors.blue],));
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      );
    }
  }

  saveJob(String value) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();
    await prefs.setString('role', value);
  }
  Future<String?> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? "";
  }


//
}
