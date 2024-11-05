import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:vitium/app/data/implementation/firebase_auth_repository_implementation.dart';
import 'package:vitium/app/data/services/user_service.dart';
import 'package:vitium/app/data/services/vacancy_service.dart';
import 'package:vitium/app/data/utils/constants/constants.dart';
import 'package:vitium/app/data/utils/injector.dart';
import 'package:vitium/app/domain/models/vacancy_model.dart';
import 'package:vitium/app/presentation/bloc/bloc_provider.dart';
import 'package:vitium/app/presentation/bloc/exception_handler_cubit.dart';
import 'package:vitium/app/presentation/bloc/register_cubit.dart';
import 'package:vitium/app/presentation/bloc/vacancys_cubit.dart';
import 'package:vitium/app/presentation/routes/app_routes.dart';
import 'app/domain/models/async_response.dart';
import 'app/domain/models/user_model.dart';
import 'app/presentation/routes/routes.dart';
import 'keys/firebase_options.dart';

FirebaseApp? firebase;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final bool? notFirstTime = prefs.getBool('notFirstTime');
    runApp(
      MaterialApp(
        home: Injector(
          accountRepository: FirebaseAuthRepositoryImplementation(
            firebaseAuth: FirebaseAuth.instance,
          ),
          child: BlocsProvider(
            child: Vitium(notFirstTime),
          ),
        ),
      ),
    );
  } catch (error) {
    /// Handle the error
    debugPrint('Error: $error');
  }
}

class Vitium extends StatelessWidget {
  const Vitium(this.notFirstTime, {super.key});
  final bool? notFirstTime;

  @override
  Widget build(BuildContext context) {
    final vacancysCubit = context.read<VacancysCubit>();
    return BlocConsumer<ExceptionHandlerCubit, ExceptionHandlerState>(
      listener: (context, state) {
        if (state.hasException && state.message != null) {
          toastification.show(
            context: context,
            title: const Text('Error'),
            description: Text(state.message!),
          );
        }
      },
      builder: (context, state) {
        final currentUser = FirebaseAuth.instance.currentUser;

        return FutureBuilder(
          future: Future.wait(
            currentUser != null
                ? [
                    VacancyService.getVacancys(),
                    UserService.getUser(currentUser.uid),
                    VacancyService.getMyVacancies(currentUser.uid),
                  ]
                : [
                    VacancyService.getVacancys(),
                    Future.value(false),
                    Future.value(false)
                  ],
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset(
                    kVitiumLogo,
                    height: 100,
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            final AsyncResponse<UserModel>? userData =
                (snapshot.data != null && snapshot.data![1] != false)
                    ? snapshot.data![1] as AsyncResponse<UserModel>
                    : null;
            if (snapshot.hasData &&
                snapshot.data != null &&
                userData?.data != null) {
              context.read<RegisterCubit>().setUser(userData!.data!);
            }
            if (snapshot.data != null && snapshot.data![2] != false) {
              final AsyncResponse<List<Vacancy>>? myVacancyData =
                  snapshot.data != null && snapshot.data![2] != false
                      ? snapshot.data![2] as AsyncResponse<List<Vacancy>>
                      : null;
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  myVacancyData?.data != null &&
                  myVacancyData!.data!.isNotEmpty) {
                vacancysCubit.setVacancys(myVacancyData.data!);
              }
            }
            if (snapshot.data != null &&
                snapshot.data![0] != false &&
                userData?.data != null &&
                userData!.data!.role != 'recruiter') {
              final AsyncResponse<List<Vacancy>> vacancyData =
                  snapshot.data![0] as AsyncResponse<List<Vacancy>>;
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  vacancyData.data != null &&
                  vacancyData.data!.isNotEmpty) {
                vacancysCubit.setVacancys(vacancyData.data!);
              }
            }

            return MaterialApp(
              initialRoute: (notFirstTime == true &&
                      FirebaseAuth.instance.currentUser != null)
                  ? Routes.home
                  : Routes.splashScreens,
              routes: appRoutes,
            );
          },
        );
      },
    );
  }
}
