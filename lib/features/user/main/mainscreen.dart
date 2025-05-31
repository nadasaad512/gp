import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/features/user/main/widget/buildTabIconwidget.dart';

import '../../../core/app_colors.dart';
import '../Cart/CartScreen.dart';
import '../Home/HomeScreen.dart';
import '../Info/InfoScreen.dart';
import '../Profile/ProfileScreen.dart';
import '../Request/RequestScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;

  final List<Widget> _screens = [
    CartScreen(),
    RequestScreen(),
    HomeScreen(),
    ProfileScreen(),
    InfoScreen(),
  ];

  final List<String> icons = [
    'assets/icons/cart_icon.svg',
    'assets/icons/request_icon.svg',
    'assets/icons/home_icon.svg',
    'assets/icons/profile_icon.svg',
    'assets/icons/info_icon.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: Row(
          children: List.generate(icons.length, (index) {
            return SizedBox(
              width: 70.w,
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
