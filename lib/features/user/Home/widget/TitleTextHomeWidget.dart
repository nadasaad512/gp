import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/app_colors.dart';

class TitleTextHomeWidget extends StatelessWidget{
  String title;
  TitleTextHomeWidget({required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),

        Text(
          "إظهار الكل",
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 1,
            decorationColor: AppColors.primary,

            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.primary,
          ),
        )
      ],
    );
  }

}