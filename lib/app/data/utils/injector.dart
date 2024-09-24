import 'package:flutter/material.dart';

import '../../domain/repository/account_repository.dart';

class Injector extends InheritedWidget {
  const Injector({
    super.key,
    required super.child,
    required this.accountRepository,
  });

  final AccountRepository accountRepository;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static Injector of(BuildContext context) {
    final Injector? injector =
        context.dependOnInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'No Injector found in context');
    return injector!;
  }
}
