import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../user/Home/widget/BgHomeWidget.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BgHomeWidget(),
          SizedBox(height: 200.h),
          GestureDetector(
            onTap: () => openWhatsApp(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/chat.png",
                  scale: 2,
                ),
                SizedBox(height: 30.h),
                Text(
                  'تواصل معنا لخدمتك',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openWhatsApp(BuildContext context) async {
    final Uri url = Uri.parse("https://wa.me/972599697166");

    // جربي مباشرة فتح التطبيق الخارجي
    bool success = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    ).catchError((e) {
      print("فشل في التطبيق الخارجي: $e");
      return false;
    });

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تعذر فتح واتساب. تأكد أن التطبيق مثبت."),
        ),
      );
    }
  }
}
