import 'package:flutter/material.dart';
import 'package:football_ticket/screens/tabs/accessory_page.dart';
import 'package:football_ticket/models/user_model.dart';

// Demo page để test AccessoryPage với cart functionality
class AccessoryDemoPage extends StatelessWidget {
  const AccessoryDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user data
    final mockUser = UserModel(
      uid: 'demo_user_123',
      name: 'Demo User',
      phoneNumber: '0123456789',
      token: 'demo_token',
      role: 'User',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessory Demo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: AccessoryPage(user: mockUser),
    );
  }
}

// Usage example trong main app
class MainAppExample extends StatelessWidget {
  const MainAppExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Ticket App',
      home: const AccessoryDemoPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    );
  }
}
