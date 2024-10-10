import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/data/utils/constants/constants.dart';
import 'package:vitium/app/data/utils/extension/int_extensions.dart';
import 'package:vitium/app/domain/models/vacancy_model.dart';
import 'package:vitium/app/presentation/bloc/register_cubit.dart';
import 'package:vitium/app/presentation/bloc/vacancys_cubit.dart';
import 'package:vitium/app/presentation/global/components/buttons/rectangle_button.dart';

import '../../../../data/services/vacancy_service.dart';
import '../../recruiter/screen/postulants_list.dart';

class VacancyInfo extends StatefulWidget {
  const VacancyInfo({
    super.key,
    required this.vacancyId,
  });

  final String vacancyId;

  @override
  State<VacancyInfo> createState() => _VacancyInfoState();
}

class _VacancyInfoState extends State<VacancyInfo> {
  @override
  Widget build(BuildContext context) {
    final userState = context.read<RegisterCubit>();
    bool inProgress = false;

    return Scaffold(
      appBar: kAppBarWithName,
      body: BlocBuilder<VacancysCubit, VacancysState>(
        builder: (context, state) {
          final Vacancy vacancy = state.vacancys
              .firstWhere((element) => element.id == widget.vacancyId);
          debugPrint(vacancy.toString());
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Detalles de la vacante',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  16.toVerticalGap,
                  Text(
                    vacancy.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.blue,
                      ),
                      10.toHorizontalGap,
                      Text(
                        '\$${vacancy.salary}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.handshake,
                        color: Colors.blue,
                      ),
                      10.toHorizontalGap,
                      Text(vacancy.aceptedDisabilities.toString()),
                    ],
                  ),
                  10.toVerticalGap,
                  if (vacancy
                      .isPostulant(FirebaseAuth.instance.currentUser!.uid))
                    StatusBar(
                      status: vacancy
                          .getStatus(FirebaseAuth.instance.currentUser!.uid),
                    ),
                  16.toVerticalGap,
                  const Text(
                    'Información general',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.toVerticalGap,
                  Text(
                    vacancy.education,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  30.toVerticalGap,
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.toVerticalGap,
                  ContainerOfVacancyText(text: vacancy.description),
                  10.toVerticalGap,
                  const Text(
                    'Experiencia',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  10.toVerticalGap,
                  ContainerOfVacancyText(text: vacancy.experience),
                  10.toVerticalGap,
                  const Text(
                    'Habilidades',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  10.toVerticalGap,
                  ContainerOfVacancyText(
                    text: vacancy.skills
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', '')
                        .replaceAll(',', '\n'),
                  ),
                  20.toVerticalGap,
                  if (userState.user.role == 'postulant' &&
                      !vacancy.isPostulant(
                        FirebaseAuth.instance.currentUser!.uid,
                      ))
                    RectangleButton(
                      onPressed: () async {
                        if (vacancy.isPostulant(
                          FirebaseAuth.instance.currentUser!.uid,
                        )) {
                          return;
                        }
                        if (inProgress) {
                          return;
                        }
                        inProgress = true;
                        await VacancyService.applyVacancy(
                          id: vacancy.id!,
                          postulant: FirebaseAuth.instance.currentUser!.uid,
                        );
                        debugPrint(vacancy.postulants.toString());
                        final response = await VacancyService.getVacancys();
                        if (response.hasData &&
                            response.data != null &&
                            response.data!.isNotEmpty &&
                            context.mounted) {
                          context.read<VacancysCubit>().setVacancys(
                                response.data!,
                              );
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.check),
                          10.toHorizontalGap,
                          const Text(
                            'Postularme',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (userState.user.role == 'recruiter')
                    RectangleButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PostulantsList(
                              ids: vacancy.postulants!,
                              vacancyId: vacancy.id!,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Ver postulantes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  10.toVerticalGap,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: getColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check,
            color: Colors.white,
          ),
          10.toHorizontalGap,
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  get getColor {
    switch (status) {
      case 'Aceptado':
        return Colors.green;
      case 'Rechazado':
        return Colors.red;
      case 'Pendiente':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }
}

class ContainerOfVacancyText extends StatelessWidget {
  const ContainerOfVacancyText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 81, 81, 81),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
