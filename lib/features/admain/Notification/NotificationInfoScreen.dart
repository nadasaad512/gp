import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/core/text_styles.dart';
import 'package:gp/date/Provider/AdminProvider.dart';
import 'package:gp/date/modules/notification.dart';
import 'package:gp/features/user/Home/widget/BgHomeWidget.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationInfoScreen extends StatefulWidget {
  final NotificationModel notification;
  NotificationInfoScreen({required this.notification});

  @override
  State<NotificationInfoScreen> createState() => _NotificationInfoScreenState();
}

class _NotificationInfoScreenState extends State<NotificationInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              BgHomeWidget(
                isTitle: true,
                title: "الاشعارات",
                isArrow: true,
              ),
              SizedBox(height: 10.h),
              CircleAvatar(
                radius: 50.sp,
                backgroundColor: Colors.grey.shade100,
                child: Icon(Icons.person),
              ),
              SizedBox(height: 10.h),
              Text(
                widget.notification.nameUser,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
              ),
              SizedBox(height: 50.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "     المنتجات المطلوبة:    ",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ...widget.notification.products.map(
                    (p) {
                      int quantity = 1;
                      int price = 1;
                      try {
                        quantity = int.parse(p.countProduct.toString().trim());
                        price = int.parse(p.price.toString().trim());
                        print("q${quantity}");
                        print("p${price}");
                      } catch (e) {
                        quantity = 1;
                      }

                      final totalPrice = price * quantity;

                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Text(
                              "${p.nameProduct}  $quantity",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "$totalPrice شيكل",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "    العنوان:  ",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "    ${widget.notification.addressUser}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        String message = generateMessage(widget.notification);
                        openWhatsApp(message);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: Text(
                        'ارسال الى مندوب التوصيل',
                        style: AppTextStyles.loginbutton,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void openWhatsApp(String message) async {
    final phoneNumber = '972598361985';
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://wa.me/$phoneNumber?text=$encodedMessage';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("لا يمكن فتح واتساب");
    }
  }

  String generateMessage(NotificationModel notification) {
    StringBuffer buffer = StringBuffer();

    buffer.writeln("🧾 *طلب جديد من العميل:*");
    buffer.writeln("👤 الاسم: ${notification.nameUser}");
    buffer.writeln("\n📦 *المنتجات المطلوبة:*");

    for (var product in notification.products) {
      int quantity = 1;
      try {
        quantity = int.parse(product.countProduct.toString().trim());
      } catch (e) {
        quantity = 1;
      }
      buffer.writeln(
          "- ${product.nameProduct} (العدد: $quantity) - السعر: ${product.price} شيكل");
    }

    buffer.writeln("\n📍 *العنوان:*");
    buffer.writeln(notification.addressUser);

    return buffer.toString();
  }
}
