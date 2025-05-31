import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';

class titleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'قم بإضافة الأقسام المتوفرة في صيدليتك',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 5),
          Text(
            'مثل: مسكنات، أدوية أمراض مزمنة، منتجات غالية بالثمن ...',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
