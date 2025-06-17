import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_event.dart';
import 'package:football_ticket/blocs/auth/auth_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/changpassword_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel userTest = UserModel(
    uid: "123456",
    name: "Tam",
    phoneNumber: "0399302970",
    role: "user",
  );

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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangpasswordPage()));
                },
                child: Icon(FontAwesomeIcons.cartShopping, color: AppColors.grey,))
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Maches",
              style: AppTextStyles.title1.copyWith(color: AppColors.primary),
            ),
            SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Text(
                    "V-lEAGUE 2025",
                    style: AppTextStyles.body1.copyWith(color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/vietnamFlag.jpg",
                            width: 60,
                            height: 50,
                          ),
                          Text("VietNam", style: AppTextStyles.body1),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/malaysia.png",
                            width: 60,
                            height: 50,
                          ),
                          Text("Malaysia", style: AppTextStyles.body1),
                        ],
                      ),
                    ],
                  ),

                  Divider(color: AppColors.secondary),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.timer_sharp, color: AppColors.grey),
                          SizedBox(width: 5),
                          Text("15/06 8.00 pm", style: AppTextStyles.body2),
                        ],
                      ),
                      SizedBox(width: 70),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.grey,
                          ),
                          SizedBox(width: 5),
                          Text("Go Dau", style: AppTextStyles.body2),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
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