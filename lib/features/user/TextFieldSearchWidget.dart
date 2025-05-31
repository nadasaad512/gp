


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';

class TextFieldSearchWidget extends StatefulWidget {
  @override
  State<TextFieldSearchWidget> createState() => _TextFieldSearchWidgetState();
}

class _TextFieldSearchWidgetState extends State<TextFieldSearchWidget> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: TextField(
        decoration: InputDecoration(
          hintText: ' بحث....',
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
            color:AppColors.primary
          ),
          suffixIcon: Icon(Icons.search,size: 20.sp,  color:AppColors.primary),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
            borderRadius: BorderRadius.circular(19),
          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
            borderRadius: BorderRadius.circular(19),
          ),
        ),
      ),
    );
  }
}
