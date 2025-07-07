import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/app_colors.dart';

class AddressWidget extends StatelessWidget {
  String address;
  String area;
  String city;
  String dec;
  String phone;
  bool isAdmin;
  AddressWidget(
      {required this.address,
      required this.area,
      required this.city,
      required this.dec,
      required this.phone,
      this.isAdmin = true});
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
          height: 10.h,
        ),
        InfoItem(phone, Icons.phone),
        SizedBox(
          height: 20.h,
        ),
        TextTitle("نبذة عنا :"),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Text(
            dec,
            style: TextStyle(fontSize: 16.sp, color: AppColors.black),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),

        // isAdmin == false
        //     ? Column(
        //         children: [
        //           Align(
        //             alignment: Alignment.topRight,
        //             child: Text(
        //               "      اطلب عبر الروشتة      ",
        //               style: TextStyle(
        //                 fontSize: 18.sp,
        //                 color: AppColors.primary,
        //                 fontWeight: FontWeight.w700,
        //               ),
        //             ),
        //           ),
        //           SizedBox(
        //             height: 20.h,
        //           ),
        //           GestureDetector(
        //               onTap: () => openWhatsApp(context),
        //               child:
        //                   Center(child: Image.asset("assets/images/prov.png"))),
        //           SizedBox(
        //             height: 20.h,
        //           ),
        //           Text(
        //             "أرفق صورة",
        //             style: TextStyle(
        //                 fontSize: 16.sp,
        //                 color: AppColors.primary,
        //                 fontWeight: FontWeight.w500),
        //           )
        //         ],
        //       )
        //     : SizedBox.shrink(),
        // isAdmin == false
        //     ? SizedBox(
        //         height: 20.h,
        //       )
        //     : SizedBox.shrink(),
        // isAdmin == false
        //     ? GestureDetector(
        //         onTap: () => openWhatsApp(context),
        //         child: Container(
        //           margin: EdgeInsets.symmetric(horizontal: 16.w),
        //           child: Text(
        //             "اسأل صيدلي ",
        //             style: TextStyle(
        //               fontSize: 18.sp,
        //               color: AppColors.primary,
        //               decoration: TextDecoration.underline,
        //               decorationColor: AppColors.primary,
        //               fontWeight: FontWeight.w700,
        //             ),
        //           ),
        //         ),
        //       )
        //     : SizedBox.shrink()
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

  Future<void> openWhatsApp(BuildContext context) async {
    final Uri url = Uri.parse("https://wa.me/972592310956");

    // جرب تفتح داخل التطبيق (WebView)
    bool success = await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    ).catchError((e) {
      print("فشل في WebView: $e");
      return false;
    });

    // إذا فشل داخليًا، جرب خارجيًا
    if (!success) {
      success = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      ).catchError((e) {
        print("فشل في التطبيق الخارجي: $e");
        return false;
      });
    }

    // إذا كل المحاولات فشلت
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تعذر فتح واتساب. تأكد أن التطبيق مثبت."),
        ),
      );
    }
  }

  // void openWhatsApp() async {
  //   final phoneNumber = '972592310956';

  //   final Uri url = Uri.parse("https://wa.me/$phoneNumber");

  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     print("لا يمكن فتح واتساب");
  //   }
  // }
}
