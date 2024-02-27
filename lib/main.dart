import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:fire_base_first/screens/wrapper.dart';
import 'package:fire_base_first/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:fire_base_first/models/AppUser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDiI5w9TT2x5v4gUi7eupempmj1JWoD404",
        authDomain: "my-first-project-fd63f.firebase.com",
        projectId: "Ymy-first-project-fd63f",
        storageBucket: "Ymy-first-project-fd63f.appspot.com",
        messagingSenderId: "160416326552",
        appId: "Y7Sc8F4pJN4ooMzCxP9gadY9JhTAh3DupWXwzoM2WSZQZ"
    )
    );
  requestPermission();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('this is tokem');
  print(fcmToken);

  runApp(const MyApp());
}

void requestPermission () async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(alert:  true, announcement: false, badge: false, carPlay: false, criticalAlert: false, sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('user granted premmision');
  }
  else if(settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('provisional premmsion');
  }
  else{
    print('user declined');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: Authservices().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(
        )

      ),
    );
  }
void requestPermission () async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(alert:  true, announcement: false, badge: false, carPlay: false, criticalAlert: false, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted premmision');
    }
      else if(settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('provisional premmsion');
    }
      else{
      print('user declined');
    }
}
}




