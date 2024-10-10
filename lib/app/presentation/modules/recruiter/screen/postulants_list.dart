import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitium/app/data/services/user_service.dart';
import 'package:vitium/app/data/utils/constants/constants.dart';
import 'package:vitium/app/data/utils/extension/int_extensions.dart';
import 'package:vitium/app/domain/models/user_model.dart';
import 'package:vitium/app/presentation/global/components/buttons/rectangle_button.dart';

import '../../../../data/services/vacancy_service.dart';

class PostulantsList extends StatelessWidget {
  const PostulantsList({
    super.key,
    required this.ids,
    required this.vacancyId,
  });

  final List<Map<String, dynamic>> ids;
  final String vacancyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBarWithName,
      body: FutureBuilder(
        future: UserService.getUsers(ids),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }
          if (snapshot.data!.data!.isEmpty) {
            return const Center(
              child: Text('No hay postulantes'),
            );
          }
          List<UserModel> postulants = snapshot.data!.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () async {
                final response = await UserService.getUsers(ids);
                postulants = response.data!;
              },
              child: ListView.builder(
                itemCount: postulants.length,
                itemBuilder: (context, index) {
                  return PostulantCard(
                      vacancyId: vacancyId,
                      postulant: postulants[index],
                      status: ids[index]['status']);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class PostulantCard extends StatelessWidget {
  const PostulantCard({
    super.key,
    required this.postulant,
    required this.status,
    required this.vacancyId,
  });

  final String status;
  final UserModel postulant;
  final String vacancyId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(postulant.name!),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(postulant.email!),
          10.toVerticalGap,
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: getColor(status),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  getIcon(status),
                  color: Colors.white,
                ),
                5.toHorizontalGap,
                Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => PostulantDialog(
            onAccept: () async {
              await VacancyService.updatePostulationOfPostulant(
                idVacancy: vacancyId,
                idPostulant: postulant.id!,
                status: 'Aceptado',
              );
              if (context.mounted) Navigator.of(context).pop();
            },
            onNotAccept: () async {
              await VacancyService.updatePostulationOfPostulant(
                idVacancy: vacancyId,
                idPostulant: postulant.id!,
                status: 'Rechazado',
              );
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        );
      },
      leading: postulant.image != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(postulant.image!),
            )
          : const CircleAvatar(
              child: Icon(Icons.person),
            ),
      trailing: GestureDetector(
        onTap: () async {
          final Uri url = Uri.parse(postulant.cv!);
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
            browserConfiguration: const BrowserConfiguration(
              showTitle: true,
            ),
            webOnlyWindowName: 'Vitium',
          );
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.file_download),
            Text('Ver CV'),
          ],
        ),
      ),
      tileColor: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  getColor(status) {
    if (status == 'Rechazado') {
      return Colors.red;
    } else if (status == 'Aceptado') {
      return Colors.blue;
    } else if (status == 'Pendiente') {
      return Colors.grey;
    }
  }

  getIcon(status) {
    if (status == 'Rechazado') {
      return Icons.info_outline;
    } else if (status == 'Aceptado') {
      return Icons.star_border_rounded;
    } else if (status == 'Pendiente') {
      return Icons.watch_later_outlined;
    }
  }
}

class PostulantDialog extends StatelessWidget {
  const PostulantDialog({
    super.key,
    required this.onAccept,
    required this.onNotAccept,
  });

  final Function onAccept;
  final Function onNotAccept;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Toma tu decisión',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 26,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/brief_splash.png'),
          20.toVerticalGap,
          const Text(
            'Llego la hora de comunicarle tu desición al postulante',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          20.toVerticalGap,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: RectangleButton(
                      onPressed: () => onAccept(),
                      child: const Text('Aceptar'),
                    ),
                  ),
                  10.toHorizontalGap,
                  Expanded(
                    child: RectangleButton(
                      color: Colors.red,
                      onPressed: () => onNotAccept(),
                      child: const Text('Rechazar'),
                    ),
                  ),
                ],
              ),
              10.toVerticalGap,
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
