import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:synergy/auth/auth.dart';
import 'package:synergy/auth/login_or_register.dart';
import 'package:synergy/screens/user_profile_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:synergy/screens/on_boarding_page.dart';

import 'models/AppsFlyerService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final themeStr =
      await rootBundle.loadString('lib/assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  await dotenv.load(fileName: ".env");
  AppsFlyerService appsFlyerService = AppsFlyerService();

  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<bool> _checkFirstRun() async {
      return await IsFirstRun.isFirstRun();
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return FutureBuilder<bool>(
      future: _checkFirstRun(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          final bool isFirstRun = snapshot.data ?? true;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Synergy',
            theme: theme,
            initialRoute: isFirstRun ? '/' : 'auth',
            routes: {
              '/': (_) => const OnBoardingPage(),
              'login_or_register': (_) => const LoginOrRegister(),
              'auth': (_) => const AuthPage(),
              'user_profile': (_) => UserProfileScreen(),
            },
          );
        }
      },
    );
  }
}
