import 'package:flutter/material.dart';

import '../../splash/widget/titlelogo.dart';

class BGgreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: const Color(0xFF74C26E),
      ),

      child: Padding(padding: EdgeInsets.only(top: 60), child: TitleLogo()),
    );
  }
}
