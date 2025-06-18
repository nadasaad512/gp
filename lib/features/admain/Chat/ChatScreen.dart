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
                TextButton(onPressed: openWhatsApp2, child: Text("try 2")),
                TextButton(onPressed: openWhatsApp3, child: Text("try 3")),
                TextButton(onPressed: openWhatsApp4, child: Text("try 4")),
                TextButton(onPressed: openWhatsApp5, child: Text("try 5")),
                TextButton(onPressed: openWhatsApp6, child: Text("try 6")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void openWhatsApp() async {
  //   final phoneNumber = '972599697166';

  //   final Uri url = Uri.parse("https://wa.me/$phoneNumber");

  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //     //await launchUrl(url, mode: LaunchMode.platformDefault);

  //   } else {
  //     print("لا يمكن فتح واتساب");
  //   }
  // }

  void openWhatsApp() async {
    final phoneNumber = '972599697166';
    final url = 'https://wa.me/$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("لا يمكن فتح واتساب");
    }
  }

  void openWhatsApp2() async {
    final phoneNumber = '972599697166';
    final Uri url = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // ← مهم جدًا لواتساب
      );
    } else {
      print("لا يمكن فتح واتساب");
    }
  }

  void openWhatsApp3() async {
    final phoneNumber = '972599697166';
    final Uri url = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView, // ← مهم جدًا لواتساب
      );
    } else {
      print("لا يمكن فتح واتساب");
    }
  }

  void openWhatsApp4() async {
    final phoneNumber = '972599697166';
    final Uri url = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication, // ← مهم جدًا لواتساب
      );
    } else {
      print("لا يمكن فتح واتساب");
    }
  }

  void openWhatsApp5() async {
    final phoneNumber = '972599697166';
    final Uri url = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.platformDefault, // ← مهم جدًا لواتساب
      );
    } else {
      print("لا يمكن فتح واتساب");
    }
  }

  void openWhatsApp6() async {
    final phoneNumber = '972599697166';
    final Uri url = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppBrowserView, // ← مهم جدًا لواتساب
      );
    } else {
      print("لا يمكن فتح واتساب");
    }
  }
}
