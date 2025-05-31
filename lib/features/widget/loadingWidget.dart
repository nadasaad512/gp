import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gp/core/app_colors.dart';

class loadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: AppColors.primary,
      strokeWidth: 1,
    );
  }
}
