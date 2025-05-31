import 'package:flutter/material.dart';
import 'package:gp/features/auth/widget/BGgreen.dart';
import 'package:gp/features/auth/widget/CustomTabBar.dart';

import 'LoginScreen.dart';
import 'SignUpScreen.dart';
import 'admainSignUpScreen.dart';

class AuthScreen extends StatefulWidget {
  bool isAdmain;
  AuthScreen({required this.isAdmain});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFF8F8F8),
      body: Stack(
        children: [
          BGgreen(),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              height: MediaQuery.of(context).size.height * 0.70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTabBar(tabController: _tabController),
                  SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        LoginScreen(),
                        widget.isAdmain ? adminSignUpScreen() : SignUpScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
