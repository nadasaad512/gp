import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/Provider/AdminProvider.dart';
import 'package:gp/features/admain/Chat/ChatScreen.dart';
import 'package:gp/features/admain/Notification/NotificationScreen.dart';
import 'package:gp/features/user/main/widget/buildTabIconwidget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../AHomeScreen/AHomeScreen.dart';
import '../Profile/ProfileScreen.dart';

class AdmainMainScreen extends StatefulWidget {
  @override
  _AdmainMainScreenState createState() => _AdmainMainScreenState();
}

class _AdmainMainScreenState extends State<AdmainMainScreen> {
  int _selectedIndex = 1;

  final List<Widget> _screens = [
    AdmainProfileScreen(),
    AHomeScreen(),
    NotificationScreen(),
    ChatScreen(),
  ];

  final List<String> icons = [
    'assets/icons/profileA_icon.svg',
    'assets/icons/home_icon.svg',
    'assets/icons/notifi_icon.svg',
    'assets/icons/chat_icon.svg',
  ];
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AdminProvider>(context, listen: false).fetchNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(icons.length, (index) {
            bool showBadge = false;
            int unseenCount = 0;

            if (index == 2) {
              final adminProvider = Provider.of<AdminProvider>(context);
              unseenCount = adminProvider.notification
                  .where((notif) => !notif.isSeen)
                  .length;
              showBadge = unseenCount > 0;
            }

            return SizedBox(
              width: 90.w,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  BuildTabIconWidget(
                    index: index,
                    icons: icons,
                    isSelected: _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                  if (showBadge)
                    Positioned(
                      top: 6,
                      right: 20,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            unseenCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
