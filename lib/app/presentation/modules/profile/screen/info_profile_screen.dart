import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vitium/app/presentation/global/components/visual_details/aplication_name_tag.dart';
import 'package:vitium/app/presentation/modules/profile/components/photo_form.dart';
import 'package:vitium/app/presentation/modules/profile/components/personal_data_form.dart';

import '../../../../data/utils/constants/constants.dart';

class InfoProfileScreen extends StatelessWidget {
  const InfoProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(kPagingTouchSlop),
        child: Column(
          children: [
            const AplicationNameTag(
              withLogo: true,
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              'Edita tu perfil',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Modifica tu perfil, cuentanos un poco sobre ti',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Expanded(
              child: Column(
                children: [
                  PhotoForm(),
                  Expanded(
                    child: PersonalDataForm(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
