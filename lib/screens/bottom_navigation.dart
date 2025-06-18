import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/change_password_from_forget.dart';
import 'package:football_ticket/screens/home_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentPageIndex = 0;
  static final List<Widget> _widgetOption = <Widget>[
    HomePage(),
    ChangePasswordFromForget(user: UserModel(uid: "123")),
    HomePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOption.elementAt(_currentPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.ticket),
            label: "Ticket",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.person),
            label: "Profile",
          ),
        ],
        currentIndex: _currentPageIndex,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
