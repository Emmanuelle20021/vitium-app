import 'package:flutter_bloc/flutter_bloc.dart';

class ExceptionHandlerCubit extends Cubit<ExceptionHandlerState> {
  ExceptionHandlerCubit() : super(ExceptionHandlerState.initial());

  void handleException(Exception exception, String message) {
    emit(ExceptionHandlerState.error(exception, message));
  }

  void clearException() {
    emit(ExceptionHandlerState.initial());
  }
}

class ExceptionHandlerState {
  final Exception? exception;
  final String? message;

  ExceptionHandlerState({this.message, this.exception});

  factory ExceptionHandlerState.initial() {
    return ExceptionHandlerState();
  }

  factory ExceptionHandlerState.error(Exception exception, String message) {
    return ExceptionHandlerState(exception: exception, message: message);
  }

  bool get hasException => exception != null;
}
