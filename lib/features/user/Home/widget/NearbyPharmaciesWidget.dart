import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/modules/admain_user.dart';
import 'package:gp/features/user/showProfileAdmin.dart';
import '../../../../core/app_colors.dart';

class NearbyPharmaciesWidget extends StatelessWidget {
  List<AdminUser> nearbyPharmac;
  NearbyPharmaciesWidget({required this.nearbyPharmac});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: nearbyPharmac.length,
        itemBuilder: (BuildContext, index) {
          return _pharmacyItem(context, nearbyPharmac[index].image,
              nearbyPharmac[index].name, nearbyPharmac[index].uid);
        },
        separatorBuilder: (BuildContext, index) {
          return SizedBox(width: 20.w);
        },
      ),
    );
  }
}

Widget _pharmacyItem(BuildContext context, image, String name, String id) {
  return Column(
    children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => showProfileAdmin(
                      idAdmin: id,
                    )),
          );
        },
        child: Container(
          height: 100.h,
          width: 120.w,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.primary, width: 1),
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 5.h),
      Text(
        name,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    ],
  );
}
