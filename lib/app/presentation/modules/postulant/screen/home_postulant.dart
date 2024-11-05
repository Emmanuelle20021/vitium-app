import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/data/services/vacancy_service.dart';
import 'package:vitium/app/data/utils/extension/int_extensions.dart';
import 'package:vitium/app/presentation/bloc/vacancys_cubit.dart';

import '../../../../data/utils/constants/constants.dart';
import '../../../global/components/buttons/vacancy_card.dart';
import '../../vacancies/screen/vacancy_info.dart';

class HomePostulant extends StatefulWidget {
  const HomePostulant({super.key});

  @override
  State<HomePostulant> createState() => _HomePostulantState();
}

class _HomePostulantState extends State<HomePostulant> {
  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: BlocBuilder<VacancysCubit, VacancysState>(
              builder: (_, vacancysState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(50),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 30,
                  ),
                  10.toHorizontalGap,
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        isEmpty
                            ? Text(
                                'Buscar vacantes',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              )
                            : SizedBox(),
                        Autocomplete<String>(
                          onSelected: (option) {
                            final vacancy = vacancysState.vacancys.firstWhere(
                              (vacancy) => vacancy.title == option,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VacancyInfo(
                                  vacancyId: vacancy.id!,
                                ),
                              ),
                            );
                          },
                          optionsBuilder: (textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              isEmpty = true;
                            } else {
                              isEmpty = false;
                            }
                            setState(() {});
                            return textEditingValue.text.isEmpty
                                ? const Iterable<String>.empty()
                                : vacancysState.vacancys
                                    .where((vacancy) => vacancy.title
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase()))
                                    .map((vacancy) => vacancy.title);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
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
                      child: Text(
                        'Recargar',
                        style: TextStyle(
                          color: kSecondaryColor,
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
