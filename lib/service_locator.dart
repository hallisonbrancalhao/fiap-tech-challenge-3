import 'package:get_it/get_it.dart';
import 'package:tech_challenge_3/core/network/dio_client.dart';
import 'package:tech_challenge_3/data/repository/auth.dart';
import 'package:tech_challenge_3/data/repository/transactions.dart';
import 'package:tech_challenge_3/data/source/auth_api_service.dart';
import 'package:tech_challenge_3/data/source/auth_local_service.dart';
import 'package:tech_challenge_3/data/source/transactions_api_service.dart';
import 'package:tech_challenge_3/domain/repository/auth.dart';
import 'package:tech_challenge_3/domain/repository/transactions.dart';
import 'package:tech_challenge_3/domain/usecases/auth/get_user.dart';
import 'package:tech_challenge_3/domain/usecases/auth/is_logged_in.dart';
import 'package:tech_challenge_3/domain/usecases/auth/logout.dart';
import 'package:tech_challenge_3/domain/usecases/auth/signin.dart';
import 'package:tech_challenge_3/domain/usecases/auth/signup.dart';
import 'package:tech_challenge_3/domain/usecases/transactions/create_transaction.dart';
import 'package:tech_challenge_3/domain/usecases/transactions/get_transactions.dart';
import 'package:tech_challenge_3/domain/usecases/transactions/upload_transaction_attachment.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());

  // Services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<AuthLocalService>(AuthLocalServiceImpl());
  sl.registerSingleton<TransactionsApiService>(TransactionsApiServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<TransactionsRepository>(TransactionsRepositoryImpl());

  // Usecases
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(sl()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<CreateTransactionUseCase>(CreateTransactionUseCase());
  sl.registerSingleton<GetTransactionsUseCase>(GetTransactionsUseCase());
  sl.registerSingleton<UploadTransactionAttachmentUseCase>(
    UploadTransactionAttachmentUseCase(),
  );
}
