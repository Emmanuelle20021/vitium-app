import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/data/services/user_service.dart';
import 'package:vitium/app/data/utils/injector.dart';
import 'package:vitium/app/domain/models/register_model.dart';
import 'package:vitium/app/presentation/bloc/register_cubit.dart';
import 'package:vitium/app/presentation/global/components/inputs/underline_input.dart';
import 'package:vitium/app/presentation/modules/profile/components/photo_form.dart';

import '../../../../data/utils/constants/constants.dart';
import '../../../global/components/buttons/rectangle_button.dart';
import '../../../global/components/inputs/disabilities_input.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterModel>(
      listener: (context, state) {
        UserService.updateUser(state.user);
      },
      builder: (context, state) {
        initControllers(state);
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Expanded(
                    child: UnderlineInput(
                      icon: Icons.person,
                      controller: nameController,
                      hintText: 'Juan Carlos Pérez López',
                      label: Text(
                        'Nombre completo',
                        style: kInputLabelStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const PhotoForm(),
                ],
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
              UnderlineInput(
                icon: Icons.location_on_outlined,
                hintText: 'Dirección',
                label: Text('Dirección', style: kInputLabelStyle),
                controller: addressController,
              ),
              UnderlineInput(
                icon: Icons.phone,
                hintText: 'Teléfono',
                label: Text('Teléfono', style: kInputLabelStyle),
                controller: phoneController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.email_outlined,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    state.user.email!,
                    style: kInputLabelStyle,
                  ),
                ],
              ),
              if (state.user.isPostulant)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cv',
                      style: kInputLabelStyle,
                    ),
                    const Divider(),
                  ],
                ),
              state.user.isPostulant
                  ? const UploadCvWidget()
                  : const SizedBox(),
              RectangleButton(
                onPressed: () async {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    context.read<RegisterCubit>().setUser(
                          state.user.copyWith(
                            name: nameController.text,
                            companyCode: companyController.text,
                            address: addressController.text,
                            phone: phoneController.text,
                          ),
                        );
                    UserService.updateUser(state.user);
                  }
                },
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        );
      },
    );
  }

  void initControllers(RegisterModel state) {
    nameController.text = state.user.name ?? '';
    companyController.text = state.user.companyCode ?? '';
    addressController.text = state.user.address ?? '';
    phoneController.text = state.user.phone ?? '';
  }
}

class UploadCvWidget extends StatefulWidget {
  const UploadCvWidget({
    super.key,
  });

  @override
  State<UploadCvWidget> createState() => _UploadCvWidgetState();
}

class _UploadCvWidgetState extends State<UploadCvWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterModel>(
        builder: (context, registerState) {
      return GestureDetector(
        onTap: () async {
          final FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
          if (result != null && context.mounted) {
            final File file = File(result.files.single.path!);
            final response =
                await Injector.of(context).accountRepository.uploadCv(file);
            if (response.hasData && context.mounted) {
              context.read<RegisterCubit>().setUser(
                    registerState.user.copyWith(
                      cv: response.data,
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cv subido correctamente'),
                ),
              );
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al subir el cv'),
                ),
              );
            }
          }
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(122, 105, 240, 175).withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(10),
            color: Colors.greenAccent.withOpacity(0.1),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      'Subir archivo',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Sube tu cv en formato pdf',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
