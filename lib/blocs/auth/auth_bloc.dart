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
  }

  Future<void> _sendOpt(SendOtpRequetsed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    await _authRepo.sendOtp(
      phoneNumber: event.phoneNumber,
      codeSent: (id) {
        add(OtpSentEvent(id));
      },
      onErorr: (err) async {
        if (!emit.isDone) emit(AuthFailure(err));
      },
    );
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
      );

      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure("Verify Fail"));
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
          UserModel(uid: user.uid, phoneNumber: user.phoneNumber),
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
        emit(AuthSuccess(UserModel(uid: event.phoneNumber,)));
      } else {
        emit(AuthFailure(response['message'] ?? "Đăng nhập thất bại"));
      }
    } catch (e) {
      print("Login error: $e");
      emit(AuthFailure(e.toString()));
    }
  }
}
