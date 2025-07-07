import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ADD THIS
import '../../../../core/app_colors.dart';

class BuildTabIconWidget extends StatelessWidget {
  final int index;
  final List<String> icons;
  final bool isSelected;
  final VoidCallback onTap;
  final String title; // ⬅️ أضف هذا السطر

  const BuildTabIconWidget({
    Key? key,
    required this.index,
    required this.icons,
    required this.isSelected,
    required this.onTap,
    required this.title, // ⬅️ أضف هذا السطر
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Transform.translate(
            offset: isSelected ? Offset(0, -10.h) : Offset(0, 0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              height: 45.h,
              width: 45.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : AppColors.white,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : [],
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                icons[index],
                color: isSelected ? AppColors.white : AppColors.primary,
                height: 25.h,
                width: 25.w,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? AppColors.primary : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
