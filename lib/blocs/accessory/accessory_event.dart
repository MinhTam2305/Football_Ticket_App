import 'package:equatable/equatable.dart';

class AccessoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadListAccessoryEvent extends AccessoryEvent {
  final String token;
  LoadListAccessoryEvent(this.token);

  @override
  List<Object?> get props => [ token];
}
