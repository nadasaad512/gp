import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';

class CardInfoWidget extends StatelessWidget {
  String name;
  String image;
  VoidCallback? onTap;

  CardInfoWidget({required this.image, required this.name, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 90.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ))
        ],
      ),
    );
  }
}
