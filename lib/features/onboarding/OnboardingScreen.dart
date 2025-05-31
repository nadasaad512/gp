import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gp/features/onboarding/widget/onboarding_data.dart';

import '../../core/AppStrings.dart';
import '../../core/BgWidget.dart';
import '../../core/text_styles.dart';
import '../auth/AuthScreen.dart';

class OnboardingScreen extends StatefulWidget {
  bool isAdmain;
  OnboardingScreen({required this.isAdmain});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  void _goToNext() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AuthScreen(isAdmain: widget.isAdmain),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.isAdmain
                  ? onboardingAdmainData.length
                  : onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 50.h,
                    width: 200.w,
                  ),
                  SizedBox(height: 70.h),
                  SvgPicture.asset(
                    widget.isAdmain
                        ? onboardingAdmainData[index]['image']!
                        : onboardingData[index]['image']!,
                    height: 250.h,
                  ),
                  SizedBox(height: 100.h),
                  Text(
                    widget.isAdmain
                        ? onboardingAdmainData[index]['description']!
                        : onboardingData[index]['description']!,
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.green
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _goToNext,
                  child: const Text(
                    AppStrings.skip,
                    style: AppTextStyles.boarding_button,
                  ),
                ),
                // TextButton(
                //   onPressed: _goToNext,
                //   child: Text(
                //     _currentPage == onboardingData.length - 1
                //         ? AppStrings.startNow
                //         : AppStrings.next,
                //     style: AppTextStyles.boarding_button,
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
