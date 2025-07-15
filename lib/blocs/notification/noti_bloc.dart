import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/notification/noti_event.dart';
import 'package:football_ticket/blocs/notification/noti_state.dart';
import 'package:football_ticket/repositories/noti_repository.dart';
import 'package:football_ticket/models/notice_model.dart';

class NotiBloc extends Bloc<NotiEvent, NotiState> {
  final NotiRepository _notiRepository;
  NotiBloc(this._notiRepository) : super(LoadNotifacationInitial()) {
    on<LoadNotiEvent>((event, emit) async {
      emit(LoadNotifacationLoading());
      try {
        final listNoti = await _notiRepository.getNotices();
        emit(LoadNotifacationLoaded(listNoti));
      } catch (e) {
        print(e.toString());
        emit(LoadNotifacationError(e.toString()));
      }
    });

    on<MarkAllAsOpenedEvent>((event, emit) async {
      if (state is LoadNotifacationLoaded) {
        final currentList = List<NoticeModel>.from(
          (state as LoadNotifacationLoaded).notiList,
        );
        for (var noti in currentList) {
          noti.opened = true;
        }
        emit(LoadNotifacationLoaded(currentList));
      }
    });
  }
}
