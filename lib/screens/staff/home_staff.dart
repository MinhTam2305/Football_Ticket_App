import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/booking_details/booking_details_bloc.dart';
import 'package:football_ticket/blocs/booking_details/booking_details_event.dart';
import 'package:football_ticket/blocs/booking_details/booking_details_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/detail_booking_model.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/staff/manual_check_ticket_screen.dart';
import 'package:football_ticket/screens/staff/report.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class HomeStaff extends StatefulWidget {
  final UserModel user;
  const HomeStaff({super.key, required this.user});

  @override
  State<HomeStaff> createState() => _HomeStaffState();
}

class _HomeStaffState extends State<HomeStaff> {
  DetailBookingModel? booking;
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  Barcode? result;
  QRViewController? controller;
  bool isDialogOpen = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingDetailsBloc, BookingDetailsState>(
      listener: (context, state) {
        if (state is BookingDetailsLoadingState) {
          // Show loading indicator if needed
        } else if (state is BookingDetailsLoadedState) {
          setState(() {
            booking = state.bookingDetails;
            isDialogOpen = true;
          });
          if (booking != null) {
            _showDialog(context, booking!);
          }
        } else if (state is BookingDetailsErrorState) {
          // Show error message
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
          print("Error: ${state.error}");
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Check ticket", style: AppTextStyles.title1),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManualCheckTicketScreen(),
                    ),
                  );
                },
                child: Icon(Icons.search, color: AppColors.primary, size: 35),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Report()),
                  );
                },
                child: Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: 420,
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
                ),

                Expanded(
                  flex: 2,
                  child: (result != null) ? Text("${result?.code}") : Text(""),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!isDialogOpen) {
        if (scanData.code == null || scanData.code!.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Invalid QR code")));
          return;
        }
        setState(() {
          result = scanData;
          context.read<BookingDetailsBloc>().add(
            LoadBookingDetailsEvent(
              bookingId: result!.code!.toString(),
              token: widget.user.token!,
            ),
          );
        });
        await controller.pauseCamera();
      }
    });
  }

  Future<void> _showDialog(BuildContext context, DetailBookingModel booking) {
    return showDialog(
      context: context,
       barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 50,
                  color: AppColors.success,
                ),
                SizedBox(height: 10),
                Text(booking.matchName),
                Text("Time: ${booking.matchTime}"),
                Text("Status: ${booking.status}"),
                SizedBox(height: 20),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    setState(() {
                      
                      isDialogOpen = false;
                      result = null;
                    });
                    await controller?.resumeCamera();
                  },
                  child: Text(
                    "Show Details",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
