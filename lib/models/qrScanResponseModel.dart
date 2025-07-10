import 'package:football_ticket/models/ticketInfo_model.dart';
import 'package:intl/intl.dart';

class QrScanResponseModel {
  final String matchId;
  final String matchName;
  final DateTime matchDateTime;
  final String currentStatus;
  final DateTime statusChangedAt;
  final TicketInfoModel ticketInfo;

  QrScanResponseModel({
    required this.matchId,
    required this.matchName,
    required this.matchDateTime,
    required this.currentStatus,
    required this.statusChangedAt,
    required this.ticketInfo,
  });

  factory QrScanResponseModel.fromJson(Map<String, dynamic> json) {
    return QrScanResponseModel(
      matchId: json['matchId'],
      matchName: json['matchName'],
      matchDateTime: DateTime.parse(json['matchDateTime']),
      currentStatus: json['currentStatus'],
      statusChangedAt: DateTime.parse(json['statusChangedAt']),
      ticketInfo: TicketInfoModel.fromJson(json['ticketInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'matchName': matchName,
      'matchDateTime': matchDateTime.toIso8601String(),
      'currentStatus': currentStatus,
      'statusChangedAt': statusChangedAt.toIso8601String(),
      'ticketInfo': ticketInfo.toJson(),
    };
  }

    String get matchDate => DateFormat('dd/MM').format(matchDateTime.toLocal());
  String get matchDateMY =>
      DateFormat('dd/MM/yyyy').format(matchDateTime.toLocal());

  String get matchTime => DateFormat('HH:mm').format(matchDateTime.toLocal());
}
