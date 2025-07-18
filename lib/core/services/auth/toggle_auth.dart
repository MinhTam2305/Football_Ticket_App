import 'package:flutter/material.dart';
import 'package:football_ticket/screens/auth/login_screen.dart';
import 'package:football_ticket/screens/auth/signup.dart';

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
      return LoginScreen(onTap: togglePage);
    } else {
      return Signup(onTap: togglePage);
    }
  }
}
