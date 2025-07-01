import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_event.dart';
import 'package:football_ticket/blocs/auth/auth_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/core/services/auth/toggle_auth.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/widgets/button_custom.dart';
import 'package:football_ticket/widgets/text_field_custom.dart';
import 'package:lottie/lottie.dart';

class ChangpasswordPage extends StatefulWidget {
  final UserModel user;
  const ChangpasswordPage({super.key, required this.user});

  @override
  State<ChangpasswordPage> createState() => _ChangpasswordPageState();
}

class _ChangpasswordPageState extends State<ChangpasswordPage> {
  bool isLoading = false;

  final TextEditingController _oldPassword = TextEditingController();

  final TextEditingController _newPassword = TextEditingController();

  final TextEditingController _confirmPassword = TextEditingController();

  void changePassword(BuildContext context) {
    String oldPassword = _oldPassword.text.trim();
    String newPassword = _newPassword.text.trim();
    String confirmPassword = _confirmPassword.text.trim();
    final hasUppercase = RegExp(r'[A-Z]');
    final hasSpecialChar = RegExp(r'[!@#\$&*~%^()_\-+=<>?/\\{}[\]|.,;:]');

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter require infomation!")));
      return;
    }
    if (oldPassword.length < 6 ||
        newPassword.length < 6 ||
        confirmPassword.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password must be 6 characters!")));
      return;
    }
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password does not match!")));
      return;
    }
    if (oldPassword == newPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mật khẩu mới và cũ không được giống nhau")),
      );
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
    setState(() {
      isLoading = true;
    });
    context.read<AuthBloc>().add(
      ChangePassword(widget.user.token!, oldPassword, newPassword),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is ResestPasswordSuccessed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, true);
          // Navigator.of(context).pushAndRemoveUntil(
          //   MaterialPageRoute(builder: (context) => ToggleAuth()),
          //   (route) => false,
          // );
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.background,
          title: Text(
            "Change Your Password",
            style: AppTextStyles.title1.copyWith(fontWeight: FontWeight.bold),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                child: Lottie.asset("assets/password.json"),
              ),
              SizedBox(height: 80),
              textFieldCustom(
                "Old Password",
                Icons.keyboard_alt_outlined,
                _oldPassword,
                true,
              ),
              SizedBox(height: 25),
              textFieldCustom(
                "New Password",
                Icons.password_outlined,
                _newPassword,
                true,
              ),
              SizedBox(height: 25),
              textFieldCustom(
                "Old Password",
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
