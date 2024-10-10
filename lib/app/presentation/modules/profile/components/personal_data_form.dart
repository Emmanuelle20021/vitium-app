import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:vitium/app/data/services/user_service.dart';
import 'package:vitium/app/data/utils/image_compresser.dart';
import 'package:vitium/app/presentation/bloc/register_cubit.dart';
import 'package:vitium/app/presentation/global/components/buttons/rectangle_button.dart';
import 'package:vitium/app/presentation/global/components/inputs/underline_input.dart';

import '../../../../data/utils/constants/constants.dart';
import '../../../../data/utils/injector.dart';
import '../../../../domain/models/register_model.dart';
import '../../../global/components/inputs/disabilities_input.dart';
import '../../../routes/routes.dart';

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
              (state.user.role == 'postulant')
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
                onPressed: () async {
                  final auth = Injector.of(context).accountRepository;
                  if (formKey.currentState!.validate()) {
                    if (state.file != null) {
                      final File file = await ImageCompresser.compressImage(
                        image: state.file!,
                        fileName: '${state.user.id}',
                      );
                      final response = await auth.uploadProfilePicture(file);
                      if (response.data != null && context.mounted) {
                        context.read<RegisterCubit>().updateUser(
                              image: response.data,
                            );
                        UserService.createUser(state.user);
                      } else if (context.mounted) {
                        toastification.show(
                          context: context,
                          title: const Text('Ups Algo salió mal'),
                          description: const Text(
                            'Revisa tu conexión a internet e intenta de nuevo',
                          ),
                          autoCloseDuration: const Duration(seconds: 3),
                        );
                      }
                    } else {
                      UserService.createUser(state.user);
                    }
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, Routes.home);
                    }
                  }
                },
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
    if (context.read<RegisterCubit>().user.role == 'recruiter') {
      companyController.text = state.user.companyCode ?? '';
      companyController.addListener(() {
        context
            .read<RegisterCubit>()
            .updateUser(companyCode: companyController.text);
      });
    }
  }
}
