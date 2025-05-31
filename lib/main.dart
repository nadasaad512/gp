import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp/date/Provider/AdminProvider.dart';
import 'package:gp/date/Provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'date/Provider/auth_provider.dart';
import 'features/admain/Main/admainmainscreen.dart';
import 'features/splash/splashscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/user/main/mainscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: prefs),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(392, 850),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: ThemeMode.light, // force light mode

          theme: ThemeData(
            fontFamily: 'Cairo',
            brightness: Brightness.light, // <- important for devices!
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
            ),
          ),
          initialRoute: '/SplashScreen',
          routes: {
            '/MainScreen': (context) => MainScreen(),
            '/AdmainMainScreen': (context) => AdmainMainScreen(),
            '/SplashScreen': (context) => SplashScreen(),
          },
        );
      },
    );
  }
}
