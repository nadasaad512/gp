import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/Provider/AdminProvider.dart';
import 'package:gp/date/modules/admain_user.dart';
import 'package:gp/date/modules/category.dart';
import 'package:gp/features/admain/Profile/widget/infowidget.dart';
import 'package:gp/features/user/products/ProductScreen.dart';
import 'package:gp/features/widget/BgProfileAdmainWidget.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class showProfileAdmin extends StatefulWidget {
  String idAdmin;
  showProfileAdmin({required this.idAdmin});
  @override
  State<showProfileAdmin> createState() => _showProfileAdminState();
}

class _showProfileAdminState extends State<showProfileAdmin> {
  AdminUser? adminUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminUser();
  }

  Future<void> _loadAdminUser() async {
    print("widget.idAdmin${widget.idAdmin}");
    AdminUser? admin = await Provider.of<AdminProvider>(context, listen: false)
        .getUserById(widget.idAdmin.toString());
    await Provider.of<AdminProvider>(context, listen: false)
        .userFetchAdminCategories(widget.idAdmin.toString());
    setState(() {
      adminUser = admin;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        return Scaffold(
          floatingActionButton: Container(
            margin: EdgeInsets.only(bottom: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  heroTag: "btn_roshteh",
                  onPressed: () => _openWhatsApp(context, adminUser!.phone),
                  backgroundColor: AppColors.primary,
                  icon: Icon(Icons.image, color: Colors.white),
                  label: Text(
                    " اطلب الروشتة",
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                SizedBox(width: 10.h),
                FloatingActionButton.extended(
                  heroTag: "b_roshteh",
                  onPressed: () => _openWhatsApp(context, adminUser!.phone),
                  backgroundColor: AppColors.primary,
                  icon: Icon(Icons.chat_rounded, color: Colors.white),
                  label: Text(
                    "اسأل صيدلي",
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          backgroundColor: AppColors.white,
          body: _isLoading
              ? loadingWidget()
              : Column(
                  children: [
                    BgProfileAdmainWidget(() {}, adminUser!.image, true),
                    SizedBox(height: 50.h),
                    Text(
                      "صيدلية   ${adminUser!.name}",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 30.h),
                    AddressWidget(
                      address: adminUser!.address,
                      area: adminUser!.arae,
                      city: adminUser!.city,
                      dec: adminUser!.desc,
                      phone: adminUser!.phone,
                      isAdmin: false,
                    ),
                    SizedBox(height: 10.h),
                    TextTitle('الأقسام'),
                    if (adminProvider.userAdminCategory.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            itemCount: adminProvider.userAdminCategory.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 8 / 9,
                            ),
                            itemBuilder: (context, index) {
                              return categoryItem(
                                  adminProvider.userAdminCategory[index]);
                            },
                          ),
                        ),
                      )
                    else
                      Text('لا توجد أقسام حالياً')
                  ],
                ),
        );
      },
    );
  }

  Widget categoryItem(CategoryModel cat) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductScreen(
                    cat.name,
                    idAdmin: widget.idAdmin,
                    isOneUser: true,
                  )),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green[50],
                image: DecorationImage(
                  image: NetworkImage(cat.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(cat.name, style: TextStyle(fontSize: 14)),
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

  Future<void> _openWhatsApp(BuildContext context, String phone) async {
    // تأكد من أن الرقم يحتوي فقط على أرقام
    phone = phone.replaceAll(RegExp(r'\D'), '');

    // جهز قائمة التجارب بالترتيب
    List<String> prefixes = ['972', '970'];
    bool success = false;

    for (String prefix in prefixes) {
      String formattedPhone =
          phone.startsWith(prefix) ? phone : '$prefix$phone';
      final Uri url = Uri.parse("https://wa.me/$phone");

      try {
        success = await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        print("فشل فتح الرابط باستخدام $prefix: $e");
        success = false;
      }

      if (success) break; // إذا نجحت محاولة، أوقف التكرار
    }

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تعذر فتح واتساب. تأكد أن التطبيق مثبت."),
        ),
      );
    }
  }
}
