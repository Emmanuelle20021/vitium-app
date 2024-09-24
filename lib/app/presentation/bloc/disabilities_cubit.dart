import 'package:flutter_bloc/flutter_bloc.dart';

class DisabilitiesCubit extends Cubit<DisabilitiesState> {
  DisabilitiesCubit() : super(DisabilitiesState());

  void setDisabilities(List<String> disabilities) {
    emit(state.copyWith(disabilities: disabilities));
  }

  void addDisability(String disability) {
    emit(state.copyWith(disabilities: [...state.disabilities, disability]));
  }

  void removeDisability(String disability) {
    emit(state.removeDisability(disability));
  }

  List<String> get disabilities => state.disabilities;

  bool containsDisability(String disability) {
    return state.disabilities.contains(disability);
  }

  bool get hasDisabilities => state.disabilities.isNotEmpty;

  bool get hasNoDisabilities => state.disabilities.isEmpty;

  void clearDisabilities() {
    emit(state.copyWith(disabilities: []));
  }

  void toggleDisability(String disability) {
    if (containsDisability(disability)) {
      removeDisability(disability);
    } else {
      addDisability(disability);
    }
  }
}

class DisabilitiesState {
  final List<String> disabilities;

  DisabilitiesState({this.disabilities = const []});

  DisabilitiesState removeDisability(String disability) {
    return DisabilitiesState(
      disabilities: disabilities.where((d) => d != disability).toList(),
    );
  }

  DisabilitiesState copyWith({List<String>? disabilities}) {
    return DisabilitiesState(disabilities: disabilities ?? this.disabilities);
  }

  bool containsDisability(String disability) {
    return disabilities.contains(disability);
  }

  bool get hasDisabilities => disabilities.isNotEmpty;

  bool get hasNoDisabilities => disabilities.isEmpty;
}
