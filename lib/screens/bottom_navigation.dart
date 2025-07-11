import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/auth/change_password_from_forget.dart';
import 'package:football_ticket/screens/staff/manual_check_ticket_screen.dart';
import 'package:football_ticket/screens/tabs/home_page.dart';
import 'package:football_ticket/screens/staff/home_staff.dart';
import 'package:football_ticket/screens/tabs/profile_page.dart';
import 'package:football_ticket/screens/tabs/ticket_screen.dart';

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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    user = widget.user;
    if (user.role == "User" || user.role == "Admin") {
      isUser = true;
    } else {
      isUser = false;
    }

   
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Xử lý khi người dùng nhấn vào thông báo (có thể điều hướng hoặc custom logic ở đây)
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOption = <Widget>[
      isUser ? HomePage() : HomeStaff(user: widget.user),
      isUser ? TicketScreen(userId: widget.user.uid!, token: widget.user.token!) : ManualCheckTicketScreen(),
      isUser ? ProfilePage() : ProfilePage(),
    ];
    return Scaffold(
      body: IndexedStack(index: _currentPageIndex, children: _widgetOption),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
        ],
        currentIndex: _currentPageIndex,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
