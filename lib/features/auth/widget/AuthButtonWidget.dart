import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';

class AuthButtonWidget extends StatelessWidget {
  String title;
  final VoidCallback onPressed;



  AuthButtonWidget({required this.title,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 192.w,
      height: 47.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 3,
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
