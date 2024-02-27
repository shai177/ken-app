import'package:fire_base_first/models/register.dart';
import 'package:fire_base_first/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}
class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = false;

  void toggleview() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      //if haveallredy an acount
      return SignIn(toggleView:toggleview);
    }
    else {
      //need to register
      return Register(toggleView: toggleview);
    }
  }
}

