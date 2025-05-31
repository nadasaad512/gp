import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/text_styles.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade500,
          labelStyle: AppTextStyles.tap,
          indicator: BoxDecoration(),
          tabs: const [
            Tab(text: "تسجيل الدخول"),
            Tab(text: "إنشاء حساب"),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            AnimatedBuilder(
              animation: tabController.animation!,
              builder: (context, child) {
                int index = tabController.index;
                double alignX = index == 0
                    ? 0.98
                    : -0.98;

                return Align(
                  alignment: Alignment(alignX, 0),
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
