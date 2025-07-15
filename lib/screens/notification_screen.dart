import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/notification/noti_bloc.dart';
import 'package:football_ticket/blocs/notification/noti_event.dart';
import 'package:football_ticket/blocs/notification/noti_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/widgets/notice_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void dispose() {
    context.read<NotiBloc>().add(MarkAllAsOpenedEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Your notice', style: AppTextStyles.title1),
        backgroundColor: AppColors.background,
      ),
      body: BlocBuilder<NotiBloc, NotiState>(
        builder: (context, state) {
          if (state is LoadNotifacationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadNotifacationLoaded) {
            return state.notiList.isNotEmpty
                ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 150,
                  child: ListView.builder(
                    itemCount: state.notiList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: NoticeCard(
                          title: state.notiList[index].title,
                          content: state.notiList[index].content,
                          isOpened: state.notiList[index].opened,
                        ),
                      );
                    },
                  ),
                )
                : Center(child: Text("Không có thông báo"));
          } else if (state is LoadNotifacationError) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text("Lỗi ${state.message}")));
          }
          return Container();
        },
      ),
    );
  }
}
