import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:football_ticket/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio _dio = Dio(BaseOptions(baseUrl: ""));

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
}
