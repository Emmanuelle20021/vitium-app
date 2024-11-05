import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/data/services/vacancy_service.dart';
import 'package:vitium/app/presentation/bloc/vacancys_cubit.dart';
import 'package:vitium/app/presentation/global/components/buttons/rectangle_button.dart';
import 'package:vitium/app/presentation/modules/recruiter/screen/create_vacancy.dart';

import '../../../../data/utils/constants/constants.dart';
import '../../../global/components/buttons/vacancy_card.dart';

class HomeRecruiter extends StatelessWidget {
  const HomeRecruiter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Escoge una de las opciones a continuación',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 72, 144),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.star_outline,
                color: Colors.amber,
                size: 50,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Aumenta tu alcance',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '¿Quieres destacarte y obtener mejores resultados? ¡Prueba nuestra suscripción premium o publicación especial!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Ultimas vacantes',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        BlocConsumer<VacancysCubit, VacancysState>(
          listener: (_, __) {},
          builder: (context, state) {
            if (state.vacancys.isEmpty) {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final response = await VacancyService.getMyVacancies(
                        FirebaseAuth.instance.currentUser!.uid);
                    if (response.hasData &&
                        response.data != null &&
                        response.data!.isNotEmpty &&
                        context.mounted) {
                      context.read<VacancysCubit>().setVacancys(response.data!);
                    }
                  },
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Column(
                          children: [
                            Text('No hay vacantes'),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: () async {
                                final response =
                                    await VacancyService.getMyVacancies(
                                        FirebaseAuth.instance.currentUser!.uid);
                                if (response.hasData &&
                                    response.data != null &&
                                    response.data!.isNotEmpty &&
                                    context.mounted) {
                                  context
                                      .read<VacancysCubit>()
                                      .setVacancys(response.data!);
                                }
                              },
                              child: Text(
                                'Recargar',
                                style: TextStyle(
                                  color: kSecondaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            return Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final response = await VacancyService.getMyVacancies(
                      FirebaseAuth.instance.currentUser!.uid);
                  if (response.hasData &&
                      response.data != null &&
                      response.data!.isNotEmpty &&
                      context.mounted) {
                    context.read<VacancysCubit>().setVacancys(response.data!);
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
              ),
            );
          },
        ),
        RectangleButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const CreateVacancy();
                },
              ),
            );
          },
          tooltip: 'Nueva Vacante',
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(
                width: 10,
              ),
              Text('Nueva Vacante'),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
