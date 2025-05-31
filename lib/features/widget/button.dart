import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/text_styles.dart';

enum CustomButtonType {
  buttonRounded,
  buttonRectangular,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final CustomButtonType type;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    double elevation;
    TextStyle styletext;
    BorderRadius borderRadius;

    switch (type) {
      case CustomButtonType.buttonRounded:
        backgroundColor = Colors.white;
        borderRadius=BorderRadius.circular(28.r);
        styletext=AppTextStyles.button;
        elevation = 4;
        break;
      case CustomButtonType.buttonRectangular:
        backgroundColor = const Color(0xFF70C16F);
        styletext=AppTextStyles.loginbutton;
        borderRadius=BorderRadius.circular(8.r);
        elevation = 4;
        break;
    }

    return SizedBox(
      width: 180.w,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          elevation: elevation,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
        child: Text(
          text,
          style: styletext
        ),
      ),
    );
  }
}
