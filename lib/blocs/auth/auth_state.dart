import 'package:equatable/equatable.dart';
import 'package:football_ticket/models/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String verificationId;
  OtpSent(this.verificationId);
  @override
  List<Object?> get props => [verificationId];
}

class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class VerifySuccess extends AuthState{
  final UserModel user;
  VerifySuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CurrentUserLoaded extends AuthState{
  final UserModel currentUser;
  CurrentUserLoaded(this.currentUser);
}
