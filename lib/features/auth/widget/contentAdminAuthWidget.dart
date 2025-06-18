import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/Provider/auth_provider.dart';
import 'package:gp/features/auth/widget/DropdownWidget.dart';
import 'package:gp/features/auth/widget/authTextField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ContentAdminAuthWidget extends StatefulWidget {
  final Function(File?)? onImageSelected;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController surePasswordController;
  final TextEditingController mobileController;
  final TextEditingController addressController;
  final TextEditingController descController;

  final FocusNode usernameFocus;
  final FocusNode mobileFocus;
  final FocusNode passFocus;
  final FocusNode surePassFocus;
  final FocusNode emailFocus;
  final FocusNode addressFocus;
  final FocusNode descFocus;

  const ContentAdminAuthWidget({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.surePasswordController,
    required this.mobileController,
    required this.addressController,
    required this.descController,
    required this.usernameFocus,
    required this.mobileFocus,
    required this.passFocus,
    required this.surePassFocus,
    required this.emailFocus,
    required this.addressFocus,
    required this.descFocus,
    required this.onImageSelected,
  });

  @override
  State<ContentAdminAuthWidget> createState() => _ContentAdminAuthWidgetState();
}

class _ContentAdminAuthWidgetState extends State<ContentAdminAuthWidget> {
  String? selectedProvince;
  String? selectedArea;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      setState(() {
        _selectedImage = file;
      });
      if (widget.onImageSelected != null) {
        widget.onImageSelected!(file);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: _pickImage,
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      _selectedImage!,
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.camera_alt,
                        size: 30.w, color: AppColors.primary),
                  ),
          ),
          SizedBox(height: 20.h),
          CustomInputField(
            label: 'اسم الصيدلية ',
            icon: Icons.person,
            controller: widget.nameController,
            focusNode: widget.usernameFocus,
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            focusNode: widget.addressFocus,
          ),
          SizedBox(height: 20.h),
          CustomInputField(
            label: 'نبذة عن الصيدلية',
            icon: Icons.info_outline,
            controller: widget.descController,
            focusNode: widget.descFocus,
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
      ),
    );
  }
}
