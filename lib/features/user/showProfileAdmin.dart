import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/Provider/AdminProvider.dart';
import 'package:gp/date/modules/admain_user.dart';
import 'package:gp/date/modules/category.dart';
import 'package:gp/features/admain/Profile/widget/infowidget.dart';
import 'package:gp/features/widget/BgProfileAdmainWidget.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';

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
    AdminUser? admin = await Provider.of<AdminProvider>(context, listen: false)
        .getUserById(widget.idAdmin.toString());
    await Provider.of<AdminProvider>(context, listen: false)
        .fetchAdminCategories();
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
                    ),
                    SizedBox(height: 20.h),
                    TextTitle('الأقسام'),
                    if (adminProvider.adminCategory.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: GridView.builder(
                            itemCount: adminProvider.adminCategory.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 8 / 9,
                            ),
                            itemBuilder: (context, index) {
                              return categoryItem(
                                  adminProvider.adminCategory[index]);
                            },
                          ),
                        ),
                      )
                  ],
                ),
        );
      },
    );
  }

  Widget categoryItem(CategoryModel cat) {
    return Column(
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
}
