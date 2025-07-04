import 'package:flutter/material.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/match_details_model.dart';
import 'package:football_ticket/models/stand_model.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/cart/cart_screen.dart';
import 'package:football_ticket/widgets/stands_card.dart';

class DetailsMatch extends StatefulWidget {
  final UserModel user;
  final MatchDetailsModel detailsMatch;
  const DetailsMatch({
    super.key,
    required this.user,
    required this.detailsMatch,
  });

  @override
  State<DetailsMatch> createState() => _DetailsMatchState();
}

class _DetailsMatchState extends State<DetailsMatch> {
  StandModel? selectedStand;
  double? selectedPrice;
  int? selectedQuantity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text("Match details", style: AppTextStyles.title2),
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     SizedBox(width: 0),
        //     Text("Match details", style: AppTextStyles.title2),
        //     // GestureDetector(
        //     //   onTap: () {
        //     //     Navigator.push(
        //     //       context,
        //     //       MaterialPageRoute(builder: (context) => CartScreen()),
        //     //     );
        //     //   },
        //     //   child: Icon(Icons.shopping_cart_outlined),
        //     // ),
        //   ],
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Card(
                  color: AppColors.white,
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Image.network(
                                widget.detailsMatch.match.homeTeam.logo,
                                width: 75,
                                height: 60,
                              ),
                              Text(
                                widget.detailsMatch.match.homeTeam.teamName,
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Image.network(
                                widget.detailsMatch.match.awayTeam.logo,
                                width: 75,
                                height: 60,
                              ),
                              Text(
                                widget.detailsMatch.match.awayTeam.teamName,
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "VS",
                        style: AppTextStyles.title1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text("V-League 2025 ", style: AppTextStyles.title2),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.grey,
                          ),
                          SizedBox(width: 5),
                          Text("Go Dau", style: AppTextStyles.body1),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            color: AppColors.grey,
                          ),
                          SizedBox(width: 5),
                          Text(
                            widget.detailsMatch.match.matchDateMY,
                            style: AppTextStyles.body1,
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.timer_sharp, color: AppColors.grey),
                          SizedBox(width: 5),
                          Text(
                            widget.detailsMatch.match.matchTime,
                            style: AppTextStyles.body1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage("assets/images/stadium.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              StandsCard(
                stands: widget.detailsMatch.stand,
                onStandSelected: (stand, price, quantity) {
                  setState(() {
                    selectedStand = stand;
                    selectedPrice = price;
                    selectedQuantity = quantity;
                  });
                },
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CartScreen(
                      detailsMatch: widget.detailsMatch,
                      user: widget.user,
                      stand: selectedStand!,
                      totlePrice: selectedPrice ?? 0.0,
                      quantity: selectedQuantity ?? 1,
                    ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "Add to Cart",
                style: AppTextStyles.title1.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
