import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrentUserRequested extends AuthEvent {}
class SendOtpRequetsed extends AuthEvent {
  final String phoneNumber;
  SendOtpRequetsed(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpRequested extends AuthEvent {
  final String smsCode;
  final String verificationId;
  VerifyOtpRequested(this.smsCode, this.verificationId);

  @override
  List<Object?> get props => [smsCode, verificationId];
}

class VerifyForgetPasswordOtpRequested extends AuthEvent {
  final String otp;
  final String verificationId;
  VerifyForgetPasswordOtpRequested( this.otp,  this.verificationId);

   @override
  List<Object?> get props => [otp, verificationId];
}

class OtpSentEvent extends AuthEvent {
  final String verificationId;
  OtpSentEvent(this.verificationId);
  @override
  List<Object?> get props => [verificationId];
}

class Login extends AuthEvent{
  final String phoneNumber;
  final String password;

  Login (this.phoneNumber,this.password);

  @override
  List<Object?> get props => [phoneNumber,password];
}
