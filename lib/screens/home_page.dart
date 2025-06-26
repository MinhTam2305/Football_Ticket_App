import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_event.dart';
import 'package:football_ticket/blocs/auth/auth_state.dart';
import 'package:football_ticket/components/home/card_highlight.dart';
import 'package:football_ticket/components/home/card_match.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/cart/cart_screen.dart';
import 'package:football_ticket/screens/auth/changpassword_page.dart';
import 'package:football_ticket/screens/details_match.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> list = <String>[
  'V-League 2024',
  'V-League 2025',
  'V-League 2026',
  'V-League 2027',
];
List<String> team = <String>['VietNam', 'Malaysia', 'Campuchia', 'China'];

class _HomePageState extends State<HomePage> {
  //pageview auto_scroll
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;



  String dropdownValue = list.first;
  String dropdownTeamValue = team.first;

  @override
  void initState() {
    super.initState();
    // context.read<AuthBloc>().add(GetCurrentUserRequested());

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: (Duration(milliseconds: 400)),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Logined) {
          final user = state.user;
          if (user.name == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Hi ${user.name!}", style: AppTextStyles.title2),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartScreen()),
                        );
                      },
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Highlight Match",
                      style: AppTextStyles.title2.copyWith(
                        color: AppColors.textMain,
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      height: 215,
                      child: PageView(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          CardHighlight(),
                          CardHighlight(),
                          CardHighlight(),
                          CardHighlight(),
                          CardHighlight(),
                        ],
                      ),
                    ),

                    SizedBox(height: 25),
                    Text(
                      "Maches",
                      style: AppTextStyles.title1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),

                    SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          width: 140,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              style: const TextStyle(
                                color: AppColors.textMain,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              elevation: 5,
                              dropdownColor: AppColors.secondary,
                              borderRadius: BorderRadius.circular(12),
                              icon: SizedBox.shrink(),
                              underline: SizedBox(),
                              items:
                                  list.map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        Container(
                          width: 140,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              value: dropdownTeamValue,
                              style: const TextStyle(
                                color: AppColors.textMain,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownTeamValue = value!;
                                });
                              },
                              icon: SizedBox.shrink(),
                              underline: SizedBox(),
                              borderRadius: BorderRadius.circular(12),
                              items:
                                  team.map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsMatch(),
                          ),
                        );
                      },
                      child: CardMatch(),
                    ),
                    SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsMatch(),
                          ),
                        );
                      },
                      child: CardMatch(),
                    ),
                    SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsMatch(),
                          ),
                        );
                      },
                      child: CardMatch(),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        } else if (state is AuthFailure) {
          print('Lỗi: ${state.message}');
          return Text('Lỗi: ${state.message}');
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}



//  Widget home(UserModel user) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         title: Text("Hi, ${user.phoneNumber}"),
//       ),
//     );
//   }