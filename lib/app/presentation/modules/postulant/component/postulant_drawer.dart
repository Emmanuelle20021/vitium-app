import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/utils/injector.dart';
import '../../../bloc/register_cubit.dart';
import '../../../routes/routes.dart';

class PostulantDrawer extends StatelessWidget {
  const PostulantDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              final auth = Injector.of(context).accountRepository;
              final response = await auth.logout();

              if (response.data != null && context.mounted) {
                context.read<RegisterCubit>().clearCubit();
                Navigator.pushReplacementNamed(context, Routes.login);
              }
            },
          ),
        ],
      ),
    );
  }
}
