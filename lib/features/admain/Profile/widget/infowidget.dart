import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/app_colors.dart';

class AddressWidget extends StatelessWidget {
  String address;
  String area;
  String city;
  String dec;
  AddressWidget(
      {required this.address,
      required this.area,
      required this.city,
      required this.dec});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.h,
        ),
        InfoItem(city + " " + area, Icons.location_on),
        SizedBox(
          height: 10.h,
        ),
        InfoItem(address, Icons.location_on),
        SizedBox(
          height: 30.h,
        ),
        TextTitle("نبذة عنا :"),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Text(
            dec,
            style: TextStyle(fontSize: 16.sp, color: AppColors.black),
          ),
        ),
      ],
    );
  }

  Widget InfoItem(String name, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          SizedBox(
            width: 10.w,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 16.sp, color: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget TextTitle(String name) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          name,
          style: TextStyle(
            fontSize: 20.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
