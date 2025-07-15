import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_event.dart';
import 'package:football_ticket/blocs/auth/auth_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/core/services/auth/toggle_auth.dart';
import 'package:football_ticket/screens/auth/change_password_from_forget.dart';
import 'package:football_ticket/screens/auth/changpassword_page.dart';
import 'package:football_ticket/widgets/button_custom.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is Logined && state.user != null) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 120),
                        child: Lottie.asset("assets/Animation-Profile.json"),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 120,
                            child: Card(
                              elevation: 5,
                              color: AppColors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.user.name ?? "Unknow",
                                    style: AppTextStyles.title1,
                                  ),
                                  Text(
                                    state.user.phoneNumber ?? "Null",
                                    style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 250),
                          ButtonCustom(
                            text: "Edit Profile",
                            opTap: () {},
                            isLoading: false,
                          ),
                          SizedBox(height: 40),
                          ButtonCustom(
                            text: "Change Password",
                            opTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          ChangpasswordPage(user: state.user),
                                ),
                              );
                
                              if (result == true) {
                                if (state.user.uid != null &&
                                    state.user.token != null) {
                                  context.read<AuthBloc>().add(
                                    GetUserById(
                                      state.user.uid!,
                                      state.user.token!,
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ToggleAuth(),
                                    ),
                                  );
                                }
                              }
                            },
                            isLoading: false,
                          ),
                          SizedBox(height: 40),
                
                          ButtonCustom(
                            text: "Logout",
                            opTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ToggleAuth(),
                                ),
                              );
                            },
                            isLoading: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
