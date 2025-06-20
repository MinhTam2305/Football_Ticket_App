import 'package:flutter/material.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/screens/staff/manual_check_ticket_screen.dart';
import 'package:football_ticket/screens/staff/report.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class HomeStaff extends StatefulWidget {
  const HomeStaff({super.key});

  @override
  State<HomeStaff> createState() => _HomeStaffState();
}

class _HomeStaffState extends State<HomeStaff> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  Barcode? result;
  QRViewController? controller;
  bool isDialogOpen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!isDialogOpen) {
        setState(() {
          result = scanData;
          isDialogOpen = true;
        });
        await controller.pauseCamera();
        await _showDialog(context);
        setState(() {
          isDialogOpen = false;
          result = null;
        });
        await controller.resumeCamera();
      }
    });
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
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
                Text("Match: VietNam vs Malaysia"),
                Text("Time: 8.00 pm"),
                Text("Status: Checked in"),
                SizedBox(height: 20),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
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
