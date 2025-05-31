import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/features/admain/Chat/ChatScreen.dart';
import 'package:gp/features/admain/Notification/NotificationScreen.dart';

import '../../../core/app_colors.dart';
import '../../user/main/widget/buildTabIconwidget.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(icons.length, (index) {
            return SizedBox(
              width: 90.w,
              child: BuildTabIconWidget(
                index: index,
                icons: icons,
                isSelected: _selectedIndex == index,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
