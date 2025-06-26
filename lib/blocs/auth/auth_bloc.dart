import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/auth/auth_event.dart';
import 'package:football_ticket/blocs/auth/auth_state.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepo;

  AuthBloc(this._authRepo) : super(AuthInitial()) {
    on<SendOtpRequetsed>(_sendOpt);
    on<VerifyOtpRequested>(_verifyOpt);
    on<VerifyForgetPasswordOtpRequested>(_verifyForgetPasswordOtp);
    on<OtpSentEvent>((event, emit) => emit(OtpSent(event.verificationId)));
    on<GetCurrentUserRequested>(_getUser);
    on<Login>(_login);
    on<GetUserById>(_getUserFromDb);
    on<ResetPassword>(_resetPassword);
  }

  Future<void> _sendOpt(SendOtpRequetsed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final phone = event.phoneNumber.replaceFirst('+84', '0');

    try {
      final isExists = await _authRepo.checkPhoneNumber(phone);
      if (event.isForgotPassword) {
        if (isExists) {
          await _authRepo.sendOtp(
            phoneNumber: event.phoneNumber,
            codeSent: (id) {
              add(OtpSentEvent(id));
            },
            onError: (err) async {
              if (!emit.isDone) emit(AuthFailure(err));
            },
          );
          emit(OptSentSuccessed());
        } else {
          emit(AuthFailure("Số điện thoại này không tồn tại"));
        }
      } else {
        if (!isExists) {
          await _authRepo.sendOtp(
            phoneNumber: event.phoneNumber,
            codeSent: (id) {
              add(OtpSentEvent(id));
            },
            onError: (err) async {
              if (!emit.isDone) emit(AuthFailure(err));
            },
          );
           emit(OptSentSuccessed());
        } else {
          emit(AuthFailure("Số điện thoại này đã được đăng ký."));
        }
      }
    } catch (e) {
      emit(AuthFailure("Lỗi: $e"));
    }
  }

  Future<void> _verifyOpt(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.verifyOtp(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
        name: event.name,
        phone: event.phone,
        password: event.password,
      );

      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure("Error $e"));
    }
  }

  Future<void> _verifyForgetPasswordOtp(
    VerifyForgetPasswordOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.verifyOtp(
        verificationId: event.verificationId,
        smsCode: event.otp,
      );

      emit(VerifySuccess(user));
    } catch (e) {
      emit(AuthFailure("Verify Fail"));
    }
  }

  Future<void> _getUser(
    GetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authRepo.getCurrentUser();
    if (user != null) {
      emit(
        CurrentUserLoaded(
          UserModel(uid: user.uid, phoneNumber: user.phoneNumber!),
        ),
      );
    } else {
      emit(AuthFailure("No user logged in"));
    }
  }

  Future<void> _login(Login event, Emitter<AuthState> emit) async {
    print("Login event received");
    emit(AuthLoading());
    try {
      final response = await _authRepo.login(event.phoneNumber, event.password);
      print("Login response: $response");
      if (response["success"] == true) {
        final String id = response["data"]['id'];
        final String token = response["data"]['token'];
        emit(TokenRetrieved(id));
        add(GetUserById(id, token));
      } else {
        emit(AuthFailure(response['message'] ?? "Đăng nhập thất bại"));
      }
    } catch (e) {
      print("Login error: $e");
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _getUserFromDb(
    GetUserById event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authRepo.getUserFromDB(event.id, event.token);
      emit(Logined(user));
    } catch (e) {
      emit(AuthFailure("Không lấy được thông tin người dùng: $e"));
    }
  }

  Future<void> _resetPassword(
    ResetPassword evet,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      String message = await _authRepo.resetPassword(
        evet.phoneNumber,
        evet.newPassord,
      );

      emit(RestPasswordSuccessed(message));
    } catch (e) {
      emit(AuthFailure("$e"));
    }
  }
}
