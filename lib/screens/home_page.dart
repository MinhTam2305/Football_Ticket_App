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
import 'package:football_ticket/screens/changpassword_page.dart';
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
  UserModel userTest = UserModel(
    uid: "123456",
    name: "Tam",
    phoneNumber: "0399302970",
    role: "user",
  );

  String dropdownValue = list.first;
  String dropdownTeamValue = team.first;

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<AuthBloc>().add(GetCurrentUserRequested());
  // }

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<AuthBloc, AuthState>(
    //   builder: (context, state) {
    //     if (state is CurrentUserLoaded) {
    //       final user = state.currentUser;
    //       return home(user);
    //     } else if (state is AuthFailure) {
    //       return Text('Lỗi: ${state.message}');
    //     }
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
    if (userTest.name == null) {
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
              Text("Hi ${userTest.name!}", style: AppTextStyles.title2),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangpasswordPage(),
                    ),
                  );
                },
                child: Icon(
                  FontAwesomeIcons.cartShopping,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Highlight Match",
              style: AppTextStyles.title2.copyWith(color: AppColors.textMain),
            ),
            SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CardHighlight(),
                  SizedBox(width: 10),
                  CardHighlight(),
                  SizedBox(width: 10),
                  CardHighlight(),
                  SizedBox(width: 10),
                  CardHighlight(),
                  SizedBox(width: 10),
                  CardHighlight(),
                ],
              ),
            ),

            SizedBox(height: 25),
            Text(
              "Maches",
              style: AppTextStyles.title1.copyWith(color: AppColors.primary),
            ),

            SizedBox(height: 5),
            Row(
              children: [
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items:
                      list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
                 SizedBox(width: 25),
                DropdownButton<String>(
                  value: dropdownTeamValue,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownTeamValue = value!;
                    });
                  },
                  items:
                      team.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ],
            ),

            SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsMatch()),
                );
              },
              child: CardMatch(),
            ),
            SizedBox(height: 25),
            CardMatch(),
          ],
        ),
      ),
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