import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import '../../date/Provider/auth_provider.dart';
import 'widget/AuthButtonWidget.dart';
import 'widget/authTextField.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: bottomInset + 20),
      child: Column(
        children: [
          SizedBox(height: 30.h),
          Container(
            alignment: Alignment.topRight,
            child: Text(
              'أهلاً بك مجددًا',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 15.h),
          CustomInputField(
            label: 'اسم المستخدم',
            icon: Icons.person,
            controller: _usernameController,
            focusNode: _usernameFocus,
          ),
          SizedBox(height: 25.h),
          CustomInputField(
            label: 'كلمة المرور',
            icon: Icons.visibility_off,
            controller: _passwordController,
            focusNode: _passwordFocus,
            obscureText: true,
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نسيت كلمة المرور',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
              ),
              Text(
                'نسيت اسم المستخدم',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h),
          Provider.of<AuthProvider>(context).isSign
              ? loadingWidget()
              : AuthButtonWidget(
                  title: 'تسجيل الدخول',
                  onPressed: () async {
                    await Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).signIn(
                      context,
                      email: _usernameController.text,
                      password: _passwordController.text,
                    );
                  },
                ),
        ],
      ),
    );
  }
}
