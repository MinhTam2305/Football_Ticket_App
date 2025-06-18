import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/core/services/auth/toggle_auth.dart';
import 'package:football_ticket/screens/auth/login.dart';
import 'package:football_ticket/screens/change_password_from_forget.dart';
import 'package:football_ticket/screens/home_page.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final bool isForgetPassword;
  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.isForgetPassword,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Xác thực OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Mã OTP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final code = codeController.text.trim();

                    if (widget.isForgetPassword) {
                      context.read<AuthBloc>().add(
                        VerifyForgetPasswordOtpRequested(
                          code,
                          widget.verificationId,
                        ),
                      );
                    } else {
                      context.read<AuthBloc>().add(
                        VerifyOtpRequested(code, widget.verificationId),
                      );
                    }
                  },
                  child: Text("Xác nhận"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => ToggleAuth()),
                    );
                  },
                  child: Text("Hủy"),
                ),
              ],
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Đăng nhập thành công!")),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else if (state is AuthFailure) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text("Lỗi: ${state.message}")),
                  // );
                } else if (state is VerifySuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ChangePasswordFromForget(user: state.user),
                    ),
                  );
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
