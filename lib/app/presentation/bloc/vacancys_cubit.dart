import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/vacancy_model.dart';

class VacancysCubit extends Cubit<VacancysState> {
  VacancysCubit() : super(VacancysState([]));

  void addVacancy(Vacancy vacancy) {
    final vacancys = [...state.vacancys];
    vacancys.add(vacancy);
    emit(VacancysState(vacancys));
  }

  void removeVacancy(Vacancy vacancy) {
    final vacancys = [...state.vacancys];
    vacancys.remove(vacancy);
    emit(VacancysState(vacancys));
  }

  void updateVacancy(Vacancy vacancy) {
    final vacancys = [...state.vacancys];
    final index = vacancys.indexWhere((element) => element.id == vacancy.id);
    vacancys[index] = vacancy;
    emit(VacancysState(vacancys));
  }

  void setVacancys(List<Vacancy> vacancys) {
    emit(VacancysState(vacancys));
  }

  void clearVacancys() {
    emit(VacancysState([]));
  }
}

class VacancysState {
  List<Vacancy> vacancys;
  VacancysState(this.vacancys);

  factory VacancysState.fromJson(List<Vacancy> vacancys) {
    return VacancysState(vacancys);
  }

  Map<String, dynamic> toJson() {
    return {
      'vacancys': vacancys,
    };
  }

  void addVacancy(Vacancy vacancy) {
    vacancys.add(vacancy);
  }

  void removeVacancy(Vacancy vacancy) {
    vacancys.remove(vacancy);
  }

  VacancysState copyWith({
    List<Vacancy>? vacancys,
  }) {
    return VacancysState(vacancys ?? this.vacancys);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VacancysState && listEquals(other.vacancys, vacancys);
  }

  @override
  int get hashCode => vacancys.hashCode;
}
