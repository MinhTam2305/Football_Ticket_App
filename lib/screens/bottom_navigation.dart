import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/staff/manual_ticket_lookup_screen.dart';
import 'package:football_ticket/screens/tabs/accessory_page.dart';
import 'package:football_ticket/screens/tabs/home_page.dart';
import 'package:football_ticket/screens/staff/home_staff.dart';
import 'package:football_ticket/screens/tabs/profile_page.dart';
import 'package:football_ticket/screens/tabs/ticket_screen.dart';
import 'package:football_ticket/screens/news/news_screen.dart'; // ✅ THÊM DÒNG NÀY

class BottomNavigation extends StatefulWidget {
  final UserModel user;
  const BottomNavigation({super.key, required this.user});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentPageIndex = 0;
  late UserModel user;
  bool isUser = true;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    user = widget.user;
    if (user.role == "User" || user.role == "Admin") {
      isUser = true;
    } else {
      isUser = false;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        // Hiển thị local notification
        await flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title ?? '',
          message.notification!.body ?? '',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'Thông báo',
              channelDescription: 'Kênh thông báo cho Football Ticket App',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOption =
        isUser
            ? [
              HomePage(),
              AccessoryPage(user: widget.user),
              NewsScreen(),
              TicketScreen(userId: widget.user.uid!, token: widget.user.token!),
              ProfilePage(),
            ]
            : [
              HomeStaff(user: widget.user),
              ManualTicketLookupScreen(),
              ProfilePage(),
            ];

    List<BottomNavigationBarItem> _navItems =
        isUser
            ? [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                label: "Accessory",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_rounded),
                label: "News",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number_outlined),
                label: "Ticket",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.person),
                label: "Profile",
              ),
            ]
            : [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number_outlined),
                label: "Ticket",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.person),
                label: "Profile",
              ),
            ];

    return Scaffold(
      body: IndexedStack(index: _currentPageIndex, children: _widgetOption),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),

          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(surfaceTint: Colors.transparent),
        ),
        child: BottomNavigationBar(
          items: _navItems,
          currentIndex: _currentPageIndex,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
