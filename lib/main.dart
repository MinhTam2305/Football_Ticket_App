import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/match/match_bloc.dart';
import 'package:football_ticket/blocs/match_details/match_details_bloc.dart';
import 'package:football_ticket/blocs/team/team_bloc.dart';
import 'package:football_ticket/blocs/ticket/ticket_bloc.dart';
import 'package:football_ticket/blocs/ticket_check/ticket_check_bloc.dart';
import 'package:football_ticket/blocs/booking/booking_bloc.dart';
import 'package:football_ticket/core/services/auth/toggle_auth.dart';
import 'package:football_ticket/repositories/auth_repository.dart';
import 'package:football_ticket/repositories/match_details_repository.dart';
import 'package:football_ticket/repositories/match_repository.dart';
import 'package:football_ticket/repositories/team_repository.dart';
import 'package:football_ticket/repositories/booking_repository.dart';
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
        BlocProvider(create: (_) => MatchBloc(MatchRepository())),
        BlocProvider(create: (_) => TeamBloc(TeamRepository())),
        BlocProvider(create: (_) => MatchDetailsBloc(MatchDetailsRepository())),
        BlocProvider(
          create: (_) => BookingBloc(
            BookingRepository(baseUrl: 'https://localhost:7023'), // ✅ Link API thật
          ),
        ),
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
      home: ToggleAuth(),
    );
  }
}