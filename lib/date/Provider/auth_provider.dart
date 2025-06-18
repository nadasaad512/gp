import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gp/date/Storge/local_storage_service.dart';
import 'package:gp/features/auth/AuthScreen.dart';
import '../Service/auth_service.dart';
import '../modules/admain_user.dart';
import '../modules/client_user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isSign = false;
  bool isSignUp = false;
  String city = "";
  String area = "";

  signIn(BuildContext context,
      {required String email, required String password}) async {
    isSign = true;
    notifyListeners();

    await _authService.signInWithEmail(
        email: email, password: password, context: context);
    isSign = false;
    notifyListeners();
  }

  Future<bool> adminSignUp(BuildContext context,
      {required AdminUser user, required File imageFile}) async {
    isSignUp = true;
    notifyListeners();

    String? result = await _authService.adminSignUpWithEmail(
        user: user, imageFile: imageFile);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      isSignUp = false;
      notifyListeners();
      return false;
    }

    // Save user data locally after successful sign up
    await LocalStorageService.saveUserData(
      uid: user.uid,
      name: user.name,
      phone: user.phone,
      city: user.city,
      area: user.arae,
      type: "admin",
    );

    isSignUp = false;
    notifyListeners();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => AuthScreen(
                isAdmain: true,
              )),
    );

    return true;
  }

  Future<bool> clientSignUp(BuildContext context,
      {required ClientUser user}) async {
    isSignUp = true;
    notifyListeners();
    String? result = await _authService.clientSignUpWithEmail(user: user);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      await LocalStorageService.saveUserData(
        uid: user.uid,
        name: user.name1,
        phone: user.phone,
        city: user.city,
        area: user.area,
        type: "client",
      );
      isSignUp = false;
      notifyListeners();
      return false;
    }
    isSignUp = false;
    notifyListeners();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => AuthScreen(
                isAdmain: false,
              )),
    );
    return true;
  }

  logout(BuildContext context) async {
    await _authService.logout(context);
  }
}
