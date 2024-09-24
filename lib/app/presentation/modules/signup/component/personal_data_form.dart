import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:vitium/app/presentation/bloc/disabilities_cubit.dart';
import 'package:vitium/app/presentation/bloc/register_cubit.dart';
import 'package:vitium/app/presentation/global/components/buttons/rectangle_button.dart';
import 'package:vitium/app/presentation/global/components/inputs/underline_input.dart';

import '../../../../data/utils/constants/constants.dart';
import '../../../../domain/models/register_model.dart';

class PersonalDataForm extends StatefulWidget {
  const PersonalDataForm({super.key});
  @override
  State<PersonalDataForm> createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends State<PersonalDataForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterModel>(
      builder: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        initializeControllers(context, state);
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              UnderlineInput(
                icon: Icons.person,
                hintText: 'Juan Carlos Pérez López',
                controller: nameController,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese su nombre' : null,
                label: Text(
                  'Nombre completo',
                  style: kInputLabelStyle,
                ),
              ),
              UnderlineInput(
                icon: Icons.phone,
                controller: phoneController,
                hintText: '921-303-2907',
                label: Text(
                  'Teléfono',
                  style: kInputLabelStyle,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese su teléfono' : null,
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              UnderlineInput(
                icon: Icons.place,
                controller: addressController,
                hintText: 'Artes Menores #220, Coatzacoalcos',
                label: Text(
                  'Dirección',
                  style: kInputLabelStyle,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese su dirección' : null,
                keyboardType: TextInputType.streetAddress,
              ),
              (user == null)
                  ? const DisabilitiesInput()
                  : UnderlineInput(
                      icon: Icons.cases_outlined,
                      hintText: 'X201JU27',
                      controller: companyController,
                      label: Text(
                        'Código de empresa',
                        style: kInputLabelStyle,
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Por favor ingrese su codigo de empresa'
                          : null,
                    ),
              RectangleButton(
                onPressed: () {},
                child: const Text('Guardar'),
              )
            ],
          ),
        );
      },
    );
  }

  void initializeControllers(BuildContext context, RegisterModel state) {
    nameController.text = state.user.name ?? '';
    phoneController.text = state.user.phone ?? '';
    addressController.text = state.user.address ?? '';

    nameController.addListener(() {
      context.read<RegisterCubit>().updateUser(name: nameController.text);
    });
    phoneController.addListener(() {
      context.read<RegisterCubit>().updateUser(phone: phoneController.text);
    });
    addressController.addListener(() {
      context.read<RegisterCubit>().updateUser(address: addressController.text);
    });
  }
}

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
    return BlocConsumer<DisabilitiesCubit, DisabilitiesState>(
      builder: (BuildContext context, state) {
        return Wrap(
          alignment: WrapAlignment.start,
          spacing: 10,
          children: List.generate(_permitedDisabilities.length, (index) {
            return InputChip(
              label: Text(
                _permitedDisabilities[index],
                style: TextStyle(
                  color: state.containsDisability(_permitedDisabilities[index])
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              onPressed: () {
                context
                    .read<DisabilitiesCubit>()
                    .toggleDisability(_permitedDisabilities[index]);
              },
              backgroundColor:
                  state.containsDisability(_permitedDisabilities[index])
                      ? Colors.blue
                      : Colors.grey[200],
            );
          }),
        );
      },
      listener: (BuildContext context, DisabilitiesState? state) {
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
