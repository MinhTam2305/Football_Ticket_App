import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/core/services/auth/toggle_auth.dart';
import 'package:football_ticket/screens/auth/login_screen.dart';
import 'package:football_ticket/screens/bottom_navigation.dart';
import 'package:football_ticket/screens/auth/change_password_from_forget.dart';
import 'package:football_ticket/screens/home_page.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String? name;
  final String? phone;
  final String? password;
  final bool isForgetPassword;
  const OtpScreen({
    super.key,
    required this.verificationId,
    this.name,
    this.phone,
    this.password,
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
      appBar: AppBar(
        centerTitle: true,
        title: Text("Xác thực OTP", style: AppTextStyles.title2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 200),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Mã OTP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      final name = widget.name;
                      final phone = widget.phone;
                      final password = widget.password;

                      if (name == null || phone == null || password == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thiếu thông tin để xác thực OTP.'),
                          ),
                        );
                        return;
                      }

                      context.read<AuthBloc>().add(
                        VerifyOtpRequested(
                          code,
                          widget.verificationId,
                          name,
                          phone,
                          password,
                        ),
                      );
                    }
                  },
                  child: Text("Xác nhận"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
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
                    SnackBar(content: Text("Đã đăng ký thành công!")),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ToggleAuth()),
                  );
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi: ${state.message}")),
                  );
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
