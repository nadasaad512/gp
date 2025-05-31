import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/features/splash/widget/titlelogo.dart';
import '../../../core/BgWidget.dart';
import '../../onboarding/OnboardingScreen.dart';
import '../../widget/button.dart';
import '../../../core/text_styles.dart';

class ChooseTypeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 50.h),
            TitleLogo(),
            SizedBox(height: 200.h),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Text(
                  "اختر كيف تريد تسجيل الدخول",
                  style: AppTextStyles.heading,
                ),
                SizedBox(height: 30.h),
                CustomButton(
                  text: 'صيدلي',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnboardingScreen(isAdmain: true),
                      ),
                    );
                  },
                  type: CustomButtonType.buttonRounded,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'مشتري',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnboardingScreen(isAdmain: false),
                      ),
                    );
                  },
                  type: CustomButtonType.buttonRounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
