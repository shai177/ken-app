import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationButton extends StatelessWidget {
  final String userName;

  NotificationButton({required this.userName});

  Future<void> _sendNotification() async {
    // Retrieve the user's document from Firestore
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userName)
        .get();

    if (userDoc.exists) {
      // Get the token from the user's document
      var targetToken = userDoc.data()?['token'];

      if (targetToken != null) {
        // Prepare the notification payload
        var notification = {
          'title': 'התראה חדשה',
          'body': 'חבר/ה לא החזרת עדיין את כל הציוד... הגיע הזמן!',
        };

        var message = {
          'notification': notification,
          'to': targetToken, // Target the specific FCM token
        };

        // Convert the message to JSON
        var jsonMessage = jsonEncode(message);

        // Make an HTTP POST request to the FCM API endpoint
        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=AAAAJVmO45g:APA91bEQMQzF53qpCAjipx6wCub_0zaD0ImYrk7ZF62-MNg49_wqaAqxfUAJyl_4oyLdFSoNREHUk4opsmLTFA8sjc7rVa45mvJ3qq8hO-LPWzNMKS-oFGDluGTz9NX402nCl1cqMEz2',
          },
          body: jsonMessage,
        );

        // Handle the response
        if (response.statusCode == 200) {
          print('Notification sent successfully');
        } else {
          print('Failed to send notification');
          print('Response body: ${response.body}');
        }
      } else {
        print('No token found for user: $userName');
      }
    } else {
      print('User document not found: $userName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: FloatingActionButton(
        onPressed: _sendNotification,
        backgroundColor: Color(0xFF1A63AF),
        child: Icon(Icons.message, size: 15),
      ),
    );
  }
}
