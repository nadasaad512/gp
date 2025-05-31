import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/modules/category.dart';
import 'package:gp/features/user/products/ProductScreen.dart';
import '../../../../core/app_colors.dart';

class CategoriesWidget extends StatelessWidget {
  List<CategoryModel> category;
  CategoriesWidget({required this.category});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: category.length,
        separatorBuilder: (context, index) => SizedBox(
          width: 20.w,
        ),
        itemBuilder: (context, index) =>
            categoryItem(context, category[index].image, category[index].name),
      ),
    );
  }
}

Widget categoryItem(BuildContext context, String image, String name) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductScreen(name)),
      );
    },
    child: Column(
      children: [
        Container(
          height: 100.h,
          width: 120.w,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.primary, width: 1),
            borderRadius: BorderRadius.circular(12.r),
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
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
        SizedBox(height: 5.h),
        Text(name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            )),
      ],
    ),
  );
}
