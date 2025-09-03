import 'package:equatable/equatable.dart';
import 'package:football_ticket/models/accessory_model.dart';

class AccessoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ListAccessoryInitial extends AccessoryState {}

class ListAccessoryLoading extends AccessoryState {}

class ListAccessoryLoaded extends AccessoryState {
  final List<AccessoryModel>? listAccessory;
  ListAccessoryLoaded(this.listAccessory);
  @override
  List<Object?> get props => [listAccessory];
}

class ListAccessoryError extends AccessoryState {
  final String message;
  ListAccessoryError(this.message);
  @override
  List<Object?> get props => [message];
}
