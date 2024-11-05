import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/data/utils/constants/constants.dart';
import 'package:vitium/app/presentation/global/components/visual_details/header_with_image.dart';
import 'package:vitium/app/presentation/modules/postulant/screen/home_postulant.dart';
import 'package:vitium/app/presentation/modules/profile/screen/profile_screen.dart';
import 'package:vitium/app/presentation/modules/postulant/screen/requested_vacancies.dart';
import 'package:vitium/app/presentation/modules/recruiter/screen/home_recruiter.dart';

import '../../../../domain/models/register_model.dart';
import '../../../bloc/register_cubit.dart';
import '../../postulant/component/postulant_drawer.dart';
import '../../recruiter/screen/recruiter_vacancys.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  final titleTextsPostulants = ['Descubre tu', 'Trabajos'];
  final titleTextsRecruiter = ['Crea, conecta', 'Administra tus'];
  final subtitleTextsPostulants = ['trabajo favorito', 'postulados'];
  final subtitleTextsRecruiter = ['gestiona', 'Vacantes'];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterModel>(
      listener: (context, state) {},
      builder: (context, state) {
        final userInfo = state.user;
        return Scaffold(
          drawer: const PostulantDrawer(),
          resizeToAvoidBottomInset: false,
          appBar: kAppBarWithName,
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            currentIndex: currentIndex,
            selectedItemColor: kSecondaryColor,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
                tooltip: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.work_outline),
                label: userInfo.isPostulant ? 'Postulaciones' : 'Vacantes',
                tooltip: userInfo.isPostulant ? 'Postulaciones' : 'Vacantes',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Perfil',
                tooltip: 'Perfil',
              ),
            ],
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
              pageController.jumpToPage(index);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (currentIndex < 2)
                  HeaderWithImage(
                    firstText: userInfo.isPostulant
                        ? titleTextsPostulants[currentIndex]
                        : titleTextsRecruiter[currentIndex],
                    seccondText: userInfo.isPostulant
                        ? subtitleTextsPostulants[currentIndex]
                        : subtitleTextsRecruiter[currentIndex],
                  ),
                if (currentIndex == 2)
                  const Text(
                    'Mi perfil',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                    ),
                  ),
                Expanded(
                  child: PageView(
                    pageSnapping: true,
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    children: userInfo.role == 'postulant'
                        ? const [
                            HomePostulant(),
                            RequestedVacancies(),
                            ProfileScreen(),
                          ]
                        : const [
                            HomeRecruiter(),
                            RecruiterVacancies(),
                            ProfileScreen(),
                          ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
