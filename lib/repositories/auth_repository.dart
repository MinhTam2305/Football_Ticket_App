import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:dio/io.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Dio _dio;

  AuthRepository()
    : _dio = Dio(BaseOptions(baseUrl: "https://10.0.2.2:7023/api/")) {
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  //Send opt
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) onErorr,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+84$phoneNumber",
      verificationCompleted: (credential) {},
      verificationFailed: (e) => onErorr(e.message ?? "OTP Fialed"),
      codeSent: (verificationId, _) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<UserModel> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await _auth.signInWithCredential(credential);

    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      throw Exception("No uid");
    }

    // final response = await _dio.post(
    //   'user/post',data: {'uid':uid},
    // );

    return UserModel(uid: uid);
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
}
