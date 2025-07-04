import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {}

class BookingFailure extends BookingState {
  final String message;

  BookingFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
