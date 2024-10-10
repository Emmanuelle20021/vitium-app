import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vitium/app/presentation/global/components/visual_details/aplication_name_tag.dart';
import 'package:vitium/app/presentation/modules/profile/components/photo_form.dart';
import 'package:vitium/app/presentation/modules/profile/components/personal_data_form.dart';

class InfoProfileScreen extends StatelessWidget {
  const InfoProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(kPagingTouchSlop),
        child: Column(
          children: [
            AplicationNameTag(
              withLogo: true,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Edita tu perfil',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Modifica tu perfil, cuentanos un poco sobre ti',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Expanded(
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
