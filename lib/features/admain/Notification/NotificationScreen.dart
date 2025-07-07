import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/Provider/AdminProvider.dart';
import 'package:gp/features/admain/Notification/NotificationInfoScreen.dart';
import 'package:gp/features/user/Home/widget/BgHomeWidget.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = true;
  late AdminProvider _adminProvider;

  @override
  void initState() {
    super.initState();
    // الحصول على المزود بدون استماع
    Future.microtask(() {
      _adminProvider = Provider.of<AdminProvider>(context, listen: false);
      _loadNotifications();
    });
  }

  @override
  void dispose() {
    _markAllNotificationsAsSeen();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    await _adminProvider.fetchNotification();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _markAllNotificationsAsSeen() async {
    final notifications = _adminProvider.notification;

    for (var notif in notifications) {
      if (!notif.isSeen) {
        await FirebaseFirestore.instance
            .collection('admin_users')
            .doc(notif.idAdmin)
            .collection('Notification')
            .doc(notif.id)
            .update({'isSeen': true});
      }
    }

    await _adminProvider.fetchNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        final notifications = adminProvider.notification
          ..sort(
              (a, b) => b.createdAt!.compareTo(a.createdAt!)); // ← هنا الترتيب

        return Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              BgHomeWidget(
                isTitle: true,
                title: "الاشعارات",
              ),
              _isLoading
                  ? Expanded(child: Center(child: loadingWidget()))
                  : notifications.isEmpty
                      ? Expanded(
                          child: Center(child: Text("لا توجد إشعارات حالياً")))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notif = notifications[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationInfoScreen(
                                              notification: notif,
                                            )),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 6.h),
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: notifications[index].isSeen
                                        ? Color.fromARGB(255, 245, 255, 245)
                                        : Colors.white,
                                    border:
                                        Border.all(color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (notif.createdAt != null)
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "${notif.createdAt!.toLocal().toString().split(' ')[0]}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                      SizedBox(height: 10.h),
                                      Text("العميل: ${notif.nameUser}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("العنوان: ${notif.addressUser}"),
                                      Text("رقم الهاتف: ${notif.phoneUser}"),
                                      SizedBox(height: 6.h),
                                      Text("المنتجات المطلوبة:",
                                          style: TextStyle(
                                              color: AppColors.primary)),
                                      ...notif.products.map((p) => Text(
                                          "- ${p.nameProduct} × ${p.countProduct}")),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        );
      },
    );
  }
}
