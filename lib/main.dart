import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/firebase_options.dart';
import 'package:tech_challenge_3/presentation/auth/pages/signin.dart';
import 'package:tech_challenge_3/presentation/auth/pages/signup.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/add_transaction.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/statement_page.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/transaction_detail_page.dart';
import 'package:tech_challenge_3/service_locator.dart';

import 'core/routes/app_routes.dart';
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
        AppRoutes.login: (context) => SigninPage(),
        AppRoutes.signup: (context) => SignupPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.createTransaction: (context) => const CreateTransactionPage(),
        AppRoutes.listTransactions: (context) => const StatementPage(),
        AppRoutes.transactionDetail:
            (context) => TransactionDetailPage(
              transaction:
                  ModalRoute.of(context)?.settings.arguments
                      as TransactionEntity,
            ),
      },
    );
  }
}
