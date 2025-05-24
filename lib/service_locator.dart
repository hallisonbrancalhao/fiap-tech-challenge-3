import 'package:get_it/get_it.dart';
import 'package:tech_challenge_3/core/network/dio_client.dart';
import 'package:tech_challenge_3/data/repository/auth.dart';
import 'package:tech_challenge_3/data/source/auth_api_service.dart';
import 'package:tech_challenge_3/data/source/auth_local_service.dart';
import 'package:tech_challenge_3/domain/repository/auth.dart';
import 'package:tech_challenge_3/domain/usecases/get_user.dart';
import 'package:tech_challenge_3/domain/usecases/is_logged_in.dart';
import 'package:tech_challenge_3/domain/usecases/logout.dart';
import 'package:tech_challenge_3/domain/usecases/signin.dart';
import 'package:tech_challenge_3/domain/usecases/signup.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());

  // Services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());

  sl.registerSingleton<AuthLocalService>(AuthLocalServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // Usecases
  sl.registerSingleton<SignupUseCase>(SignupUseCase());

  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());

  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());

  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());

  sl.registerSingleton<SigninUseCase>(SigninUseCase());
}
