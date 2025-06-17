import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/widgets/button_custom.dart';
import 'package:football_ticket/widgets/text_field_custom.dart';

class ChangpasswordPage extends StatelessWidget {
  ChangpasswordPage({super.key});

  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  void changePassword(BuildContext context){
    String oldPassword = _oldPassword.text;
    String newPassword = _newPassword.text;
    String confirmPassword = _confirmPassword.text;


    if(oldPassword.isEmpty||newPassword.isEmpty||confirmPassword.isEmpty){
       ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Enter require infomation!")),
          );
    }
    else  if(oldPassword.length<6||newPassword.length<6||confirmPassword.length<6){
       ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password must be 6 characters!")),
          );
    }
    else if(newPassword==confirmPassword){
       ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password does not match!")),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Change Your Password",
              style: AppTextStyles.title1.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 100),
            textFieldCustom(
              "Old Password",
              Icons.keyboard_alt_outlined,
              _newPassword,
              true,
            ),
            SizedBox(height: 25),
            textFieldCustom(
              "New Password",
              Icons.password_outlined,
              _oldPassword,
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
            ButtonCustom(text: "Change", opTap: () => changePassword(context) , isLoading: false),
          ],
        ),
      ),
    );
  }
}
