import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app_colors.dart';

class BgHomeWidget extends StatelessWidget {
  final String title;
  final bool isTitle;
  final bool isArrow;

  BgHomeWidget({
    this.title = "",
    this.isTitle = false,
    this.isArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25.r),
          bottomLeft: Radius.circular(25.r),
        ),
      ),
      child: isTitle
          ? Row(
              children: [
                SizedBox(width: 15.w),
                if (isArrow) // ✅ عرض السهم فقط إذا كانت isArrow = true
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                if (!isArrow)
                  SizedBox(width: 24.w), // مكان بديل إذا لا يوجد سهم
                Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                    fontSize: 25.sp,
                  ),
                ),
                Spacer(flex: 2),
              ],
            )
          : Image.asset('assets/images/logo.png', scale: 3),
    );
  }
}
