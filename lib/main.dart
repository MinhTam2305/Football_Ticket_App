import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/booking_details/booking_details_bloc.dart';
import 'package:football_ticket/blocs/match/match_bloc.dart';
import 'package:football_ticket/blocs/match_details/match_details_bloc.dart';
import 'package:football_ticket/blocs/team/team_bloc.dart';
import 'package:football_ticket/blocs/ticket/ticket_bloc.dart';
import 'package:football_ticket/blocs/ticket_check/ticket_check_bloc.dart';
import 'package:football_ticket/blocs/booking/booking_bloc.dart';
import 'package:football_ticket/blocs/payment/payment_bloc.dart';
import 'package:football_ticket/core/services/auth/toggle_auth.dart';
import 'package:football_ticket/repositories/auth_repository.dart';
import 'package:football_ticket/repositories/booking_details_repository.dart';
import 'package:football_ticket/repositories/match_details_repository.dart';
import 'package:football_ticket/repositories/match_repository.dart';
import 'package:football_ticket/repositories/team_repository.dart';
import 'package:football_ticket/repositories/booking_repository.dart';
import 'package:football_ticket/repositories/payment_repository.dart';
import 'package:football_ticket/repositories/ticket_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketRepository = TicketRepository(baseUrl: 'https://intership.hqsolutions.vn');
    final paymentRepository = PaymentRepository(baseUrl: 'https://intership.hqsolutions.vn');
    final bookingRepository = BookingRepository();

    final ticketBloc = TicketBloc(repository: ticketRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthRepository())),
        BlocProvider(create: (_) => ticketBloc), // ✔️ TicketBloc duy nhất
        BlocProvider(create: (_) => MatchBloc(MatchRepository())),
        BlocProvider(create: (_) => TeamBloc(TeamRepository())),
        BlocProvider(create: (_) => MatchDetailsBloc(MatchDetailsRepository())),
        BlocProvider(create: (_) => BookingDetailsBloc(BookingDetailsRepository())),
        BlocProvider(create: (_) => BookingBloc(bookingRepository: bookingRepository)),

        // ✔️ PaymentBloc cần truyền ticketBloc vào
        BlocProvider(
          create: (_) => PaymentBloc(
            paymentRepository: paymentRepository,
            bookingRepository: bookingRepository,
            ticketBloc: ticketBloc,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'FootBall Ticket App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: ToggleAuth(),
      ),
    );
  }
}