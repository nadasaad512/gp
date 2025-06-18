import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/Provider/auth_provider.dart';
import 'package:gp/features/auth/widget/DropdownWidget.dart';
import 'package:gp/features/auth/widget/authTextField.dart';
import 'package:provider/provider.dart';

class ContentClientAuthWidget extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController secondNameController;
  final TextEditingController genderController;
  final TextEditingController ageController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController surePasswordController;
  final TextEditingController mobileController;
  final TextEditingController addressController;

  final FocusNode firstNameFocus;
  final FocusNode secondNameFocus;
  final FocusNode genderFocus;
  final FocusNode ageFocus;
  final FocusNode emailFocus;
  final FocusNode passFocus;
  final FocusNode surePassFocus;
  final FocusNode mobileFocus;
  final FocusNode addresFocus;

  const ContentClientAuthWidget({
    required this.firstNameController,
    required this.secondNameController,
    required this.genderController,
    required this.ageController,
    required this.emailController,
    required this.passwordController,
    required this.surePasswordController,
    required this.mobileController,
    required this.firstNameFocus,
    required this.secondNameFocus,
    required this.genderFocus,
    required this.ageFocus,
    required this.emailFocus,
    required this.passFocus,
    required this.surePassFocus,
    required this.mobileFocus,
    required this.addressController,
    required this.addresFocus,
  });

  @override
  State<ContentClientAuthWidget> createState() =>
      _ContentClientAuthWidgetState();
}

class _ContentClientAuthWidgetState extends State<ContentClientAuthWidget> {
  String? selectedProvince;
  String? selectedArea;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: CustomInputField(
                label: 'الإسم الأول',
                icon: Icons.person,
                controller: widget.firstNameController,
                focusNode: widget.firstNameFocus,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomInputField(
                label: 'الإسم الثاني',
                icon: Icons.person,
                controller: widget.secondNameController,
                focusNode: widget.secondNameFocus,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: CustomInputField(
                label: 'العمر',
                icon: Icons.calendar_month,
                controller: widget.ageController,
                focusNode: widget.ageFocus,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomInputField(
                label: 'الجنس',
                icon: Icons.male,
                controller: widget.genderController,
                focusNode: widget.genderFocus,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            DropdownWidget(
              title: 'اختر المحافظة',
              listIndex: 1,
              onChanged: (value) {
                setState(() {
                  selectedProvince = value;
                  selectedArea = null;
                  Provider.of<AuthProvider>(context, listen: false).city =
                      selectedProvince.toString();
                });
              },
            ),
            SizedBox(width: 10.w),
            DropdownWidget(
              title: 'اختر المنطقة',
              listIndex: 2,
              selectedProvince: selectedProvince,
              onChanged: (value) {
                setState(() {
                  selectedArea = value;
                  Provider.of<AuthProvider>(context, listen: false).area =
                      selectedArea.toString();
                });
              },
            ),
          ],
        ),
        SizedBox(height: 20.h),
        CustomInputField(
          label: 'العنوان',
          icon: Icons.location_on_outlined,
          controller: widget.addressController,
          focusNode: widget.addresFocus,
        ),
        SizedBox(height: 20.h),
        CustomInputField(
          label: 'رقم الجوال  ',
          icon: Icons.phone,
          controller: widget.mobileController,
          focusNode: widget.mobileFocus,
        ),
        SizedBox(height: 20.h),
        CustomInputField(
          label: 'الايميل',
          icon: Icons.email_outlined,
          controller: widget.emailController,
          focusNode: widget.emailFocus,
        ),
        SizedBox(height: 20.h),
        CustomInputField(
          label: 'كلمة المرور',
          icon: Icons.visibility_off,
          controller: widget.passwordController,
          focusNode: widget.passFocus,
          obscureText: true,
        ),
        SizedBox(height: 20.h),
        CustomInputField(
          label: 'تأكيد كلمة المرور',
          icon: Icons.visibility_off,
          controller: widget.surePasswordController,
          focusNode: widget.surePassFocus,
          obscureText: true,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
