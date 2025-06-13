import 'package:flutter/material.dart';
import 'package:football_ticket/screens/login.dart';
import 'package:football_ticket/screens/signup.dart';

class ToggleAuth extends StatefulWidget {
  const ToggleAuth({super.key});

  @override
  State<ToggleAuth> createState() => _ToggleAuthState();
}

class _ToggleAuthState extends State<ToggleAuth> {
  bool showLogin = true;

  void togglePage() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return Login(onTap: togglePage);
    } else {
      return Signup(onTap: togglePage);
    }
  }
}
