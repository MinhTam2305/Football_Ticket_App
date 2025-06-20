import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/ticket/ticket_bloc.dart';
import 'package:football_ticket/blocs/ticket_check/ticket_check_bloc.dart';
import 'package:football_ticket/core/services/auth/toggle_auth.dart';
import 'package:football_ticket/repositories/auth_repository.dart';
import 'package:football_ticket/screens/bottom_navigation.dart';
import 'package:football_ticket/screens/home_page.dart';
import 'package:football_ticket/screens/staff/manual_check_ticket_screen.dart';
import 'package:football_ticket/screens/ticket/ticket_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthRepository())),
        BlocProvider(create: (_) => TicketBloc()),
        BlocProvider(create: (_) => TicketCheckBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FootBall Ticket App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BottomNavigation(),
    );
  }
}
