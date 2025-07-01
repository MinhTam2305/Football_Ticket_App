import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_ticket/components/match_details/card_stand.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/stand_model.dart';
import 'package:intl/intl.dart';

class StandsCard extends StatefulWidget {
  final List<StandModel> stands;
  const StandsCard({super.key, required this.stands});

  @override
  State<StandsCard> createState() => _StandsCardState();
}

class _StandsCardState extends State<StandsCard> {
  int quantity = 1;
  double price = 0;
  double unitPrice = 0;
  int selectedIndex = 0;
  int availableTickets = 0;

  @override
  void initState() {
    super.initState();
    if (widget.stands.isNotEmpty) {
      price = widget.stands[0].price;
      unitPrice = widget.stands[0].price;
      availableTickets = widget.stands[0].availabelTickets;
    }
  }

  void add() {
    if (quantity < availableTickets) {
      setState(() {
        quantity++;
      });
    }
  }

  void decre() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = unitPrice * quantity;
    final formattedPrice = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    ).format(totalPrice);
    print("Số khán đài: ${widget.stands.length}");
    return Card(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            widget.stands.isNotEmpty
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.spaceBetween,
                        children:
                            widget.stands.asMap().entries.map((entry) {
                              final index = entry.key;
                              final stand = entry.value;
                              return SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 50,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                      price = stand.price;
                                      unitPrice = stand.price;
                                      availableTickets = stand.availabelTickets;
                                    });
                                  },
                                  child: CardStand(
                                    stand: stand.standName,
                                    quantity:
                                        "${stand.availabelTickets}/${stand.totalTickets}",
                                    isTarget: selectedIndex == index,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
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
                          width: 125,
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
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text(
                            "Price:        ",
                            style: AppTextStyles.body1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$formattedPrice",
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : Center(
                  child: Text(
                    "Chưa có thông tin khán đài",
                    style: AppTextStyles.title2,
                  ),
                ),
      ),
    );
  }
}
