import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrentUserRequested extends AuthEvent {}

class SendOtpRequetsed extends AuthEvent {
  final String phoneNumber;
  final bool isForgotPassword;
  SendOtpRequetsed(this.phoneNumber, this.isForgotPassword);

  @override
  List<Object?> get props => [phoneNumber, isForgotPassword];
}

class VerifyOtpRequested extends AuthEvent {
  final String smsCode;
  final String verificationId;
  final String? name;
  final String? phone;
  final String? password;

  VerifyOtpRequested(
    this.smsCode,
    this.verificationId,
    this.name,
    this.phone,
    this.password,
  );

  @override
  List<Object?> get props => [smsCode, verificationId, name, phone, password];
}

class VerifyForgetPasswordOtpRequested extends AuthEvent {
  final String otp;
  final String verificationId;
  VerifyForgetPasswordOtpRequested(this.otp, this.verificationId);

  @override
  List<Object?> get props => [otp, verificationId];
}

class OtpSentEvent extends AuthEvent {
  final String verificationId;
  OtpSentEvent(this.verificationId);
  @override
  List<Object?> get props => [verificationId];
}

class Login extends AuthEvent {
  final String phoneNumber;
  final String password;

  Login(this.phoneNumber, this.password);

  @override
  List<Object?> get props => [phoneNumber, password];
}

class GetUserById extends AuthEvent {
  final String id;
  final String token;
  GetUserById(this.id, this.token);
  @override
  List<Object?> get props => [id, token];
}

class ResetPassword extends AuthEvent {
  final String phoneNumber;
  final String newPassord;
  ResetPassword(this.phoneNumber, this.newPassord);

  @override
  List<Object?> get props => [phoneNumber, newPassord];
}
