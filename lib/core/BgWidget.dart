import 'package:flutter/material.dart';
import 'app_colors.dart';

class BgWidget extends StatelessWidget {
  final Widget child;

  const BgWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        body: child
    );
  }

}