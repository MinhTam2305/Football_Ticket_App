import 'package:equatable/equatable.dart';
import 'package:football_ticket/models/notice_model.dart';

class NotiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotifacationInitial extends NotiState {}

class LoadNotifacationLoading extends NotiState {}

class LoadNotifacationLoaded extends NotiState {
  final List<NoticeModel> notiList;
  LoadNotifacationLoaded(this.notiList);
  @override
  List<Object?> get props => [notiList];
}

class LoadNotifacationError extends NotiState {
  final String message;
  LoadNotifacationError(this.message);

  @override
  List<Object?> get props => [message];
}
