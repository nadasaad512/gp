import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/modules/client_user.dart';
import 'package:gp/date/Provider/auth_provider.dart';
import 'package:gp/features/auth/widget/AuthButtonWidget.dart';
import 'package:gp/features/auth/widget/contentUserAuthWidget.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firstnameController = TextEditingController();
  final secondnameController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final surepasswordController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  final firstnameFocus = FocusNode();
  final secondnameFocus = FocusNode();
  final genderFocus = FocusNode();
  final ageFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final surepasswordFocus = FocusNode();
  final mobileFocus = FocusNode();
  final addresFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("يسعدنا إنضمامك في "),
              Image.asset("assets/images/title.png", scale: 2),
            ],
          ),
          ContentClientAuthWidget(
            firstNameController: firstnameController,
            secondNameController: secondnameController,
            genderController: genderController,
            ageController: ageController,
            emailController: emailController,
            passwordController: passwordController,
            surePasswordController: surepasswordController,
            mobileController: mobileController,
            firstNameFocus: firstnameFocus,
            secondNameFocus: secondnameFocus,
            genderFocus: genderFocus,
            ageFocus: ageFocus,
            emailFocus: emailFocus,
            passFocus: passwordFocus,
            surePassFocus: surepasswordFocus,
            mobileFocus: mobileFocus,
            addresFocus: addresFocus,
            addressController: addressController,
          ),
          Provider.of<AuthProvider>(context).isSignUp
              ? loadingWidget()
              : AuthButtonWidget(
                  title: 'إنشاء حساب',
                  onPressed: () async {
                    final city =
                        Provider.of<AuthProvider>(context, listen: false).city;
                    final area =
                        Provider.of<AuthProvider>(context, listen: false).area;

                    if (firstnameController.text.isEmpty ||
                        secondnameController.text.isEmpty ||
                        genderController.text.isEmpty ||
                        ageController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        surepasswordController.text.isEmpty ||
                        mobileController.text.isEmpty ||
                        addressController.text.isEmpty ||
                        city.isEmpty ||
                        area.isEmpty) {
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

                    ClientUser user = ClientUser(
                      age: ageController.text,
                      gender: genderController.text,
                      name1: firstnameController.text,
                      name2: secondnameController.text,
                      password: passwordController.text,
                      email: emailController.text,
                      phone: mobileController.text,
                      city: city,
                      area: area,
                      address: addressController.text,
                      uid: "",
                    );

                    bool success = await Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).clientSignUp(context, user: user);

                    if (success) {
                      firstnameController.clear();
                      addressController.clear();
                      secondnameController.clear();
                      genderController.clear();
                      ageController.clear();
                      emailController.clear();
                      passwordController.clear();
                      surepasswordController.clear();
                      mobileController.clear();
                    }
                  },
                ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
