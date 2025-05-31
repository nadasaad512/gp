import 'package:flutter/material.dart';
import 'package:gp/features/splash/widget/choosetypewidget.dart';
import 'package:gp/features/splash/widget/logowidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

import '../../core/BgWidget.dart';
import '../admain/Main/admainmainscreen.dart';
import '../user/main/mainscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    await _getLocationAndSave();
    await Future.delayed(const Duration(seconds: 3));
    await _navigateToNextScreen();
  }

  Future<void> _getLocationAndSave() async {
    try {
      loc.Location location = loc.Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      loc.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) return;
      }

      loc.LocationData locationData = await location.getLocation();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String city = place.subAdministrativeArea ?? '';
        String area = place.locality ?? place.name ?? '';

        final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('city', city);
        // await prefs.setString('area', area);

        print('✅ المدينة: $city');
        print('✅ المنطقة: $area');
      }
    } catch (e) {
      print('❌ خطأ في تحديد أو حفظ الموقع: $e');
    }
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userType = prefs.getString('type');
    //prefs.clear();

    if (userType == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdmainMainScreen()),
      );
    } else if (userType == 'client') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChooseTypeWidget()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgWidget(child: Center(child: LogoWidget()));
  }
}
