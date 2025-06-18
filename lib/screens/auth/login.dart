import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_event.dart';
import 'package:football_ticket/blocs/auth/auth_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/screens/auth/opt_screen.dart';
import 'package:football_ticket/widgets/button_custom.dart';
import 'package:football_ticket/widgets/text_field_custom.dart';

class Login extends StatefulWidget {
  void Function()? onTap;

  Login({super.key, this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() {
    setState(() {
      isLoading = true;
    });
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
      context.read<AuthBloc>().add(SendOtpRequetsed(phone));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) {
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
                ButtonCustom(text: "Login", opTap: login, isLoading: isLoading),
                SizedBox(height: 28),

                GestureDetector(
                  onTap: widget.onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
