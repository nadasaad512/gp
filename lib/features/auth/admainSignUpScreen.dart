import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/features/auth/widget/contentAdminAuthWidget.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import '../../date/modules/admain_user.dart';
import '../../date/Provider/auth_provider.dart';
import 'widget/AuthButtonWidget.dart';

class adminSignUpScreen extends StatefulWidget {
  @override
  State<adminSignUpScreen> createState() => _adminSignUpScreenState();
}

class _adminSignUpScreenState extends State<adminSignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final surepasswordController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final decController = TextEditingController();
  File? selectedImage;

  final usernameFocus = FocusNode();
  final mobileFocus = FocusNode();
  final passFocus = FocusNode();
  final surepassFocus = FocusNode();
  final emailFocus = FocusNode();
  final addressFocus = FocusNode();
  final decFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("يسعدنا إنضمامك في "),
                Image.asset("assets/images/title.png", scale: 2),
              ],
            ),
            ContentAdminAuthWidget(
              nameController: nameController,
              usernameFocus: usernameFocus,
              addressController: addressController,
              addressFocus: addressFocus,
              descController: decController,
              descFocus: decFocus,
              emailController: emailController,
              emailFocus: emailFocus,
              mobileController: mobileController,
              mobileFocus: mobileFocus,
              passFocus: passFocus,
              passwordController: passwordController,
              surePassFocus: surepassFocus,
              surePasswordController: surepasswordController,
              onImageSelected: (image) {
                selectedImage = image; // ✅ حفظ الصورة
              },
            ),
            Provider.of<AuthProvider>(context).isSignUp
                ? loadingWidget()
                : AuthButtonWidget(
                    title: 'إنشاء حساب',
                    onPressed: () async {
                      final city =
                          Provider.of<AuthProvider>(context, listen: false)
                              .city;
                      final area =
                          Provider.of<AuthProvider>(context, listen: false)
                              .area;

                      if (nameController.text.isEmpty ||
                          addressController.text.isEmpty ||
                          decController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          mobileController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          surepasswordController.text.isEmpty ||
                          selectedImage == null ||
                          area.isEmpty ||
                          city.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
                        );
                        return;
                      }

                      if (passwordController.text !=
                          surepasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('كلمة المرور غير متطابقة')),
                        );
                        return;
                      }

                      if (passwordController.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'كلمة المرور يجب أن تكون 6 خانات على الأقل')),
                        );
                        return;
                      }

                      AdminUser user = AdminUser(
                          phone: mobileController.text,
                          address: addressController.text,
                          email: emailController.text,
                          desc: decController.text,
                          name: nameController.text,
                          password: passwordController.text,
                          arae: area,
                          city: city,
                          uid: "",
                          image: "");

                      bool success = await Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).adminSignUp(context,
                          user: user, imageFile: selectedImage!);

                      if (success) {
                        nameController.clear();
                        emailController.clear();
                        passwordController.clear();
                        surepasswordController.clear();
                        mobileController.clear();
                        addressController.clear();
                        decController.clear();
                      }
                    }),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
