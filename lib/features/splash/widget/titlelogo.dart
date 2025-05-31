import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TitleLogo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: 50.h,
      width: 200.w,
    );
  }

}