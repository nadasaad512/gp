import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/app_colors.dart';
import '../Home/widget/BgHomeWidget.dart';

class InfoScreen extends StatelessWidget {
  final List<InfoItem> items = [
    InfoItem("عن التطبيق", 'assets/icons/about_icon.svg'),
    InfoItem("مشاركة التطبيق", 'assets/icons/share_icon.svg'),
    InfoItem("قم بتقييم التطبيق", 'assets/icons/star_icon.svg'),
    InfoItem("المساعدة والدعم", 'assets/icons/support_icon.svg'),
    InfoItem("الشروط والاحكام", 'assets/icons/condition_icon.svg'),
    InfoItem("سياسة الخصوصية", 'assets/icons/privecy_icon.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BgHomeWidget(),
          SizedBox(
            height: 700.h,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                return _InfoItem(items[index].name, items[index].icon);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _InfoItem(String name, String image) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 24.w,vertical: 10.h),
    child: Row(
      children: [
        SvgPicture.asset(image),
        SizedBox(width: 16.w),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.black,
            fontSize: 15.sp,
          ),
        ),
      ],
    ),
  );
}

class InfoItem {
  final String name;
  final String icon;
  InfoItem(this.name, this.icon);
}
