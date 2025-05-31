import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/app_colors.dart';

class MenuWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool isArrow;

  MenuWidget(this.onTap, this.isArrow);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 130.h,
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25.r),
              bottomLeft: Radius.circular(25.r),
            ),
          ),
          child: isArrow
              ? Container(
                  height: 130.h,
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 10.h),
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.white,
                      )))
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Spacer(),
                    SvgPicture.asset("assets/icons/menu_icon.svg"),
                    SizedBox(
                      width: 16.w,
                    )
                  ],
                )),
    );
  }
}
