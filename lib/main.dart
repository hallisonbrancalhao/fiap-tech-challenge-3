import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tech_challenge_3/firebase_options.dart';
import 'package:tech_challenge_3/service_locator.dart';

import 'core/routes/app_routes.dart';
import 'presentation/auth/pages/custom_signin.dart';
import 'presentation/auth/pages/custom_signup.dart';
import 'presentation/home/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
    ),
  );
  setupServiceLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.login: (context) => CustomSigninPage(),
        AppRoutes.signup: (context) => CustomSignupPage(),
        AppRoutes.home: (context) => const HomePage(),
      },
    );
  }
}
