import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_ticket/blocs/auth/auth_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_event.dart';
import 'package:football_ticket/blocs/auth/auth_state.dart';
import 'package:football_ticket/blocs/match/match_bloc.dart';
import 'package:football_ticket/blocs/match/match_event.dart';
import 'package:football_ticket/blocs/match/match_state.dart';
import 'package:football_ticket/blocs/match_details/match_details_bloc.dart';
import 'package:football_ticket/blocs/match_details/match_details_event.dart';
import 'package:football_ticket/blocs/match_details/match_details_state.dart';
import 'package:football_ticket/blocs/team/team_bloc.dart';
import 'package:football_ticket/blocs/team/team_event.dart';
import 'package:football_ticket/blocs/team/team_state.dart';
import 'package:football_ticket/components/home/card_highlight.dart';
import 'package:football_ticket/components/home/card_match.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/match_details_model.dart';
import 'package:football_ticket/models/match_model.dart';
import 'package:football_ticket/models/team_model.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/cart/cart_screen.dart';
import 'package:football_ticket/screens/auth/changpassword_page.dart';
import 'package:football_ticket/screens/details_match.dart';
import 'package:football_ticket/widgets/show_loading_dialog.dart';
import 'package:lottie/lottie.dart';

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

  List<MatchModel>? listMatch;
  bool isLoadMatch = true;
  TeamModel? selectedTeam;
  @override
  void initState() {
    super.initState();
    context.read<TeamBloc>().add(LoadTeamEvent());
    context.read<MatchBloc>().add(LoadMatchEvent(null));
    selectedTeam = null;
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: (Duration(milliseconds: 400)),
            curve: Curves.easeInOut,
          );
        }
      });
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
          print("Token: ${user.token}");
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>CartScreen()),
                        // );
                      },
                      child: Lottie.asset(
                        "assets/notification.json",
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: BlocListener<MatchBloc, MatchState>(
              listener: (context, state) {
                if (state is MatchLoaded) {
                  setState(() {
                    isLoadMatch = false;

                    listMatch = state.listMatch.reversed.toList();
                  });
                }
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<MatchBloc>().add(LoadMatchEvent(null));
                },
                child: SingleChildScrollView(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<MatchBloc>().add(LoadMatchEvent(null));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Card(
                            elevation: 5,
                            color: AppColors.secondary,
                            child: SizedBox(
                              width: double.infinity,
                              height: 220,
                              child: Lottie.asset("assets/home_page.json"),
                            ),
                          ),

                          SizedBox(height: 10),
                          Text(
                            "Maches",
                            style: AppTextStyles.title1.copyWith(
                              color: AppColors.primary,
                            ),
                          ),

                          SizedBox(height: 5),
                          Row(
                            children: [
                              // Container(
                              //   width: 140,
                              //   height: 40,
                              //   decoration: BoxDecoration(
                              //     color: AppColors.secondary,
                              //     border: Border.all(
                              //       color: AppColors.primary,
                              //       width: 2,
                              //     ),
                              //     borderRadius: BorderRadius.circular(10.0),
                              //   ),
                              //   child: Center(
                              //     child: DropdownButton<String>(
                              //       value: dropdownValue,
                              //       style: const TextStyle(
                              //         color: AppColors.textMain,
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //       onChanged: (String? value) {
                              //         setState(() {
                              //           dropdownValue = value!;
                              //         });
                              //       },
                              //       elevation: 5,
                              //       dropdownColor: AppColors.secondary,
                              //       borderRadius: BorderRadius.circular(12),
                              //       icon: SizedBox.shrink(),
                              //       underline: SizedBox(),
                              //       items:
                              //           list.map<DropdownMenuItem<String>>((
                              //             String value,
                              //           ) {
                              //             return DropdownMenuItem<String>(
                              //               value: value,
                              //               child: Text(value),
                              //             );
                              //           }).toList(),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(width: 25),
                              BlocBuilder<TeamBloc, TeamState>(
                                builder: (context, state) {
                                  if (state is TeamLoading) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is TeamLoaded) {
                                    final teams = state.teamModel;

                                    return Card(
                                      color: AppColors.secondary_bg,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.primary,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: DropdownButton<TeamModel?>(
                                            value: selectedTeam,
                                            style: const TextStyle(
                                              color: AppColors.textMain,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            onChanged: (TeamModel? value) {
                                              setState(() {
                                                selectedTeam = value;
                                                isLoadMatch = true;

                                                context.read<MatchBloc>().add(
                                                  LoadMatchEvent(value?.teamId),
                                                );
                                              });
                                            },
                                            menuMaxHeight: 300,
                                            icon: SizedBox.shrink(),
                                            underline: SizedBox(),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            items: [
                                              DropdownMenuItem<TeamModel?>(
                                                value: null,
                                                child: Text(
                                                  "Teams",
                                                  style: TextStyle(
                                                    color: AppColors.textMain,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              ...teams.map((team) {
                                                return DropdownMenuItem<
                                                  TeamModel
                                                >(
                                                  value: team,
                                                  child: Text(team.teamName),
                                                );
                                              }).toList(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (state is TeamLoadError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Lỗi:${state.message}"),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 25),
                          if (isLoadMatch || listMatch == null)
                            Center(child: CircularProgressIndicator())
                          else if (listMatch == null || listMatch!.isEmpty)
                            Center(child: Text("Không có trận đấu nào"))
                          else
                            BlocListener<MatchDetailsBloc, MatchDetailsState>(
                              listener: (context, state) {
                                if (state is MatchDetailsLoading) {
                                  showLoadingDialog(context);
                                }
                                if (state is MatchDetailsLoaded) {
                                  if (Navigator.canPop(context))
                                    Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DetailsMatch(
                                            user: user,
                                            detailsMatch: state.detailsMatch,
                                          ),
                                    ),
                                  );
                                }
                                if (state is MatchDetailsError) {
                                  if (Navigator.canPop(context))
                                    Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Lỗi khi lấy chi tiết trận đấu",
                                      ),
                                    ),
                                  );
                                }
                              },

                              child: ListView.builder(
                                itemCount: listMatch!.length,

                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  print("--------------");
                                  print("match${listMatch![index]}");
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        context.read<MatchDetailsBloc>().add(
                                          LoadMatchDetailsEvent(
                                            user.token!,
                                            listMatch![index].matchId,
                                          ),
                                        );
                                      },
                                      child: CardMatch(
                                        match: listMatch![index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
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