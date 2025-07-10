import 'package:dio/dio.dart';
import 'package:football_ticket/models/detail_booking_model.dart';
import 'package:football_ticket/models/qrScanResponseModel.dart';
import 'package:football_ticket/repositories/api_client.dart';

class BookingDetailsRepository {
  final _dio = ApiClient.instance;

  Future<DetailBookingModel> LoadBookingById(
    String bookingId,
    String token,
  ) async {
    try {
      final response = await _dio.get(
        'bookingApi/ticket/$bookingId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return DetailBookingModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load booking details');
      }
    } catch (e) {
      throw Exception('Failed to load booking details: $e');
    }
  }

  Future<QrScanResponseModel> scanQr(String ticketId, String token) async {
    try {
      final response = await _dio.post(
        'QrTicketStatusApi/scan-qr',
        // options: Options(headers: {'Content-Type': 'application/json'}),
        data: {'ticketId': ticketId},
      );
      final data = response.data;
      if (data['message'] == "Vé không tồn tại") {
        throw Exception(data['message']);
      }
      return QrScanResponseModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }
}
