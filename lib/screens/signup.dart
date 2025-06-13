import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/button_custom.dart';
import '../widgets/text_field_custom.dart';

class Signup extends StatefulWidget {
  void Function()? onTap;

  Signup({super.key, required this.onTap});

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
    setState(() {
      isLoading=true;
    });
  }
  @override
  dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                style: AppTextStyles.title1.copyWith(color: AppColors.primary),
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
              ButtonCustom(text: "Sign up", opTap: signup,isLoading: isLoading,),
            ],
          ),
        ),
      ),
    );
  }
}
