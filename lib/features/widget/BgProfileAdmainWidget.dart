import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../admain/Profile/widget/MenuWidget.dart';

class BgProfileAdmainWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final bool isArrow;
  BgProfileAdmainWidget(this.onTap, this.image, this.isArrow);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MenuWidget(onTap, isArrow),
        Positioned(
          top: 80.h,
          left: 0,
          right: 0,
          child: Center(
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(image),
              //  child: Icon(Icons.person, size: 40.sp, color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
