import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/vacancy_service.dart';
import '../../../bloc/vacancys_cubit.dart';
import '../../../global/components/buttons/vacancy_card.dart';

class RecruiterVacancies extends StatelessWidget {
  const RecruiterVacancies({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VacancysCubit, VacancysState>(
      builder: (context, state) {
        if (state.vacancys.isEmpty) {
          return const Center(
            child: Text('Aún no tienes vacantes'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            final asyncResponse = await VacancyService.getMyVacancies(
              FirebaseAuth.instance.currentUser!.uid,
            );
            if (asyncResponse.isRight() &&
                asyncResponse.data!.isNotEmpty &&
                context.mounted) {
              context.read<VacancysCubit>().setVacancys(asyncResponse.data!);
            }
          },
          child: ListView.builder(
            itemCount: state.vacancys.length,
            itemBuilder: (context, index) {
              return VacancyCard(
                vacancy: state.vacancys[index],
              );
            },
          ),
        );
      },
    );
  }
}
