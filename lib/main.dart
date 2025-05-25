import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tech_challenge_3/core/configs/theme/app_theme.dart';
import 'package:tech_challenge_3/core/routes/app_routes.dart';
import 'package:tech_challenge_3/service_locator.dart';

import 'package:tech_challenge_3/presentation/transaction/screens/update_transaction.dart';
import 'package:tech_challenge_3/presentation/transaction/screens/new_transaction.dart';
import 'package:tech_challenge_3/presentation/transaction/screens/transactions.dart';
import 'package:tech_challenge_3/presentation/auth/pages/custom_signin.dart';
import 'package:tech_challenge_3/presentation/auth/pages/custom_signup.dart';
import 'package:tech_challenge_3/presentation/home/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => CustomSigninPage(),
        AppRoutes.signup: (context) => CustomSignupPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.transactions: (context) => const TransactionsScreen(),
        AppRoutes.newTransaction: (context) => const NewTransactionScreen(),
        AppRoutes.updateTransaction: (context) => const UpdateTransaction(),
      },
    );
  }
}
