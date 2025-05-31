import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../ProfileScreen.dart';
import 'AvaterWidget.dart';

class InfoWidget extends StatelessWidget {
  String name;
  String phone;
  InfoWidget({required this.name, required this.phone});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AvaterWidget(),
        SizedBox(
          height: 10.h,
        ),
        TextWidget(name),
        SizedBox(
          height: 10.h,
        ),
        TextWidget(phone),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
