import 'package:flutter/material.dart';
import 'package:vitium/app/domain/models/vacancy_model.dart';

import '../../../../data/utils/constants/constants.dart';
import '../../../modules/vacancies/screen/vacancy_info.dart';

class VacancyCard extends StatelessWidget {
  const VacancyCard({
    super.key,
    this.isApplied = false,
    this.isRejected = false,
    this.isAccepted = false,
    this.isPending = false,
    required this.vacancy,
  });

  final bool isApplied;
  final bool isRejected;
  final bool isAccepted;
  final bool isPending;
  final Vacancy vacancy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VacancyInfo(
              vacancyId: vacancy.id!,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vacancy.title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                isApplied
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: getColor(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              getIcon(),
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              getText(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/vitium_logo.png',
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '\$${vacancy.salary}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              vacancy.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          vacancy.aceptedDisabilities.length,
                          (index) => Text(
                            vacancy.aceptedDisabilities[index],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getColor() {
    if (isRejected) {
      return Colors.red;
    } else if (isAccepted) {
      return kSecondaryColor;
    } else if (isPending) {
      return Colors.grey;
    }
  }

  getIcon() {
    if (isRejected) {
      return Icons.info_outline;
    } else if (isAccepted) {
      return Icons.star_border_rounded;
    } else if (isPending) {
      return Icons.watch_later_outlined;
    }
  }

  String getText() {
    if (isRejected) {
      return 'Rechazado';
    } else if (isAccepted) {
      return 'Aceptado';
    }
    return 'Pendiente';
  }
}
