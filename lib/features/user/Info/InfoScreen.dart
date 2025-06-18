import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gp/date/Provider/auth_provider.dart';
import 'package:gp/date/Service/auth_service.dart';
import 'package:gp/features/splash/widget/choosetypewidget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_colors.dart';
import '../Home/widget/BgHomeWidget.dart';

class InfoScreen extends StatelessWidget {
  final List<InfoItem> items = [
    InfoItem("عن التطبيق", 'assets/icons/about_icon.svg'),
    InfoItem("مشاركة التطبيق", 'assets/icons/share_icon.svg', isShare: true),
    InfoItem("قم بتقييم التطبيق", 'assets/icons/star_icon.svg', isRate: true),
    InfoItem("المساعدة والدعم", 'assets/icons/support_icon.svg'),
    InfoItem("الشروط والاحكام", 'assets/icons/condition_icon.svg'),
    InfoItem("سياسة الخصوصية", 'assets/icons/privecy_icon.svg'),
    InfoItem('تسجيل الخروج', 'assets/logout.svg', isLogout: true),
    InfoItem('حذف الحساب', 'assets/delete.svg', isDelete: true),
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
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final item = items[index];
                return _InfoItem(context, item.name, item.icon,
                    isLogout: item.isLogout,
                    isDelete: item.isDelete,
                    isShare: item.isShare,
                    isRate: item.isRate);
              },
            ),
          ),
        ],
      ),
    );
  }

  void shareLink() {
    // SharePlus.instance
    //     .share(ShareParams(text: 'check out my website https://example.com'));
  }

  Widget _InfoItem(
    BuildContext context,
    String name,
    String image, {
    bool isLogout = false,
    bool isDelete = false,
    bool isShare = false,
    bool isRate = false,
  }) {
    return GestureDetector(
      onTap: () async {
        if (isLogout == true) {
          await Provider.of<AuthProvider>(context, listen: false)
              .logout(context);
        } else if (isShare == true) {
          shareLink();
        } else if (isRate == true) {
          await launchUrl(
            Uri.parse("https://example.com"),
            mode: LaunchMode.inAppWebView,
          );
        } else if (isDelete == true) {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('تأكيد الحذف'),
              content: Text(
                'هل أنت متأكد من حذف بيانات المستخدم؟ لا يمكن التراجع عن هذا الإجراء.',
              ),
              actions: [
                TextButton(
                  child: Text('إلغاء', style: TextStyle(color: Colors.black)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  child: Text('حذف', style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );

          if (confirmed != true) return;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );

          String? result = await AuthService().deleteUserData();

          Navigator.of(context).pop(); // إغلاق مؤشر التحميل

          if (result == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم حذف بيانات المستخدم بنجاح')),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChooseTypeWidget()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result)),
            );
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Row(
          children: [
            if (isLogout == true)
              Icon(Icons.logout, color: Colors.red)
            else if (isDelete == true)
              Icon(Icons.delete, color: Colors.red)
            else
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
      ),
    );
  }

  // void shareApp() {
  //   Share.share(
  //     'جرب هذا التطبيق الرائع: https://play.google.com/store/apps/details?id=com.example.yourapp',
  //     subject: 'تطبيق رائع!',
  //   );
  // }
}

class InfoItem {
  final String name;
  final String icon;
  final bool isLogout;
  final bool isDelete;
  final bool isShare;
  final bool isRate;

  InfoItem(
    this.name,
    this.icon, {
    this.isLogout = false,
    this.isDelete = false,
    this.isShare = false,
    this.isRate = false,
  });
}
