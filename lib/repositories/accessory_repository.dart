// data/accessory_repository.dart
import 'package:dio/dio.dart';
import 'package:football_ticket/models/accessory_model.dart';
import 'package:football_ticket/repositories/api_client.dart';

class AccessoryRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<AccessoryModel>?> fetchAccessories({
    required String bearerToken,
  }) async {
    try {
      final resp = await _dio.get(
        'Accessory',
        options: Options(headers: {'Authorization': 'Bearer $bearerToken'}),
      );

      final data = resp.data;
      final rawList =
          data is Map<String, dynamic> ? (data['items'] as List) : data as List;

      final items =
          rawList
              .map((e) => AccessoryModel.fromJson(e as Map<String, dynamic>))
              .toList();
      return items;
    } on DioException catch (e) {
      final msg =
          e.response?.data is Map
              ? (e.response!.data['message'] ?? e.message).toString()
              : e.message ?? 'Network error';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
