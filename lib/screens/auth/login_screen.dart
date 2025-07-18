import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_event.dart';
import 'package:football_ticket/blocs/auth/auth_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/screens/auth/opt_screen.dart';
import 'package:football_ticket/screens/bottom_navigation.dart';
import 'package:football_ticket/widgets/button_custom.dart';
import 'package:football_ticket/widgets/show_loading_dialog.dart';
import 'package:football_ticket/widgets/text_field_custom.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  void Function()? onTap;

  LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login(String phone, String password) {
    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );

      return;
    }

    if (phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số điện thoại không hợp lệ!')),
      );
    }
    showLoadingDialog(context);
    context.read<AuthBloc>().add(Login(phone, password));
  }

  void forgetPassword(String phone) {
    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter your munber phone")));
    } else if (phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số điện thoại không hợp lệ!')),
      );
      return;
    } else {
      context.read<AuthBloc>().add(SendOtpRequetsed(phone, true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is OtpSent) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => OtpScreen(
                      verificationId: state.verificationId,
                      isForgetPassword: true,
                    ),
              ),
            );
          });
        } else if (state is Logined) {
          Navigator.of(context).pop();
          String? deviceToken = await FirebaseMessaging.instance.getToken();
          print("Device Token: $deviceToken");
          if (deviceToken != null) {
            context.read<AuthBloc>().add(
              AddTokenDevice(state.user.token!, deviceToken),
            );
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Đăng nhập thành công')));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigation(user: state.user),
            ),
          );
        } else if (state is AuthFailure) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Loi: ${state.message}")));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 80),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    height: 200,
                    width: 200,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Login",
                  style: AppTextStyles.title1.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 60),
                textFieldCustom("Phone", Icons.phone, _phoneController, false),
                SizedBox(height: 35),
                textFieldCustom(
                  "Password",
                  Icons.lock_open_sharp,
                  _passwordController,
                  true,
                ),
                SizedBox(height: 5),

                //change to sign up
                GestureDetector(
                  onTap: () => forgetPassword(_phoneController.text),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forget password?",
                        style: AppTextStyles.body1.copyWith(
                          color: const Color.fromARGB(255, 241, 56, 56),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 55),

                //btn Login
                ButtonCustom(
                  text: "Login",
                  opTap:
                      () => login(
                        _phoneController.text,
                        _passwordController.text,
                      ),
                  isLoading: false,
                ),
                SizedBox(height: 18),

                GestureDetector(
                  onTap: widget.onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account? ",
                        style: AppTextStyles.body1,
                      ),
                      Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
