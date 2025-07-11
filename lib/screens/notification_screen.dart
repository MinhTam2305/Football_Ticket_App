import 'package:flutter/material.dart';
import 'package:football_ticket/core/constants/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Your notice', style: AppTextStyles.title1),
        backgroundColor: AppColors.background,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        width: double.infinity,
        height: MediaQuery.of(context).size.height - 150,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Card(
                  elevation: 5,
                  color: const Color.fromARGB(255, 243, 243, 243),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Đặt vé thành công', style: AppTextStyles.body1),
                        Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          'Xin chúc mừng bạn đã đặt vé thành công trận đấu giữa Becamex Bình Dương và Sông Lam Nghệ An',
                          style: AppTextStyles.body2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 100,
                child: Card(
                  elevation: 5,
                  color: const Color.fromARGB(255, 243, 243, 243),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trận đấu sắp diễn ra',
                          style: AppTextStyles.body1,
                        ),
                        Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          'Becamex Bình Dương và Sông Lam Nghệ An đang được mở bán vé',
                          style: AppTextStyles.body2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Card(
                  elevation: 5,
                  color: const Color.fromARGB(255, 243, 243, 243),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kết quả thi đấu giải V-league 2025',
                          style: AppTextStyles.body1,
                        ),
                        Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          'Click để xem chi tiết kết quả của các trận đấu đã diễn ra, Click để xem chi tiết kết quả của các trận đấu đã diễn ra,Click để xem chi tiết kết quả của các trận đấu đã diễn ra,Click để xem chi tiết kết quả của các trận đấu đã diễn ra',
                          style: AppTextStyles.body2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 100,
                child: Card(
                  elevation: 1,
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Đặt vé thành công', style: AppTextStyles.body1),
                        Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          'Xin chúc mừng bạn đã đặt vé thành công trận đấu giữa Becamex Bình Dương và Sông Lam Nghệ An',
                          style: AppTextStyles.body2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 100,
                child: Card(
                  elevation: 1,
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trận đấu sắp diễn ra',
                          style: AppTextStyles.body1,
                        ),
                        Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          'Becamex Bình Dương và Sông Lam Nghệ An đang được mở bán vé',
                          style: AppTextStyles.body2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Card(
                  elevation: 1,
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kết quả thi đấu giải V-league 2025',
                          style: AppTextStyles.body1,
                        ),
                        Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          'Click để xem chi tiết kết quả của các trận đấu đã diễn ra, Click để xem chi tiết kết quả của các trận đấu đã diễn ra,Click để xem chi tiết kết quả của các trận đấu đã diễn ra,Click để xem chi tiết kết quả của các trận đấu đã diễn ra',
                          style: AppTextStyles.body2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
