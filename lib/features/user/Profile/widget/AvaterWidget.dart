import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app_colors.dart';

class AvaterWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  return  Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: AppColors.primary,
        width: 1.0,
      ),
    ),
    child: CircleAvatar(
      radius: 50.sp,
      backgroundColor: AppColors.white,
      child: Icon(
        Icons.person,  // Example icon inside the CircleAvatar
        size: 40.0,  // Icon size
        color: AppColors.primary,  // Icon color
      ),
    ),
  );
  }

}