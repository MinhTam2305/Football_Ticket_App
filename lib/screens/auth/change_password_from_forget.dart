import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_event.dart';
import 'package:football_ticket/blocs/auth/auth_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/core/services/auth/toggle_auth.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/bottom_navigation.dart';
import 'package:football_ticket/widgets/button_custom.dart';
import 'package:football_ticket/widgets/text_field_custom.dart';

class ChangePasswordFromForget extends StatefulWidget {
  UserModel? user;
  ChangePasswordFromForget({super.key, required this.user});

  @override
  State<ChangePasswordFromForget> createState() =>
      _ChangePasswordFromForgetState();
}

class _ChangePasswordFromForgetState extends State<ChangePasswordFromForget> {
  bool isLoading = false;

  final TextEditingController _newPassword = TextEditingController();

  final TextEditingController _confirmPassword = TextEditingController();

  void changePassword(BuildContext context) {
    String newPassword = _newPassword.text.trim();
    String confirmPassword = _confirmPassword.text.trim();

    final hasUppercase = RegExp(r'[A-Z]');
    final hasSpecialChar = RegExp(r'[!@#\$&*~%^()_\-+=<>?/\\{}[\]|.,;:]');

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter require infomation!")));
      return;
    }
    if (newPassword.length < 6 || confirmPassword.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password must be 6 characters!")));
      return;
    }
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("M")));
      return;
    }
    if (!hasUppercase.hasMatch(newPassword) ||
        !hasSpecialChar.hasMatch(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mật khẩu phải có ít nhất 1 chữ in hoa và 1 ký tự đặc biệt!',
          ),
        ),
      );
      return;
    }

    if (widget.user?.phoneNumber != null) {
      String phone = formatPhoneNumber(widget.user!.phoneNumber!);
      print("Number: $phone ; $newPassword");
      context.read<AuthBloc>().add(ResetPassword(phone, newPassword));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy số điện thoại ')),
      );
    }
  }

  String formatPhoneNumber(String phone) {
    if (phone.startsWith('+84')) {
      return '0${phone.substring(3)}';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is ResestPasswordSuccessed) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ToggleAuth()),
            (route) => false,
          );
        } else if (state is AuthFailure) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(backgroundColor: AppColors.white),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Change Your Password",
                style: AppTextStyles.title1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 100),
              textFieldCustom(
                "New Password",
                Icons.keyboard_alt_outlined,
                _newPassword,
                true,
              ),

              SizedBox(height: 25),
              textFieldCustom(
                "Confirm Password",
                Icons.password_outlined,
                _confirmPassword,
                true,
              ),
              SizedBox(height: 50),
              ButtonCustom(
                text: "Change",
                opTap: () => changePassword(context),
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
