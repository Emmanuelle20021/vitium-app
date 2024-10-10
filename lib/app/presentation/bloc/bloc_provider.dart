import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/presentation/bloc/vacancys_cubit.dart';
import 'exception_handler_cubit.dart';
import 'register_cubit.dart';

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => ExceptionHandlerCubit(),
        ),
        BlocProvider(
          create: (context) => VacancysCubit(),
        ),
      ],
      child: child,
    );
  }
}
