import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitium/app/data/services/vacancy_service.dart';

import '../../../global/components/buttons/vacancy_card.dart';

class RequestedVacancies extends StatelessWidget {
  const RequestedVacancies({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Resultado de tus postulaciones',
          textAlign: TextAlign.start,
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
          child: RefreshIndicator(
            onRefresh: () {
              return VacancyService.getMyPostulantVacancies(
                FirebaseAuth.instance.currentUser!.uid,
              );
            },
            child: FutureBuilder(
              future: VacancyService.getMyPostulantVacancies(
                FirebaseAuth.instance.currentUser!.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.data != null &&
                    snapshot.data!.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (context, index) {
                      return VacancyCard(
                        vacancy: snapshot.data!.data![index],
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('No hay vacantes disponibles'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
