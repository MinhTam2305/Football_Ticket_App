import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:dio/io.dart';
import 'package:football_ticket/repositories/api_client.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Dio _dio = ApiClient.instance;

  //Send opt
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+84$phoneNumber",
      verificationCompleted: (credential) {},
      verificationFailed: (e) => onError(e.message ?? "OTP Fialed"),
      codeSent: (verificationId, _) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<UserModel> verifyOtp({
    required String verificationId,
    required String smsCode,
    String? name,
    String? phone,
    String? password,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-verification-code':
          throw Exception("Mã OTP không chính xác.");
        case 'session-expired':
          throw Exception("Mã OTP đã hết hạn. Vui lòng gửi lại mã.");
        default:
          throw Exception("Xác minh OTP thất bại: ${e.message}");
      }
    }

    final uid = _auth.currentUser?.uid;
    final phoneNumber = _auth.currentUser?.phoneNumber;

    if (uid == null) {
      throw Exception("No uid");
    }
    if (name != null || phone != null || password != null) {
      try {
        final response = await _dio.post(
          'auth/register-mobile',
          data: {
            'PhoneNumber': phone,
            'Password': password,
            'FullName': name,
            'Id': "0291",
          },
        );
        if (response.statusCode == 200) {
          return UserModel(uid: response.data['userId']);
        } else if (response.statusCode == 400) {
          throw Exception('Số điện thoại đã được đăng ký');
        }
      } on DioException catch (e) {
        final errorMsg =
            e.response?.data['message'] ?? 'Lỗi không xác định từ server';
        throw Exception(errorMsg);
      } catch (e) {
        throw "Error $e";
      }
    }

    return UserModel(uid: uid, phoneNumber: phoneNumber!);
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    try {
      final response = await _dio.post(
        'auth/check-phone',
        data: {'phoneNumber': phoneNumber},
      );
      if (response.statusCode == 200) {
        bool isExists = response.data['exists'];
        return isExists;
      }
      throw Exception(response.data['message']);
    } catch (e) {
      if (e is DioException) {
        final message =
            e.response?.data['message'] ?? 'Không thể kiểm tra số điện thoại';
        throw Exception(message);
      } else {
        throw Exception("Lỗi không xác định: $e");
      }
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final response = await _dio.post(
        'auth/login',
        data: {'phoneNumber': phone, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errors = e.response?.data['errors'];
        final errorMsg = errors?.entries
            .map((e) => "${e.key}: ${e.value.join(', ')}")
            .join('\n');
        throw Exception(errorMsg ?? "Yêu cầu không hợp lệ");
      } else {
        throw Exception("Lỗi không xác định");
      }
    }
  }

  Future<UserModel> getUserFromDB(String id, String token) async {
    try {
      final response = await _dio.get(
        'auth/user/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw "No user";
      }
    } catch (e) {
      throw "Error: $e";
    }
  }

  Future<String> resetPassword(String phone, String newPassword) async {
    try {
      final response = await _dio.post(
        'auth/reset-password',
        data: {"PhoneNumber": phone, "newPassword": newPassword},
      );
      if (response.statusCode == 200) {
        return response.data['message'];
      }
      return response.data['message'] ?? 'Có lỗi xảy ra';
    } catch (e) {
      throw Exception("Reset mật khẩu thất bại: $e");
    }
  }
}
