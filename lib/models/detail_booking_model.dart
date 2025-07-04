import 'package:intl/intl.dart';

class DetailBookingModel {
  final String bookingId;
  final String userId;
  final String matchId;
  final String matchName;
  final DateTime matchDateTime;
  final DateTime bookingTime;
  final String status;
  final double totalAmount;

  DetailBookingModel({
    required this.bookingId,
    required this.userId,
    required this.matchId,
    required this.matchName,
    required this.matchDateTime,
    required this.bookingTime,
    required this.status,

    required this.totalAmount,
  });

  factory DetailBookingModel.fromJson(Map<String, dynamic> json) {
    return DetailBookingModel(
      bookingId: json['bookingId'],
      userId: json['userId'],
      matchId: json['matchId'],
      matchName: json['matchName'],
      matchDateTime: DateTime.parse(json['matchDateTime']),
      bookingTime: DateTime.parse(json['bookingTime']),
      status: json['status'],

      totalAmount: json['totalAmount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'matchId': matchId,
      'matchName': matchName,
      'matchDateTime': matchDateTime,
      'bookingTime': bookingTime,
      'status': status,
      'totalAmount': totalAmount,
    };
  }

  String get matchDate => DateFormat('dd/MM').format(matchDateTime.toLocal());
  String get matchDateMY =>
      DateFormat('dd/MM/yyyy').format(matchDateTime.toLocal());

  String get matchTime => DateFormat('HH:mm').format(matchDateTime.toLocal());
}
