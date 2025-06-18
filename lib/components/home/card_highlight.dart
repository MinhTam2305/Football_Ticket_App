import 'package:flutter/material.dart';
import 'package:football_ticket/core/constants/colors.dart';

class CardHighlight extends StatelessWidget {
  const CardHighlight({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.white,
                border: Border.all(color: AppColors.primary, width: 2),
              ),

              width: MediaQuery.of(context).size.width,
              height: 215,
              child: Column(
                children: [
                  SizedBox(height: 15),
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
                            "VietNam",
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
                            "Malaysia",
                            style: AppTextStyles.body1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "VS",
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Remaining Tickets: 100  | From only 50.000 VND",
                    style: AppTextStyles.body2.copyWith(color: AppColors.grey),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 35,
                    width: 135,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary
                      ) ,
                      onPressed: () {},
                      child: Center(
                        child: Text(
                          "Đặt vé ngay",
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(height: 10),
                ],
              ),
            );
  }
}