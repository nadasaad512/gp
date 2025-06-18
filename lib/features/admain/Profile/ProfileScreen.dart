import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/Provider/AdminProvider.dart';
import 'package:gp/date/Provider/auth_provider.dart';
import 'package:gp/date/Service/auth_service.dart';
import 'package:gp/date/modules/admain_user.dart';
import 'package:gp/date/modules/category.dart';
import 'package:gp/features/admain/Profile/widget/infowidget.dart';
import 'package:gp/features/splash/widget/choosetypewidget.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_colors.dart';
import '../../widget/BgProfileAdmainWidget.dart';

class AdmainProfileScreen extends StatefulWidget {
  @override
  State<AdmainProfileScreen> createState() => _AdmainProfileScreenState();
}

class _AdmainProfileScreenState extends State<AdmainProfileScreen> {
  AdminUser? adminUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminUser();
  }

  Future<void> _loadAdminUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString('uid');
      print("Admin UID: $id");

      if (id != null) {
        AdminProvider provider =
            Provider.of<AdminProvider>(context, listen: false);
        AdminUser? user = await provider.getUserById(id);
        await provider.fetchAdminCategories();

        setState(() {
          adminUser = user;
          _isLoading = false;
        });
      } else {
        print('UID not found in SharedPreferences');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading admin user: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _confirmAndDeleteUserData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text(
            'هل أنت متأكد من حذف بيانات المستخدم؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            child: Text(
              'إلغاء',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // اظهار مؤشر تحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
          child: CircularProgressIndicator(
        color: AppColors.primary,
      )),
    );

    String? result = await AuthService().deleteUserData();

    // اخفاء مؤشر التحميل
    Navigator.of(context).pop();

    if (result == null) {
      // نجاح الحذف
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف بيانات المستخدم بنجاح')),
      );
      // يمكنك هنا إعادة التوجيه مثلاً لشاشة تسجيل الدخول أو غيرها
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChooseTypeWidget()),
      );
    } else {
      // ظهور خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _isLoading
          ? loadingWidget()
          : adminUser == null
              ? Center(child: Text('لا يمكن تحميل بيانات المستخدم'))
              : Consumer<AdminProvider>(
                  builder: (context, adminProvider, child) {
                    return Column(
                      children: [
                        BgProfileAdmainWidget(
                          () async {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .logout(context);
                          },
                          adminUser!.image,
                          false,
                        ),
                        SizedBox(height: 50.h),
                        Text(
                          "صيدلية   ${adminUser!.name}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        AddressWidget(
                          address: adminUser!.address,
                          area: adminUser!.arae,
                          city: adminUser!.city,
                          dec: adminUser!.desc,
                          phone: adminUser!.phone,
                        ),
                        SizedBox(height: 20.h),
                        TextTitle('الأقسام'),
                        if (adminProvider.adminCategory.isNotEmpty)
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                          ),
                        SizedBox(height: 20.h),
                        ElevatedButton.icon(
                          onPressed: _confirmAndDeleteUserData,
                          icon: Icon(Icons.delete),
                          label: Text('حذف الصيدلية'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
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
