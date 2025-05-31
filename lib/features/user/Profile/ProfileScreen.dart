import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/Provider/UserProvider.dart';
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
                        Align(
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
