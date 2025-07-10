<<<<<<< HEAD
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uni_links/uni_links.dart';
// import 'package:football_ticket/blocs/booking/booking_bloc.dart';
// import 'package:football_ticket/blocs/booking/booking_event.dart';
// import 'package:football_ticket/screens/cart/cart_successful_screen.dart';
// import 'package:football_ticket/models/match_details_model.dart';
// import 'package:football_ticket/models/user_model.dart';
// import 'package:football_ticket/models/stand_model.dart';
=======
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_links/app_links.dart';
import 'package:football_ticket/blocs/booking/booking_bloc.dart';
import 'package:football_ticket/blocs/booking/booking_event.dart';
import 'package:football_ticket/screens/cart/cart_successful_screen.dart';
import 'package:football_ticket/models/match_details_model.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/models/stand_model.dart';
>>>>>>> 7e934a2758adf64294dc24ea11ce0dc981769d2b

// class PaymentResultHandler extends StatefulWidget {
//   final MatchDetailsModel detailsMatch;
//   final StandModel stand;
//   final int quantity;
//   final UserModel user;

//   const PaymentResultHandler({
//     super.key,
//     required this.detailsMatch,
//     required this.stand,
//     required this.quantity,
//     required this.user,
//   });

//   @override
//   State<PaymentResultHandler> createState() => _PaymentResultHandlerState();
// }

// class _PaymentResultHandlerState extends State<PaymentResultHandler> {
//   StreamSubscription? _sub;

//   @override
//   void initState() {
//     super.initState();
//     _handleDeepLink();
//   }

<<<<<<< HEAD
//   void _handleDeepLink() {
//     _sub = uriLinkStream.listen((Uri? uri) {
//       if (uri == null) return;
=======
  void _handleDeepLink() {
    final appLinks = AppLinks();
    _sub = appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri == null) return;
>>>>>>> 7e934a2758adf64294dc24ea11ce0dc981769d2b

//       final result = uri.queryParameters['result'];
//       debugPrint('💰 Received payment result: $result');

//       if (result == 'success') {
//         context.read<BookingBloc>().add(
//           BookTicketEvent(
//             userId: widget.user.uid!,
//             matchId: widget.detailsMatch.idMatch,
//             standId: widget.stand.standId,
//             quantity: widget.quantity,
//           ),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const CartSuccessfulScreen()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Thanh toán thất bại!")),
//         );
//         Navigator.pop(context);
//       }
//     }, onError: (err) {
//       debugPrint('❌ Deep link error: $err');
//     });
//   }

//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }