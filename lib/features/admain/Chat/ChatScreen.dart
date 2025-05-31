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
            onTap: openWhatsApp,
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

  void openWhatsApp() async {
    final phoneNumber = '972592310956';

    final Uri url = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("لا يمكن فتح واتساب");
    }
  }
}
