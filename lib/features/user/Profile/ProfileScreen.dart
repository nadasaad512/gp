import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/Provider/UserProvider.dart';
import 'package:gp/date/Service/auth_service.dart';
import 'package:gp/date/modules/client_user.dart';
import 'package:gp/features/user/Profile/widget/ProfileWidget.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../auth/widget/authTextField.dart';
import '../../auth/widget/dropdownedit.dart';
import '../Home/widget/BgHomeWidget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _genderFocus = FocusNode();
  final _ageFocus = FocusNode();
  final _mobileFocus = FocusNode();
  ClientUser? user;
  bool _isLoading = true;
  String area = "";
  String city = "";
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    user =
        await Provider.of<UserProvider>(context, listen: false).fetchProfile();
    print("user$user");
    nameController.text = user!.name1 + user!.name2;
    _genderController.text = user!.gender;
    _ageController.text = user!.age;
    _mobileController.text = user!.phone;
    _addressController.text = user!.address;
    _emailController.text = user!.email;
    _addressController.text = user!.address;
    city = user!.city;
    area = user!.area;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          BgHomeWidget(isTitle: true, isArrow: false, title: "الملف الشخصي"),
          _isLoading
              ? Expanded(child: Center(child: loadingWidget()))
              : Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ListView(
                      children: [
                        InfoWidget(
                          name: user!.name1 + " " + user!.name2,
                          phone: user!.phone,
                        ),
                        Divider(thickness: 1, color: AppColors.divider),
                        SizedBox(height: 10.h),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "معلومات الحساب",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 170.w,
                              child: CustomInputField(
                                label: '',
                                icon: Icons.calendar_month,
                                controller: _ageController,
                                focusNode: _ageFocus,
                                isEnable: false,
                              ),
                            ),
                            SizedBox(
                              width: 170.w,
                              child: CustomInputField(
                                label: '',
                                icon: Icons.male,
                                controller: _genderController,
                                focusNode: _genderFocus,
                                isEnable: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            EditDropdownWidget(
                              title: city,
                              isEnabled: false,
                            ),
                            EditDropdownWidget(
                              title: area,
                              isEnabled: false,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        CustomInputField(
                          label: '',
                          icon: Icons.email,
                          controller: _emailController,
                          focusNode: _mobileFocus,
                          isEnable: false,
                        ),
                        SizedBox(height: 20.h),
                        CustomInputField(
                          label: '',
                          icon: Icons.info,
                          controller: _addressController,
                          focusNode: _mobileFocus,
                          isEnable: false,
                        ),
                        SizedBox(height: 20.h),
                        CustomInputField(
                          label: '',
                          icon: Icons.phone,
                          controller: _mobileController,
                          focusNode: _mobileFocus,
                          isEnable: false,
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => ChangePasswordDialog(),
                            );
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "تغير كلمة المرور",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

Widget TextWidget(String name) {
  return Text(
    name,
    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
  );
}

class ChangePasswordDialog extends StatelessWidget {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان وصف الإغلاق
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تغير كلمة المرور',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            SizedBox(height: 10.h),
            // الحقول
            _buildField(oldPasswordController, 'كلمة المرور القديمة'),
            SizedBox(height: 10.h),
            _buildField(newPasswordController, 'كلمة المرور الجديدة'),
            SizedBox(height: 10.h),
            _buildField(confirmPasswordController, 'تأكيد كلمة المرور'),
            SizedBox(height: 20.h),
            // زر الحفظ
            ElevatedButton(
              onPressed: () async {
                final oldPass = oldPasswordController.text.trim();
                final newPass = newPasswordController.text.trim();
                final confirmPass = confirmPasswordController.text.trim();

                if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
                  // ممكن تضيفي رسالة خطأ للمستخدم
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('يرجى ملء جميع الحقول'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (newPass != confirmPass) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('كلمة المرور الجديدة وتأكيدها غير متطابقين'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // استدعاء دالة تغيير كلمة المرور من AuthService
                final authService = AuthService();
                String? result = await authService.changePassword(
                  oldPassword: oldPass,
                  newPassword: newPass,
                );

                if (result == null) {
                  // نجاح
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم تحديث كلمة المرور بنجاح'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  // خطأ
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
              ),
              child: Text('حفظ'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
