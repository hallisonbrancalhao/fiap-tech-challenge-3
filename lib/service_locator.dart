import 'package:get_it/get_it.dart';
import 'package:tech_challenge_3/core/network/dio_client.dart';
import 'package:tech_challenge_3/data/repository/auth_repository.dart';
import 'package:tech_challenge_3/data/repository/transactions_repository.dart';
import 'package:tech_challenge_3/data/source/auth_service.dart';
import 'package:tech_challenge_3/data/source/local_service.dart';
import 'package:tech_challenge_3/data/source/transactions_api_service.dart';
import 'package:tech_challenge_3/domain/repository/auth_repository.dart';
import 'package:tech_challenge_3/domain/repository/transactions_repository.dart';
import 'package:tech_challenge_3/domain/source/auth_service.dart';
import 'package:tech_challenge_3/domain/source/local_service.dart';
import 'package:tech_challenge_3/domain/source/transactions_service.dart';
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
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Services
  sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  sl.registerLazySingleton<LocalService>(() => LocalServiceImpl());
  sl.registerLazySingleton<TransactionsService>(
    () => TransactionsApiServiceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<TransactionsRepository>(
    () => TransactionsRepositoryImpl(),
  );

  // Usecases
  sl.registerLazySingleton<SignupUseCase>(() => SignupUseCase());
  sl.registerLazySingleton<IsLoggedInUseCase>(() => IsLoggedInUseCase());
  sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase());
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase());
  sl.registerLazySingleton<SigninUseCase>(() => SigninUseCase());
  sl.registerLazySingleton<CreateTransactionUseCase>(
    () => CreateTransactionUseCase(),
  );
  sl.registerLazySingleton<GetTransactionsUseCase>(
    () => GetTransactionsUseCase(),
  );
  sl.registerLazySingleton<UploadTransactionAttachmentUseCase>(
    () => UploadTransactionAttachmentUseCase(),
  );
}
