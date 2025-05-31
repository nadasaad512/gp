import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ADD THIS
import '../../../../core/app_colors.dart';

class BuildTabIconWidget extends StatelessWidget {
  final int index;
  final List<String> icons; // <-- Now List of String paths
  final bool isSelected;
  final VoidCallback onTap;

  const BuildTabIconWidget({
    Key? key,
    required this.index,
    required this.icons,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      hoverColor: AppColors.white,
      focusColor: AppColors.white,
      splashColor: AppColors.white,
      highlightColor: AppColors.white,
      child: Transform.translate(
        offset: isSelected ? Offset(0, -25.h) : Offset(0, 0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          height: 60.h,
          width: 60.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.primary : AppColors.white,
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.black12,
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
    );
  }
}
