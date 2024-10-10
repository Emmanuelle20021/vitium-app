import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/utils/constants/constants.dart';
import '../../../../domain/models/register_model.dart';
import '../../../bloc/register_cubit.dart';

class DisabilitiesInput extends StatefulWidget {
  const DisabilitiesInput({super.key});

  @override
  State<DisabilitiesInput> createState() => _DisabilitiesInputState();
}

class _DisabilitiesInputState extends State<DisabilitiesInput> {
  final List<String> _permitedDisabilities = [
    'Visual',
    'Auditiva',
    'Motora',
    'Intelectual',
    'Psicosocial',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterModel>(
      builder: (BuildContext context, RegisterModel state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Discapacidad', style: kInputLabelStyle),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 10,
              children: List.generate(_permitedDisabilities.length, (index) {
                return InputChip(
                  label: Text(
                    _permitedDisabilities[index],
                    style: TextStyle(
                      color:
                          state.containsDisability(_permitedDisabilities[index])
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<RegisterCubit>()
                        .toggleDisability(_permitedDisabilities[index]);
                  },
                  backgroundColor:
                      state.containsDisability(_permitedDisabilities[index])
                          ? Colors.blue
                          : Colors.grey[200],
                );
              }),
            ),
          ],
        );
      },
      listener: (BuildContext context, RegisterModel? state) {
        if (state != null && state.hasNoDisabilities) {
          toastification.show(
            context: context,
            title: const Text(
              'No puedes continuar sin seleccionar una discapacidad',
            ),
            animationDuration: const Duration(seconds: 3),
          );
        }
      },
    );
  }
}
