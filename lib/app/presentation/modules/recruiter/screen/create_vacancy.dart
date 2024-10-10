import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/data/services/vacancy_service.dart';
import 'package:vitium/app/data/utils/constants/constants.dart';
import 'package:vitium/app/data/utils/extension/int_extensions.dart';
import 'package:vitium/app/presentation/global/components/buttons/rectangle_button.dart';

import '../../../../domain/models/vacancy_model.dart';
import '../../../bloc/vacancys_cubit.dart';

class CreateVacancy extends StatefulWidget {
  const CreateVacancy({super.key});

  @override
  State<CreateVacancy> createState() => _CreateVacancyState();
}

class _CreateVacancyState extends State<CreateVacancy> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para cada campo
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool notInProgress = true;

  // Listas para chips de skills y discapacidades aceptadas
  final List<String> _skills = [];
  final List<String> _acceptedDisabilities = [];

  // Lista de discapacidades disponibles
  final List<String> _disabilitiesOptions = [
    'Visual',
    'Auditiva',
    'Motora',
    'Intelectual',
    'Psicosocial',
  ];

  // Método para agregar habilidades
  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        _skills.add(_skillController.text);
        _skillController.clear();
      });
    }
  }

  // Método para cancelar
  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBarWithName,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Por favor, complete la siguiente información:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre de la vacante
                      _buildTextField(
                        controller: _titleController,
                        label: 'Nombre de la vacante',
                        helperText: 'Escriba el nombre de la vacante',
                        validator: _requiredValidator,
                      ),
                      // Nivel educativo requerido
                      _buildTextField(
                        controller: _educationController,
                        label: 'Nivel educativo requerido',
                        helperText: 'Ingrese el nivel educativo',
                        validator: _requiredValidator,
                      ),
                      // Experiencia requerida
                      _buildTextField(
                        controller: _experienceController,
                        label: 'Experiencia requerida',
                        helperText: 'Ingrese la experiencia solicitada',
                        validator: _requiredValidator,
                      ),
                      // Habilidades requeridas (Skills)
                      _buildSkillField(),
                      // Discapacidades aceptadas (con ChoiceChip)
                      _buildDisabilityChips(),
                      // Salario ofrecido (solo acepta números)
                      _buildTextField(
                        controller: _salaryController,
                        label: 'Salario ofrecido',
                        helperText: 'Ingrese el salario en formato numérico',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: _requiredValidator,
                      ),
                      // Descripción de la vacante (multiline)
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Descripción de la vacante',
                        helperText: 'Proporcione una descripción detallada',
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20),
                      // Botones de acción (Agregar y Cancelar)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: RectangleButton(
                      key: GlobalKey(),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            notInProgress) {
                          final vacancy = Vacancy(
                            title: _titleController.text,
                            education: _educationController.text,
                            experience: _experienceController.text,
                            skills: _skills,
                            aceptedDisabilities: _acceptedDisabilities,
                            salary: _salaryController.text,
                            description: _descriptionController.text,
                            owner: FirebaseAuth.instance.currentUser!.uid,
                            postulants: [],
                          );
                          context.read<VacancysCubit>().addVacancy(vacancy);
                          notInProgress = false;
                          await VacancyService.createVacancy(vacancy);
                          notInProgress = true;
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      child: const Text('Agregar Vacante'),
                    ),
                  ),
                  10.toHorizontalGap,
                  Expanded(
                    child: RectangleButton(
                      key: GlobalKey(),
                      onPressed: _cancel,
                      color: Colors.red,
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir el campo de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String helperText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          helperText: helperText,
          alignLabelWithHint: true,
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }

  // Método para validar campos obligatorios
  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  // Método para construir el campo de habilidades
  Widget _buildSkillField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _skillController,
            decoration: InputDecoration(
              labelText: 'Habilidades requeridas',
              border: const OutlineInputBorder(),
              helperText: 'Añada una habilidad y presione +',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addSkill,
              ),
              alignLabelWithHint: true,
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: _skills.map((skill) {
              return Chip(
                label: Text(skill),
                onDeleted: () {
                  setState(() {
                    _skills.remove(skill);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Método para construir los ChoiceChips de discapacidades
  Widget _buildDisabilityChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discapacidades aceptadas:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: _disabilitiesOptions.map((disability) {
              return ChoiceChip(
                label: Text(disability),
                selected: _acceptedDisabilities.contains(disability),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _acceptedDisabilities.add(disability);
                    } else {
                      _acceptedDisabilities.remove(disability);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _salaryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
