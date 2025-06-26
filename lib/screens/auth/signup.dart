import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_event.dart';
import 'package:football_ticket/blocs/auth/auth_state.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/auth/opt_screen.dart';

import '../../core/constants/colors.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/text_field_custom.dart';

class Signup extends StatefulWidget {
  void Function()? onTap;

  Signup({super.key, this.onTap});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void signup() {
    final hasUppercase = RegExp(r'[A-Z]');
    final hasSpecialChar = RegExp(r'[!@#\$&*~%^()_\-+=<>?/\\{}[\]|.,;:]');

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
      return;
    }
    if (phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số điện thoại không hợp lệ!')),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mật khẩu không khớp!')));
      return;
    }
    if (!hasUppercase.hasMatch(password) ||
        !hasSpecialChar.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mật khẩu phải có ít nhất 1 chữ in hoa và 1 ký tự đặc biệt!',
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    context.read<AuthBloc>().add(SendOtpRequetsed(phone, false));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is OtpSent) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OtpScreen(
                    verificationId: state.verificationId,
                    name: _nameController.text.trim(),
                    phone: _phoneController.text.trim(),
                    password: _passwordController.text.trim(),
                    isForgetPassword: false,
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
                  "Sign up",
                  style: AppTextStyles.title1.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 45),

                //name
                textFieldCustom("Name", Icons.person, _nameController, false),
                SizedBox(height: 20),

                //phone
                textFieldCustom("Phone", Icons.phone, _phoneController, false),
                SizedBox(height: 20),

                //password
                textFieldCustom(
                  "Password",
                  Icons.lock_open_sharp,
                  _passwordController,
                  true,
                ),
                SizedBox(height: 20),

                //confirm password
                textFieldCustom(
                  "Confirm Password",
                  Icons.lock,
                  _confirmPasswordController,
                  true,
                ),
                SizedBox(height: 5),

                //change to login
                GestureDetector(
                  onTap: widget.onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("You have an account? ", style: AppTextStyles.body1),
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 55),

                //btn sign up
                ButtonCustom(
                  text: "Sign up",
                  opTap: signup,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
