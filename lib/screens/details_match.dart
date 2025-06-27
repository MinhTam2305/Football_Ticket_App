import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_ticket/components/match_details/card_stand.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/match_model.dart';
import 'package:football_ticket/screens/cart/cart_screen.dart';

class DetailsMatch extends StatefulWidget {
  final MatchModel match;
  const DetailsMatch({super.key, required this.match});

  @override
  State<DetailsMatch> createState() => _DetailsMatchState();
}

class _DetailsMatchState extends State<DetailsMatch> {
  int quantity = 0;

  void add() {
    setState(() {
      quantity++;
    });
  }

  void decre() {
    setState(() {
      quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 0),
            Text("Match details", style: AppTextStyles.title2),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
              child: Icon(Icons.shopping_cart_outlined),
            ),
          ],
        ),
      ),
      body: Padding(
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
                            Image.asset(
                              "assets/images/vietnamFlag.jpg",
                              width: 75,
                              height: 60,
                            ),
                            Text(
                              widget.match.homeTeam.teamName,
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              "assets/images/malaysia.png",
                              width: 75,
                              height: 60,
                            ),
                            Text(
                              widget.match.awayTeam.teamName,
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
                        Icon(Icons.location_on_outlined, color: AppColors.grey),
                        SizedBox(width: 5),
                        Text("Go Dau", style: AppTextStyles.body1),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.date_range_outlined, color: AppColors.grey),
                        SizedBox(width: 5),
                        Text(
                          widget.match.matchDateMY,
                          style: AppTextStyles.body1,
                        ),
                        SizedBox(width: 15),
                        Icon(Icons.timer_sharp, color: AppColors.grey),
                        SizedBox(width: 5),
                        Text(
                          widget.match.matchTime,
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
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage("assets/images/stadium.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 35),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardStand(stand: "A", quantity: "10/20", isTarget: true),
                    CardStand(stand: "B", quantity: "10/20"),
                    CardStand(stand: "C", quantity: "10/20"),
                  ],
                ),
                SizedBox(height: 25),
                CardStand(stand: "D", quantity: "10/20"),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Quantity:",
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  width: 115,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: decre,
                        icon: Icon(Icons.remove, size: 25),
                        padding: EdgeInsets.zero,
                      ),
                      Text(
                        "$quantity",
                        style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: add,
                        icon: Icon(FontAwesomeIcons.plus, size: 15),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Price:        ",
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "500.000 VND",
                  style: AppTextStyles.body1.copyWith(color: AppColors.grey),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
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
          ],
        ),
      ),
    );
  }
}
