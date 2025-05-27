import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tech_challenge_3/core/configs/theme/app_theme.dart';
import 'package:tech_challenge_3/core/routes/app_routes.dart';
import 'package:tech_challenge_3/firebase_options.dart';
import 'package:tech_challenge_3/service_locator.dart';

import 'package:tech_challenge_3/presentation/transactions/bloc/transactions_display_cubit.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/transaction_detail_page.dart';
import 'package:tech_challenge_3/presentation/transaction/screens/update_transaction.dart';
import 'package:tech_challenge_3/presentation/transaction/screens/new_transaction.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/add_transaction.dart';
import 'package:tech_challenge_3/presentation/transaction/screens/transactions.dart';
import 'package:tech_challenge_3/presentation/home/bloc/user_display_cubit.dart';
import 'package:tech_challenge_3/presentation/splash/spash_screen.dart';
import 'package:tech_challenge_3/presentation/auth/pages/signin.dart';
import 'package:tech_challenge_3/presentation/auth/pages/signup.dart';
import 'package:tech_challenge_3/presentation/home/pages/home.dart';

import 'package:tech_challenge_3/common/bloc/auth/auth_state.dart';
import 'package:tech_challenge_3/common/bloc/auth/auth_state_cubit.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state_cubit.dart';

import 'package:tech_challenge_3/domain/entities/transaction.dart';

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
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserDisplayCubit()..displayUser()),
        BlocProvider(
          create: (context) => TransactionsDisplayCubit()..fetchTransactions(),
        ),
        BlocProvider(create: (context) => ButtonStateCubit()),
        BlocProvider(create: (context) => AuthStateCubit()..appStarted()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    return BlocBuilder<AuthStateCubit, AuthState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.appTheme,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [Locale('pt')],

          home: switch (state) {
            AppInitialState() => const SplashScreen(),
            Authenticated() => const HomePage(),
            UnAuthenticated() => SigninPage(),
            _ => const SplashScreen(),
          },
          routes: {
            AppRoutes.login: (context) => SigninPage(),
            AppRoutes.signup: (context) => SignupPage(),
            AppRoutes.home: (context) => HomePage(),
            AppRoutes.createTransaction:
                (context) => const CreateTransactionPage(),
            // AppRoutes.listTransactions: (context) => const StatementPage(),
            AppRoutes.transactionDetail:
                (context) => TransactionDetailPage(
                  transaction:
                      ModalRoute.of(context)?.settings.arguments
                          as TransactionEntity,
                ),
            AppRoutes.transactions: (context) => const TransactionsScreen(),
            AppRoutes.newTransaction: (context) => const NewTransactionScreen(),
            AppRoutes.updateTransaction:
                (context) => const UpdateTransactionScreen(),
          },
        );
      },
    );
  }
}
