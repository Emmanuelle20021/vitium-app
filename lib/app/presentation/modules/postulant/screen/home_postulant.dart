import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/data/services/vacancy_service.dart';
import 'package:vitium/app/presentation/bloc/vacancys_cubit.dart';

import '../../../global/components/buttons/vacancy_card.dart';

class HomePostulant extends StatelessWidget {
  const HomePostulant({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: SearchBar(
            hintText: 'Buscar vacantes',
            leading: Icon(Icons.search),
            padding: WidgetStatePropertyAll<EdgeInsetsDirectional>(
              EdgeInsetsDirectional.symmetric(horizontal: 20),
            ),
          ),
        ),
        const Text(
          'Ofertas de empleo basadas en tú actividad',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: BlocConsumer<VacancysCubit, VacancysState>(
            listener: (_, vacancysState) {},
            builder: (context, vacancysState) {
              if (vacancysState.vacancys.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'No hay vacantes disponibles',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                        refresh(context);
                      },
                      child: const Text(
                        'Recargar',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await refresh(context);
                },
                child: ListView.builder(
                  addSemanticIndexes: true,
                  semanticChildCount: vacancysState.vacancys.length,
                  itemBuilder: (context, index) {
                    return VacancyCard(
                      vacancy: vacancysState.vacancys[index],
                    );
                  },
                  itemCount: vacancysState.vacancys.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> refresh(BuildContext context) async {
    context.read<VacancysCubit>().setVacancys(
          (await VacancyService.getVacancys()).data!,
        );
  }
}
